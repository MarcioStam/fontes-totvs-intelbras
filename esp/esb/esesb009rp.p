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

DEFINE VARIABLE c-referencia         AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-titulo         AS CHAR FORMAT "X(09)"    NO-UNDO.

/* Procedures do financeiro - utilizada por v†rios programas do Projeto Canais */
{esp/esb/esesbapi003-apb.i}

/************************  FIM DEFINIÄÂES APB  ***********************/

/*-------------------------------------------------*/
/*    D E F I N I Ä « O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
define temp-table tt-param no-undo
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHAR format "x(35)"
    FIELD usuario     AS CHAR format "x(12)"
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD ano         AS INTEGER
    FIELD mes         AS INTEGER
    FIELD rs-tipo     AS INTEGER
    FIELD rs-acao     AS INTEGER
    FIELD tg-gera-log AS LOG.

/* /* Temp-table int-beneficio */ */
/* {esp/esb/esesbapi004-benef.i} */

/*Temp-tables com os dados do faturamento/devoluá‰es*/
{esp/esb/esesbapi002.i}  /* tt-canal */
{esp/esb/esesbapi002.i1} /* tt-fat-mensal; tt-fat-mensal-det */

DEF TEMP-TABLE tt-cc-benef NO-UNDO LIKE int-cc-benef.

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(500)"
    FIELD ajuda    AS CHAR FORMAT "X(500)".

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

{esp/esb/esesbapi003-movtos.i2} /* pi-cria-transacao-saldo-inicial */
{esp/esb/esesbapi003-movtos.i3} /* pi-retorna-base-faturamento-periodo*/
        
/*Para busca dos parÉmetros globais do CRM*/
{esp/esb/out/msg0111.i} 

/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}

/*{esapi/esapi015tt.i}*/

/* bloco principal do programa */
ASSIGN c-programa     = "esesb009"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Canais Intelbras"
       c-titulo-relat = "Provisionamento de Saldo de Benef°cios Canais".

/************ DEFINIÄ«O DE VARIµVEIS **************/
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
DEFINE VARIABLE c-arq-fat                 AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-benef               AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-centrais            AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-fat-detalhe         AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-cc                  AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-status              AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE c-arq-provisao            AS CHAR FORMAT "X(180)"   NO-UNDO.
DEFINE VARIABLE da-ini-apur               AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim-apur               AS DATE                   NO-UNDO.
DEFINE VARIABLE da-vencimento             AS DATE                   NO-UNDO.
DEFINE VARIABLE da-ini-apur-ant           AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim-apur-ant           AS DATE                   NO-UNDO.
DEFINE VARIABLE da-ini-trimestre          AS DATE                   NO-UNDO.
DEFINE VARIABLE da-fim-trimestre          AS DATE                   NO-UNDO.
DEFINE VARIABLE c-label                  AS CHAR  FORMAT "X(300)"   NO-UNDO.
DEFINE VARIABLE da-aux                    AS DATE                   NO-UNDO.
DEFINE VARIABLE i-seq-ref                 AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-seq-det                 AS INTEGER                NO-UNDO.
DEFINE VARIABLE i-sequencia-movto         AS INTEGER                NO-UNDO.
DEFINE VARIABLE c-trimestre               AS CHARACTER              NO-UNDO.
DEFINE VARIABLE i-transacao               AS INTEGER                NO-UNDO.

DEFINE BUFFER b-matriz                FOR emitente.
DEFINE BUFFER b-cc-benef              FOR int-cc-benef.
DEFINE BUFFER b-int-cc-benef          FOR int-cc-benef.
DEFINE BUFFER b-int-cc-benef-eliminar FOR int-cc-benef.
DEFINE BUFFER b-int-cc-benef-movto    FOR int-cc-benef-movto.

DEF STREAM exp1.
DEF STREAM exp2.
DEF STREAM exp3.
DEF STREAM exp1-det.
DEF STREAM exp4.

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
                                                                    
    ASSIGN c-label = "MOVTO;CANAL;UNID NEG;TP BENEF;CATEGORIA;CLASSIFICAÄ«O;PER INI;PER FIM;SALDO ANT;BASE-CALC;% CUSTO;% PREV META;% BENEF÷CIO;SALDO CALC ATUAL;DT TRANS;DT VENCTO;STATUS;USUARIO;CLASSIFICAÄ«O;GUID BENEF CANAL;GUID BENEF;GUID-CANAL".
                                                                                                                                                                                                                               
                                                                                                                                                                                                                               
/* Essa Ç a PROCEDURE PRINCIPAL do programa, a qual contro a transaá∆o */


/*---------------------------------------------------*/
/*    GERAÄ«O DE ARQUIVO DE ACOMPANHAMENTO  (.CSV)   */
/*---------------------------------------------------*/
IF tt-param.tg-gera-log THEN DO:

    IF  OPSYS = "UNIX" THEN 
        ASSIGN c-arq-fat = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-prov-fat_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    ELSE
        ASSIGN c-arq-fat = SESSION:TEMP-DIRECTORY +  "log-prov-fat_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    OUTPUT STREAM exp1 TO VALUE(c-arq-fat) CONVERT TARGET "iso8859-1".
    PUT STREAM exp1 "Ano;Mes;Canal;Unidade;Vl Faturado;Vl Devolvido;Vl Apurado;GUID Canal" SKIP.
    

    IF  OPSYS = "UNIX" THEN 
        ASSIGN c-arq-centrais = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-prov-centrais_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    ELSE
        ASSIGN c-arq-centrais = SESSION:TEMP-DIRECTORY + "log-prov-centrais_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".        

    OUTPUT STREAM exp2 TO VALUE(c-arq-centrais) CONVERT TARGET "iso8859-1".
    

    IF  OPSYS = "UNIX" THEN 
        ASSIGN c-arq-benef = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-prov-benef_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_"  + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    ELSE
        ASSIGN c-arq-benef = SESSION:TEMP-DIRECTORY + "log-prov-benef_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    OUTPUT STREAM exp3 TO VALUE(c-arq-benef) CONVERT TARGET "iso8859-1".
    


    IF  OPSYS = "UNIX" THEN 
        ASSIGN c-arq-fat-detalhe = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-prov-fat-detalhes_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    ELSE
        ASSIGN c-arq-fat-detalhe = SESSION:TEMP-DIRECTORY + "log-prov-fat-detalhes_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

    OUTPUT STREAM exp1-det TO VALUE(c-arq-fat-detalhe) CONVERT TARGET "iso8859-1".
    PUT STREAM exp1-det "Ano;Mes;Canal Central;Filial;Unidade;Movto;Seq;Estabel;Serie;Nota;Seq Item;Item;Vl Fat;Data;Serie Ent; Docto Ent; Cliente; Nat Op; Sequencia; Vl Devol" SKIP.
    


    IF  OPSYS = "UNIX" THEN 
        ASSIGN c-arq-provisao = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-prov-cc_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    ELSE
        ASSIGN c-arq-provisao = SESSION:TEMP-DIRECTORY + "log-prov-cc_" + string(tt-param.mes, "99") + "-" + STRING(tt-param.ano) + "_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

    OUTPUT STREAM exp4 TO VALUE(c-arq-provisao) CONVERT TARGET "iso8859-1".
    PUT STREAM exp4 c-label SKIP.
END.


RUN PI-PRINCIPAL.


