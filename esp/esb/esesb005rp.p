{include/i-prgvrs.i esesb005RP 2.00.00.000}  
    
/*----------------------------------------------------------------*/
/*        DEFINIÄÂES ESPEC÷FICAS PARA INTEGRAÄ«O COM O APB        */
/*----------------------------------------------------------------*/
DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

v_des_contdo_prog_valid_dtsul = "esesb005rp".

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as i no-undo.

DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esapi/esapi015tt.i}

{utp/utapi009.i}
/* {esbo/boes455.i tt-vpc} */
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
FIELD r-Rowid AS ROWID.
/* {esbo/boes456.i tt-pagto-vpc} */

DEFINE TEMP-TABLE tt-pagto-vpc NO-UNDO LIKE pagto-vpc
    FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF NEW GLOBAL SHARED VAR v_Cod_Empres_Usuar AS CHAR NO-UNDO.

DEFINE VARIABLE c-referencia         AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-titulo         AS CHAR FORMAT "X(09)"    NO-UNDO.
DEFINE VARIABLE c-conta              AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-centro-custo       AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-estab          AS CHAR FORMAT "X(05)"    NO-UNDO.
DEFINE VARIABLE c-especie            AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-tipo-fluxo         AS CHAR                   NO-UNDO.
DEFINE VARIABLE h-esesb003-apb       AS HANDLE                 NO-UNDO.

/* Procedures comuns aos programas esesbapi003-apb e a este programa.*/
{esp/esb/esesbapi003-apb.i}

/************************  FIM DEFINIÄÂES APB  ***********************/


/*-------------------------------------------------*/
/*    D E F I N I Ä « O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
define temp-table tt-param no-undo
    FIELD destino      AS INTEGER
    FIELD arquivo      AS CHAR format "x(35)"
    FIELD usuario      AS CHAR format "x(12)"
    FIELD data-exec    AS DATE
    FIELD hora-exec    AS INTEGER
    FIELD ano          AS INTEGER
    FIELD trimestre    AS INTEGER
    FIELD rs-tipo      AS INTEGER
    FIELD rs-acao      AS INTEGER
    FIELD da-transacao AS DATE.

/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

DEF TEMP-TABLE tt-beneficio-aux LIKE tt-beneficio.

DEF TEMP-TABLE tt-cc-benef NO-UNDO LIKE int-cc-benef
    FIELD r-rowid AS ROWID.

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(200)"
    FIELD ajuda    AS CHAR FORMAT "X(250)".

DEF TEMP-TABLE tt-erro-benef NO-UNDO LIKE tt-erro.

/* Carregada no .w, caso o usu†rio tenha optado por digitar os canais individualmente */
define temp-table tt-digita 
    FIELD canal-central     AS INTEGER
        INDEX idx-canal IS PRIMARY UNIQUE canal-central.


/*************** PAR∂METROS ***************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-freeac.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{include/tt-edit.i}
{include/pi-edit.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/*Temp-tables com os dados do faturamento/devoluá‰es*/
{esp/esb/esesbapi002.i}  /* tt-canal */
{esp/esb/esesbapi002.i1} /* tt-fat-mensal; tt-fat-mensal-det */

DEF TEMP-TABLE tt-canal-aux1 LIKE tt-canal.

{esp/esb/esesbapi003-movtos.i2} /* pi-cria-transacao-saldo-inicial */
{esp/esb/esesbapi003-movtos.i3} /* pi-retorna-base-faturamento-periodo*/
        
/*Para busca dos parÉmetros globais do CRM*/
{esp/esb/out/msg0111.i} 

/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}

{esp/esb/out/msg0160.i} /*msg0160r-FormaPagamentoItem*/
/*{esapi/esapi015tt.i}*/

DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.
DEF TEMP-TABLE tt-erro-saldo   LIKE tt-erro.

DEF TEMP-TABLE tt-central-aux LIKE tt-central.

/* bloco principal do programa */
ASSIGN c-programa     = "esesb005"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Canais Intelbras"
       c-titulo-relat = "Apuraá∆o Benef°cios Canais".

/************ DEFINIÄ«O DE VAR   IµVEIS **************/
DEFINE VARIABLE h-acomp                   AS HANDLE                 NO-UNDO.
DEFINE VARIABLE c-tipo                    AS CHAR FORMAT "X(10)"    NO-UNDO.
DEFINE VARIABLE c-unid-negoc              AS CHARACTER              NO-UNDO.
DEFINE VARIABLE v-cod-modal               AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-unidade                 AS INTEGER                NO-UNDO.
DEFINE VARIABLE da-ini                    AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim                    AS DATE                   NO-UNDO.
DEFINE VARIABLE c-negativos               AS CHARACTER              NO-UNDO.
DEFINE VARIABLE c-pais                    AS CHARACTER              NO-UNDO.
DEFINE VARIABLE c-estado                  AS CHARACTER              NO-UNDO.
DEFINE VARIABLE c-cidade                  AS CHARACTER              NO-UNDO.
DEFINE VARIABLE i-cont                    AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-count                   AS INTEGER                NO-UNDO.
DEFINE VARIABLE i                         AS INTEGER                NO-UNDO.
DEFINE VARIABLE c-guid-beneficio          AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-tipo-beneficio          AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-guid-regiao             AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-guid-classificacao      AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-categoria               AS CHAR                   NO-UNDO.
DEFINE VARIABLE c-arq-beneficios          AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-fat                 AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-fat-detalhe         AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-cc                  AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE da-ini-apur               AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim-apur               AS DATE                   NO-UNDO.
DEFINE VARIABLE da-vencimento             AS DATE                   NO-UNDO.
DEFINE VARIABLE da-ini-apur-ant           AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim-apur-ant           AS DATE                   NO-UNDO.
DEFINE VARIABLE c-labels                  AS CHAR  FORMAT "X(350)"  NO-UNDO.
DEFINE VARIABLE c-label-cc                AS CHAR  FORMAT "X(350)"  NO-UNDO.
DEFINE VARIABLE da-aux                    AS DATE                   NO-UNDO.
DEFINE VARIABLE i-seq-ref                 AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-seq-det                 AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-sequencia-movto         AS INTEGER                NO-UNDO.
DEFINE VARIABLE c-trimestre               AS CHARACTER              NO-UNDO.
DEFINE VARIABLE i-transacao               AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-trimestre               AS INTEGER                NO-UNDO.

DEFINE BUFFER b-matriz                FOR emitente.
DEFINE BUFFER b-cc-benef              FOR int-cc-benef.
DEFINE BUFFER b-int-cc-benef          FOR int-cc-benef.
DEFINE BUFFER b-int-cc-benef-eliminar FOR int-cc-benef.
DEFINE BUFFER b-int-cc-benef-movto    FOR int-cc-benef-movto.


DEF STREAM exp1.
DEF STREAM exp2.
DEF STREAM exp-fat.
DEF STREAM exp-fat-det.

/*-------------------*/
/*   F U N Ä Â E S   */
/*-------------------*/

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

/*------------------------------------------------------*/
/*    I N ÷ C I O  -   B L O C O   P R I N C I P A L    */
/*------------------------------------------------------*/
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

IF  tt-param.rs-tipo = 2 THEN DO:
    ASSIGN c-tipo = "Oficial".
END.
ELSE
    ASSIGN c-tipo = "PrÇvia".

IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                    
IF  VALID-HANDLE(h-acomp) THEN                                      
    RUN pi-inicializar IN h-acomp (INPUT "Gerando Apuraá∆o").
    
/*---------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                              GERAÄ«O DE ARQUIVO DE ACOMPANHAMENTO                                                           */
/*---------------------------------------------------------------------------------------------------------------------------------------------*/
ASSIGN c-labels   = "MOVTO;CANAL;NOM.ABREV;UNID NEG;BENEF÷CIO;CATEGORIA;PER INI;PER FIM;BASE CµLCULO;% APLICADO;SALDO CALCULADO;DT TRANS;DT VENCTO;STATUS CC;USUARIO;SALDO VMC TRANSFERIDO;GUID CLASS;GUID CANAL;GUID BENEF÷CIO;GUID BENEF÷CIO CANAL".    
       c-label-cc = "MOVTO;CANAL;NOM.ABREV;UNID NEG;BENEF÷CIO;CATEGORIA;CLASSIFICACAO;PER INI;PER FIM;BASE CµLCULO;% APLICADO;SALDO CALCULADO;% CUSTO;SALDO x %CUSTO;DT TRANS;DT VENCTO;STATUS CC;USUARIO;SALDO VMC TRANSFERIDO;GUID CLASS;GUID CANAL;GUID BENEF÷CIO;GUID BENEF÷CIO CANAL".    
                                                                                                                                                                                                                                                                                                   
/* FATURAMENTO MENSAL */
IF  OPSYS = "UNIX" THEN 
   ASSIGN c-arq-fat = c-dir-arquivo-session + c-seg-usuario + "/" + "log-base-fat_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
   ASSIGN c-arq-fat = SESSION:TEMP-DIRECTORY +  "log-base-fat_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
OUTPUT STREAM exp-fat TO VALUE(c-arq-fat) CONVERT TARGET "iso8859-1".
PUT STREAM exp-fat "Ano;Mes;Canal;NomeAbrev;Unidade;Vl Faturado.;Vl Devolvido;Vl Apurado;Vl Fat Base p/ Reabte;Vl Dev Base p/ Rebate; Vl Apurado Base p/ Rebate;GUID Canal" SKIP.

/* DETALHES DO FATURAMENTO MENSAL*/
IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-fat-detalhe = c-dir-arquivo-session + c-seg-usuario + "/" + "log-base-fat-detalhes_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-fat-detalhe = SESSION:TEMP-DIRECTORY + "log-base-fat-detalhes_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

OUTPUT STREAM exp-fat-det TO VALUE(c-arq-fat-detalhe) CONVERT TARGET "iso8859-1".
PUT STREAM exp-fat-det "Ano;Mes;Canal Central;NomeCanalCentral;Filial;Unidade;Movto;Seq;Estabel;Serie;Nota;Seq Item;Item;Vl Fat; Vl Fat base Retabe;Data;Serie Ent; Docto Ent; Cliente; Nat Op; Sequencia; Vl Devol;Vl Devol Base Reabate" SKIP.

/* CONTAS CORRENTES DE BENEF÷CIO*/
IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-cc = c-dir-arquivo-session + c-seg-usuario + "/" + "log-cc-beneficios_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-cc = SESSION:TEMP-DIRECTORY + "log-cc-beneficios_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
OUTPUT STREAM exp2 TO VALUE(c-arq-cc) CONVERT TARGET "iso8859-1".
PUT STREAM exp2 c-label-CC SKIP.

/* BENEFICIOS */

IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-beneficios = c-dir-arquivo-session + c-seg-usuario + "/" + "log-beneficios_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-beneficios = SESSION:TEMP-DIRECTORY + "log-beneficios_T" + string(tt-param.trimestre, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

OUTPUT STREAM exp1 TO VALUE(c-arq-beneficios) CONVERT TARGET "iso8859-1".
PUT STREAM exp1 "Canal;Nom.Abrev;Unidade;Beneficio;Categoria;Classificaá∆o;% Benef;% Custo;% Prov Meta;STATUS;Conta Contab;Centro Custo;Estabelec;EspÇcie;Tp Fluxo;Exclusiv;Calcula Verba;GUID Canal;GUID Benef;GUID Benef Canal;GUID Classificaá∆o;GUID Categoria" SKIP.

/*---------------------*/
/*  P R I N C I P A L  */
/*---------------------*/
RUN PI-PRINCIPAL.                                                                                                                                                                                                                             

/* Retornou erro */
IF  CAN-FIND (FIRST tt-erro) OR RETURN-VALUE <> "OK" THEN DO:
    PUT "Erro       Mensagem" SKIP
        "---------- -------------------------------------------------------------------------------------------------------------------------" SKIP(1).

    FOR EACH tt-erro:
        PUT tt-erro.codigo TO 10
            tt-erro.mensagem  AT 12 SKIP
            tt-erro.ajuda AT 12 SKIP(1).
    END.

    PUT SKIP(3)"    ATENÄ«O: N∆o foi poss°vel concluir a apuraá∆o para o per°odo. Entre em contato com a TIC Intelbras.".
END.
ELSE 
    DISP SKIP(2) "    Apuraá∆o de Benef°cios executada com sucesso!".


PUT SKIP(2).
PUT "    Gerado arquivo de acompanhamento Base C†lculo Faturamento.........................: " c-arq-fat         SKIP(1).
PUT "    Gerado arquivo de acompanhamento Base C†lculo Faturamento Detalhado...............: " c-arq-fat-detalhe SKIP(1).
PUT "    Gerado arquivo de acompanhamento Benef°cios utilizados............................: " c-arq-beneficios  SKIP(1).
PUT "    Gerado arquivo de acompanhamento Conta Corrente de Despesa para o canal...........: " c-arq-cc          SKIP(1).

                                                                         
/* DISPLYA PAR∂METROS */
PUT "                                                       PAR∂METROS" SKIP
    "                                                   ------------------" SKIP(1).
PUT "                                                   Ano...: " string(tt-param.ano)  SKIP
    "                                                   Màs...: " string(tt-param.trimestre)  SKIP
    "                                                   Opá∆o.: " c-tipo  SKIP.


OUTPUT STREAM exp1        CLOSE.             
OUTPUT STREAM exp2        CLOSE.
OUTPUT STREAM exp-fat     CLOSE.
OUTPUT STREAM exp-fat-det CLOSE.

                                        
ASSIGN v_des_contdo_prog_valid_dtsul = "".

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             
/*-----------------------------------------*/
/*  F I M   B L O C O   P R I N C I P A L  */
/*-----------------------------------------*/



/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                                                                                                                 */
/*                                                  P R O C E D U R E S  I N T E R N A S                                                           */
/*                                                                                                                                                 */
/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE PI-PRINCIPAL:


    /* Cria a data inicial e final com base no ano e mes informados em tela */
    RUN pi-RETORNA-DATAS (INPUT tt-param.trimestre,
                          INPUT tt-param.ano).

    /* S‡ CONSIDERA OS CANAIS QUE O USUµRIO ESCOLHEU NO PROGRAMA */
    IF  CAN-FIND (FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            /* CANAIS ESTRUTURA CENTRAL - FILIAL COM BASE NA DIGITAÄ«O DO USUµRIO*/
            RUN esp/esb/esesbapi005.p (INPUT string(tt-digita.canal-central),
                                       OUTPUT TABLE tt-central-aux,
                                       OUTPUT TABLE tt-erro).
    
            FOR EACH tt-central-aux:
                CREATE tt-central.
                BUFFER-COPY tt-central-aux TO tt-central.
            END.

            IF  RETURN-VALUE <> "OK" 
            OR  CAN-FIND (FIRST tt-erro) THEN
                RETURN "NOK".
        END.
    END.
    ELSE DO:
        /* TODOS OS CANAIS DENTRO DA ESTRUTURA CENTRAL - FILIAL*/
        RUN esp/esb/esesbapi005.p (INPUT "",
                                   OUTPUT TABLE tt-central,
                                   OUTPUT TABLE tt-erro).

        IF  RETURN-VALUE <> "OK" 
        OR  CAN-FIND (FIRST tt-erro) THEN
            RETURN "NOK".
    END.

    /*----------------------------------------------------*/
    /*  APURA FATURAMENTO DO M“S PARA O CANAL             */
    /*----------------------------------------------------*/
    RUN pi-APURACAO-BASE-CALCULO-TRIMESTREAL.

    IF  RETURN-VALUE <> "OK" THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Erro ao buscar faturamento mensal",
                                            INPUT "").
        RETURN "NOK".
    END.

    /* MENSAGEM QUE LISTA FORMAS DE PAGAMENTO DO CRM */
    RUN pi-CARREGA-FORMA-PAGAMENTO-CRM.
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    /*---------------------------*/
    /*  APURAÄ«O DOS BENEF÷CIOS  */
    /*---------------------------*/
    RUN pi-acompanhar IN h-acomp ("Buscando benef°cios...").
    RUN pi-BUSCA-BENEFICIO-CANAL.
    
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    /*------------------------------------------------------------------------*/
    /*  GERAÄ«O CONTA CORRENTE  P/    R E B A T E                            */
    /*------------------------------------------------------------------------*/           
    RUN pi-GERA-CONTA-CORRENTE.
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK". 
    

    /* Valida existància de fornecedor financeiro */
    FOR EACH tt-cc-benef:
        FIND FIRST fornec_financ 
            WHERE fornec_financ.cdn_fornecedor = tt-cc-benef.canal
              AND fornec_financ.cod_empresa    = v_cod_empres_usuar NO-LOCK NO-ERROR.

        IF  NOT AVAIL fornec_financ THEN 
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Fornecedor financeiro n∆o cadastrado: " + STRING(tt-cc-benef.canal),
                                                INPUT "").                                    
    END.
    IF  CAN-FIND (FIRST tt-erro) THEN
        RETURN "NOK".

    /*-------------------------*/
    /* GERAÄ«O NO MODO "PRêVIA */
    /*-------------------------*/
    IF  tt-param.rs-tipo = 1 /* Simulaá∆o */
    THEN
        RETURN "OK".


    /*-------------------------------------------------------------------*/
    /*    TRANSAÄ«O PRINCIPAL  execuá∆o opá∆o OFICIAL                    */
    /*     FUNÄ«0: > GRAVAR OS NOVOS REGISTROS DE CONTA CORRENTE         */
    /*            > MARCAR OS REGISTROS ANTERIORES COMO FINALIZADOS      */
    /*            > INTEGRAR OS NOVOS REGISTROS COM O FINANCEIRO         */
    /*-------------------------------------------------------------------*/
    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco 
             ON ERROR  UNDO bloco, LEAVE bloco:
        
        /*---------------------------------------------------*/
        /*  GRAVA CONTA CORRENTE QUANDO FOR GERAÄ«O OFICIAL  */
        /*---------------------------------------------------*/
        RUN pi-GRAVA-CONTA-CORRENTE-DESPESA.

        IF  RETURN-VALUE <> "OK" THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Erro gravando conta corrente benef°cio.",
                                                INPUT "Ocorreu um erro na tentativa de gravaá∆o de novos registros de conta correte para os canais.":U).
            UNDO bloco, RETURN "NOK".
        END.

        
        /* GRAVA O FATURAMENTO TRIMESTRAL */   
        RUN pi-acompanhar IN h-acomp ("Gravando base de c†lculo...").
        
        RUN pi-GRAVA-FAT-MENSAL.

        IF  RETURN-VALUE <> "OK" THEN DO:
            UNDO bloco , RETURN "NOK".
        END.

        /*---------------------------------------------------------------------*/
        /*             INTEGRAR OS BENEF÷CIOS COM O CONTAS A PAGAR             */
        /*---------------------------------------------------------------------*/
        RUN pi-acompanhar IN h-acomp ("Gerando T°tulos com o Contas a Pagar...").

        IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
             RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.

        RUN pi-INTEGRA-DESPESAS-APB.

        IF  VALID-HANDLE(h-esesb003-apb) THEN
            DELETE PROCEDURE h-esesb003-apb.

        IF  RETURN-VALUE <> "OK" THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Erro na integraá∆o de benef°cios com o Contas a Pagar.",
                                                INPUT "Favor entrar em contato com a TIC da Intelbras.":U).
            UNDO bloco, RETURN "NOK".
        END.
    END. /* DO TRANSACTION */

    RETURN "OK".
END.