/* Retornou erro */
IF  CAN-FIND (FIRST tt-erro) OR RETURN-VALUE <> "OK" THEN DO:
    PUT "Erro       Mensagem" SKIP
        "---------- -------------------------------------------------------------------------------------------------------------------------" SKIP(1).

    FOR EACH tt-erro:
    
        /*Imprime a mensagem tabulada*/    
        EMPTY TEMP-TABLE tt-editor.
        run pi-print-editor (tt-erro.mensagem, 80).
        FOR EACH tt-editor:
            PUT tt-erro.codigo TO 10 tt-editor.conteudo AT 12 SKIP.     
        END.   
        IF  NOT CAN-FIND (FIRST tt-editor) THEN
            PUT tt-erro.codigo TO 10 tt-erro.mensagem  AT 12 SKIP.

        /*Imprime o Help tabulado*/
        EMPTY TEMP-TABLE tt-editor.
        run pi-print-editor (tt-erro.ajuda, 80).
        FOR EACH tt-editor:
            PUT tt-editor.conteudo AT 12 SKIP.     
        END.   
        IF  NOT CAN-FIND (FIRST tt-editor) THEN
            PUT tt-erro.ajuda  AT 12 SKIP.
        PUT SKIP (1).

    END.
    IF  tt-param.rs-acao = 1 THEN
         PUT SKIP(3)"    ATENÄ«O: N∆o foi poss°vel concluir o provisionamento para o per°odo. Entre em contato com a TIC Intelbras.".
     ELSE
         PUT SKIP(3)"    ATENÄ«O: N∆o foi poss°vel concluir o rec†lculo da base de faturamento para o per°odo. Entre em contato com a TIC Intelbras.".

    
END.
ELSE DO:

    IF  tt-param.rs-acao = 1 THEN
        DISP SKIP(2) "    C†lculo de Provis∆o Mensal de Benef°cios executada com sucesso!".
    ELSE
        DISP SKIP(2) "    Rec†lculo de Provis∆o Mensal de Benef°cios executada com sucesso!".

END.
PUT SKIP(2).
PUT "    Gerado arquivo de acompanhamento Apuraá∆o Valores Faturamento/Devoluá‰es..........: " c-arq-fat         SKIP(1).
PUT "    Gerado arquivo de acompanhamento Detalhamento faturamento X Benef°cios canal......: " c-arq-fat-detalhe SKIP(1).
PUT "    Gerado arquivo de acompanhamento Conta Corrente de Provis∆o para o canal..........: " c-arq-provisao    SKIP(3).

                                                                         
/* DISPLYA PAR∂METROS */
PUT "                                                       PAR∂METROS" SKIP
    "                                                   ------------------" SKIP(1).
PUT "                                                   Ano...: " string(tt-param.ano)  SKIP
    "                                                   Màs...: " string(tt-param.mes)  SKIP
    "                                                   Opá∆o.: " c-tipo  SKIP.


/* FECHAR ARUIVOS EXCEL */
IF  tt-param.tg-gera-log THEN DO:
    OUTPUT STREAM exp1      CLOSE.
    OUTPUT STREAM exp2      CLOSE.
    OUTPUT STREAM exp3      CLOSE.
    OUTPUT STREAM exp1-det  CLOSE.
    OUTPUT STREAM exp4      CLOSE.
END.

ASSIGN v_des_contdo_prog_valid_dtsul = "".

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             
/*-----------------------------------------*/
/*  F I M   B L O C O   P R I N C I P A L  */
/*-----------------------------------------*/


/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                  P R O C E D U R E S  I N T E R N A S                                                           */
/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE PI-PRINCIPAL:

    /*-------------------------*/
    /* CANAIS A SEREM APURADOS */
    /*-------------------------*/
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Gerando Provis‰es.").

    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando canais centrais...").

    /* S‡ CONSIDERA OS CANAIS QUE O USUµRIO ESCOLHEU NO PROGRAMA */
    IF  CAN-FIND (FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:
            /* CANAIS ESTRUTURA CENTRAL - FILIAL COM BASE NA DIGITAÄ«O DO USUµRIO*/
            RUN esp/esb/esesbapi005.p (INPUT string(tt-digita.canal-central),
                                       OUTPUT TABLE tt-central,
                                       OUTPUT TABLE tt-erro).
    
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

    /* LOG */
    IF  tt-param.tg-gera-log THEN RUN pi-exporta-centrais.

    /* Cria a data inicial e final com base no ano e mes informados em tela */
    RUN pi-retorna-datas (INPUT tt-param.mes,
                          INPUT tt-param.ano).




    /*----------------------------------------------------*/
    /*  APURA FATURAMENTO DO M“S PARA O CANAL + SELL OUT  */
    /*----------------------------------------------------*/
    RUN esp/esb/esesbapi002-fat-dev.p (INPUT tt-param.ano,
                                       INPUT tt-param.mes,
                                       INPUT  TABLE tt-central,
                                       OUTPUT TABLE tt-fat-mensal,
                                       OUTPUT TABLE tt-fat-mensal-det,
                                       OUTPUT TABLE tt-canal,
                                       OUTPUT TABLE tt-erro).

    IF  RETURN-VALUE <> "OK" THEN 
        RETURN "NOK".            
    
    /*---------------------------*/
    /*  APURAÄ«O DOS BENEF÷CIOS  */
    /*---------------------------*/
    /*RUN pi-busca-beneficios-canal.*/
    
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    /* Calcular a data inicial do trimestre a partir da data de apuraá∆o informada */
    CASE MONTH(da-fim):
        WHEN 01 OR WHEN 02 OR WHEN 03 THEN 
            ASSIGN da-ini-trimestre = DATE(01,01,YEAR(da-fim))
                   da-fim-trimestre = DATE(03,31,YEAR(da-fim)).
        WHEN 04 OR WHEN 05 OR WHEN 06 THEN 
            ASSIGN da-ini-trimestre = DATE(04,01,YEAR(da-fim))
                   da-fim-trimestre = DATE(06,30,YEAR(da-fim)).
        WHEN 07 OR WHEN 08 OR WHEN 09 THEN 
            ASSIGN da-ini-trimestre = DATE(07,01,YEAR(da-fim))
                   da-fim-trimestre = DATE(09,30,YEAR(da-fim)).
        WHEN 10 OR WHEN 11 OR WHEN 12 THEN 
            ASSIGN da-ini-trimestre = DATE(10,01,YEAR(da-fim))
                   da-fim-trimestre = DATE(12,31,YEAR(da-fim)).
    END CASE.

    /* TRANSAÄ«O PRINCIPAL */
    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco ON ERROR UNDO bloco, LEAVE bloco:
    
        /*----------------------------------------------------*/
        /*                GERAÄ«O PROVIS«O                    */
        /*----------------------------------------------------*/
        IF  tt-param.rs-acao = 1 /* Somente c†lculo */ THEN
            RUN pi-processa-provisoes.
        
        IF  RETURN-VALUE <> "OK" THEN DO:
            UNDO bloco , RETURN "NOK".
        END.

        /*----------------------------------------------------*/
        /*     GRAVA APURAÄ«O VALORES FATURAMENTO/DEVOLUÄÂES  */
        /*----------------------------------------------------*/

        IF  tt-param.tg-gera-log THEN DO: 
            RUN pi-exporta-fat.
            RUN pi-exporta-fat-detalhes.
        END.

        /* Execuá∆o for "OFICIAL" */
/*         IF  tt-param.rs-tipo = 2 THEN DO:      */
/*             RUN pi-grava-fat-mensal.           */
/*             IF  RETURN-VALUE <> "OK" THEN DO:  */
/*                 UNDO bloco , RETURN "NOK".     */
/*             END.                               */
/*         END.                                   */
    END. 
    
    RETURN "OK".
END.


PROCEDURE pi-processa-provisoes:

      /*--------------------------*/
      /*           REBATE         */
      /*--------------------------*/
      RUN pi-Gerar-Provisao (INPUT 37, 
                             INPUT da-fim-trimestre + 60, 
                             INPUT "").
      IF  RETURN-VALUE <> "OK" THEN
          RETURN "NOK".

      /*--------------------------*/
      /*    REBATE  P‡S-VENDA     */
      /*--------------------------*/
      RUN pi-Gerar-Provisao (INPUT 66, 
                             INPUT da-fim-trimestre + 60, 
                             INPUT "").
      IF  RETURN-VALUE <> "OK" THEN
          RETURN "NOK".

      /*---------------------------*/
      /*        VMC - OURO         */
      /*---------------------------*/
      RUN pi-Gerar-Provisao (INPUT 21,
                             INPUT da-fim-trimestre + 20, 
                             INPUT "OURO").
      IF  RETURN-VALUE <> "OK" THEN 
          RETURN "NOK".

      /*---------------------------*/
      /*    VMC - DISTRIBUIDORES   */
      /*---------------------------*/
      RUN pi-Gerar-Provisao (INPUT 21,
                             INPUT da-fim-trimestre + 20, 
                             INPUT "DISTRIBUIDOR").
      IF  RETURN-VALUE <> "OK" THEN 
          RETURN "NOK".

      /*---------------------------*/
      /*    VMC - PRATA E BRONZE   */
      /*---------------------------*/
      RUN pi-Gerar-Provisao (INPUT 21, 
                             INPUT IF  MONTH(da-fim) <= 9 THEN  DATE(12,31,YEAR(da-fim)) ELSE DATE(03,31,YEAR(da-fim) + 1), 
                             INPUT "PRATABRONZE"). /*N∆o Existe PrataBronze, Ç apenas para diferenciar da categoria Ouro*/
      IF  RETURN-VALUE <> "OK" THEN 
          RETURN "NOK". 

      RETURN "OK".
END.


PROCEDURE pi-Gerar-Provisao:
    /*----------------------------------------------*/
    /*          GERAÄ«O DE PROVIS«O MENSAL          */
    /*----------------------------------------------*/
    DEF INPUT PARAM p-tp-beneficio AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-da-vencto    AS DATE    NO-UNDO.
    DEF INPUT PARAM p-categoria    AS CHAR    NO-UNDO.
    
    DEF VAR de-vl-provisao      AS DEC  NO-UNDO.
    DEF VAR da-vencto           AS DATE NO-UNDO.
    DEF VAR da-per-ini          AS DATE NO-UNDO.
    DEF VAR da-per-fim          AS DATE NO-UNDO.
    DEF VAR de-base-calc        AS DEC  NO-UNDO.
    DEF VAR de-custo-prev-meta  AS DEC  NO-UNDO.
    
    EMPTY TEMP-TABLE tt-cc-benef.

    RUN pi-acompanhar IN h-acomp ("Gerando Provis∆o p/ Benef°cio: " + fn-retorna-nome-beneficio (p-tp-beneficio) + "...").

    /* N«O ê NECESSµRIO VERIFICA SE OS BENEF÷CIOS EST«O ATIVOS, POIS NOS  */
    /* PRIMEIROS MESES DO TRIMESTRE, LOGICAMENTE ELES N«O ESTAR«O         */
    FOR EACH tt-fat-mensal
        WHERE tt-fat-mensal.ano = YEAR(da-fim)  
          AND tt-fat-mensal.mes = MONTH(da-fim) 
        , EACH int-beneficio
            WHERE int-beneficio.canal          = tt-fat-mensal.canal 
              AND int-beneficio.unid-neg       = tt-fat-mensal.unid-neg
              AND int-beneficio.tipo-beneficio = p-tp-beneficio
              AND (IF p-categoria = "DISTRIBUIDOR" THEN int-beneficio.tipo-categoria = p-categoria ELSE YES) /*Caso seja o VMC para DISTRIBUIDOR */
              AND (IF p-categoria = "OURO"         THEN int-beneficio.tipo-categoria = p-categoria ELSE YES) /*Caso seja o VMC para revenda Ouro*/
              AND (IF p-categoria = "PRATABRONZE"  THEN (int-beneficio.tipo-categoria <> "OURO" AND int-beneficio.tipo-categoria <> "DISTRIBUIDOR")    ELSE YES) /*Caso seja o VMC para revenda Prata e Bronze*/
          BREAK BY tt-fat-mensal.canal
                BY tt-fat-mensal.unid-neg:

        IF  FIRST-OF (tt-fat-mensal.unid-neg) THEN
            ASSIGN de-vl-provisao     = 0
                   de-base-calc       = 0
                   de-custo-prev-meta = 0.

        ASSIGN de-base-calc       = de-base-calc   +   tt-fat-mensal.vl-apurado
               de-custo-prev-meta = tt-fat-mensal.vl-apurado * (IF int-beneficio.perc-custo     > 0 THEN int-beneficio.perc-custo     / 100 ELSE 1) *
                                                               (IF int-beneficio.perc-prov-meta > 0 THEN int-beneficio.perc-prov-meta / 100 ELSE 1)  
               de-vl-provisao     = de-vl-provisao + (de-custo-prev-meta * (int-beneficio.perc-global / 100) ).

        IF  LAST-OF (tt-fat-mensal.unid-neg) THEN DO:
    
            /* Verifica o per°odo inicial e final, pois para o VMC-Prata/bronze Ç diferente */
            IF  p-tp-beneficio = 21 AND p-categoria <> "OURO" AND p-categoria <> "DISTRIBUIDOR" THEN 
                ASSIGN da-per-ini = IF  MONTH(da-fim) <= 9 THEN  DATE(01,01,YEAR(da-fim)) ELSE DATE(10,01,YEAR(da-fim))  
                       da-per-fim = IF  MONTH(da-fim) <= 9 THEN  DATE(09,30,YEAR(da-fim)) ELSE DATE(12,31,YEAR(da-fim)). 
            ELSE
               ASSIGN da-per-ini = da-ini-trimestre 
                      da-per-fim = da-fim-trimestre. 

            IF   de-vl-provisao > 0  THEN DO:
                CREATE tt-cc-benef.
                ASSIGN tt-cc-benef.tp-movto             = 1 /* PROVIS«O */
                       tt-cc-benef.canal                = tt-fat-mensal.canal
                       tt-cc-benef.unid-neg             = tt-fat-mensal.unid-neg
                       tt-cc-benef.tipo-beneficio       = int-beneficio.tipo-beneficio
                       tt-cc-benef.classificacao        = int-beneficio.guid-class
                       tt-cc-benef.categoria            = int-beneficio.tipo-categoria
                       tt-cc-benef.guid-beneficio       = int-beneficio.guid-beneficio
                       tt-cc-benef.guid-beneficio-canal = int-beneficio.guid-beneficio-canal
                       tt-cc-benef.guid-canal           = int-beneficio.guid-canal
                       tt-cc-benef.dt-periodo-ini       = da-per-ini
                       tt-cc-benef.dt-periodo-fim       = da-per-fim
                       tt-cc-benef.vl-saldo-ori         = de-vl-provisao
                       tt-cc-benef.vl-saldo-anterior    = 0
                       tt-cc-benef.vl-saldo             = de-vl-provisao
                       tt-cc-benef.perc-benef           = int-beneficio.perc-global
                       tt-cc-benef.dt-transacao         = da-fim
                       tt-cc-benef.dt-vencimento        = p-da-vencto
                       tt-cc-benef.id-status            = 1 /*CONTA CORRENTE ATIVA */
                       tt-cc-benef.usuario              = c-seg-usuario 
                       tt-cc-benef.canal-matriz         = tt-fat-mensal.canal-matriz
                       tt-cc-benef.forma-pagto          = 1
                       tt-cc-benef.vl-base-calc         = de-base-calc
                       tt-cc-benef.perc-custo           = int-beneficio.perc-custo    
                       tt-cc-benef.perc-prov-meta       = int-beneficio.perc-prov-meta.
    
                IF tt-param.tg-gera-log THEN RUN pi-exporta-provisao.
            END.
        END.
    END.

/*    /* OFICIAL */                                                                                                                                      */
/*     IF  tt-param.rs-tipo = 2                                                                                                                          */
/*     AND tt-param.rs-acao = 1 THEN DO /*TRANS*/ :                                                                                                      */
/*                                                                                                                                                       */
/*         RUN pi-Integra-PROVISAO-APB (INPUT da-per-ini,                                                                                                */
/*                                      INPUT da-per-fim,                                                                                                */
/*                                      INPUT p-tp-beneficio,                                                                                            */
/*                                      INPUT p-categoria).                                                                                              */
/*                                                                                                                                                       */
/*         IF  RETURN-VALUE <> "OK" THEN DO:                                                                                                             */
/*             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */                                                                               */
/*                                                 INPUT "Erro ao gerar provis∆o mensal para o Benef°cio: " + fn-retorna-nome-beneficio(p-tp-beneficio), */
/*                                                 INPUT "Processamento n∆o conclu°do.":U).                                                              */
/*             RETURN "NOK".                                                                                                                             */
/*         END.                                                                                                                                          */
/*                                                                                                                                                       */
/*     END.                                                                                                                                              */

    RETURN "OK".

END.

PROCEDURE pi-grava-conta-corrente-Provisao:


    FOR EACH tt-cc-benef:
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

            BUFFER-COPY tt-cc-benef  EXCEPT  tp-movto
                                             canal 
                                             unid-neg 
                                             tipo-beneficio 
                                             dt-periodo-ini 
                                             dt-periodo-fim  TO int-cc-benef.
        END.
        ELSE
            ASSIGN int-cc-benef.vl-base-calc      = int-cc-benef.vl-base-calc + tt-cc-benef.vl-base-calc
                   int-cc-benef.vl-saldo-anterior = int-cc-benef.vl-saldo
                   int-cc-benef.vl-saldo          = int-cc-benef.vl-saldo + tt-cc-benef.vl-saldo.

    END.

    RETURN "OK".
END.


/*-------------------------------------------------------------------*/
/*        B U S C A R   B E N E F ÷ C I O S   D O   C A N A L        */
/*-------------------------------------------------------------------*/
/* PROCEDURE pi-busca-beneficios-canal:                                                                                               */
/*                                                                                                                                    */
/*     /*------------------------------------------------------------------------------*/                                             */
/*     /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */                                             */
/*     /*------------------------------------------------------------------------------*/                                             */
/*     EMPTY TEMP-TABLE tt-erro-benef.                                                                                                */
/*     EMPTY TEMP-TABLE int-beneficio.                                                                                                */
/*                                                                                                                                    */
/*     RUN esp/esb/esesbapi004-benef.p (INPUT  YES,  /* Indica que Ç provisionamento, logo n∆o busca o stock rotation tambÇm */       */
/*                                      INPUT  YES,  /* Buscar msg0111 com o % global de cada benef°cio   */                          */
/*                                      INPUT  YES,  /* Buscar msg0142, parÉmetros financeiros e provis∆o */                          */
/*                                      INPUT  ?,    /* (?) para buscar todas as unidades, ou informar uma unidade espec°fica */      */
/*                                      INPUT  ?,    /* (?) para buscar todas os benef°cios, ou informar uma benef°cio espec°fico */  */
/*                                      INPUT  TABLE tt-canal,                                                                        */
/*                                      OUTPUT TABLE tt-erro-benef,                                                                   */
/*                                      OUTPUT TABLE int-beneficio).                                                                  */
/*     IF  RETURN-VALUE <> "OK"                                                                                                       */
/*     OR  CAN-FIND (FIRST tt-erro-benef) THEN DO:                                                                                    */
/*         FOR EACH tt-erro-benef:                                                                                                    */
/*             CREATE tt-erro.                                                                                                        */
/*             BUFFER-COPY tt-erro-benef TO tt-erro.                                                                                  */
/*         END.                                                                                                                       */
/*         RETURN "NOK".                                                                                                              */
/*     END.                                                                                                                           */
/*                                                                                                                                    */
/*                                                                                                                                    */
/*     IF tt-param.tg-gera-log THEN RUN pi-exporta-beneficios.                                                                        */
/*                                                                                                                                    */
/*                                                                                                                                    */
/*     RETURN "OK".                                                                                                                   */
/* END.                                                                                                                               */

PROCEDURE pi-Integra-PROVISAO-APB:

    /*-----------------------------*/
    /*     INTEGRAÄ«O PROVIS«O     */
    /*-----------------------------*/
    DEF INPUT PARAM p-da-ini-per   AS DATE    NO-UNDO.
    DEF INPUT PARAM p-da-fim-per   AS DATE    NO-UNDO.
    DEF INPUT PARAM p-tp-beneficio AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-categoria    AS CHAR    NO-UNDO.


    DEF VAR v_hdl_aux                 AS HANDLE             NO-UNDO.
    DEF VAR v_cod_matriz_trad_org_ext AS CHAR FORMAT "x(8)" NO-UNDO. 
    DEF VAR l-atualizou-pagto         AS LOGICAL            NO-UNDO.
    DEF VAR c-estab-ant               AS CHAR     INIT "1"  NO-UNDO.
    DEF VAR c-ep-codigo               AS CHAR               NO-UNDO.
    DEF VAR l-criar-novo              AS LOG                NO-UNDO.
    DEF VAR c-esp-prov                AS CHAR               NO-UNDO.
    DEF BUFFER b-int-cc-benef FOR int-cc-benef.

    ASSIGN i-seq-ref    = 0
           c-referencia = "".

    RUN pi-zera-tabelas.
    
    FOR EACH tt-cc-benef
        ,FIRST int-beneficio
             WHERE int-beneficio.canal          = tt-cc-benef.canal
               AND int-beneficio.tipo-beneficio = tt-cc-benef.tipo-beneficio
               AND int-beneficio.unid-neg       = tt-cc-benef.unid-neg:

        /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB005RP.P (CµLCULO) - POIS ELE UTILIZA-SE  */
        /* DESTA CODIFICAÄ«O PARA EFETUAR O ESTORNO DA PROVIS«O.O PROGRAMA ESESBAPI003-APB.P TAMBêM UTILIZAR ESSE FORMATO DE C‡DIGO                  */
        ASSIGN c-cod-titulo =  STRING      (tt-cc-benef.tipo-beneficio)        +
                               TRIM(STRING (tt-cc-benef.unid-neg))             +
                               STRING(MONTH(tt-cc-benef.dt-periodo-fim), "99") +
                               SUBSTR(string(YEAR (tt-cc-benef.dt-periodo-fim), "9999"), 3, 2).

        IF  c-estab-ant <> int-beneficio.cod-estabel THEN DO:
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = int-beneficio.cod-estabel NO-ERROR.

            IF NOT AVAIL estabelec THEN DO:
                RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Estabelecimento inv†lido: " + int-beneficio.cod-estabel,
                                            INPUT "Canal: " + string(tt-cc-benef.canal) + CHR(10) +
                                                  "Unidade: " + tt-cc-benef.unid-neg + CHR(10) +
                                                  "Benef°cio: " + fn-retorna-nome-beneficio(tt-cc-benef.tipo-beneficio) + CHR(10) +
                                                ", processamento n∆o conclu°do.").
                RETURN "NOK".
            END.

            ASSIGN c-estab-ant = int-beneficio.cod-estabel
                   c-ep-codigo = estabelec.ep-codigo.
        END.

        RUN pi-busca-referencia (INPUT  "BPRV",
                                 INPUT  int-beneficio.cod-estabel,
                                 OUTPUT c-referencia).

        /*  Verifica se o benef°cio j† possui t°tulo de provis∆o criada em per°odos anteriores  */
        ASSIGN  l-criar-novo = NO.

        FIND FIRST int-cc-benef NO-LOCK
            WHERE int-cc-benef.tp-movto       = 1 /*Provis∆o*/
              AND int-cc-benef.canal          = tt-cc-benef.canal
              AND int-cc-benef.tipo-beneficio = tt-cc-benef.tipo-beneficio
              AND int-cc-benef.unid-neg       = tt-cc-benef.unid-neg
              AND int-cc-benef.dt-periodo-ini = p-da-ini-per
              AND int-cc-benef.dt-periodo-fim = p-da-fim-per NO-ERROR.

        IF  AVAIL int-cc-benef THEN DO:
            FIND FIRST tit_ap NO-LOCK
                WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
                  AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.

            IF  AVAIL tit_ap THEN DO:
                
                /*IF  tit_ap.val_sdo_tit_ap <> tt-cc-benef.vl-saldo  THEN DO:*/

                    RUN pi-altera-temp-table-titulo (INPUT int-beneficio.cod-estabel,
                                                      INPUT da-fim, /*tt-cc-benef.dt-transacao*/  /* data da transaá∆o */
                                                      INPUT tt-cc-benef.dt-vencimento,
                                                      INPUT int-cc-benef.vl-saldo + tt-cc-benef.vl-saldo, /* Acumula o saldo pois o saldo no banco j† foi atualizado pouco antes*/
                                                      INPUT  "Processamento do " + (IF tt-param.rs-acao = 1 THEN "c†lculo" ELSE "rec†lculo de") + " provis∆o ocorrido em: " + STRING(TODAY, "99/99/9999")
                                                          /*,
                                                      INPUT  c-referencia*/).

                    IF  RETURN-VALUE <> "OK" THEN
                        RETURN "NOK".
                /*END.
                ELSE
                    NEXT.*/
            END.
            ELSE
                ASSIGN l-criar-novo = YES.
        END.
        ELSE
            ASSIGN l-criar-novo = YES.


        IF  l-criar-novo THEN DO:

            ASSIGN c-esp-prov = IF  tt-cc-benef.tipo-beneficio = 37 THEN 
                                    "RO" /*REBATE*/ 
                                ELSE IF  tt-cc-benef.tipo-beneficio = 66 THEN 
                                         "PO"   /*REBATE P‡S-VENDA*/ 
                                     ELSE  
                                         "VO". /*VMC*/

            RUN pi-cria-temp-table-titulo  (INPUT YES, /*ê Provis∆o*/
                                            INPUT int-beneficio.cod-estabel,
                                            INPUT c-ep-codigo,
                                            INPUT c-referencia,
                                            INPUT int-beneficio.conta,
                                            INPUT int-beneficio.centro-custo,
                                            INPUT c-esp-prov,
                                            INPUT int-beneficio.tipo-fluxo,
                                            INPUT c-cod-titulo,
                                            INPUT da-fim,
                                            INPUT tt-cc-benef.dt-vencimento,
                                            INPUT tt-cc-benef.canal,
                                            INPUT tt-cc-benef.unid-neg,
                                            INPUT tt-cc-benef.tipo-beneficio,
                                            INPUT tt-cc-benef.categoria,
                                            INPUT tt-cc-benef.vl-saldo).

            IF  RETURN-VALUE <> "OK" THEN
                RETURN "NOK".
        END.

    END.

    /* GRAVAÄ«O DA CONTA CORRENTE DE PROVIS«O */
    RUN pi-grava-conta-corrente-Provisao.


    IF  RETURN-VALUE <> "OK" THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Erro Tentar Gravar Contas Correntes de Provis∆o para o Benef°cio" + fn-retorna-nome-beneficio(p-tp-beneficio),
                                            INPUT "Processamento n∆o conclu°do.":U).
        RETURN "NOK".
    END.


    /*-----------------------------------------------------*/
    /*          EFETIVAÄ«O DO T÷TULO DE PROVIS«O           */
    /*-----------------------------------------------------*/
    DEF VAR l-ataulizou-provisao AS LOG NO-UNDO.

    RUN pi-efetiva-CRIACAO-titulo-APB.

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".
    
    /*------------------------------------------------------------------------*/
    /*     Atualizaá∆o dos dados do t°tulo no registro da conta conrrente     */
    /*    OBS: s¢ entra quando o t°tulo Ç novo, atualizaá∆o n∆o deve entrar   */
    /*------------------------------------------------------------------------*/
    FOR EACH int-cc-benef EXCLUSIVE-LOCK
        WHERE int-cc-benef.tp-movto        = 1               /* DESPESA */
          AND int-cc-benef.id-status       = 1               /* ATIVO */
          AND int-cc-benef.dt-periodo-ini  = p-da-ini-per
          AND int-cc-benef.dt-periodo-fim  = p-da-fim-per
          AND int-cc-benef.tipo-beneficio  = p-tp-beneficio
          AND (IF p-categoria = "DISTRIBUIDOR" THEN int-cc-benef.categoria  = p-categoria                                            ELSE  YES) /*Caso seja o VMC para DISTRIBUIDOR */
          AND (IF p-categoria = "OURO"         THEN int-cc-benef.categoria  = p-categoria                                            ELSE  YES) /*Caso seja o VMC para revenda Ouro*/
          AND (IF p-categoria = "PRATABRONZE"  THEN (int-cc-benef.categoria  <> "OURO" AND int-cc-benef.categoria <> "DISTRIBUIDOR") ELSE  YES) /*Caso seja o VMC para revenda Prata e Bronze*/
          AND int-cc-benef.num_id_tit_ap = 0 :

        ASSIGN l-ataulizou-provisao = NO.

        FIND FIRST int-beneficio
            WHERE int-beneficio.canal          = int-cc-benef.canal
              AND int-beneficio.tipo-beneficio = int-cc-benef.tipo-beneficio
              AND int-beneficio.unid-neg       = int-cc-benef.unid-neg   NO-ERROR.

        /* ATENÄ«O, AO MUDAR DA NOMENCLATURA DO T÷TULO, ESTA DEVERµ SER CONSIDERADA TAMBêM NO PROGRAMA ESESB005RP.P (CµLCULO) - POIS ELE UTILIZA-SE  */
        /* DESTA CODIFICAÄ«O PARA EFETUAR O ESTORNO DA PROVIS«O. O PROGRAMA ESESBAPI003-APB.P TAMBêM UTILIZAR ESSE FORMATO DE C‡DIGO                 */
        ASSIGN c-cod-titulo = STRING      (int-cc-benef.tipo-beneficio)        +
                              TRIM(STRING (int-cc-benef.unid-neg))             +
                              string(MONTH(int-cc-benef.dt-periodo-fim), "99") +
                              SUBSTR(string(YEAR (int-cc-benef.dt-periodo-fim), "9999"), 3, 2).
           ASSIGN c-esp-prov = IF  int-cc-benef.tipo-beneficio = 37 THEN
                                    "RO" /*REBATE*/
                               ELSE IF  int-cc-benef.tipo-beneficio = 66 THEN
                                        "PO"   /*REBATE P‡S-VENDA*/
                                     ELSE
                                        "VO". /*VMC*/

        FIND FIRST tit_ap NO-LOCK
            WHERE tit_ap.cod_estab         = int-beneficio.cod-estabel
              AND tit_ap.cdn_fornecedor    = int-cc-benef.canal
              AND tit_ap.cod_espec_docto   = c-esp-prov
              AND tit_ap.cod_ser_docto     = "1"
              AND tit_ap.cod_tit_ap        = c-cod-titulo
              AND tit_ap.cod_parcela       = "01"   NO-ERROR.

        IF  AVAIL tit_ap THEN DO:
             ASSIGN int-cc-benef.cod_estab     = tit_ap.cod_estab
                    int-cc-benef.num_id_tit_ap = tit_ap.num_id_tit_ap
                    l-ataulizou-provisao       = YES.
         END.
         ELSE
             ASSIGN l-ataulizou-provisao = NO.

        IF  NOT l-ataulizou-provisao THEN DO:

            RUN pi-cria-erro (INPUT 17006, /* Erro */
                              INPUT "N∆o foi poss°vel atualizar o registro de provis∆o para o t°tulo",
                              INPUT  "     Canal.......: " + STRING(int-cc-benef.canal) +  CHR(10) +
                                     "     Unid Neg¢cio: " + int-cc-benef.unid-neg      +  CHR(10) +
                                     "     Estab.......: " + int-beneficio.cod-estabel   +  CHR(10) +
                                     "     Cod T°tulo..: " + c-cod-titulo               +  CHR(10) +
                                     "Processamento n∆o conclu°do.":U).
            RETURN "NOK".
        END.
    END.

    /*------------------------------------------------------*/
    /*        ROTINA ALTERAÄ«O DO T÷TULO DE PROVIS«O        */
    /*------------------------------------------------------*/
    RUN pi-efetiva-ALTERECAO-titulo-ABP.

    EMPTY TEMP-TABLE tt_tit_ap_alteracao_base_aux_1.

    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    RETURN "OK".