/*------------------------------------------------------------------------------------------*/
/*   G E R A Ä « O   C O N T A S   C O R R E N T E S   D O S   B E N E F ÷ C I O S          */
/*------------------------------------------------------------------------------------------*/
PROCEDURE pi-GERA-CONTA-CORRENTE:
    
    /* APURAÄ«O DA CONTA CORRENTE PARA REBATE */
    DEF VAR de-vl-beneficio        AS DEC  NO-UNDO.
    DEF VAR da-vencto-rebate       AS DATE NO-UNDO.
    DEF VAR de-saldo-atual         AS DEC  NO-UNDO.
    DEF VAR da-ini-tri-anterior    AS DATE NO-UNDO.
    DEF VAR da-fim-tri-anterior    AS DATE NO-UNDO.
    DEF VAR de-base-fat-dev        AS DEC  NO-UNDO.
    DEF VAR de-base-fat-dev-rebate AS DEC  NO-UNDO.
    DEF VAR i-reg                  AS INTEGER NO-UNDO.
    DEF VAR i-cont                 AS INTEGER NO-UNDO.


    RUN pi-acompanhar IN h-acomp ("Gerando Conta Corrente para Benef°cio REBATE... ").

    /* VENCIMENTO DO PRAZO PARA SOLICITAÄ«O DO REBATE */
    ASSIGN da-vencto-rebate = da-fim + 60.


    /* Conta total de registros */
    FOR EACH tt-fat-mensal  NO-LOCK
        WHERE tt-fat-mensal.ano = YEAR(da-fim)
          AND tt-fat-mensal.mes >= MONTH(da-ini)
          AND tt-fat-mensal.mes <= MONTH(da-fim)
        , EACH tt-beneficio
            WHERE tt-beneficio.canal          = tt-fat-mensal.canal 
              AND tt-beneficio.unid-neg       = tt-fat-mensal.unid-neg
              AND tt-beneficio.id-status      <> 2 /* BLOQUEADO */
           BREAK BY tt-fat-mensal.canal
                 BY tt-beneficio.tipo-beneficio
                 BY tt-fat-mensal.unid-neg:

         IF  LAST-OF (tt-fat-mensal.unid-neg) THEN
             i-reg = i-reg + 1.
    END.

    /* Cria a tt-cc-benef */
    FOR EACH tt-fat-mensal  NO-LOCK
        WHERE tt-fat-mensal.ano = YEAR(da-fim)
          AND tt-fat-mensal.mes >= MONTH(da-ini)
          AND tt-fat-mensal.mes <= MONTH(da-fim)
        , EACH tt-beneficio
            WHERE tt-beneficio.canal          = tt-fat-mensal.canal 
              AND tt-beneficio.unid-neg       = tt-fat-mensal.unid-neg
              AND tt-beneficio.id-status      <> 2 /* BLOQUEADO */
        ,FIRST emitente NO-LOCK 
            WHERE emitente.cod-emitente = tt-beneficio.canal

       BREAK BY tt-fat-mensal.canal
             BY tt-beneficio.tipo-beneficio
             BY tt-fat-mensal.unid-neg:
       
        IF  FIRST-OF (tt-fat-mensal.unid-neg) THEN 
            ASSIGN de-base-fat-dev        = 0
                   de-base-fat-dev-rebate = 0.
        
          ASSIGN de-base-fat-dev        = de-base-fat-dev        + tt-fat-mensal.vl-apurado /*Faturamento/devoluá‰es*/
                 de-base-fat-dev-rebate = de-base-fat-dev-rebate + tt-fat-mensal.vl-apurado-rebate.

        IF  LAST-OF (tt-fat-mensal.unid-neg) THEN DO:

            ASSIGN i-cont = i-cont + 1.
            /* BENEF÷CIO APURADO */
            IF  tt-beneficio.tipo-beneficio = 37  THEN /*Base do Rebate (desconta o faturamento com rebate antecipado*/
                ASSIGN de-vl-beneficio = (de-base-fat-dev-rebate * tt-beneficio.perc-global) / 100.  
            ELSE
                ASSIGN de-vl-beneficio = (de-base-fat-dev * tt-beneficio.perc-global) / 100.  

            RUN pi-acompanhar IN h-acomp ("Processando Conta Corrente: " + STRING(i-cont) + " de " + STRING(i-reg) ).

            IF  de-vl-beneficio >= 0.01 THEN DO:
                CREATE tt-cc-benef.
                ASSIGN tt-cc-benef.tp-movto             = 2 /*DESPESA*/
                       tt-cc-benef.canal                = tt-fat-mensal.canal
                       tt-cc-benef.unid-neg             = UPPER(tt-fat-mensal.unid-neg)
                       tt-cc-benef.tipo-beneficio       = tt-beneficio.tipo-beneficio
                       tt-cc-benef.classificacao        = tt-beneficio.guid-class
                       tt-cc-benef.categoria            = tt-beneficio.tipo-categoria
                       tt-cc-benef.guid-canal           = tt-beneficio.guid-canal
                       tt-cc-benef.guid-beneficio       = tt-beneficio.guid-beneficio
                       tt-cc-benef.guid-beneficio-canal = tt-beneficio.guid-beneficio-canal
                       tt-cc-benef.dt-periodo-ini       = da-ini
                       tt-cc-benef.dt-periodo-fim       = da-fim
                       tt-cc-benef.vl-base-calc         = (IF  tt-beneficio.tipo-beneficio = 37 THEN de-base-fat-dev-rebate ELSE de-base-fat-dev)  /* BASE DE CµLCULO, VALOR APURADO DO FATURAMENTO - DEVOLUÄÂES + SELLOUT DO PER÷ODO. */
                       tt-cc-benef.perc-benef           = tt-beneficio.perc-global
                       tt-cc-benef.VerbaCalculada       = de-vl-beneficio         /* SALDO ORIGINAL,  ê A APURAÄ«O NO MOMENTO DO CµLCULO (% DO BENEF÷CIO APLICADO NA BASE DE FATURAMENTO DO CANAL */   
                       tt-cc-benef.dt-transacao         = da-fim
                       tt-cc-benef.dt-vencimento        = da-vencto-rebate
                       tt-cc-benef.id-status            = 1 /*CONTA CORRENTE ATIVA */
                       tt-cc-benef.usuario              = c-seg-usuario 
                       tt-cc-benef.canal-matriz         = tt-fat-mensal.canal-matriz
                       tt-cc-benef.perc-custo           = tt-beneficio.perc-custo.
                       
                RUN pi-exporta-tt-cc-benef.
            END.
        END.
    END.

    /* Atualiza saldo e status das apuraá‰es anteriores */

    RETURN "OK".
    
END.

PROCEDURE pi-GRAVA-CONTA-CORRENTE-DESPESA:
    /*------------------------------------------------------------------------------*/
    /*                    REBATE / STOCK ROTATION / VMC (OURO)                      */
    /*------------------------------------------------------------------------------*/

    DEF VAR i-cont AS INTEGER NO-UNDO.
    DEF VAR i-reg  AS INTEGER NO-UNDO.

    RUN pi-acompanhar IN h-acomp ("Gravando Conta Corrente dos Benef°cios ...").

    /*Conta n£mero de registros*/
    FOR EACH tt-cc-benef
        WHERE tt-cc-benef.tp-movto  = 2 /*DESPESA*/
          AND tt-cc-benef.id-status = 1:
        ASSIGN i-reg = i-reg + 1.
    END.

    FOR EACH tt-cc-benef
        WHERE tt-cc-benef.tp-movto  = 2 /*DESPESA*/
          AND tt-cc-benef.id-status = 1:

        i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp ("Gravando Conta Corrente: " + STRING(i-cont) + " de " + STRING(i-reg)).

        FIND FIRST int-cc-benef EXCLUSIVE-LOCK
            WHERE int-cc-benef.tp-movto        = tt-cc-benef.tp-movto
              AND int-cc-benef.canal           = tt-cc-benef.canal
              AND int-cc-benef.unid-neg        = tt-cc-benef.unid-neg 
              AND int-cc-benef.tipo-beneficio  = tt-cc-benef.tipo-beneficio 
              AND int-cc-benef.dt-periodo-ini  = tt-cc-benef.dt-periodo-ini
              AND int-cc-benef.dt-periodo-fim  = tt-cc-benef.dt-periodo-fim NO-ERROR. 

        IF  NOT AVAIL int-cc-benef THEN DO:
            CREATE int-cc-benef.
            ASSIGN int-cc-benef.tp-movto       = tt-cc-benef.tp-movto
                   int-cc-benef.canal          = tt-cc-benef.canal         
                   int-cc-benef.unid-neg       = tt-cc-benef.unid-neg      
                   int-cc-benef.tipo-beneficio = tt-cc-benef.tipo-beneficio
                   int-cc-benef.dt-periodo-ini = tt-cc-benef.dt-periodo-ini     
                   int-cc-benef.dt-periodo-fim = tt-cc-benef.dt-periodo-fim.

        END.
        ELSE IF  int-cc-benef.VerbaCalculada > 0 THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "Registro j† possui verba calculada",
                                                INPUT "Canal EMS.: " + STRING(tt-cc-benef.canal)                                     + CHR(10) +                                                                                                                                   
                                                      "Unidade...: " +        tt-cc-benef.unid-neg                                   + CHR(10) +                                                                                                                                   
                                                      "Benef°cio.: " +        fn-retorna-nome-beneficio(tt-beneficio.tipo-beneficio) + CHR(10) +                                                                                                     
                                                      "Canal CRM.: " +        int-cc-benef.guid-canal ).
            RETURN "NOK".
        END.

        BUFFER-COPY tt-cc-benef  
            EXCEPT  tp-movto 
                    canal
                    unid-neg
                    tipo-beneficio
                    dt-periodo-ini
                    dt-periodo-fim 
                    VerbaAjustada 
                    VerbaCancelada
                    VerbaPeriodoAnterior
                    VerbaAcumulada  
                    num_id_tit_ap
                    cod_estab
            TO int-cc-benef.

        ASSIGN tt-cc-benef.r-rowid = ROWID(int-cc-benef).
        RELEASE int-cc-benef.
    END.

    RETURN "OK".
END.

/*-------------------------------------------------------------------*/
/*        B U S C A R   B E N E F ÷ C I O S   D O   C A N A L        */
/*-------------------------------------------------------------------*/
PROCEDURE pi-BUSCA-BENEFICIO-CANAL:

    /*------------------------------------------------------------------------------*/
    /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */
    /*------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio.

    /* Busca os benef°cios que s∆o automaticamente sincronizados com o ERP pelo CRM */
    RUN esp/esb/esesbapi004-benef-erp.p (INPUT  YES,
                                         INPUT  YES,  /* Buscar msg0111 com o % global de cada benef°cio   */
                                         INPUT  YES,  /* Buscar msg0142, parÉmetros financeiros e provis∆o */
                                         INPUT  ?,    /* (?) Totadas as Unidades                           */
                                         INPUT  ?,    /* (?) Totadas as beneficios                         */
                                         INPUT  TABLE tt-canal,
                                         OUTPUT TABLE tt-erro-benef,
                                         OUTPUT TABLE tt-beneficio).

    IF  RETURN-VALUE <> "OK" THEN DO:
        IF  CAN-FIND (FIRST tt-erro-benef) THEN DO:
            FOR EACH tt-erro-benef:
                CREATE tt-erro.
                BUFFER-COPY tt-erro-benef TO tt-erro.
            END.
            RETURN "NOK".
        END.
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "(1) Erro desconhecido na busca de Benef°cios ",
                                            INPUT "Benef°cios n∆o foram carregados para c†lculo, devido a erro desconhecido.").
        RETURN "NOK".
    END.


    /* MantÇm apenas os benef°cios que geram conta corrente */
    FOR EACH tt-beneficio:
        IF  tt-beneficio.tipo-beneficio <> 21
        AND tt-beneficio.tipo-beneficio <> 22 
        AND tt-beneficio.tipo-beneficio <> 37
        AND tt-beneficio.tipo-beneficio <> 66 THEN
            DELETE tt-beneficio.
    END.

    /* EXPORTAR OS BENEF÷CIOS ENCONTRADOS */
    RUN pi-exporta-beneficios.

    RETURN "OK".
END.

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