END.
    

/* CRIAÄ«O DO T÷TULO REFERENTE AO BENEF÷CIO NO APB*/
PROCEDURE pi-cria-temp-table-titulo:

    DEF INPUT PARAM p-provisao          AS LOG  NO-UNDO.
    DEF INPUT PARAM p-cod-estab         AS CHAR NO-UNDO.       
    DEF INPUT PARAM p-ep-codigo         AS CHAR NO-UNDO.     
    DEF INPUT PARAM p-referencia        AS CHAR NO-UNDO.
    DEF INPUT PARAM p-conta             AS CHAR NO-UNDO.       
    DEF INPUT PARAM p-centro-custo      AS CHAR NO-UNDO.
    DEF INPUT PARAM p-especie           AS CHAR NO-UNDO.         
    DEF INPUT PARAM p-tipo-fluxo        AS CHAR NO-UNDO.        
    DEF INPUT PARAM p-cod-titulo        AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-transacao      AS DATE NO-UNDO.
    DEF INPUT PARAM p-dt-vencimento     AS DATE NO-UNDO. 
    DEF INPUT PARAM p-canal             AS INT  NO-UNDO.
    DEF INPUT PARAM p-unid-neg          AS CHAR NO-UNDO.
    DEF INPUT PARAM p-tipo-beneficio    AS INT  NO-UNDO.
    DEF INPUT PARAM p-categoria         AS CHAR NO-UNDO.
    DEF INPUT PARAM p-vl-saldo          AS DEC  NO-UNDO.
    
    DEF VAR da-per-ini AS DATE NO-UNDO.
    DEF VAR da-per-fim AS DATE NO-UNDO.

    DEF VAR de-saldo-aprop AS DEC NO-UNDO.
    DEF VAR c-tta_cod_plano_cta_ctbl AS CHAR NO-UNDO.
    DEF VAR c-tta_cod_plano_ccusto  AS CHAR NO-UNDO.
    
    v_log_atualiza_refer_apb = YES.

    /* Verifica se j† existe um lote criado para o estabelecimento */
    FIND FIRST tt_integr_apb_lote_impl
        WHERE tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab
          AND tt_integr_apb_lote_impl.tta_cod_refer         = p-referencia
          AND tt_integr_apb_lote_impl.tta_dat_transacao     = p-dt-transacao
          AND tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"
          AND tt_integr_apb_lote_impl.tta_cod_empresa       = p-ep-codigo 
          AND IF p-provisao THEN 
              tt_integr_apb_lote_impl.tta_cod_espec_docto = p-especie ELSE 
          YES NO-ERROR.

    IF  NOT AVAIL tt_integr_apb_lote_impl THEN DO:
        CREATE tt_integr_apb_lote_impl.
        ASSIGN tt_integr_apb_lote_impl.tta_cod_estab         = p-cod-estab                  
               tt_integr_apb_lote_impl.tta_cod_refer         = p-referencia.
        
        IF  p-provisao THEN
               tt_integr_apb_lote_impl.tta_cod_espec_docto   = p-especie.

        ASSIGN tt_integr_apb_lote_impl.tta_dat_transacao     = p-dt-transacao 
               tt_integr_apb_lote_impl.tta_ind_origin_tit_ap = "APB"                        
               tt_integr_apb_lote_impl.tta_cod_empresa       = p-ep-codigo. 
        
        VALIDATE tt_integr_apb_lote_impl.

    END.
    
    ASSIGN i-seq-ref = i-seq-ref + 1.

    CREATE tt_integr_apb_item_lote_impl_3.
    ASSIGN tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl     = recid(tt_integr_apb_lote_impl)
           tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote     = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_item_lote_impl_3.tta_num_seq_refer                = i-seq-ref
           tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor               = p-canal
           tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto              = p-especie
           tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto                = "1" /*"U"*/
           tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                   = p-cod-titulo
           tt_integr_apb_item_lote_impl_3.tta_cod_parcela                  = "01"
           tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto               = p-dt-transacao
           tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap            = p-dt-vencimento
           tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto               = p-dt-vencimento
           tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto              = "30" /*boleto*/
           tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ               = "real"
           tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                   = p-vl-saldo
           tt_integr_apb_item_lote_impl_3.tta_cod_portador                 = "999"
           tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ         = 1.



/*     MESSAGE "tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl : " tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl    skip */
/*             "tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote : " tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote    skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            : " tt_integr_apb_item_lote_impl_3.tta_num_seq_refer               skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           : " tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor              skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          : " tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto             skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            : " tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto               skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               : " tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap                  skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_parcela              : " tt_integr_apb_item_lote_impl_3.tta_cod_parcela                 skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           : " tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto              skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        : " tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap           skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           : " tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto              skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          : " tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto             skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           : " tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ              skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               : " tt_integr_apb_item_lote_impl_3.tta_val_tit_ap                  skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_cod_portador             : " tt_integr_apb_item_lote_impl_3.tta_cod_portador                skip */
/*             "tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     : " tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ             */
/*             "                                                                                                                                    */
/*             "                                                                                                                                    */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                       */


    VALIDATE tt_integr_apb_item_lote_impl_3.
      
    ASSIGN de-saldo-aprop           = p-vl-saldo
           c-tta_cod_plano_cta_ctbl = "Padrao"
           c-tta_cod_plano_ccusto   = "Padrao".


    /* Verifica o per°odo inicial e final, pois para o VMC-Prata/bronze Ç diferente */
    IF  p-tipo-beneficio = 21 AND p-categoria <> "OURO" AND p-categoria <> "DISTRIBUIDOR" THEN 
        ASSIGN da-per-ini = IF  MONTH(da-fim) <= 9 THEN  DATE(01,01,YEAR(da-fim)) ELSE DATE(10,01,YEAR(da-fim))  
               da-per-fim = IF  MONTH(da-fim) <= 9 THEN  DATE(09,30,YEAR(da-fim)) ELSE DATE(12,31,YEAR(da-fim)). 
    ELSE
        ASSIGN da-per-ini = da-ini-trimestre 
               da-per-fim = da-fim-trimestre. 

    /*Apropriaá∆o dos t°tulos*/
    create tt_integr_apb_aprop_ctbl_pend.
    assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  = recid(tt_integr_apb_item_lote_impl_3)
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      = ?
           tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend = ?
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            = p-unid-neg
           tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      = p-tipo-fluxo /*"201"*/
           tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            = p-vl-saldo /* Saldo da conta de despesas */
           tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         = ""
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        = c-tta_cod_plano_cta_ctbl
           tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              = p-conta
           tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          = c-tta_cod_plano_ccusto
           tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                = p-centro-custo.
    VALIDATE tt_integr_apb_aprop_ctbl_pend.