PROCEDURE pi-RETORNA-DATAS:

    DEF INPUT PARAM p-trimestre AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-ano AS INTEGER NO-UNDO.
    
    /**************** CALCULAR DATA INICIAL E FINAL *****************/
    CASE p-trimestre:
        WHEN 01 THEN ASSIGN da-ini = DATE(01, 01, p-ano)
                            da-fim = DATE(03, 31, p-ano).
        WHEN 02 THEN ASSIGN da-ini = DATE(04, 01, p-ano)
                            da-fim = DATE(06, 30, p-ano).  
        WHEN 03 THEN ASSIGN da-ini = DATE(07, 01, p-ano)
                            da-fim = DATE(09, 30, p-ano).  
        WHEN 04 THEN ASSIGN da-ini = DATE(10, 01, p-ano)
                            da-fim = DATE(12, 31, p-ano).  
    END CASE.

    RETURN "OK".
END.

PROCEDURE pi-valida-campo-em-branco:
    DEF INPUT PARAM p-campo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-valor AS CHAR NO-UNDO.
    IF  p-valor = ""
    OR  p-valor = ? THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Campo <" + p-campo + "> n∆o preenchido.",
                                            INPUT "Canal: " + STRING(int-emitente.cod-emitente) 
                                                            + " / Unid Neg.: " + c-unid-negoc).
        RETURN "NOK".
    END.

    RETURN "OK".
END.

PROCEDURE pi-INTEGRA-DESPESAS-APB:

    DEF VAR i-reg          AS INTEGER NO-UNDO.
    DEF VAR i-cont         AS INTEGER NO-UNDO.

    FOR EACH tt-cc-benef
        WHERE tt-cc-benef.tp-movto  = 2 /* DESPESA */
          AND tt-cc-benef.id-status = 1: /* ATIVA */
        i-reg = i-reg + 1.
    END.

    FOR EACH tt-cc-benef
        WHERE tt-cc-benef.tp-movto  = 2         /* DESPESA */
          AND tt-cc-benef.id-status = 1         /* ATIVA */
          AND tt-cc-benef.tipo-beneficio <> 22: /* STOCK ROTATION N«O GERA DESPESA */

        i-cont = i-cont + 1.

        RUN pi-acompanhar IN h-acomp ("Gerando T°tulos Contas a Pagar: " + STRING(i-cont) + " de " + STRING(i-reg)).
        
        RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT tt-cc-benef.r-rowid,
                                                       INPUT tt-cc-benef.VerbaCalculada,
                                                       INPUT NO,
                                                       INPUT tt-param.da-transacao,
                                                       INPUT tt-cc-benef.dt-periodo-fim,
                                                       INPUT NO, /*n∆o Ç tratado como desconto em duplicata*/
                                                       INPUT TABLE tt-beneficio,
                                                       OUTPUT TABLE tt-erro-apb).

        IF  CAN-FIND (FIRST tt-erro-apb)
        OR  RETURN-VALUE <> "OK" THEN DO:
            DEF VAR l-erro AS LOG NO-UNDO.
            FOR EACH tt-erro-apb:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                    INPUT tt-erro-apb.mensagem,
                                                    INPUT tt-erro-apb.mensagem ).

                l-erro = YES.
            END.

            IF  NOT l-erro THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                    INPUT "Retorno com erro, mas n∆o retornou descriá∆o do mesmo.",
                                                    INPUT "").


            END.

            RETURN "NOK".
        END.

    END.

END.

       
PROCEDURE pi-APURACAO-BASE-CALCULO-TRIMESTREAL:

    RUN esp/esb/esesbapi002-fat-dev.p (INPUT da-ini,
                                       INPUT da-fim,
                                       INPUT "C", /* Tipo = C†lculo */
                                       INPUT  TABLE tt-central,
                                       OUTPUT TABLE tt-fat-mensal,
                                       OUTPUT TABLE tt-fat-mensal-det,
                                       OUTPUT TABLE tt-canal,
                                       OUTPUT TABLE tt-erro).

    IF  RETURN-VALUE <> "OK" 
    OR CAN-FIND (FIRST tt-erro) THEN 
        RETURN "NOK".            

    IF  NOT CAN-FIND (FIRST tt-canal) THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Faturamento Inexistente",
                                            INPUT "N∆o foram encontrados dados de faturamento para c†lculo.").
        RETURN "NOK".
    END.

    /* EXPORTA OS DADOS */
    RUN pi-exporta-fat.
    RUN pi-exporta-fat-detalhes.

    RETURN "OK".
    
END PROCEDURE.

PROCEDURE pi-GRAVA-FAT-MENSAL:

    /*------------------------------------------------------------------------*/
    /* DELETA INF-FAT-MENSAL e INT-FAT-MENSAL PARA O PER÷ODO DE PROCESSAMENTO */
    /*------------------------------------------------------------------------*/
    FOR EACH tt-central:
        FOR EACH int-fat-mensal EXCLUSIVE-LOCK
            WHERE int-fat-mensal.ano   = YEAR(da-ini)
              AND int-fat-mensal.mes  >= MONTH(da-ini)
              AND int-fat-mensal.mes  <= MONTH(da-fim)
              AND int-fat-mensal.tipo  = "C" 
              AND int-fat-mensal.canal = tt-central.canal-central:
            DELETE int-fat-mensal.
        END.
        
        FOR EACH int-fat-mensal-det EXCLUSIVE-LOCK
            WHERE int-fat-mensal.ano  = YEAR(da-ini)
              AND int-fat-mensal.mes >= MONTH(da-ini)
              AND int-fat-mensal.mes <= MONTH(da-fim)
              AND int-fat-mensal.tipo = "C" /* C†lculo */
              AND int-fat-mensal.canal = tt-central.canal-central:
            DELETE int-fat-mensal-det.
        END.
    END.
    /*-----------------------------------------------------------------------*/
    /*                               CRIAÄ«O                                 */
    /*-----------------------------------------------------------------------*/
    FOR EACH tt-fat-mensal
       , FIRST tt-beneficio  
             WHERE tt-beneficio.canal          = tt-fat-mensal.canal 
               AND tt-beneficio.unid-neg       = tt-fat-mensal.unid-neg
               AND tt-beneficio.id-status     <> 2 /*BLOQUEADO*/:
        CREATE int-fat-mensal.    
        BUFFER-COPY tt-fat-mensal TO int-fat-mensal.

    END.

    FOR EACH tt-fat-mensal-det
        , FIRST tt-beneficio  
             WHERE tt-beneficio.canal          = tt-fat-mensal-det.canal 
               AND tt-beneficio.unid-neg       = tt-fat-mensal-det.unid-neg
               AND tt-beneficio.id-status     <> 2 /*BLOQUEADO*/:    

        CREATE int-fat-mensal-det.    
        BUFFER-COPY tt-fat-mensal-det TO int-fat-mensal-det.
    END.

    RETURN "OK".

END.

PROCEDURE pi-CARREGA-FORMA-PAGAMENTO-CRM:
        
    EMPTY TEMP-TABLE  msg0160r-FormaPagamentoItem. 
    EMPTY TEMP-TABLE  resultado. 
    
    FOR EACH int-forma-pagto NO-LOCK:
        CREATE msg0160r-FormaPagamentoItem.
        ASSIGN msg0160r-FormaPagamentoItem.CodigoFormaPagamento = int-forma-pagto.guid-forma-pagto
               msg0160r-FormaPagamentoItem.NomeFormaPagamento   = int-forma-pagto.desc-forma-pagto.
    END.

    IF  NOT CAN-FIND(FIRST msg0160r-FormaPagamentoItem ) THEN DO:

        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "N∆ existem formas de pagamento cadastradas no programa esesb012" ,
                                            INPUT "" ).
        RETURN "NOK".
    END.

    RETURN "OK".

END.

PROCEDURE pi-exporta-beneficios:
                        
    DEF VAR c-status AS CHAR FORMAT "x(10)" NO-UNDO.

    FOR EACH tt-beneficio
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-beneficio.canal:
    
        CASE tt-beneficio.id-status:
            WHEN 1 THEN ASSIGN c-status = "ATIVO"    .
            WHEN 2 THEN ASSIGN c-status = "BLOQUEADO".
            WHEN 3 THEN ASSIGN c-status = "SUSPENSO" .
            OTHERWISE ASSIGN c-status = ?.
        END CASE.

         EXPORT STREAM exp1 DELIMITER ";" tt-beneficio.canal   
                                          emitente.nome-abrev
                                          tt-beneficio.unid-neg               
                                          fn-retorna-nome-beneficio(tt-beneficio.tipo-beneficio)
                                          tt-beneficio.tipo-categoria         
                                          tt-beneficio.nome-class             
                                          tt-beneficio.perc-global            
                                          tt-beneficio.perc-custo                                         
                                          tt-beneficio.perc-prov-meta         
                                          c-status              
                                          tt-beneficio.conta-contab           
                                          tt-beneficio.centro-custo           
                                          tt-beneficio.cod-estabel            
                                          tt-beneficio.cod-especie            
                                          tt-beneficio.tipo-fluxo             
                                          tt-beneficio.exclusividade             
                                          tt-beneficio.calcula-verba                                                
                                          tt-beneficio.guid-canal             
                                          tt-beneficio.guid-beneficio 
                                          tt-beneficio.guid-beneficio-canal   
                                          tt-beneficio.guid-class             
                                          tt-beneficio.guid-categoria.         
    END.                                                                      


END.

PROCEDURE pi-exporta-tt-cc-benef:
    
    EXPORT STREAM exp2 DELIMITER ";" IF tt-cc-benef.tp-movto = 1 THEN "Provis∆o" ELSE "Despesa"
                                     tt-cc-benef.canal         
                                     emitente.nome-abrev
                                     tt-cc-benef.unid-neg      
                                     fn-retorna-nome-beneficio (tt-cc-benef.tipo-beneficio) 
                                     tt-cc-benef.categoria
                                     tt-beneficio.nome-class
                                     tt-cc-benef.dt-periodo-ini
                                     tt-cc-benef.dt-periodo-fim
                                     tt-cc-benef.vl-base-calc
                                     tt-cc-benef.perc-benef
                                     tt-cc-benef.VerbaCalculada
                                     tt-cc-benef.perc-custo
                                     ((tt-cc-benef.vl-base-calc * tt-cc-benef.perc-custo / 100) * tt-cc-benef.perc-benef / 100)
                                     tt-cc-benef.dt-transacao  
                                     tt-cc-benef.dt-vencimento 
                                     IF tt-cc-benef.id-status = 1 THEN "ATIVA" ELSE "FINALIZADA"
                                     tt-cc-benef.usuario       
                                     /*tt-cc-benef.vl-saldo-transp-vmc-ouro*/
                                     tt-cc-benef.classificacao       
                                     tt-cc-benef.guid-canal              
                                     tt-cc-benef.guid-beneficio          
                                     tt-cc-benef.guid-beneficio-canal.      