/*     MESSAGE 'tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote  : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote     skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend      : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend         skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend : ' tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend    skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc            : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc               skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ      : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_tip_fluxo_financ         skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl            : ' tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl               skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                  : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                     skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac          : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac             skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto               : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                  skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto         : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto            skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl        : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl           skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl              : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl                 skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto          : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto             skip  */
/*             'tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                : ' tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                   skip  */
/*                                                                                                                                                   */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                        */


    RETURN "OK".           
END.

/* ALTERAÄ«O DO T÷TULO REFERENTE AO BENEF÷CIO NO APB*/
PROCEDURE pi-altera-temp-table-titulo:

    DEF INPUT PARAM p-cod-estab   AS CHAR NO-UNDO.
    DEF INPUT PARAM p-dt-transcao AS DATE NO-UNDO.
    DEF INPUT PARAM p-dt-vencto   AS DATE NO-UNDO.
    DEF INPUT PARAM p-de-saldo    AS DEC  NO-UNDO.
    DEF INPUT PARAM p-motivo      AS CHAR NO-UNDO.
/*    DEF INPUT PARAM p-referencia  AS CHAR NO-UNDO.*/
    DEF VAR c-refer AS CHAR NO-UNDO.

    /*busca referencia*/
    ASSIGN c-refer = "".

    DO WHILE TRUE:
    
        RUN pi-busca-referencia (INPUT  "BPRV",
                                 INPUT  p-cod-estab,
                                 OUTPUT c-refer).
        IF  NOT CAN-FIND (FIRST tt_tit_ap_alteracao_base_aux_1
                           WHERE tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer = c-refer) 
        AND NOT CAN-FIND (FIRST tt_integr_apb_lote_impl
                            WHERE tt_integr_apb_lote_impl.tta_cod_refer = c-refer) THEN
            LEAVE.

    END.

    create tt_tit_ap_alteracao_base_aux_1.
    assign tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren             = v_cod_usuar_corren
           tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                  = tit_ap.cod_empresa
           tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                    = tit_ap.cod_estab
           tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap                = tit_ap.num_id_tit_ap
           tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                   = recid(tt_tit_ap_alteracao_base_aux_1)
           tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor               = tit_ap.cdn_fornecedor
           tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto              = tit_ap.cod_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto                = tit_ap.cod_ser_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                   = tit_ap.cod_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                  = tit_ap.cod_parcela
           tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao                = p-dt-transcao
           tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                    = c-refer 
           tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap               = p-de-saldo
           tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto               = tit_ap.dat_emis_docto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap            = p-dt-vencto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto               = p-dt-vencto
           tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto                = tit_ap.dat_ult_pagto
           tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso              = tit_ap.num_dias_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso        = tit_ap.val_perc_multa_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso         = tit_ap.val_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso    = tit_ap.val_perc_juros_dia_atraso
           tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                 = tit_ap.dat_desconto
           tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc                = tit_ap.val_perc_desc
           tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                 = tit_ap.val_desconto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                 = tit_ap.cod_portador
           tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo             = tit_ap.log_pagto_bloqdo
           tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora               = tit_ap.cod_seguradora
           tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro              = tit_ap.cod_apol_seguro
           tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador               = tit_ap.cod_arrendador
           tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas             = tit_ap.cod_contrat_leas
           tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto          = tit_ap.ind_tip_espec_docto
           tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ               = tit_ap.cod_indic_econ
           tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap   = "alteraá∆o"
           tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr              = ""
           tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr              = p-motivo
           tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap               = tit_ap.ind_sit_tit_ap
           tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto              = tit_ap.cod_forma_pagto.

           VALIDATE tt_tit_ap_alteracao_base_aux_1.

/*     MESSAGE "tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren           : " tt_tit_ap_alteracao_base_aux_1.ttv_cod_usuar_corren            skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                : " tt_tit_ap_alteracao_base_aux_1.tta_cod_empresa                 skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                  : " tt_tit_ap_alteracao_base_aux_1.tta_cod_estab                   skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap              : " tt_tit_ap_alteracao_base_aux_1.tta_num_id_tit_ap               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                 : " tt_tit_ap_alteracao_base_aux_1.ttv_rec_tit_ap                  skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor             : " tt_tit_ap_alteracao_base_aux_1.tta_cdn_fornecedor              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_espec_docto             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto              : " tt_tit_ap_alteracao_base_aux_1.tta_cod_ser_docto               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                 : " tt_tit_ap_alteracao_base_aux_1.tta_cod_tit_ap                  skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                : " tt_tit_ap_alteracao_base_aux_1.tta_cod_parcela                 skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao              : " tt_tit_ap_alteracao_base_aux_1.ttv_dat_transacao               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                  : " tt_tit_ap_alteracao_base_aux_1.ttv_cod_refer                   skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap             : " tt_tit_ap_alteracao_base_aux_1.tta_val_sdo_tit_ap              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto             : " tt_tit_ap_alteracao_base_aux_1.tta_dat_emis_docto              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap          : " tt_tit_ap_alteracao_base_aux_1.tta_dat_vencto_tit_ap           skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto             : " tt_tit_ap_alteracao_base_aux_1.tta_dat_prev_pagto              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto              : " tt_tit_ap_alteracao_base_aux_1.tta_dat_ult_pagto               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso            : " tt_tit_ap_alteracao_base_aux_1.tta_num_dias_atraso             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso      : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_multa_atraso       skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso       : " tt_tit_ap_alteracao_base_aux_1.tta_val_juros_dia_atraso        skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso  : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_juros_dia_atraso   skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto               : " tt_tit_ap_alteracao_base_aux_1.tta_dat_desconto                skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc              : " tt_tit_ap_alteracao_base_aux_1.tta_val_perc_desc               skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_val_desconto               : " tt_tit_ap_alteracao_base_aux_1.tta_val_desconto                skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_portador               : " tt_tit_ap_alteracao_base_aux_1.tta_cod_portador                skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo           : " tt_tit_ap_alteracao_base_aux_1.tta_log_pagto_bloqdo            skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_seguradora              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_apol_seguro             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_arrendador              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas           : " tt_tit_ap_alteracao_base_aux_1.tta_cod_contrat_leas            skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto        : " tt_tit_ap_alteracao_base_aux_1.tta_ind_tip_espec_docto         skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ             : " tt_tit_ap_alteracao_base_aux_1.tta_cod_indic_econ              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap : " tt_tit_ap_alteracao_base_aux_1.ttv_ind_motiv_alter_val_tit_ap  skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_histor_padr             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr            : " tt_tit_ap_alteracao_base_aux_1.tta_des_histor_padr             skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap             : " tt_tit_ap_alteracao_base_aux_1.tta_ind_sit_tit_ap              skip  */
/*             "tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto            : " tt_tit_ap_alteracao_base_aux_1.tta_cod_forma_pagto             skip  */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                                          */

    RETURN "OK".
END.
        

PROCEDURE pi-exporta-beneficios:

     PUT STREAM exp3 "Canal;Unidade;Beneficio;Categoria;Classificaá∆o;% Benef;% Custo;% Prov Meta;STATUS;Conta Contab;Centro Custo;Estabelec;EspÇcie;Tp Fluxo;Exclusiv;Calcula Verba;GUID Canal;GUID Benef;GUID Benef Canal;GUID Classificaá∆o;GUID Categoria" SKIP.
     
     FOR EACH int-beneficio:
          EXPORT STREAM exp3 DELIMITER ";" int-beneficio.canal                  
                                           int-beneficio.unid-neg               
                                           fn-retorna-nome-beneficio(int-beneficio.tipo-beneficio)
                                           int-beneficio.tipo-categoria         
                                           int-beneficio.nome-class             
                                           int-beneficio.perc-global            
                                           int-beneficio.perc-custo                                         
                                           int-beneficio.perc-prov-meta         
                                           int-beneficio.id-status              
                                           int-beneficio.conta-contab           
                                           int-beneficio.centro-custo           
                                           int-beneficio.cod-estabel            
                                           int-beneficio.cod-especie            
                                           int-beneficio.tipo-fluxo             
                                           int-beneficio.exclusividade             
                                           int-beneficio.calcula-verba                                                
                                           int-beneficio.guid-canal             
                                           int-beneficio.guid-beneficio 
                                           int-beneficio.guid-beneficio-canal   
                                           int-beneficio.guid-class             
                                           int-beneficio.guid-categoria.         
     END.                                                                      