END.

PROCEDURE pi-exporta-fat:

    RUN pi-acompanhar IN h-acomp ("Exportando faturamento para arquivo...").
    FOR EACH tt-fat-mensal
        /*,FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = tt-fat-mensal.canal
        ,FIRST int-benef-canal NO-LOCK
            WHERE int-benef-canal.CodigoConta          = int-emitente.cod-guid
              AND int-benef-canal.CodigoUnidadeNegocio = tt-fat-mensal.unid-neg
              AND int-benef-canal.NomeStatusBeneficio  <> "BLOQUEADO"
        */
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-fat-mensal.canal:

        EXPORT STREAM exp-fat DELIMITER ";" tt-fat-mensal.ano         
                                            tt-fat-mensal.mes         
                                            tt-fat-mensal.canal
                                            emitente.nome-abrev
                                            tt-fat-mensal.unid-neg    
                                            tt-fat-mensal.vl-faturado
                                            tt-fat-mensal.vl-devolvido
                                            tt-fat-mensal.vl-apurado
                                            tt-fat-mensal.vl-faturado-rebate
                                            tt-fat-mensal.vl-devolvido-rebate
                                            tt-fat-mensal.vl-apurado-rebate
                                            tt-fat-mensal.guid-canal.        
    END.
END.


PROCEDURE pi-exporta-fat-detalhes:

    RUN pi-acompanhar IN h-acomp ("Exportando detalhes faturamento para arquivo...").
    FOR EACH tt-fat-mensal-det
        /*
        ,FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = tt-fat-mensal-det.canal
        ,FIRST int-benef-canal NO-LOCK
            WHERE int-benef-canal.CodigoConta          = int-emitente.cod-guid
              AND int-benef-canal.CodigoUnidadeNegocio = tt-fat-mensal-det.unid-neg
              AND int-benef-canal.NomeStatusBeneficio  <> "BLOQUEADO"
         */     
        ,FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = tt-fat-mensal-det.canal:
    
        EXPORT STREAM exp-fat-det DELIMITER ";" tt-fat-mensal-det.ano         
                                             tt-fat-mensal-det.mes         
                                             tt-fat-mensal-det.canal
                                             emitente.nome-abrev
                                             tt-fat-mensal-det.cod-emitente
                                             tt-fat-mensal-det.unid-neg    
                                             (IF tt-fat-mensal-det.tp-movto = 1 THEN "FATUR" ELSE "DEVOL")
                                             tt-fat-mensal-det.seq         
                                             tt-fat-mensal-det.cod-estabel 
                                             tt-fat-mensal-det.serie       
                                             tt-fat-mensal-det.nr-nota-fis 
                                             tt-fat-mensal-det.nr-seq-fat  
                                             tt-fat-mensal-det.it-codigo   
                                             tt-fat-mensal-det.vl-faturado 
                                             tt-fat-mensal-det.vl-faturado-rebate
                                             tt-fat-mensal-det.data
                                             tt-fat-mensal-det.serie-docto 
                                             tt-fat-mensal-det.nro-docto   
                                             tt-fat-mensal-det.cod-emitente
                                             tt-fat-mensal-det.nat-operacao
                                             tt-fat-mensal-det.sequencia   
                                             tt-fat-mensal-det.vl-devolvido
                                             tt-fat-mensal-det.vl-devolvido-rebate.        
    END.

    
END.
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                          F U N Ä Â E S   I N T E R N A S                                                                                */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.