END.                                                                               




PROCEDURE pi-exporta-centrais:
    PUT STREAM exp2 "Central;Ades∆o Central;CLASS Central; NomeAb Central; Nome Central; NomeMatriz Central;Filial;NomeAb Filial;Nome Filial;Matriz Filial;Ades∆o Filial;GUID CLASS Filial;Centralizada;Exclusiva" SKIP.
    
    FOR EACH tt-central:
        EXPORT STREAM exp2 DELIMITER ";"  tt-central.canal-central
                                          tt-central.dt-adesao-central
                                          tt-central.guid-class-central
                                          tt-central.nome-abrev-central
                                          tt-central.nome-emit-central
                                          tt-central.nome-matriz-central
                                          tt-central.canal-filial
                                          tt-central.nome-abrev-filial
                                          tt-central.nome-emit-filial
                                          tt-central.nome-matriz-filial
                                          tt-central.dt-adesao-filial
                                          tt-central.guid-class-filial
                                          tt-central.centralizada 
                                          tt-central.exclusividade.  
    END.
END.

PROCEDURE pi-exporta-fat:

    FOR EACH tt-fat-mensal
        , FIRST int-beneficio  
             WHERE int-beneficio.canal          = tt-fat-mensal.canal 
               AND int-beneficio.unid-neg       = tt-fat-mensal.unid-neg:
    
        EXPORT STREAM exp1 DELIMITER ";" tt-fat-mensal.ano         
                                         tt-fat-mensal.mes         
                                         tt-fat-mensal.canal       
                                         tt-fat-mensal.unid-neg    
                                         tt-fat-mensal.vl-faturado
                                         tt-fat-mensal.vl-devolvido
                                         tt-fat-mensal.vl-apurado
                                         tt-fat-mensal.guid-canal.        
    END.
END.


PROCEDURE pi-exporta-fat-detalhes:

    FOR EACH tt-fat-mensal-det
       , FIRST int-beneficio  
             WHERE int-beneficio.canal          = tt-fat-mensal-det.canal 
               AND int-beneficio.unid-neg       = tt-fat-mensal-det.unid-neg:
    
        EXPORT STREAM exp1-det DELIMITER ";" tt-fat-mensal-det.ano         
                                             tt-fat-mensal-det.mes         
                                             tt-fat-mensal-det.canal
                                             tt-fat-mensal-det.cod-emitente
                                             tt-fat-mensal-det.unid-neg    
                                             (IF tt-fat-mensal-det.tp-movto = 1 THEN "FATUR"
                                              ELSE IF tt-fat-mensal-det.tp-movto = 2 THEN "DEVOL"
                                                  ELSE "SELLOUT")
                                             tt-fat-mensal-det.seq         
                                             tt-fat-mensal-det.cod-estabel 
                                             tt-fat-mensal-det.serie       
                                             tt-fat-mensal-det.nr-nota-fis 
                                             tt-fat-mensal-det.nr-seq-fat  
                                             tt-fat-mensal-det.it-codigo   
                                             tt-fat-mensal-det.vl-faturado 
                                             tt-fat-mensal-det.data
                                             tt-fat-mensal-det.serie-docto 
                                             tt-fat-mensal-det.nro-docto   
                                             tt-fat-mensal-det.cod-emitente
                                             tt-fat-mensal-det.nat-operacao
                                             tt-fat-mensal-det.sequencia   
                                             tt-fat-mensal-det.vl-devolvido
                                             /*tt-fat-mensal-det.vl-sellout*/.        
    END.

    
END.

PROCEDURE pi-exporta-provisao:

    EXPORT STREAM exp4 DELIMITER ";" "PROVIS«O"
                                     tt-cc-benef.canal              
                                     tt-cc-benef.unid-neg      
                                     fn-retorna-nome-beneficio(tt-cc-benef.tipo-beneficio)
                                     tt-cc-benef.categoria
                                     int-beneficio.nome-class
                                     tt-cc-benef.dt-periodo-ini
                                     tt-cc-benef.dt-periodo-fim
                                     tt-cc-benef.vl-saldo-anterior    
                                     tt-cc-benef.vl-base-calc
                                     tt-cc-benef.perc-custo    
                                     tt-cc-benef.perc-prov-meta
                                     tt-cc-benef.perc-benef
                                     tt-cc-benef.vl-saldo      
                                     tt-cc-benef.dt-transacao  
                                     tt-cc-benef.dt-vencimento 
                                     tt-cc-benef.id-status     
                                     tt-cc-benef.usuario       
                                     tt-cc-benef.classificacao
                                     tt-cc-benef.guid-beneficio-canal
                                     tt-cc-benef.guid-beneficio
                                     tt-cc-benef.guid-canal.
END.

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                          F U N Ä Â E S   I N T E R N A S                                                                                */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.

PROCEDURE pi-retorna-datas:

    DEF INPUT PARAM p-mes AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-ano AS INTEGER NO-UNDO.
    
    /**************** CALCULAR DATA INICIAL E FINAL *****************/
    ASSIGN da-ini = DATE(tt-param.mes,01, tt-param.ano)
           da-fim = IF  tt-param.mes = 12 THEN
                        DATE(12, 31, tt-param.ano) 
                    ELSE
                        DATE(MONTH(da-ini) + 1, 01, YEAR(da-ini)) - 1.

    RETURN "OK".
END.

PROCEDURE pi-grava-fat-mensal:


/*     /* Est† recalculando */           */
/*     IF  tt-param.rs-acao = 2 THEN DO: */
    
        /*DELETA INF-FAT-MENSAL PARA O MES DE PROCESSAMENTO*/
        FOR EACH nova.int-fat-mensal EXCLUSIVE-LOCK
            WHERE int-fat-mensal.ano = YEAR (da-fim)
              AND int-fat-mensal.mes = MONTH(da-fim):    

            DELETE int-fat-mensal.
        END. 
        /*DELETA INT-FAT-MENSAL PARA O MES DE PROCESSAMENTO*/
        FOR EACH nova.int-fat-mensal-det
            WHERE int-fat-mensal-det.ano = YEAR (da-fim)
              AND int-fat-mensal-det.mes = MONTH(da-fim) EXCLUSIVE-LOCK:
            DELETE int-fat-mensal-det.
        END.

/*     END.  */


    /* CRIAÄ«O */
    FOR EACH tt-fat-mensal
        WHERE tt-fat-mensal.ano = YEAR (da-fim)
          AND tt-fat-mensal.mes = MONTH(da-fim)
        , FIRST int-beneficio  
             WHERE int-beneficio.canal          = tt-fat-mensal.canal 
               AND int-beneficio.unid-neg       = tt-fat-mensal.unid-neg:
        CREATE int-fat-mensal.    
        BUFFER-COPY tt-fat-mensal TO int-fat-mensal.
    END.

    FOR EACH tt-fat-mensal-det
        WHERE tt-fat-mensal-det.ano = YEAR (da-fim)
          AND tt-fat-mensal-det.mes = MONTH(da-fim)
        , FIRST int-beneficio  
             WHERE int-beneficio.canal          = tt-fat-mensal-det.canal 
               AND int-beneficio.unid-neg       = tt-fat-mensal-det.unid-neg:    

        CREATE int-fat-mensal-det.    
        BUFFER-COPY tt-fat-mensal-det TO int-fat-mensal-det.
    END.

    RETURN "OK".

END.


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