/* PROCEDURE pi-INTEGRA-DESPESAS-APB-ant:                                                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                    */
/*     DEF VAR v_hdl_aux                 AS HANDLE              NO-UNDO.                                                                                                                                                                              */
/*     DEF VAR v_cod_matriz_trad_org_ext AS CHAR FORMAT "x(8)"  NO-UNDO.                                                                                                                                                                              */
/*     DEF VAR l-atualizou-pagto         AS LOGICAL             NO-UNDO.                                                                                                                                                                              */
/*     DEF VAR c-estab-ant               AS CHAR     INIT "-1"  NO-UNDO.                                                                                                                                                                              */
/*     DEF VAR c-ep-codigo               AS CHAR                NO-UNDO.                                                                                                                                                                              */
/*     DEF VAR de-valor-ap               AS DEC                 NO-UNDO.                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*     ASSIGN i-seq-ref    = 0                                                                                                                                                                                                                        */
/*            c-referencia = "".                                                                                                                                                                                                                      */
/*                                                                                                                                                                                                                                                    */
/*     RUN pi-zera-tabelas.                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     /* Busca benef°cios */                                                                                                                                                                                                                         */
/*     FOR EACH int-cc-benef NO-LOCK                                                                                                                                                                                                                  */
/*         WHERE int-cc-benef.tp-movto        = 2   /* DESPESA */                                                                                                                                                                                     */
/*           AND int-cc-benef.id-status       = 1   /* ATIVO */                                                                                                                                                                                       */
/*           AND int-cc-benef.tipo-beneficio <> 22  /* N«O GERA PARA STOCK ROTATION */                                                                                                                                                                */
/*         BREAK BY int-cc-benef.tp-movto                                                                                                                                                                                                             */
/*               BY int-cc-benef.tipo-beneficio                                                                                                                                                                                                       */
/*               BY int-cc-benef.unid-neg:                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                    */
/*         /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB009RP.P (PROVIS«O) - POIS ELE UTILIZA-SE  */                                                                                           */
/*         /* DESTA CODIFICAÄ«O PARA PROVISIONAR O BENEF÷CIO. O PROGRAMA ESESBAPI003-APB.P TAMBêM UTILIZAR ESSE FORMATO DE C‡DIGO                        */                                                                                           */
/*         ASSIGN c-cod-titulo = STRING             (int-cc-benef.tipo-beneficio)        +                                                                                                                                                            */
/*                               TRIM  (STRING      (int-cc-benef.unid-neg))             +                                                                                                                                                            */
/*                               STRING (MONTH      (int-cc-benef.dt-periodo-fim), "99") +                                                                                                                                                            */
/*                               SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*         /* WEB SERVICE DO CRM RETORNARµ AS INFORMAÄÂES ABAIXO */                                                                                                                                                                                   */
/*         IF  FIRST-OF (int-cc-benef.unid-neg) THEN DO:                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*             FIND FIRST tt-beneficio                                                                                                                                                                                                                */
/*                 WHERE tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio                                                                                                                                                                    */
/*                   AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg NO-ERROR.                                                                                                                                                                */
/*             IF  NOT AVAIL tt-beneficio THEN DO:                                                                                                                                                                                                    */
/*                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                                                                                                                                                        */
/*                                                     INPUT "Erro ao buscar a conta, centro de custo, estabelecimento e espÇcie, da Unidade: " + int-cc-benef.unid-neg + " - Benef°cio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio),  */
/*                                                     INPUT "Favor entrar em contato com a TIC da Intelbras.":U).                                                                                                                                    */
/*                 RETURN "NOK".                                                                                                                                                                                                                      */
/*             END.                                                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                    */
/*             ASSIGN c-conta        = tt-beneficio.conta                                                                                                                                                                                             */
/*                    c-centro-custo = tt-beneficio.centro-custo                                                                                                                                                                                      */
/*                    c-cod-estab    = tt-beneficio.cod-estabel                                                                                                                                                                                       */
/*                    c-especie      = tt-beneficio.cod-especie                                                                                                                                                                                       */
/*                    c-tipo-fluxo   = tt-beneficio.tipo-fluxo  .                                                                                                                                                                                     */
/*                                                                                                                                                                                                                                                    */
/*         END.                                                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                    */
/*         IF  c-estab-ant <> c-cod-estab THEN DO:                                                                                                                                                                                                    */
/*             FIND FIRST estabelec NO-LOCK                                                                                                                                                                                                           */
/*                  WHERE estabelec.cod-estabel = c-cod-estab NO-ERROR.                                                                                                                                                                               */
/*             IF NOT AVAIL estabelec THEN DO:                                                                                                                                                                                                        */
/*                 RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                                                                                                                                                        */
/*                                             INPUT "Estabelecimento inv†lido: " + c-cod-estab,                                                                                                                                                      */
/*                                             INPUT "Favor entrar em contato com a TIC da Intelbras.").                                                                                                                                              */
/*                 RETURN "NOK".                                                                                                                                                                                                                      */
/*             END.                                                                                                                                                                                                                                   */
/*             ASSIGN c-estab-ant = c-cod-estab                                                                                                                                                                                                       */
/*                    c-ep-codigo = estabelec.ep-codigo.                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*         END.                                                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                    */
/*         /*  Verifica se o benef°cio j† possui t°tulo j† criado em per°odos anteriores  */                                                                                                                                                          */
/*         FIND FIRST tit_ap NO-LOCK                                                                                                                                                                                                                  */
/*             WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab                                                                                                                                                                                    */
/*               AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.                                                                                                                                                                      */
/*                                                                                                                                                                                                                                                    */
/*         /*-----------------------------------*/                                                                                                                                                                                                    */
/*         /*   APLICA NO SALDO, O % DE CUSTO   */                                                                                                                                                                                                    */
/*         /*-----------------------------------*/                                                                                                                                                                                                    */
/*         IF  NOT (tt-beneficio.perc-custo > 0) THEN DO:                                                                                                                                                                                             */
/*             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                                                                                                                                                            */
/*                                                 INPUT "% de custo para c†lcular saldo do t°tulo Ç inv†lido",                                                                                                                                       */
/*                                                 INPUT "Canal EMS.: " + STRING(int-cc-benef.canal)    + CHR(10) +                                                                                                                                   */
/*                                                       "Unidade...: " +       int-cc-benef.unid-neg   + CHR(10) +                                                                                                                                   */
/*                                                       "Benef°cio.: " +       fn-retorna-nome-beneficio(tt-beneficio.tipo-beneficio)+ CHR(10) +                                                                                                     */
/*                                                       "Canal CRM.: " + int-cc-benef.guid-canal ).                                                                                                                                                  */
/*             RETURN "NOK".                                                                                                                                                                                                                          */
/*         END.                                                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                    */
/*         ASSIGN de-valor-ap = int-cc-benef.vl-saldo * (tt-beneficio.perc-custo / 100).                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*         IF  AVAIL tit_ap THEN DO:                                                                                                                                                                                                                  */
/*             RUN pi-ALTERA-temp-table-titulo (INPUT c-cod-estab,                                                                                                                                                                                    */
/*                                              INPUT da-fim /*int-cc-benef.dt-periodo-fim*/,                                                                                                                                                         */
/*                                              INPUT int-cc-benef.dt-vencimento,                                                                                                                                                                     */
/*                                              INPUT de-valor-ap,                                                                                                                                                                                    */
/*                                              INPUT "Alteraá∆o saldo e vencimento t°tulo").                                                                                                                                                         */
/*             IF  RETURN-VALUE <> "OK" THEN                                                                                                                                                                                                          */
/*                 RETURN "NOK".                                                                                                                                                                                                                      */
/*         END.                                                                                                                                                                                                                                       */
/*         ELSE DO:                                                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                    */
/*             IF  int-cc-benef.vl-saldo > 0 THEN                                                                                                                                                                                                     */
/*                 RUN pi-CRIA-temp-table-titulo (INPUT NO, /* se NO indica que n∆o Ç provis∆o, e sim despesa*/                                                                                                                                       */
/*                                                INPUT c-cod-estab,                                                                                                                                                                                  */
/*                                                INPUT c-ep-codigo,                                                                                                                                                                                  */
/*                                                INPUT c-referencia,                                                                                                                                                                                 */
/*                                                INPUT c-conta,                                                                                                                                                                                      */
/*                                                INPUT c-centro-custo,                                                                                                                                                                               */
/*                                                INPUT c-especie,                                                                                                                                                                                    */
/*                                                INPUT c-tipo-fluxo,                                                                                                                                                                                 */
/*                                                INPUT c-cod-titulo,                                                                                                                                                                                 */
/*                                                INPUT tt-param.da-transacao /*int-cc-benef.dt-periodo-fim*/,                                                                                                                                        */
/*                                                INPUT int-cc-benef.dt-vencimento,                                                                                                                                                                   */
/*                                                INPUT int-cc-benef.canal,                                                                                                                                                                           */
/*                                                INPUT int-cc-benef.unid-neg,                                                                                                                                                                        */
/*                                                INPUT int-cc-benef.tipo-beneficio,                                                                                                                                                                  */
/*                                                INPUT int-cc-benef.categoria,                                                                                                                                                                       */
/*                                                INPUT de-valor-ap).                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                    */
/*             IF  RETURN-VALUE <> "OK" THEN                                                                                                                                                                                                          */
/*                 RETURN "NOK".                                                                                                                                                                                                                      */
/*         END.                                                                                                                                                                                                                                       */
/*     END. /* Fim looping benef°cios*/                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*     /*-----------------------------------------------------*/                                                                                                                                                                                      */
/*     /*          ROTINA PARA CRIAÄ«O DO T÷TULO              */                                                                                                                                                                                      */
/*     /*-----------------------------------------------------*/                                                                                                                                                                                      */
/*     RUN pi-efetiva-CRIACAO-titulo-APB.                                                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                    */
/*     IF  RETURN-VALUE <> "OK" THEN                                                                                                                                                                                                                  */
/*         RETURN "NOK".                                                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*     /*------------------------------------------------------------------------*/                                                                                                                                                                   */
/*     /*     Atualizaá∆o dos dados do t°tulo no registro da conta conrrente     */                                                                                                                                                                   */
/*     /*------------------------------------------------------------------------*/                                                                                                                                                                   */
/*     FOR EACH int-cc-benef EXCLUSIVE-LOCK                                                                                                                                                                                                           */
/*         WHERE int-cc-benef.tp-movto        = 2   /* DESPESA */                                                                                                                                                                                     */
/*           AND int-cc-benef.id-status       = 1   /* ATIVO */                                                                                                                                                                                       */
/*           AND int-cc-benef.tipo-beneficio <> 22: /* N«O GERA PARA STOCK ROTATION */                                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/*         ASSIGN l-atualizou-pagto = NO.                                                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                    */
/*         FIND FIRST tt-beneficio                                                                                                                                                                                                                    */
/*             WHERE tt-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio                                                                                                                                                                        */
/*               AND tt-beneficio.unid-neg       = int-cc-benef.unid-neg   NO-ERROR.                                                                                                                                                                  */
/*                                                                                                                                                                                                                                                    */
/*          /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB009RP.P (PROVIS«O) - POIS ELE UTILIZA-SE  */                                                                                          */
/*         /* DESTA CODIFICAÄ«O PARA PROVISIONAR O BENEF÷CIO. O PROGRAMA ESESBAPI003-APB.P TAMBêM UTILIZAR ESSE FORMATO DE C‡DIGO                         */                                                                                          */
/*         ASSIGN c-cod-titulo = STRING             (int-cc-benef.tipo-beneficio)         +                                                                                                                                                           */
/*                               TRIM  (STRING      (int-cc-benef.unid-neg))              +                                                                                                                                                           */
/*                               STRING (MONTH      (int-cc-benef.dt-periodo-fim), "99")  +                                                                                                                                                           */
/*                               SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*         FIND FIRST tit_ap NO-LOCK                                                                                                                                                                                                                  */
/*             WHERE tit_ap.cod_estab         = tt-beneficio.cod-estabel                                                                                                                                                                              */
/*               AND tit_ap.cdn_fornecedor    = int-cc-benef.canal                                                                                                                                                                                    */
/*               AND tit_ap.cod_espec_docto   = tt-beneficio.cod-especie                                                                                                                                                                              */
/*               AND tit_ap.cod_ser_docto     = "1"                                                                                                                                                                                                   */
/*               AND tit_ap.cod_tit_ap        = c-cod-titulo                                                                                                                                                                                          */
/*               AND tit_ap.cod_parcela       = "01"    NO-ERROR.                                                                                                                                                                                     */
/*                                                                                                                                                                                                                                                    */
/*         IF  AVAIL tit_ap THEN DO:                                                                                                                                                                                                                  */
/*              ASSIGN int-cc-benef.cod_estab     = tit_ap.cod_estab                                                                                                                                                                                  */
/*                     int-cc-benef.num_id_tit_ap = tit_ap.num_id_tit_ap                                                                                                                                                                              */
/*                     l-atualizou-pagto          = YES.                                                                                                                                                                                              */
/*          END.                                                                                                                                                                                                                                      */
/*          ELSE                                                                                                                                                                                                                                      */
/*              ASSIGN l-atualizou-pagto = NO.                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                    */
/*         IF  NOT l-atualizou-pagto THEN DO:                                                                                                                                                                                                         */
/*                                                                                                                                                                                                                                                    */
/*             RUN pi-cria-erro (INPUT 17006, /* Erro */                                                                                                                                                                                              */
/*                               INPUT "Erro ao tentar atualizar o registro de conta corrente para o Canal " + STRING(int-cc-benef.canal) + ", Unidade de Neg¢cio: " + int-cc-benef.unid-neg,                                                         */
/*                               INPUT "Favor entrar em contato com a TIC da Intelbras.":U).                                                                                                                                                          */
/*             RETURN "NOK".                                                                                                                                                                                                                          */
/*         END.                                                                                                                                                                                                                                       */
/*     END.                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     /*-----------------------------------------------------*/                                                                                                                                                                                      */
/*     /*             ROTINA ALTERAÄ«O DO T÷TULO              */                                                                                                                                                                                      */
/*     /*-----------------------------------------------------*/                                                                                                                                                                                      */
/*     RUN pi-efetiva-ALTERECAO-titulo-ABP.                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*     IF  RETURN-VALUE <> "OK" THEN                                                                                                                                                                                                                  */
/*         RETURN "NOK".                                                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     RETURN "OK".                                                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                    */
/* END.                                                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/* PROCEDURE pi-altera-provisao:                                                                                                                                                                                                                      */
/*                                                                                                                                                                                                                                                    */
/*     DEF INPUT  PARAM p-canal         AS INTEGER NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-tp-beneficio  AS INTEGER NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-unid-neg      AS CHAR    NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-categoria     AS CHAR    NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-especie       AS CHAR    NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-periodo-ini   AS DATE    NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-periodo-fim   AS DATE    NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT  PARAM p-saldo         AS DEC     NO-UNDO. /*Saldo da operaá∆o Rebate*/                                                                                                                                                              */
/*     DEF OUTPUT PARAM p-saldo-aprop   AS DEC     NO-UNDO. /*Saldo da apropriacao*/                                                                                                                                                                  */
/*                                                                                                                                                                                                                                                    */
/*     FIND FIRST b-int-cc-benef NO-LOCK                                                                                                                                                                                                              */
/*          WHERE b-int-cc-benef.tp-movto       = 1 /*PROVIS«O*/                                                                                                                                                                                      */
/*            AND b-int-cc-benef.canal          = p-canal                                                                                                                                                                                             */
/*            AND b-int-cc-benef.tipo-beneficio = p-tp-beneficio                                                                                                                                                                                      */
/*            AND b-int-cc-benef.unid-neg       = p-unid-neg                                                                                                                                                                                          */
/*            AND b-int-cc-benef.dt-periodo-ini = p-periodo-ini                                                                                                                                                                                       */
/*            AND b-int-cc-benef.dt-periodo-fim = p-periodo-fim NO-ERROR.                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                    */
/*     IF  NOT AVAIL b-int-cc-benef THEN                                                                                                                                                                                                              */
/*         RETURN "OK".                                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     FIND FIRST tit_ap                                                                                                                                                                                                                              */
/*         WHERE tit_ap.cod_estab     = b-int-cc-benef.cod_estab                                                                                                                                                                                      */
/*           AND tit_ap.num_id_tit_ap = b-int-cc-benef.num_id_tit_ap NO-LOCK NO-ERROR.                                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/*     IF  AVAILABLE tit_ap /*AND tit_ap.val_sdo_tit_ap > 0 */ THEN DO:                                                                                                                                                                               */
/*         CREATE tt_integr_apb_abat_prev_provis.                                                                                                                                                                                                     */
/*         ASSIGN tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote                                                                                                           */
/*                tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     = ?                                                                                                                                                                     */
/*                tt_integr_apb_abat_prev_provis.tta_cod_estab                = tit_ap.cod_estab                                                                                                                                                      */
/*                tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          = p-especie                                                                                                                                                             */
/*                tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            = tit_ap.cod_ser_docto                                                                                                                                                  */
/*                tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           = tit_ap.cdn_fornecedor                                                                                                                                                 */
/*                tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               = tit_ap.cod_tit_ap                                                                                                                                                     */
/*                tt_integr_apb_abat_prev_provis.tta_cod_parcela              = tit_ap.cod_parcela.                                                                                                                                                   */
/*                                                                                                                                                                                                                                                    */
/*         /*-----------------------------------------------------------------------------*/                                                                                                                                                          */
/*         /*   VALOR DO SALDO DO BENEFICIO EFETIVAMENTE APURADO, EXCEDE O PROVISIONADO   */                                                                                                                                                          */
/*         /*-----------------------------------------------------------------------------*/                                                                                                                                                          */
/*                                                                                                                                                                                                                                                    */
/*         IF  p-saldo > b-int-cc-benef.vl-saldo  THEN DO:                                                                                                                                                                                            */
/*             /* Para que o valor da apropriaá∆o fique correto, abate do Saldo do Benef°cio apurado, o valor que havia side provisionado */                                                                                                          */
/*             ASSIGN tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap = tit_ap.val_sdo_tit_ap                                                                                                                                                      */
/*                    p-saldo-aprop = p-saldo - tit_ap.val_sdo_tit_ap.                                                                                                                                                                                */
/*         END.                                                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                    */
/*         /*-------------------------------------------------------------------------------------------*/                                                                                                                                            */
/*         /*   VALOR DO SALDO DO BENEFICIO EFETIVAMENTE APURADO, ê INFERIOR OU IGUAL AO PROVISIONADO   */                                                                                                                                            */
/*         /*-------------------------------------------------------------------------------------------*/                                                                                                                                            */
/*         IF  p-saldo <= b-int-cc-benef.vl-saldo THEN DO:                                                                                                                                                                                            */
/*             ASSIGN tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap = p-saldo                                                                                                                                                                    */
/*                    p-saldo-aprop = p-saldo.                                                                                                                                                                                                        */
/*             /* ZERAR O SALDO DO T÷TULO PROVISIONADO */                                                                                                                                                                                             */
/*             RUN pi-ALTERA-temp-table-titulo (INPUT c-cod-estab,                                                                                                                                                                                    */
/*                                              INPUT tt-param.da-transacao, /* data da transaá∆o */                                                                                                                                                  */
/*                                              INPUT tit_ap.dat_vencto_tit_ap,                                                                                                                                                                       */
/*                                              INPUT 0, /*alteraá∆o de saldo*/                                                                                                                                                                       */
/*                                              INPUT "Zerado saldo t°tulo provis∆o, visto que o valor de Benef°cio apurado excede o provisionado").                                                                                                  */
/*             IF  RETURN-VALUE <> "OK" THEN                                                                                                                                                                                                          */
/*                 RETURN "NOK".                                                                                                                                                                                                                      */
/*                                                                                                                                                                                                                                                    */
/*         END.                                                                                                                                                                                                                                       */
/* /*         MESSAGE 'tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote : ' tt_integr_apb_abat_prev_provis.ttv_rec_integr_apb_item_lote skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     : ' tt_integr_apb_abat_prev_provis.ttv_rec_antecip_pef_pend     skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.tta_cod_estab                : ' tt_integr_apb_abat_prev_provis.tta_cod_estab                skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          : ' tt_integr_apb_abat_prev_provis.tta_cod_espec_docto          skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            : ' tt_integr_apb_abat_prev_provis.tta_cod_ser_docto            skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           : ' tt_integr_apb_abat_prev_provis.tta_cdn_fornecedor           skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               : ' tt_integr_apb_abat_prev_provis.tta_cod_tit_ap               skip  */                                                                                           */
/* /*                 'tt_integr_apb_abat_prev_provis.tta_cod_parcela              : ' tt_integr_apb_abat_prev_provis.tta_cod_parcela              skip  */                                                                                           */
/* /*                 "tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap          : " tt_integr_apb_abat_prev_provis.tta_val_abat_tit_ap SKIP           */                                                                                           */
/* /*                 "p-saldo-aprop: " p-saldo-aprop                                                                                                    */                                                                                           */
/* /*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                     */                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*         VALIDATE tt_integr_apb_abat_prev_provis.                                                                                                                                                                                                   */
/*                                                                                                                                                                                                                                                    */
/*     END.                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     RETURN "OK".                                                                                                                                                                                                                                   */
/* END.                                                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/* /* CRIAÄ«O DO T÷TULO REFERENTE AO BENEF÷CIO NO APB*/                                                                                                                                                                                               */
/* PROCEDURE pi-CRIA-temp-table-titulo:                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*     DEF INPUT PARAM p-provisao          AS LOG  NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-cod-estab         AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-ep-codigo         AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-referencia        AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-conta             AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-centro-custo      AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-especie           AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-tipo-fluxo        AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-cod-titulo        AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-dt-transacao      AS DATE NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-dt-vencimento     AS DATE NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-canal             AS INT  NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-unid-neg          AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-tipo-beneficio    AS INT  NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-categoria         AS CHAR NO-UNDO.                                                                                                                                                                                           */
/*     DEF INPUT PARAM p-vl-saldo          AS DEC  NO-UNDO.                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     DEF VAR da-per-ini AS DATE NO-UNDO.                                                                                                                                                                                                            */
/*     DEF VAR da-per-fim AS DATE NO-UNDO.                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                    */
/*     DEF VAR de-saldo-aprop            AS DEC NO-UNDO.                                                                                                                                                                                              */
/*     DEF VAR c-tta_cod_plano_cta_ctbl  AS CHAR NO-UNDO.                                                                                                                                                                                             */
/*     DEF VAR c-tta_cod_plano_ccusto    AS CHAR NO-UNDO.                                                                                                                                                                                             */
/*     DEF VAR c-esp-prov                AS CHAR NO-UNDO.                                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                    */
/*     DEF VAR c-refer-aux AS CHAR NO-UNDO.                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     v_log_atualiza_refer_apb = YES.                                                                                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/*     IF  c-referencia = "" THEN DO:                                                                                                                                                                                                                 */
/*         DO WHILE TRUE:                                                                                                                                                                                                                             */
/*             RUN pi-busca-referencia (INPUT  "BNEF",                                                                                                                                                                                                */
/*                                      INPUT  p-cod-estab,                                                                                                                                                                                           */
/*                                      OUTPUT c-refer-aux).                                                                                                                                                                                          */
/*                                                                                                                                                                                                                                                    */
/*             IF  NOT CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1                                                                                                                                                                                 */
/*                                WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = c-refer-aux)                                                                                                                                                   */
/*             AND NOT CAN-FIND (FIRST tt_integr_apb_lote_impl                                                                                                                                                                                        */
/*                                 WHERE tt_integr_apb_lote_impl.tta_cod_refer = c-refer-aux) THEN DO:                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/*                 ASSIGN c-referencia = c-refer-aux.                                                                                                                                                                                                 */
/*                 LEAVE.                                                                                                                                                                                                                             */
/*             END.                                                                                                                                                                                                                                   */
/*         END.                                                                                                                                                                                                                                       */
/*     END.                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     /* Verifica se j† existe um lote criado para o esta para o estabelecimento */                                                                                                                                                                  */
/*     FIND FIRST tt_integr_apb_lote_impl                                                                                                                                                                                                             */
/*         WHERE tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab                                                                                                                                                                          */
/*           AND tt_integr_apb_lote_impl.tta_cod_refer         = c-referencia                                                                                                                                                                         */
/*           AND tt_integr_apb_lote_impl.tta_dat_transacao     = p-dt-transacao                                                                                                                                                                       */
/*           AND tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"                                                                                                                                                                                */
/*           AND tt_integr_apb_lote_impl.tta_cod_empresa       = p-ep-codigo                                                                                                                                                                          */
/*           NO-ERROR.                                                                                                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/*     IF  NOT AVAIL tt_integr_apb_lote_impl THEN DO:                                                                                                                                                                                                 */
/*         CREATE tt_integr_apb_lote_impl.                                                                                                                                                                                                            */
/*         ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab                                                                                                                                                                         */
/*                tt_integr_apb_lote_impl.tta_cod_refer         = c-referencia.                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                    */
/*         IF  p-provisao THEN                                                                                                                                                                                                                        */
/*                tt_integr_apb_lote_impl.tta_cod_espec_docto   = p-especie.                                                                                                                                                                          */
/*                                                                                                                                                                                                                                                    */
/*         ASSIGN tt_integr_apb_lote_impl.tta_dat_transacao     = p-dt-transacao                                                                                                                                                                      */
/*                tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"                                                                                                                                                                               */
/*                tt_integr_apb_lote_impl.tta_cod_empresa       = p-ep-codigo.                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                    */
/*         VALIDATE tt_integr_apb_lote_impl.                                                                                                                                                                                                          */
/*                                                                                                                                                                                                                                                    */
/*     END.                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/* /*     MESSAGE "tt_integr_apb_lote_impl.tta_cod_estab         : " tt_integr_apb_lote_impl.tta_cod_estab         skip  */                                                                                                                           */
/* /*             "tt_integr_apb_lote_impl.tta_cod_refer         : " tt_integr_apb_lote_impl.tta_cod_refer         skip  */                                                                                                                           */
/* /*             "tt_integr_apb_lote_impl.tta_cod_espec_docto   : " tt_integr_apb_lote_impl.tta_cod_espec_docto   skip  */                                                                                                                           */
/* /*             "tt_integr_apb_lote_impl.tta_dat_transacao     : " tt_integr_apb_lote_impl.tta_dat_transacao     skip  */                                                                                                                           */
/* /*             "tt_integr_apb_lote_impl.tta_ind_origin_tit_ap : " tt_integr_apb_lote_impl.tta_ind_origin_tit_ap skip  */                                                                                                                           */
/* /*             "tt_integr_apb_lote_impl.tta_cod_empresa       : " tt_integr_apb_lote_impl.tta_cod_empresa             */                                                                                                                           */
/* /*                                                                                                                    */                                                                                                                           */
/* /*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                         */                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     ASSIGN i-seq-ref = i-seq-ref + 1.                                                                                                                                                                                                              */
/*                                                                                                                                                                                                                                                    */
/*     CREATE tt_integr_apb_item_lote_impl_3.                                                                                                                                                                                                         */
/*     ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)                                                                                                                                        */
/*            tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)                                                                                                                                 */
/*            tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = i-seq-ref                                                                                                                                                             */
/*            tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = p-canal                                                                                                                                                               */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = p-especie                                                                                                                                                             */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "1"                                                                                                                                                                   */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = p-cod-titulo                                                                                                                                                          */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = "01"                                                                                                                                                                  */
/*            tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = p-dt-transacao                                                                                                                                                        */
/*            tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = p-dt-vencimento                                                                                                                                                       */
/*            tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = p-dt-vencimento                                                                                                                                                       */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "30" /*boleto*/                                                                                                                                                       */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "real"                                                                                                                                                                */
/*            tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = p-vl-saldo                                                                                                                                                            */
/*            tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"                                                                                                                                                                 */
/*            tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/* /*     MESSAGE "tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl : " tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl    skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote : " tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote    skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            : " tt_integr_apb_item_lote_impl_3.tta_num_seq_refer               skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           : " tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor              skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          : " tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto             skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            : " tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto               skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               : " tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                  skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_parcela              : " tt_integr_apb_item_lote_impl_3.tta_cod_parcela                 skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           : " tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto              skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        : " tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap           skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           : " tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto              skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          : " tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto             skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           : " tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ              skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               : " tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                  skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_cod_portador             : " tt_integr_apb_item_lote_impl_3.tta_cod_portador                skip  */                                                                                            */
/* /*             "tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     : " tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ              */                                                                                            */
/* /*             "                                                                                                                                     */                                                                                            */
/* /*             "                                                                                                                                     */                                                                                            */
/* /*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                        */                                                                                            */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     VALIDATE tt_integr_apb_item_lote_impl_3.                                                                                                                                                                                                       */
/*                                                                                                                                                                                                                                                    */
/*     ASSIGN de-saldo-aprop           = p-vl-saldo                                                                                                                                                                                                   */
/*            c-tta_cod_plano_cta_ctbl = "Padrao"                                                                                                                                                                                                     */
/*            c-tta_cod_plano_ccusto   = "Padrao".                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     /* Verifica o per°odo inicial e final, pois para o VMC-Prata/bronze Ç diferente */                                                                                                                                                             */
/*     IF  p-tipo-beneficio = 21 AND p-categoria <> "OURO" THEN                                                                                                                                                                                       */
/*         ASSIGN da-per-ini = IF  MONTH(da-fim) <= 9 THEN  DATE(01,01,YEAR(da-fim)) ELSE DATE(10,01,YEAR(da-fim))                                                                                                                                    */
/*                da-per-fim = IF  MONTH(da-fim) <= 9 THEN  DATE(09,30,YEAR(da-fim)) ELSE DATE(12,31,YEAR(da-fim)).                                                                                                                                   */
/*     ELSE                                                                                                                                                                                                                                           */
/*         ASSIGN da-per-ini = da-ini                                                                                                                                                                                                                 */
/*                da-per-fim = da-fim.                                                                                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     IF  NOT p-provisao THEN DO:                                                                                                                                                                                                                    */
/*         ASSIGN c-esp-prov = IF  int-cc-benef.tipo-beneficio = 37 THEN                                                                                                                                                                              */
/*                                 "RO" /*REBATE*/                                                                                                                                                                                                    */
/*                             ELSE IF  int-cc-benef.tipo-beneficio = 66 THEN                                                                                                                                                                         */
/*                                      "PO"   /*REBATE P‡S-VENDA*/                                                                                                                                                                                   */
/*                                  ELSE                                                                                                                                                                                                              */
/*                                      "VO". /*VMC*/                                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                    */
/*         RUN pi-altera-provisao (INPUT  p-canal,                                                                                                                                                                                                    */
/*                                 INPUT  p-tipo-beneficio,                                                                                                                                                                                           */
/*                                 INPUT  p-unid-neg,                                                                                                                                                                                                 */
/*                                 INPUT  p-categoria,                                                                                                                                                                                                */
/*                                 INPUT  c-esp-prov,  /*EspÇcie*/                                                                                                                                                                                    */
/*                                 INPUT  da-per-ini,                                                                                                                                                                                                 */
/*                                 INPUT  da-per-fim,                                                                                                                                                                                                 */
/*                                 INPUT  p-vl-saldo,                                                                                                                                                                                                 */
/*                                 OUTPUT de-saldo-aprop).                                                                                                                                                                                            */
/*         IF  RETURN-VALUE <> "OK" THEN                                                                                                                                                                                                              */
/*             RETURN "NOK".                                                                                                                                                                                                                          */
/*     END.                                                                                                                                                                                                                                           */
/*     /*Apropriaá∆o dos t°tulos*/                                                                                                                                                                                                                    */
/*     create tt_integr_apb_aprop_ctbl_pend.                                                                                                                                                                                                          */
/*     assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)                                                                                                                                     */
/*            tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?                                                                                                                                                                         */
/*            tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?                                                                                                                                                                         */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = p-unid-neg                                                                                                                                                                */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = p-tipo-fluxo /*"201"*/                                                                                                                                                    */
/*            tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = p-vl-saldo /* Saldo da conta de despesas */                                                                                                                               */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""                                                                                                                                                                        */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""                                                                                                                                                                        */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""                                                                                                                                                                        */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""                                                                                                                                                                        */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = c-tta_cod_plano_cta_ctbl                                                                                                                                                  */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = p-conta                                                                                                                                                                   */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = c-tta_cod_plano_ccusto                                                                                                                                                    */
/*            tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = p-centro-custo.                                                                                                                                                           */
/*     VALIDATE tt_integr_apb_aprop_ctbl_pend.                                                                                                                                                                                                        */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/* /*     MESSAGE 'tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            : ' tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             skip  */                                                                                            */
/* /*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   skip  */                                                                                            */
/* /*                                                                                                                                                   */                                                                                            */
/* /*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                        */                                                                                            */
/*                                                                                                                                                                                                                                                    */
/*                                                                                                                                                                                                                                                    */
/*     RETURN "OK".                                                                                                                                                                                                                                   */
/* END.                                                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/* /* ALTERAÄ«O DO T÷TULO REFERENTE AO BENEF÷CIO NO APB*/                                                                                                                                                                                             */
/* PROCEDURE pi-ALTERA-temp-table-titulo:                                                                                                                                                                                                             */
/*                                                                                                                                                                                                                                                    */
/*     DEF INPUT PARAM p-cod-estab   AS CHAR NO-UNDO.                                                                                                                                                                                                 */
/*     DEF INPUT PARAM p-dt-transcao AS DATE NO-UNDO.                                                                                                                                                                                                 */
/*     DEF INPUT PARAM p-dt-vencto   AS DATE NO-UNDO.                                                                                                                                                                                                 */
/*     DEF INPUT PARAM p-de-saldo    AS DEC  NO-UNDO.                                                                                                                                                                                                 */
/*     DEF INPUT PARAM p-motivo      AS CHAR NO-UNDO.                                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                    */
/*     DEF VAR c-refer AS CHAR NO-UNDO.                                                                                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*     /*busca referencia*/                                                                                                                                                                                                                           */
/*     ASSIGN c-refer = "".                                                                                                                                                                                                                           */
/* /*     RUN pi-busca-referencia (INPUT  "BNEF",       */                                                                                                                                                                                            */
/* /*                              INPUT  p-cod-estab,  */                                                                                                                                                                                            */
/* /*                              OUTPUT c-refer).     */                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                    */
/*     DO WHILE TRUE:                                                                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                    */
/*         RUN pi-busca-referencia (INPUT  "BNEF",                                                                                                                                                                                                    */
/*                                  INPUT  p-cod-estab,                                                                                                                                                                                               */
/*                                  OUTPUT c-refer).                                                                                                                                                                                                  */
/*         IF  NOT CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1                                                                                                                                                                                     */
/*                            WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = c-refer)                                                                                                                                                           */
/*         AND NOT CAN-FIND (FIRST tt_integr_apb_lote_impl                                                                                                                                                                                            */
/*                             WHERE tt_integr_apb_lote_impl.tta_cod_refer = c-refer) THEN                                                                                                                                                            */
/*             LEAVE.                                                                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                    */
/*     END.                                                                                                                                                                                                                                           */
/*                                                                                                                                                                                                                                                    */
/*     create tt_tit_ap_alteracao_base_aux_1.                                                                                                                                                                                                         */
/*     assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren                                                                                                                                                    */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa                                                                                                                                                    */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab                                                                                                                                                      */
/*            tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap                                                                                                                                                  */
/*            tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor                                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto                                                                                                                                                */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto                                                                                                                                                  */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap                                                                                                                                                     */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela                                                                                                                                                    */
/*            tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = p-dt-transcao                                                                                                                                                         */
/*            tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer                                                                                                                                                               */
/*            tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = p-de-saldo                                                                                                                                                            */
/*            tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = tit_ap.dat_emis_docto                                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = p-dt-vencto                                                                                                                                                           */
/*            tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = p-dt-vencto                                                                                                                                                           */
/*            tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = tit_ap.dat_ult_pagto                                                                                                                                                  */
/*            tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = tit_ap.num_dias_atraso                                                                                                                                                */
/*            tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = tit_ap.val_perc_multa_atraso                                                                                                                                          */
/*            tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = tit_ap.val_juros_dia_atraso                                                                                                                                           */
/*            tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = tit_ap.val_perc_juros_dia_atraso                                                                                                                                      */
/*            tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = tit_ap.dat_desconto                                                                                                                                                   */
/*            tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = tit_ap.val_perc_desc                                                                                                                                                  */
/*            tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = tit_ap.val_desconto                                                                                                                                                   */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = tit_ap.cod_portador                                                                                                                                                   */
/*            tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = tit_ap.log_pagto_bloqdo                                                                                                                                               */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = tit_ap.cod_seguradora                                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = tit_ap.cod_apol_seguro                                                                                                                                                */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = tit_ap.cod_arrendador                                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = tit_ap.cod_contrat_leas                                                                                                                                               */
/*            tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = tit_ap.ind_tip_espec_docto                                                                                                                                            */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = tit_ap.cod_indic_econ                                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "alteraá∆o"                                                                                                                                                           */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""                                                                                                                                                                    */
/*            tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = p-motivo                                                                                                                                                              */
/*            tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap                                                                                                                                                 */
/*            tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.                                                                                                                                               */
/*                                                                                                                                                                                                                                                    */
/*            VALIDATE tt_tit_ap_alteracao_base_aux_1.                                                                                                                                                                                                */
/*                                                                                                                                                                                                                                                    */
/* /*     MESSAGE "tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren           : " tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren            skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                : " tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                 skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                  : " tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                   skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap              : " tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap               skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                 : " tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                  skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor             : " tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto             skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto              : " tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto               skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                 : " tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                  skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                : " tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                 skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao              : " tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao               skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                  : " tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                   skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap             : " tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto             : " tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap          : " tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap           skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto             : " tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto              : " tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto               skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso            : " tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso             skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso      : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso       skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso       : " tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso        skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso  : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso   skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto               : " tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc              : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc               skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_val_desconto               : " tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_portador               : " tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo           : " tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo            skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro             skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas           : " tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas            skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto        : " tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto         skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap : " tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap  skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr             skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr            : " tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr             skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap             : " tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap              skip  */                                                                                          */
/* /*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto             skip  */                                                                                          */
/* /*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                          */                                                                                          */
/*                                                                                                                                                                                                                                                    */
/*     RETURN "OK".                                                                                                                                                                                                                                   */
/* END.                                                                                                                                                                                                                                               */
