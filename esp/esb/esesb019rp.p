{include/i-prgvrs.i esesb019rp 2.00.00.000}  
    
/*----------------------------------------------------------------*/
/*        DEFINIÄÂES ESPEC÷FICAS PARA INTEGRAÄ«O COM O APB        */
/*----------------------------------------------------------------*/
DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

v_des_contdo_prog_valid_dtsul = "esesb019rp".

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as i no-undo.

DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esapi/esapi015tt.i}
{esp/esb/esesbapi010-saldo.i1} 
{esp/esb/out/msg0159.i}
{utp/utapi009.i}
{esp/esb/esesb000.i}
{esp/esb/esesbapi004-benef.i} /* Temp-table tt-beneficio */
{esp/esb/esesbapi002.i} /* tt-canal; tt-fat-mensal; tt-fat-mensal-det */
{esp/esb/esesb019rp.i} /* retornar o pre-fixo para o Guid da Solicitaá∆o hist¢rica */

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(500)"
    FIELD ajuda    AS CHAR FORMAT "X(500)".

DEF TEMP-TABLE tt-erro-benef NO-UNDO LIKE tt-erro.
DEF TEMP-TABLE tt-beneficio-aux LIKE tt-beneficio.

DEFINE TEMP-TABLE tt-unid-negoc NO-UNDO
    FIELD cod-unid-negoc AS CHARACTER
    FIELD descricao      AS CHARACTER.

DEFINE VARIABLE c-referencia         AS CHAR FORMAT "X(20)"    NO-UNDO.
DEFINE VARIABLE c-cod-titulo         AS CHAR FORMAT "X(09)"    NO-UNDO.

/*-------------------------------------------------*/
/*    D E F I N I Ä « O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
define temp-table tt-param no-undo
    FIELD destino        AS INTEGER
    FIELD arquivo        AS CHAR format "x(35)"
    FIELD usuario        AS CHAR format "x(12)"
    FIELD data-exec      AS DATE
    FIELD hora-exec      AS INTEGER
    FIELD dt-periodo-ini AS DATE
    FIELD dt-periodo-fim AS DATE
    FIELD trimestre      AS CHAR
    FIELD ano            AS CHAR
    FIELD rs-tipo     AS INTEGER.


DEFINE TEMP-TABLE tt-migracao NO-UNDO
     FIELD CodigoSolicitacaoBeneficio LIKE int-solicitacao.CodigoSolicitacaoBeneficio            
     FIELD cod-emitente               LIKE int-solicitacao.cod-emitente                  
     FIELD nome-abrev                 LIKE emitente.nome-abrev
     FIELD tipo-beneficio             LIKE int-solicitacao.tipo-beneficio                        
     FIELD unidade                    LIKE int-solicitacao.CodigoUnidadeNegocio
     FIELD dt-periodo-ini             AS DATE                      
     FIELD dt-periodo-fim             AS DATE
     FIELD desc-forma-pagto           LIKE int-solicitacao.desc-forma-pagto                      
     FIELD situacao                   LIKE int-solicitacao.SituacaoSolicitacaoBeneficio
     FIELD ValorSolicitado            LIKE int-solicitacao.ValorSolicitado                       
     FIELD DataCriacao                LIKE int-solicitacao.DataCriacao                           
     FIELD ValorPago                  LIKE int-solicitacao.ValorPago                             
     FIELD vl-empenho-a-transferir    LIKE int-solicitacao.ValorPago                            
     FIELD dt-new-periodo-ini         AS DATE
     FIELD dt-new-periodo-fim         AS DATE
     FIELD pai                        AS LOG INIT YES
     FIELD r-int-cc-benef             AS ROWID
    
    INDEX idx-primary CodigoSolicitacaoBeneficio
    INDEX idx-cc cod-emitente
                 tipo-beneficio
                 unidade
                 dt-periodo-ini
                 dt-periodo-fim .


def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

DEF TEMP-TABLE tt-erro-saldo   LIKE tt-erro.
DEF TEMP-TABLE tt-erro-apb     LIKE tt-erro.

define temp-table tt-digita 
    FIELD canal-central     AS INTEGER
        INDEX idx-canal IS PRIMARY UNIQUE canal-central.


DEF TEMP-TABLE b-tt-saldo NO-UNDO LIKE tt-saldo.

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

/* bloco principal do programa */
ASSIGN c-programa     = "esesb019rp"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Programa de Canais"
       c-titulo-relat = "Finalizaá∆o Contas Correntes e Migraá∆o Empenho Solicitaá‰es".

/************ DEFINIÄ«O DE VARIµVEIS **************/
DEFINE VARIABLE h-acomp                   AS HANDLE                       NO-UNDO.
DEFINE VARIABLE c-tipo                    AS CHAR FORMAT "X(10)"          NO-UNDO.
DEFINE VARIABLE de-verba-disp-a-encerrar  LIKE tt-saldo.VerbaDisponivel   NO-UNDO.
DEFINE VARIABLE de-saldo-tit-encerrar     LIKE tit_ap.val_sdo_tit_ap      NO-UNDO.
DEFINE VARIABLE l-ok                      AS LOG INIT NO                  NO-UNDO.
DEFINE VARIABLE i-qt-contas-correntes     AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont-tit                AS INTEGER                      NO-UNDO.

DEF VAR da-proximo-periodo-ini AS DATE NO-UNDO.
DEF VAR da-proximo-periodo-fim AS DATE NO-UNDO.

DEFINE BUFFER b-cc-benef                  FOR int-cc-benef.
DEFINE BUFFER b-cc-migracao               FOR int-cc-benef.
DEFINE BUFFER b-cc-finaliza               FOR int-cc-benef.
DEFINE BUFFER b-emitente                  FOR emitente.
DEFINE BUFFER b-tt-migracao               FOR tt-migracao.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF TEMP-TABLE tt-migra-conta LIKE int-cc-benef
    FIELD dt-periodo-ini-ant LIKE int-cc-benef.dt-periodo-ini
    FIELD dt-periodo-fim-ant LIKE int-cc-benef.dt-periodo-fim.

DEF TEMP-TABLE tt-migra-conta-aux LIKE tt-migra-conta.

DEF STREAM exp1.
DEF STREAM exp2.
DEF STREAM exp3.
DEF STREAM EXP10.

/*-------------------*/
/*   F U N Ä Â E S   */
/*-------------------*/
FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

FUNCTION fn-retorna-situacao-beneficio RETURNS CHAR
    (p-situacao AS INT) FORWARD.

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
                                                                    
/*---------------------------------------------------*/
/*    GERAÄ«O DE ARQUIVO DE ACOMPANHAMENTO  (.CSV)   */
/*---------------------------------------------------*/
DEF VAR c-arq-contas       AS CHAR NO-UNDO.
DEF VAR c-arq-empenho      AS CHAR NO-UNDO.
DEF VAR c-arq-empenho-fim  AS CHAR NO-UNDO.
DEF VAR c-arq-new-contas   AS CHAR NO-UNDO.

IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-contas = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-Finaliza_Ctas_Correntes_" + string(tt-param.dt-periodo-ini, "99-99-9999") + "_a_" + string(tt-param.dt-periodo-fim, "99-99-9999") + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-contas = SESSION:TEMP-DIRECTORY +  "log-Finaliza_Ctas_Correntes_" + string(tt-param.dt-periodo-ini, "99-99-9999") + "_a_" + string(tt-param.dt-periodo-fim, "99-99-9999") + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

OUTPUT STREAM exp1 TO VALUE(c-arq-contas) CONVERT TARGET "iso8859-1".
PUT STREAM exp1 "Opá∆o;Canal;NomeAbrev;Benef°cio;Unidade;Per°odo In°cio; Per°odo Final;Verba Dispon°vel Atual;Sdo Tit Atual;Situaá∆o" SKIP.


IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-empenho = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-Migra_Empenhos_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-empenho = SESSION:TEMP-DIRECTORY + "log-Migra_Empenhos_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

OUTPUT STREAM exp2 TO VALUE(c-arq-empenho) CONVERT TARGET "iso8859-1".

PUT STREAM exp2 "Opá∆o;CodigoSolicitaá∆o;Canal;NomeAbrev;Benef°cio;Unidade;Per°odo Orig Ini;Per°odo Orig Fim;Situaá∆o;Forma Pagto;Dt Criaá∆o;Valor Solicitacao;Valor Pago;Empenho Transferido;Per Ini Novo;Per Fim Novo" SKIP.


/* NOVA CONTA CORRENTE */
IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-new-contas = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-Novas_Contas_Correntes_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-new-contas = SESSION:TEMP-DIRECTORY + "log-Novas_Contas_Correntes_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

OUTPUT STREAM exp3 TO VALUE(c-arq-new-contas) CONVERT TARGET "iso8859-1".

PUT STREAM exp3 "Opá∆o;Canal;NomeAbrev;Benef°cio;Unidade;Per Ini;Per Fim;Verba Acumulada(stock_Rot);Verba Transferida;Verba Calculada;VerbaAjustada;Verba Cancelada;Verba Empenhada; Verba Reembolsada; Saldo Dispon°vel; Situaá∆o" SKIP.
                                                                                                                            


IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arq-empenho-fim = SESSION:TEMP-DIRECTORY + "/" + c-seg-usuario + "/" + "log-Migra_Empenhos_FIM_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE
    ASSIGN c-arq-empenho-fim = SESSION:TEMP-DIRECTORY + "log-Migra_Empenhos_FIM_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

OUTPUT STREAM exp10 TO VALUE(c-arq-empenho-fim) CONVERT TARGET "iso8859-1".

PUT STREAM exp10 "Opá∆o;CodigoSolicitaá∆o;Canal;NomeAbrev;Benef°cio;Unidade;Per°odo Orig Ini;Per°odo Orig Fim;Situaá∆o;Forma Pagto;Dt Criaá∆o;Valor Solicitacao;Valor Pago;Empenho Transferido;Per Ini Novo;Per Fim Novo" SKIP.


/*In°cio*/                                                                                                                  
RUN PI-PRINCIPAL.                                                                                                           
                                                                                                                            
                                                                                                                            
/* Retornou erro */                                                                                                         
IF  CAN-FIND (FIRST tt-erro) OR NOT l-ok THEN DO:      

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
 
    PUT SKIP(3)" ATENÄ«O: N∆o foi poss°vel concluir a finalizaá∆o e migraá∆o dos empenhos. Entre em contato com a PCI ou Financeiro Intelbras.".
 
END.
ELSE 
    PUT SKIP(2) "    Finalizaá∆o de contas e migraá∆o de empenho de solicitaá‰es foram executados com sucesso!".

PUT SKIP(2).
PUT "    Gerado arquivo de acompanhamento Contas Correntes Finalizadas..........: " c-arq-contas     FORMAT "x(100)" SKIP(1).
PUT "    Gerado arquivo de acompanhamento Migraá∆o de Solicitaá‰es..............: " c-arq-empenho    FORMAT "x(100)" SKIP(1).
PUT "    Gerado arquivo de Novas Contas Correntes ..............................: " c-arq-new-contas FORMAT "x(100)" SKIP(1).

                                                                         
/* DISPLYA PAR∂METROS */
PUT "                                                            PAR∂METROS"           SKIP
    "                                                --------------------------------" SKIP(1).
PUT "                                                Trimestre a encerrar.: " string(tt-param.trimestre)  SKIP
    "                                                Ano..................: " string(tt-param.ano)  SKIP
    "                                                Opá∆o................: " c-tipo  SKIP.



ASSIGN v_des_contdo_prog_valid_dtsul = "".


/* FECHAR ARQUIVOS EXCEL */
OUTPUT STREAM exp1 CLOSE.
OUTPUT STREAM exp2 CLOSE.
OUTPUT STREAM exp3 CLOSE.
OUTPUT STREAM exp10 CLOSE.

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             

/*  F I M  */


/*--------------------------------------------------------------*/
/*             P R O C E D U R E S  I N T E R N A S             */
/*--------------------------------------------------------------*/
PROCEDURE PI-PRINCIPAL:
    
    ASSIGN l-ok = NO.

    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Transferencia empenhos...").
    
    /* ----------------------------------------------------------------------------------------------------- */ 
    /*                             MIGRAÄ«O DE SALDO EMPENAHDO ENTRE TRIMESTRES                              */
    /*                                                                                                       */
    /* Busca as Solicitaá‰es Pendentes - podendo estar completamente abertas ou atendidas parcialmente para: */
    /*                  REBATE, REBATE P‡S-VENDA, VMC, STOCK ROTATION, PRICE PROTECTION                      */
    /* ----------------------------------------------------------------------------------------------------- */ 

    /*---------- VALIDAÄÂES -------------*/
    FIND LAST int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto  = 2
          AND int-cc-benef.id-status = 1 /*Ativa*/ NO-ERROR.

    IF  NOT AVAIL int-cc-benef THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, 
                                            INPUT "N∆o existem contas correntes ativas no per°odo selecionado", 
                                            INPUT "").
        RETURN "NOK".
    END.
    /*Caso o usu†rio tenha selecionado um per°odo que j† esteja fechado*/
    IF  NOT (tt-param.dt-periodo-ini = int-cc-benef.dt-periodo-ini AND tt-param.dt-periodo-fim = int-cc-benef.dt-periodo-fim) THEN DO:
        
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, 
                                            INPUT "Per°odo selecionado n∆o Ç compativel com o per°odo das £ltimas contas correntes ativas", 
                                            INPUT "Existem contas correntes ativas de " + STRING(int-cc-benef.dt-periodo-ini, "99/99/9999") + " atÇ " + STRING(int-cc-benef.dt-periodo-fim, "99/99/9999") ).
        RETURN "NOK".
    END.

    /* Zerar o saldo dispon°vel das contas correntes ativas. Envia msg0159 para o CRM, para zerar o saldo neste. */
    IF  tt-param.rs-tipo = 2 THEN DO:
        RUN pi-zera-saldo-contas-correntes (OUTPUT l-ok).
        IF  NOT l-ok THEN
            RETURN "NOK".
    END.

    /* Buscar os benef°cios dos canais */
    RUN pi-buscar-beneficios (OUTPUT l-ok).

    IF  NOT l-ok THEN
        RETURN "NOK".

    RUN pi-APURAR-EMPENHOS.

    RUN pi-MIGRA-CONTA-CORRENTE (OUTPUT l-ok).
    IF  NOT l-ok THEN
        RETURN "NOK".

    /* TRANSAÄ«O PRINCIPAL */
    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco ON ERROR UNDO bloco, LEAVE bloco:

         /* FINALIZAR AS CONTAS ATUAIS */
         RUN pi-FINALIZA-CONTA-CORRENTE (OUTPUT l-ok).

         IF  NOT l-ok THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "Erro finalizando contas correntes",
                                                 INPUT "").
             UNDO bloco , RETURN "NOK".
         END.

            
         /* Grava as novas contas criadas */
         IF  tt-param.rs-tipo = 2 THEN DO:
             FOR EACH tt-migra-conta:
                 CREATE b-cc-migracao.
                 BUFFER-COPY tt-migra-conta TO b-cc-migracao.
             END.

             RUN pi-lista-novas-contas.
         END.

         RUN PI-GRAVA-MIGRACAO  (OUTPUT l-ok).
         IF  NOT l-ok THEN DO:
             UNDO bloco , RETURN "NOK".
         END.

/*          /* CRIA T÷TULO PARA AS NOVAS CONTAS*/ */
/*          RUN PI-CRIA-SALDO-APB (OUTPUT l-ok).  */
/*                                                */
/*          IF  NOT l-ok THEN DO:                 */
/*              UNDO bloco , RETURN "NOK".  */
/*          END.                            */

    END.
    
    ASSIGN l-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-APURAR-EMPENHOS:

    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-acompanhar IN h-acomp (INPUT "Apurando Empenhos Trimestre Selecionado...").

    DEFINE VARIABLE da-new-periodo-ini        AS DATE INIT ? NO-UNDO.
    DEFINE VARIABLE da-new-periodo-fim        AS DATE INIT ? NO-UNDO.
    DEFINE VARIABLE da-vencto                 AS DATE NO-UNDO.

    FOR EACH int-solicitacao NO-LOCK
        WHERE int-solicitacao.dt-periodo-ini = tt-param.dt-periodo-ini
          AND int-solicitacao.dt-periodo-fim = tt-param.dt-periodo-fim
          AND int-solicitacao.cod-emitente <> 4365
          AND (    int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520006 
               AND int-solicitacao.SituacaoSolicitacaoBeneficio <> 993520004
               ) 
          AND NOT int-solicitacao.ajuste 
          AND NOT int-solicitacao.log-historica
          /*AND int-solicitacao.int-1 = 0 /*Distribuidor*/   */
          , FIRST emitente FIELDS (nome-abrev) NO-LOCK
             WHERE emitente.cod-emitente = int-solicitacao.cod-emitente
               /*AND (/*emitente.cod-emitente = 179189 OR*/ emitente.cod-emitente = 21755) */ :

          FIND int-cc-benef
              WHERE int-cc-benef.canal          = int-solicitacao.cod-emitente
                AND int-cc-benef.unid-neg       = int-solicitacao.CodigoUnidadeNegocio
                AND int-cc-benef.tipo-beneficio = int-solicitacao.tipo-beneficio
                AND int-cc-benef.dt-periodo-ini = int-solicitacao.dt-periodo-ini
                AND int-cc-benef.dt-periodo-fim = int-solicitacao.dt-periodo-fim
                AND int-cc-benef.tp-movto       = 2 NO-LOCK.

          /* Considerar apenas Distribuidores, Revenda Soluá‰es e Provedores */
          IF  int-cc-benef.categoria <> "DISTRIBUIDOR"
          AND int-cc-benef.categoria <> "REVENDA SOLUCOES" 
          AND int-cc-benef.categoria <> "PROVEDORES" THEN 
              NEXT.

          CREATE tt-migracao.
          ASSIGN tt-migracao.CodigoSolicitacaoBeneficio = int-solicitacao.CodigoSolicitacaoBeneficio
                 tt-migracao.cod-emitente               = int-solicitacao.cod-emitente
                 tt-migracao.nome-abrev                 = emitente.nome-abrev
                 tt-migracao.tipo-beneficio             = int-solicitacao.tipo-beneficio
                 tt-migracao.unidade                    = int-solicitacao.CodigoUnidadeNegocio
                 tt-migracao.dt-periodo-ini             = int-solicitacao.dt-periodo-ini
                 tt-migracao.dt-periodo-fim             = int-solicitacao.dt-periodo-fim
                 tt-migracao.situacao                   = int-solicitacao.SituacaoSolicitacaoBeneficio
                 tt-migracao.desc-forma-pagto           = int-solicitacao.desc-forma-pagto
                 tt-migracao.ValorSolicitado            = int-solicitacao.ValorSolicitado
                 tt-migracao.DataCriacao                = int-solicitacao.DataCriacao
                 tt-migracao.ValorPago                  = 0
                 tt-migracao.vl-empenho-a-transferir    = int-solicitacao.ValorSolicitado
                 tt-migracao.r-int-cc-benef             = ROWID(int-cc-benef).

          /* Define o novo per°odo */
          IF  da-new-periodo-ini = ? THEN
              RUN pi-busca-proximo-trimestre (INPUT tt-migracao.dt-periodo-ini,
                                              OUTPUT da-new-periodo-ini,
                                              OUTPUT da-new-periodo-fim,
                                              OUTPUT da-vencto).

          ASSIGN tt-migracao.dt-new-periodo-ini = da-new-periodo-ini 
                 tt-migracao.dt-new-periodo-fim = da-new-periodo-fim.

    END.

    RUN pi-exporta-migracao.

    DEF VAR da-vl-empenho-total    LIKE int-cc-benef.VerbaCalculada NO-UNDO.
    
    FOR EACH tt-migracao                                                                                                           
        WHERE tt-migracao.unidade = "ADM"                                                                                          
          AND tt-migracao.pai                                                                                                      
          , FIRST int-cc-benef                                                                                                     
            WHERE int-cc-benef.canal          = tt-migracao.cod-emitente                                                           
              AND int-cc-benef.tipo-beneficio = tt-migracao.tipo-beneficio                                                         
              AND int-cc-benef.unid-neg       = tt-migracao.unidade                                                                
              AND int-cc-benef.dt-periodo-ini = tt-migracao.dt-periodo-ini                                                         
              AND int-cc-benef.dt-periodo-fim = tt-migracao.dt-periodo-fim                                                         
              AND int-cc-benef.tp-movto  = 2 /* movimento (n∆o provis∆o) */                                                        
          BREAK BY tt-migracao.cod-emitente                                                                                        
                BY tt-migracao.tipo-beneficio                                                                                      
                BY tt-migracao.unidade                                                                                             
                BY tt-migracao.dt-periodo-ini                                                                                      
                BY tt-migracao.dt-periodo-fim:                                                                                     
                                                                                                                                   
          ASSIGN da-vl-empenho-total   = da-vl-empenho-total + tt-migracao.vl-empenho-a-transferir.                                
                                                                                                                                   
          IF  LAST-OF (tt-migracao.dt-periodo-fim) THEN DO:       

              FIND FIRST tit_ap NO-LOCK                                                                                            
                 WHERE tit_ap.cod_estab    = int-cc-benef.cod_estab                                                                
                  AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.                                                  
              FOR EACH val_tit_ap NO-LOCK OF tit_ap                                                                                
                  WHERE val_tit_ap.val_perc_rat > 0:                                                                               
                  CREATE b-tt-migracao.                                                                                            
                  BUFFER-COPY tt-migracao EXCEPT unidade vl-empenho-a-transferir                                                   
                                            TO b-tt-migracao.                                                                      
                                                                                                                                   
                  ASSIGN b-tt-migracao.unidade                 = val_tit_ap.cod_unid_negoc                                         
                         b-tt-migracao.vl-empenho-a-transferir = val_tit_ap.val_perc_rat * da-vl-empenho-total / 100               
                         b-tt-migracao.pai                     = NO
                         b-tt-migracao.r-int-cc-benef          = ROWID(int-cc-benef).                                                               
              END.                                                                                                                 
                                                                                                                                   
              ASSIGN da-vl-empenho-total = 0.                                                                                      
                                                                                                                                   
          END.                                                                                                                     
                                                                                                                                   
    END.                                                                                                                           
                                                                                                                                   
    RUN pi-exporta-migracao-fim.                                                                                                   
    
    RETURN "ok".
END.

PROCEDURE pi-buscar-beneficios:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.
    
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando Beneficios dos canais...").

    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.dt-periodo-ini = tt-param.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim = tt-param.dt-periodo-fim
          AND int-cc-benef.canal <> 4365
          AND int-cc-benef.id-status = 1 /*ativo*/
          AND int-cc-benef.tp-movto  = 2 /* movimento (n∆o provis∆o) */
          AND (int-cc-benef.tipo-beneficio = 37  OR /* Rebate           */ 
               int-cc-benef.tipo-beneficio = 66  OR /* Rebate P¢s-venda */ 
               int-cc-benef.tipo-beneficio = 21  OR /* VMC              */ 
               int-cc-benef.tipo-beneficio = 22  OR /* Stock Rotation   */ 
               int-cc-benef.tipo-beneficio = 08)    /* Price Protection */ 
        ,FIRST emitente FIELDS (nome-abrev) NO-LOCK 
             WHERE emitente.cod-emitente = int-cc-benef.canal
        , FIRST int-emitente
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK:
    
        RUN pi-retorna-saldo-disponivel.

        IF  tt-param.rs-tipo = 2 THEN DO:
            IF  NOT AVAIL tt-saldo
            OR  (AVAIL tt-saldo AND tt-saldo.verbaDisponivel > 0) THEN
                /* O CRM S‡ ZERA AUTOMATICAMENTE VIA PLANILHA DE AJUSTES, OS REBATES E VMC.  PRICE E STOCK ROTATION ESTE PROGRAMA SE ENCARREGA */
                IF  int-cc-benef.tipo-beneficio <> 22 AND int-cc-benef.tipo-beneficio <> 08 THEN DO:
                    RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                        INPUT "Alerta Conta Corrente ainda possui saldo. N∆o pode ser finalizada",
                                                        INPUT "Canal.....: " + string(int-cc-benef.canal)                             + CHR(10) +
                                                              "Unidade...: " + int-cc-benef.unid-neg                                  + CHR(10) +
                                                              "Benef°cio.: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio) + CHR(10) + CHR(10)
                                                              ).
            END.
        END.

        RUN pi-busca-beneficios-canal (INPUT int-cc-benef.unid-neg,
                                       INPUT int-cc-benef.tipo-beneficio).

        ASSIGN i-qt-contas-correntes = i-qt-contas-correntes + 1.

    END.

    IF  CAN-FIND (tt-erro) THEN 
        RETURN "NOK".

    ASSIGN p-ok = YES.
    RETURN "Ok".
END.

PROCEDURE pi-FINALIZA-CONTA-CORRENTE:

    /* --------------------------------------------------------------------------------- */
    /*            F I N A L I Z A Ä « O   D E   C O N T A S   C O R R E N T E S          */
    /*                                                                                   */
    /*      BENEF÷CIOS:  REBATE                                                          */
    /*                   REBATE P‡S-VENDAS                                               */
    /*                   VMC                                                             */
    /*                   STOCK ROTATION                                                  */
    /*                   PRICE PROTECTION                                                */
    /* --------------------------------------------------------------------------------- */
    
    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-acompanhar IN h-acomp (INPUT "Finalizando Contas Correntes do Trimestre...").

    FOR EACH int-cc-benef EXCLUSIVE-LOCK
        WHERE int-cc-benef.dt-periodo-ini = tt-param.dt-periodo-ini
          AND int-cc-benef.dt-periodo-fim = tt-param.dt-periodo-fim
          AND int-cc-benef.id-status = 1  /* ativo   */
          AND int-cc-benef.tp-movto  = 2  /* despesa */
          AND (int-cc-benef.tipo-beneficio = 37  OR /* Rebate           */ 
               int-cc-benef.tipo-beneficio = 66  OR /* Rebate P¢s-venda */ 
               int-cc-benef.tipo-beneficio = 21  OR /* VMC              */ 
               int-cc-benef.tipo-beneficio = 22  OR /* Stock Rotation   */ 
               int-cc-benef.tipo-beneficio = 08)    /* Price Protection */ 
        ,FIRST emitente FIELDS (nome-abrev) NO-LOCK 
             WHERE emitente.cod-emitente = int-cc-benef.canal
        , FIRST int-emitente
             WHERE int-emitente.cod-emitente = emitente.cod-emitente NO-LOCK:

            RUN pi-retorna-saldo-disponivel.
            
            /* ------------------------------------------ O F I C I A L -------------------------------------- */
            /*  ATUALIZA O STATUS DA CONTA PARA "FINALIZADA" E GRAVA O NOVO REGISTRO DE CONTA CORRENTE MIGRADO */
            IF  tt-param.rs-tipo = 2 THEN DO:
                                
                ASSIGN int-cc-benef.id-status = 2
                       i-cont-tit             = i-cont-tit + 1. 
                RUN PI-ZERA-SALDO-CONTA-FINAlIZADA (OUTPUT p-ok).

                IF  RETURN-VALUE <> "OK" OR NOT p-ok THEN  DO:
                    MESSAGE "Erro zerando saldo conta-corrente"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    RETURN "NOK".
                END.

                /* EFETIVA O REGISTRO DE CONTA CORRENTE DO NOVO TRIMESTRE */
                ASSIGN p-ok = NO.
            END.
            
            FIND FIRST tit_ap NO-LOCK
               WHERE tit_ap.cod_estab    = int-cc-benef.cod_estab
                AND tit_ap.num_id_tit_ap = int-cc-benef.num_id_tit_ap NO-ERROR.
            
            /* Listar Contas Encerradas */
            PUT STREAM exp1  (IF tt-param.rs-tipo = 1 THEN "PRêVIA" ELSE "OFICIAL")                       ";" 
                             int-cc-benef.canal                                                            ";"  
                             emitente.Nome-Abrev                                                           ";"
                             fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio)  FORMAT "x(20)"        ";"
                             int-cc-benef.unid-neg                                                         ";"
                             int-cc-benef.dt-periodo-ini                                                   ";"
                             int-cc-benef.dt-periodo-fim                                                   ";"
                             tt-saldo.verbaDisponivel                                                      ";"  
                             (IF AVAIL tit_ap THEN tit_ap.val_sdo_tit_ap ELSE 0)                           ";"  
                             (IF int-cc-benef.id-status = 2 THEN "FINALIZADA" ELSE "ATIVA") FORMAT "X(12)" SKIP.

    END.

    ASSIGN p-ok = YES.
    RETURN "OK".

END.

PROCEDURE pi-MIGRA-CONTA-CORRENTE:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR da-vl-empenho-total    LIKE int-cc-benef.VerbaCalculada NO-UNDO.
    DEF VAR da-vl-reembolso-total  LIKE int-cc-benef.VerbaCalculada NO-UNDO.
    DEF VAR da-vencto              AS DATE NO-UNDO.

    FOR EACH b-tt-migracao
        WHERE b-tt-migracao.unidade <> "ADM" 
          AND b-tt-migracao.cod-emitente <> 4365
         , FIRST int-cc-benef NO-LOCK
               WHERE ROWID(int-cc-benef) = b-tt-migracao.r-int-cc-benef 
          BREAK BY b-tt-migracao.cod-emitente
                BY b-tt-migracao.tipo-beneficio
                BY b-tt-migracao.unidade
                BY b-tt-migracao.dt-periodo-ini
                BY b-tt-migracao.dt-periodo-fim:

        ASSIGN da-vl-empenho-total   = da-vl-empenho-total + b-tt-migracao.vl-empenho-a-transferir.

        IF  LAST-OF (b-tt-migracao.dt-periodo-fim) THEN DO:
            /* REPLICA a conta corrente para o NOVO TRIMESTRE*/
            CREATE tt-migra-conta.
            BUFFER-COPY int-cc-benef            
                EXCEPT dt-periodo-ini           num_id_tit_ap           
                       dt-periodo-fim           vl-saldo-ori      
                       id-status                vl-saldo-anterior       
                       vl-base-calc             vl-saldo                
                       VerbaCalculada           vl-empenhado            
                       VerbaAcumulada           dt-transacao            
                       VerbaCancelada           dt-vencimento           
                       VerbaAjustada            usuario                 
                       VerbaPeriodoAnterior     unid-neg      
                TO tt-migra-conta .
        
            /* Define o novo per°odo */
            RUN pi-busca-proximo-trimestre (INPUT  int-cc-benef.dt-periodo-ini,
                                            OUTPUT da-proximo-periodo-ini,
                                            OUTPUT da-proximo-periodo-fim,
                                            OUTPUT da-vencto).
            ASSIGN tt-migra-conta.unid-neg             = b-tt-migracao.unidade
                   tt-migra-conta.dt-periodo-ini-ant   = int-cc-benef.dt-periodo-ini
                   tt-migra-conta.dt-periodo-fim-ant   = int-cc-benef.dt-periodo-fim
                   tt-migra-conta.dt-periodo-ini       = da-proximo-periodo-ini
                   tt-migra-conta.dt-periodo-fim       = da-proximo-periodo-fim
                   tt-migra-conta.tp-movto             = 2
                   tt-migra-conta.id-status            = 1
                   tt-migra-conta.dt-transacao         = TODAY
                   tt-migra-conta.dt-vencimento        = da-vencto
                   tt-migra-conta.usuario              = c-seg-usuario.
        
            /* ---------------------------------------------------------------------------------------------------- */
            /* VERBA TRASNFERIDA, TODO EMPENHO DAS SOLICITAÄÂES, DESCONTADO OS PAGAMENTOS ATUALIS "VALOR PAGO" E TB */ 
            /* O "VL-EMPENHO-PAGO", REALIZADO EM OUTROS TRIMESTRES                                                  */
            /* ---------------------------------------------------------------------------------------------------- */
            ASSIGN tt-migra-conta.VerbaPeriodoAnterior = da-vl-empenho-total.

            ASSIGN da-vl-empenho-total = 0.
        END.
    END.

    IF  tt-param.rs-tipo = 1 THEN
        RUN pi-lista-PREVIA-novas-contas.

    ASSIGN p-ok = YES.
    RETURN "OK".

END.


PROCEDURE PI-GRAVA-MIGRACAO:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    /* As solicitaá‰es devem ter a data de in°cio e fim alteradas para o novo trimestre */
    /* Deve ser criada Conta Corrente nova, cujo saldo Ç composto pelo valor de cada    */
    /* solicitaá∆o do canal/beneficio/unidade neg¢cio). Esse valor alimentar† o campo   */
    /* Verba Trasf Periodo Anterior.                                                    */
    DEF BUFFER b-solicitacao      FOR int-solicitacao.
    DEF BUFFER b-solicitacao-item FOR int-solicitacao-item.

    DEF VAR c-prefixo AS CHAR NO-UNDO.

    FIND FIRST tt-migracao NO-LOCK NO-ERROR.
    IF  NOT AVAIL tt-migracao THEN DO:
        ASSIGN p-ok = NO.
        RETURN "nok".
    END.

    RUN pi-retorna-trimestre-historico (INPUT tt-migracao.dt-periodo-fim,
                                        OUTPUT c-prefixo).
        
    FOR EACH tt-migracao
        WHERE tt-migracao.pai = YES:

        FIND int-solicitacao EXCLUSIVE-LOCK
            WHERE int-solicitacao.CodigoSolicitacaoBeneficio = tt-migracao.CodigoSolicitacaoBeneficio NO-ERROR.

        IF  NOT AVAIL int-solicitacao THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, 
                                                INPUT "Solicitaá∆o n∆o dispon°vel para atualizaá∆o ", 
                                                INPUT "C¢digo: " + tt-migracao.CodigoSolicitacaoBeneficio
                                                ).
            RETURN "NOK".
        END.

        /* Transfere a Solicitaá∆o para novo trimestre                                                                   */
        /* Para hist¢rio do que foi pago em cada trimetre, deve armazenar o valor aberto e tambÇm j† pago da solicitaá∆o */
        IF  tt-migracao.vl-empenho-a-transferir < 0  THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, 
                                                INPUT "Solicitaá∆o com valor pago maior que o solicitado", 
                                                INPUT "C¢digo...........: " + tt-migracao.CodigoSolicitacaoBeneficio                + CHR(10) +
                                                      "Unidade..........: " + tt-migracao.unidade                                   + CHR(10) +
                                                      "Benef°cio........: " + fn-retorna-nome-beneficio(tt-migracao.tipo-beneficio) + CHR(10) +
                                                      "Per°odo Ini......: " + string(tt-migracao.dt-periodo-ini,"99/99/9999")       + CHR(10) + 
                                                      "Per°odo fim......: " + string(tt-migracao.dt-periodo-fim,"99/99/9999")       + CHR(10) + 
                                                      "Valor Solicitado.: " + string(tt-migracao.valorSolicitado)).
            RETURN "NOK".
        END.

        /*-----------------------------------------------------------------------------------*/
        /* Cria c¢pia da solicitaá∆o para permanecer na conta corrente antiga como hist¢rico */
        /*-----------------------------------------------------------------------------------*/
        CREATE b-solicitacao.
        BUFFER-COPY int-solicitacao  EXCEPT CodigoSolicitacaoBeneficio TO b-solicitacao.

        ASSIGN b-solicitacao.CodigoSolicitacaoBeneficio = c-prefixo + int-solicitacao.CodigoSolicitacaoBeneficio .
               b-solicitacao.log-historica              = YES. /* Solicitaá∆o congelada (hist¢rico) */
        /*Fim hist¢rica*/

        ASSIGN int-solicitacao.dt-periodo-ini         = tt-migracao.dt-new-periodo-ini
               int-solicitacao.dt-periodo-fim         = tt-migracao.dt-new-periodo-fim
               int-solicitacao.vl-empenho-transferido = tt-migracao.vl-empenho-a-transferir     
               int-solicitacao.vl-empenho-pago        = 0
               int-solicitacao.ValorPago              = 0     
               int-solicitacao.Vl-Abatido-apb         = 0.

    END.

    ASSIGN p-ok = YES.
    RETURN "OK".

END.


PROCEDURE pi-retorna-saldo-disponivel:
    DEF VAR p-ok AS LOG NO-UNDO.

    RUN esp/esb/esesbapi010-saldo.p (INPUT ?, 
                                     INPUT ?, 
                                     INPUT ?, 
                                     INPUT ?, 
                                     INPUT ?, 
                                     INPUT rowid(int-cc-benef),
                                     INPUT ?,
                                     OUTPUT p-ok,
                                     OUTPUT TABLE tt-saldo,
                                     OUTPUT TABLE tt-erro-saldo).
    FIND FIRST tt-saldo NO-ERROR.
    IF  NOT AVAIL tt-saldo THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,                                                                      
                                            INPUT "N∆o encontrado saldo para a conta corrente",
                                            INPUT "Rowid: " + STRING(ROWID(int-cc-benef))).
        RETURN "NOK".
    END.

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

PROCEDURE pi-exporta-migracao:
    /* Lista as solicitaá‰es que ser∆o migradas */
    FOR EACH tt-migracao:
        PUT STREAM EXP2 (IF tt-param.rs-tipo = 1 THEN "PRêVIA" ELSE "OFICIAL")        ";" 
                        tt-migracao.CodigoSolicitacaoBeneficio                        ";"
                        tt-migracao.cod-emitente                                      ";"
                        tt-migracao.nome-abrev                                        ";"
                        fn-retorna-nome-beneficio(tt-migracao.tipo-beneficio)         ";"
                        tt-migracao.unidade                                           ";"
                        tt-migracao.dt-periodo-ini                                    ";"
                        tt-migracao.dt-periodo-fim                                    ";"
                        fn-retorna-situacao-beneficio(tt-migracao.situacao)           ";"
                        tt-migracao.desc-forma-pagto                                  ";"
                        tt-migracao.DataCriacao                                       ";"
                        tt-migracao.ValorSolicitado                                   ";"
                        tt-migracao.ValorPago                                         ";"
                        tt-migracao.vl-empenho-a-transferir FORMAT ">>>,>>>,>>9.9999" ";"
                        tt-migracao.dt-new-periodo-ini                                ";"              
                        tt-migracao.dt-new-periodo-fim SKIP.            
    END.
END.

PROCEDURE pi-exporta-migracao-fim:
    /* Lista as solicitaá‰es que ser∆o migradas */
    FOR EACH tt-migracao
        WHERE tt-migracao.pai = NO:
        PUT STREAM EXP10 (IF tt-param.rs-tipo = 1 THEN "PRêVIA" ELSE "OFICIAL")        ";" 
                           tt-migracao.CodigoSolicitacaoBeneficio                        ";"
                           tt-migracao.cod-emitente                                      ";"
                           tt-migracao.nome-abrev                                        ";"
                           fn-retorna-nome-beneficio(tt-migracao.tipo-beneficio)         ";"
                           tt-migracao.unidade                                           ";"
                           tt-migracao.dt-periodo-ini                                    ";"
                           tt-migracao.dt-periodo-fim                                    ";"
                           fn-retorna-situacao-beneficio(tt-migracao.situacao)           ";"
                           tt-migracao.desc-forma-pagto                                  ";"
                           tt-migracao.DataCriacao                                       ";"
                           tt-migracao.ValorSolicitado                                   ";"
                           tt-migracao.ValorPago                                         ";"
                           tt-migracao.vl-empenho-a-transferir FORMAT ">>>,>>>,>>9.9999" ";"
                           tt-migracao.dt-new-periodo-ini                                ";"              
                           tt-migracao.dt-new-periodo-fim SKIP.            
    END.
END.


PROCEDURE pi-lista-novas-contas:

    DEF VAR p-ok AS LOG NO-UNDO.

    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.id-status = 1:
    
        /* LISTAR AS NOVAS CONTAS CORRENTES CRIADAS */
        RUN esp/esb/esesbapi010-saldo.p (INPUT ?, 
                                         INPUT ?, 
                                         INPUT ?, 
                                         INPUT ?, 
                                         INPUT ?, 
                                         INPUT rowid(int-cc-benef),
                                         INPUT ?,
                                         OUTPUT p-ok,
                                         OUTPUT TABLE tt-saldo,
                                         OUTPUT TABLE tt-erro-saldo).
        FIND FIRST tt-saldo NO-ERROR.
        IF  NOT AVAIL tt-saldo THEN DO:
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,                                                                      
                                                INPUT "N∆o encontrado saldo para a conta corrente",
                                                INPUT "Rowid: " + STRING(ROWID(int-cc-benef))).
            RETURN "NOK".
        END.
    
        FOR FIRST b-emitente FIELDS (nome-abrev) NO-LOCK
            WHERE b-emitente.cod-emitente = int-cc-benef.canal:
        END.
    
        PUT STREAM exp3 (IF tt-param.rs-tipo = 1  THEN "PRêVIA" ELSE "OFICIAL")                 ";" 
                        int-cc-benef.canal                                                     ";"  
                        (IF AVAIL b-emitente THEN b-emitente.Nome-Abrev ELSE "")                ";"
                        fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio)  FORMAT "x(20)" ";"
                        int-cc-benef.unid-neg                                                  ";"
                        int-cc-benef.dt-periodo-ini                                            ";"
                        int-cc-benef.dt-periodo-fim                                            ";"
                        int-cc-benef.VerbaAcumulada                                            ";"  
                        tt-saldo.VerbaPeriodoAnterior                                           ";" 
                        tt-saldo.VerbaCalculada                                                 ";"  
                        tt-saldo.VerbaAjustada                                                  ";"  
                        tt-saldo.VerbaCancelada                                                 ";"  
                        tt-saldo.VerbaEmpenhadaTotal                                            ";"
                        tt-saldo.VerbaReembolsada                                               ";"
                        tt-saldo.VerbaDisponivel                                                ";"
                       (IF int-cc-benef.id-status = 2 THEN "FINALIZADA" ELSE "ATIVA") FORMAT "X(10)" SKIP.
    END.
END.



PROCEDURE pi-lista-PREVIA-novas-contas:

    DEF VAR da-vl-empenho-total       LIKE int-cc-benef.VerbaCalculada NO-UNDO.
    DEF VAR da-vl-reembolso-total     LIKE int-cc-benef.VerbaCalculada NO-UNDO.
    DEF VAR da-vl-solicitacoes-total  LIKE int-cc-benef.VerbaCalculada NO-UNDO.

    DEF VAR i AS INTEGER.

    ASSIGN da-vl-empenho-total = 0.

    FOR EACH tt-migra-conta
        ,FIRST emitente NO-LOCK
         WHERE emitente.cod-emitente = tt-migra-conta.canal:

        FOR EACH tt-migracao
            WHERE tt-migracao.cod-emitente      = tt-migra-conta.canal
              AND tt-migracao.tipo-beneficio    = tt-migra-conta.tipo-beneficio
              AND tt-migracao.unidade           = tt-migra-conta.unid-neg
              AND tt-migracao.dt-periodo-ini    = tt-migra-conta.dt-periodo-ini-ant
              AND tt-migracao.dt-periodo-fim    = tt-migra-conta.dt-periodo-fim-ant
              AND tt-migracao.unidade           <> "ADM":

              ASSIGN da-vl-solicitacoes-total = da-vl-solicitacoes-total + tt-migracao.vl-empenho-a-transferir.
        END.

        PUT STREAM exp3 "PRêVIA"                                                                   ";" 
                        tt-migra-conta.canal                                                       ";"  
                        (IF AVAIL emitente THEN emitente.Nome-Abrev ELSE "")                       ";"
                        fn-retorna-nome-beneficio(tt-migra-conta.tipo-beneficio)  FORMAT "x(20)"   ";"
                        tt-migra-conta.unid-neg                                                    ";"
                        tt-migra-conta.dt-periodo-ini                                              ";"
                        tt-migra-conta.dt-periodo-fim                                              ";"
                        tt-migra-conta.VerbaAcumulada                                              ";"  
                        tt-migra-conta.VerbaPeriodoAnterior                                        ";" 
                        tt-migra-conta.VerbaCalculada                                              ";"
                        tt-migra-conta.VerbaAjustada                                               ";"
                        tt-migra-conta.VerbaCancelada                                              ";"
                        da-vl-solicitacoes-total                                                   SKIP.

        ASSIGN da-vl-solicitacoes-total = 0.
    END.
END.


PROCEDURE PI-CRIA-SALDO-APB:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.
    DEF VAR i-cont AS INTEGER NO-UNDO.
    DEF VAR i AS INTEGER NO-UNDO.

    DEF BUFFER b-nova-cc FOR int-cc-benef.
    RUN pi-acompanhar IN h-acomp ("Verificando benef°cios dispon°veis...").

    /* Se for prÇvia, simplesmente sai do programa e n∆o integra com o Financeiro */
    IF  tt-param.rs-tipo = 1 THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.
    
    /* CRIAÄ«O T÷TULO PARA A CONTA NOVA, MIGRADA A PARTIR DAS SOLICITAÄÂES EM ABERTO */
    FOR EACH int-cc-benef NO-LOCK
         WHERE int-cc-benef.id-status = 1
           AND int-cc-benef.tp-movto  = 2
           AND int-cc-benef.dt-periodo-ini = da-proximo-periodo-ini
           AND int-cc-benef.dt-periodo-fim = da-proximo-periodo-fim
           /*AND int-cc-benef.canal = 137031*/
         , FIRST tt-beneficio  
                WHERE tt-beneficio.canal           = int-cc-benef.canal
                  AND tt-beneficio.unid-neg        = int-cc-benef.Unid-neg
                  AND tt-beneficio.tipo-beneficio  = int-cc-benef.tipo-beneficio:
        ASSIGN i-cont = i-cont + 1.
    END.

    /* CRIAÄ«O T÷TULO PARA A CONTA NOVA, MIGRADA A PARTIR DAS SOLICITAÄÂES EM ABERTO */
    FOR EACH int-cc-benef NO-LOCK
         WHERE int-cc-benef.id-status = 1
           AND int-cc-benef.tp-movto  = 2
           AND int-cc-benef.dt-periodo-ini = da-proximo-periodo-ini
           AND int-cc-benef.dt-periodo-fim = da-proximo-periodo-fim
          /*AND int-cc-benef.canal = 137031*/
         , FIRST tt-beneficio  
                WHERE tt-beneficio.canal           = int-cc-benef.canal
                  AND tt-beneficio.unid-neg        = int-cc-benef.Unid-neg
                  AND tt-beneficio.tipo-beneficio  = int-cc-benef.tipo-beneficio:

         /* GERA T÷TULO PARA REBATE, REBATE P‡S-VENDA, VMC E PRICE PROTECTION.  N«O GERA DESPESA PARA STOCK ROTATION*/
/*          IF  int-cc-benef.tipo-beneficio <> 22 THEN DO:                                                                                            */
/*                                                                                                                                                    */
/*              IF  NOT VALID-HANDLE(h-esesb003-apb) THEN                                                                                             */
/*                  RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.                                                                      */
/*                                                                                                                                                    */
/*              ASSIGN i = i + 1.                                                                                                                     */
/*                                                                                                                                                    */
/*              RUN pi-acompanhar IN h-acomp ("Integrando T°tulo: " + STRING(i) + " de " + string(i-cont) + " ...").                                  */
/*              RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),                                                             */
/*                                                             INPUT (int-cc-benef.VerbaPeriodoAnterior ),                                            */
/*                                                             INPUT NO,                                                                              */
/*                                                             INPUT TODAY,                                                                           */
/*                                                             INPUT int-cc-benef.dt-periodo-fim,                                                     */
/*                                                             INPUT NO, /*n∆o Ç tratado como desconto em duplicata*/                                 */
/*                                                             INPUT TABLE tt-beneficio,                                                              */
/*                                                             OUTPUT TABLE tt-erro-apb).                                                             */
/*               IF  CAN-FIND (FIRST tt-erro-apb)                                                                                                     */
/*               OR  RETURN-VALUE <> "OK" THEN DO:                                                                                                    */
/*                   DEF VAR l-erro AS LOG NO-UNDO.                                                                                                   */
/*                   FOR EACH tt-erro-apb:                                                                                                            */
/*                       RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,                                                                             */
/*                                                           INPUT "CRIANDO SALDO: " + tt-erro-apb.mensagem,                                          */
/*                                                           INPUT "Canal: " + STRING(int-cc-benef.canal)                                 + CHR(10) + */
/*                                                                 "Beneficio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio) + CHR(10) + */
/*                                                                 "Unidade: " + STRING(int-cc-benef.unid-neg) + CHR(10) +                            */
/*                                                                 tt-erro-apb.mensagem                                                               */
/*                                                           ).                                                                                       */
/*                       l-erro = YES.                                                                                                                */
/*                   END.                                                                                                                             */
/*                                                                                                                                                    */
/*                   IF  NOT l-erro THEN DO:                                                                                                          */
/*                       RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,                                                                             */
/*                                                           INPUT "CRIANDO SALDO: Retorno com erro, mas n∆o retornou descriá∆o do mesmo.",           */
/*                                                           INPUT "Canal: " + STRING(int-cc-benef.canal)                                 + CHR(10) + */
/*                                                                 "Beneficio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio) + CHR(10) + */
/*                                                                 "Unidade: " + STRING(int-cc-benef.unid-neg) ).                                     */
/*                   END.                                                                                                                             */
/*                                                                                                                                                    */
/*                   IF  VALID-HANDLE(h-esesb003-apb) THEN                                                                                            */
/*                       DELETE PROCEDURE h-esesb003-apb.                                                                                             */
/*                                                                                                                                                    */
/*                   RETURN "NOK".                                                                                                                    */
/*               END.                                                                                                                                 */
/*                                                                                                                                                    */
/*               IF  VALID-HANDLE(h-esesb003-apb) THEN                                                                                                */
/*                   DELETE PROCEDURE h-esesb003-apb.                                                                                                 */
/*                                                                                                                                                    */
/*                                                                                                                                                    */
/*          END.                                                                                                                                      */

    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

/*-------------------------------------------------------------------*/
/*        B U S C A R   B E N E F ÷ C I O S   D O   C A N A L        */
/*-------------------------------------------------------------------*/

PROCEDURE pi-busca-beneficios-canal:
    /*------------------------------------------------------------------------------*/
    /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */
    /*------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-unid-neg       AS CHAR NO-UNDO.
    DEF INPUT PARAM p-tipo-beneficio AS INT  NO-UNDO.

    DEFINE VARIABLE i-status    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-categoria AS CHARACTER NO-UNDO.
    
    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio-aux.

    FOR FIRST int-class-canal FIELDS (nome)
        WHERE int-class-canal.codigo-classificacao = int-emitente.guid-class:
    END.

    IF  NOT AVAIL int-class-canal THEN
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Benef°cios do Canal - Classificaá∆o Canal inexistente no EMS." , 
                                            INPUT "C¢digo Canal EMS...: " + string(int-emitente.cod-emitente) + CHR(10) + 
                                                  "C¢digo Canal CRM...: " + int-emitente.cod-guid    + CHR(10) +  
                                                  "Classificaá∆o CRM..: " + int-emitente.guid-class).
        
    FOR FIRST int-benef-canal NO-LOCK
        WHERE int-benef-canal.CodigoConta          = int-emitente.cod-guid
          AND int-benef-canal.BeneficioCodigo      = p-tipo-beneficio
          AND int-benef-canal.CodigoUnidadeNegocio = p-unid-neg :
    END.

    IF  NOT AVAIL int-benef-canal THEN DO:
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Benef°cios do Canal n∆o existente " ,
                                            INPUT "C¢digo Canal EMS....: " + string(int-emitente.cod-emitente)       + CHR(10) +
                                                  "C¢digo Canal CRM....: " + int-emitente.cod-guid                   + CHR(10) +
                                                  "Benef°cio...........: " + fn-retorna-nome-beneficio(p-tipo-beneficio)  + CHR(10) +  
                                                  "Unidade.............: " + p-unid-neg).
        RETURN "NOK".
    END.

    /* STATUS DO BENEF÷CIO ê CONVERTIDO APENAS AQUI */
    CASE int-benef-canal.NomeStatusBeneficio:
        WHEN "ATIVO"     THEN ASSIGN i-status = 1.
        WHEN "BLOQUEADO" THEN ASSIGN i-status = 2.
        WHEN "SUSPENSO"  THEN ASSIGN i-status = 3.
        OTHERWISE ASSIGN i-status = ?.
    END CASE.

    /* CASO E STATUS N«O TENHA SIDO INFORMADO NO CRM, ASSUMIMOS QUE ESTµ SUSPENSO */
    IF  i-status = ? THEN
        ASSIGN i-status = 3.

    /* TIPO DA CATEGORIA, INDICANDO SE ê OURO/BRATA/BRONZE/DISTRIBUIDOR */
    CASE int-benef-canal.CategoriaCodigo:
        WHEN 1  THEN ASSIGN c-categoria = "OURO".
        WHEN 2  THEN ASSIGN c-categoria = "PRATA".
        WHEN 3  THEN ASSIGN c-categoria = "BRONZE".
        WHEN 5  THEN ASSIGN c-categoria = "DISTRIBUIDOR".
        WHEN 14 THEN ASSIGN c-categoria = "REVENDA SOLUCOES".
        WHEN 15 THEN ASSIGN c-categoria = "PROVEDORES".
        OTHERWISE ASSIGN c-categoria = ?.
    END CASE.

    IF  c-categoria = ? THEN 
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "Benef°cios do Canal - Categoria do benef°cio n∆o existe no EMS. " ,
                                            INPUT "C¢digo Canal EMS....: " + string(int-emitente.cod-emitente)        + CHR(10) +
                                                  "C¢digo Canal CRM....: " + int-emitente.cod-guid                    + CHR(10) +
                                                  "Cod Categoria CRM...: " + string(int-benef-canal.CategoriaCodigo)  + CHR(10) +  
                                                  "Nome Categoria......: " + int-benef-canal.NomeCategoria).

    CREATE tt-beneficio-aux.
    ASSIGN tt-beneficio-aux.canal                = int-emitente.cod-emitente
           tt-beneficio-aux.guid-canal           = int-emitente.cod-guid
           tt-beneficio-aux.unid-neg             = int-benef-canal.CodigoUnidadeNegocio
           tt-beneficio-aux.guid-categoria       = int-benef-canal.CodigoCategoria    
           tt-beneficio-aux.guid-beneficio       = int-benef-canal.CodigoBeneficio
           tt-beneficio-aux.guid-beneficio-canal = int-benef-canal.CodigoBeneficioCanal
           tt-beneficio-aux.tipo-beneficio       = int-benef-canal.BeneficioCodigo
           tt-beneficio-aux.tipo-categoria       = c-categoria
           tt-beneficio-aux.guid-class           = int-emitente.guid-class 
           tt-beneficio-aux.nome-class           = int-class-canal.nome
           tt-beneficio-aux.exclusividade        = int-emitente.exclusividade
           tt-beneficio-aux.id-status            = i-status         
           tt-beneficio-aux.calcula-verba        = int-benef-canal.CalcularVerba.
    
    IF  int-benef-canal.CodigoUnidadeNegocio <> "ADM" THEN DO:
        FIND LAST int-benef-canal-perc NO-LOCK
            WHERE int-benef-canal-perc.CodigoClassificacao  = int-emitente.guid-class
              AND int-benef-canal-perc.CodigoCategoria      = int-benef-canal.CodigoCategoria
              AND int-benef-canal-perc.CodigoBeneficio      = int-benef-canal.CodigoBeneficio
              AND int-benef-canal-perc.TipoParametroGlobal  = int-benef-canal.BeneficioCodigo
              AND int-benef-canal-perc.CodigoUnidadeNegocio = int-benef-canal.CodigoUnidadeNegocio NO-ERROR.

        IF  NOT AVAIL int-benef-canal-perc
        OR  (AVAIL int-benef-canal-perc AND dec(int-benef-canal-perc.ValorParametroGlobal) <= 0) THEN DO:
        
            RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                                INPUT "PAR∂METRO GLOBAL inexistente ou com valor percentual zero" ,
                                                INPUT "Canal EMS..........: " + string(int-emitente.cod-emitente)    + CHR(10) +
                                                      "C¢digo Canal CRM...: " + int-emitente.cod-guid                + CHR(10) +
                                                      "Classificacao CRM..: " + int-emitente.guid-clas               + CHR(10) +
                                                      "Categoria CRM......: " + int-benef-canal.CodigoCategoria      + CHR(10) +
                                                      "Unidade de Neg¢cio.: " + int-benef-canal.CodigoUnidadeNegocio + CHR(10) +
                                                      "Beneficio CRM......: " + int-benef-canal.CodigoBeneficio      + CHR(10) + CHR(10)
                                                      ).
            RETURN "NOK".
        END.

        ASSIGN tt-beneficio-aux.perc-global = dec(int-benef-canal-perc.ValorParametroGlobal).
    END.

    FOR FIRST int-benef-parametro NO-LOCK
         WHERE int-benef-parametro.CodigoBeneficio      = tt-beneficio-aux.guid-beneficio
           AND int-benef-parametro.CodigoUnidadeNegocio = tt-beneficio-aux.unid-neg:

        ASSIGN tt-beneficio-aux.conta          = int-benef-parametro.ContaContabil                
               tt-beneficio-aux.centro-custo   = int-benef-parametro.CentroCusto                  
               tt-beneficio-aux.cod-estabel    = string(int-benef-parametro.CodigoEstabelecimento)
               tt-beneficio-aux.cod-especie    = int-benef-parametro.EspecieDocumento             
               tt-beneficio-aux.tipo-fluxo     = int-benef-parametro.TipoFluxoFinanceiro          
               tt-beneficio-aux.perc-custo     = int-benef-parametro.PercentualCusto              
               tt-beneficio-aux.perc-prov-meta = int-benef-parametro.PercentualAtingimentoMeta.   
    END.

    IF  NOT AVAIL int-benef-parametro THEN 
        RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006, /* Erro */
                                            INPUT "PAR∂METRO BENEF÷CIO. N∆o existem parÉmetros cadastrados para este benef°cio. " ,
                                            INPUT "Canal EMS..........: " + string(int-emitente.cod-emitente)                        + CHR(10) +
                                                  "C¢digo Canal CRM...: " + int-emitente.cod-guid                                    + CHR(10) +
                                                  "Benef°cio CRM......: " + string(tt-beneficio-aux.guid-beneficio)                  + CHR(10) +  
                                                  "Unidade............: " + tt-beneficio-aux.unid-neg                                + CHR(10) +  
                                                  "Nome Benef°cio.....: " + fn-retorna-nome-beneficio (tt-beneficio-aux.tipo-beneficio)).
    CREATE tt-beneficio.
    BUFFER-COPY tt-beneficio-aux TO tt-beneficio.
    
    RETURN "OK".
END.


PROCEDURE PI-ZERA-SALDO-CONTA-FINAlIZADA:

    DEF OUTPUT PARAM p-ok AS LOG INIT NO NO-UNDO.

    DEF VAR h-esesb003-apb AS HANDLE NO-UNDO.

    /* N«O POSSUI T÷TULO DE STOCK ROTATION */
    IF  int-cc-benef.tipo-beneficio = 22 THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.

    IF  NOT CAN-FIND (FIRST tit_ap 
                         WHERE tit_ap.cod_estab     = int-cc-benef.cod_estab
                          AND tit_ap.num_id_tit_ap  = int-cc-benef.num_id_tit_ap
                          AND tit_ap.val_sdo_tit_ap > 0) THEN DO:
        ASSIGN p-ok = YES.
        RETURN "OK".
    END.
            
    FIND FIRST tt-beneficio  
         WHERE tt-beneficio.canal           = int-cc-benef.canal
           AND tt-beneficio.unid-neg        = int-cc-benef.Unid-neg
           AND tt-beneficio.tipo-beneficio  = int-cc-benef.tipo-beneficio NO-ERROR.

    IF  NOT VALID-HANDLE(h-esesb003-apb) THEN
        RUN esp/esb/esesbapi003-apb.p PERSISTENT SET h-esesb003-apb.

    RUN pi-acompanhar IN h-acomp ("Zerando T°tulo finalizado: " + string(i-cont-tit) + " de " + STRING(i-qt-contas-correntes)).
    RUN pi-Integra-Despesas-APB IN h-esesb003-apb (INPUT ROWID(int-cc-benef),
                                                   INPUT 0,  /* ZERAR SALDO */
                                                   INPUT YES,
                                                   INPUT TODAY,
                                                   INPUT int-cc-benef.dt-periodo-fim,
                                                   INPUT NO, /*n∆o Ç tratado como desconto em duplicata*/
                                                   INPUT TABLE tt-beneficio,
                                                   OUTPUT TABLE tt-erro-apb).
     IF  CAN-FIND (FIRST tt-erro-apb)
     OR  RETURN-VALUE <> "OK" THEN DO:
         DEF VAR l-erro AS LOG NO-UNDO.
         FOR EACH tt-erro-apb:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "ZERANDO SALDO: " + tt-erro-apb.mensagem,
                                                 INPUT "Canal: " + STRING(int-cc-benef.canal)                                 + CHR(10) +
                                                       "Beneficio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio) + CHR(10) +
                                                       "Unidade: " + STRING(int-cc-benef.unid-neg) + CHR(10) +
                                                       tt-erro-apb.mensagem
                                                 ).
             l-erro = YES.
         END.

         IF  NOT l-erro THEN DO:
             RUN pi-cria-erro IN THIS-PROCEDURE (INPUT 17006,
                                                 INPUT "ZERANDO SALDO: Retorno com erro, mas n∆o retornou descriá∆o do mesmo.",
                                                 INPUT "Canal: " + STRING(int-cc-benef.canal)                                 + CHR(10) +
                                                       "Beneficio: " + fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio) + CHR(10) +
                                                       "Unidade: " + STRING(int-cc-benef.unid-neg) ).
         END.

         IF  VALID-HANDLE(h-esesb003-apb) THEN
             DELETE PROCEDURE h-esesb003-apb.

         RETURN "NOK".
     END.

     IF  VALID-HANDLE(h-esesb003-apb) THEN
         DELETE PROCEDURE h-esesb003-apb.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.


PROCEDURE pi-busca-proximo-trimestre:

    DEF INPUT  PARAM p-data-atual    AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-prox-trim-ini AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-prox-trim-fim AS DATE NO-UNDO.
    DEF OUTPUT PARAM p-dt-vencto     AS DATE NO-UNDO.



    CASE MONTH(p-data-atual):
        WHEN 1 THEN 
            ASSIGN p-prox-trim-ini = DATE(04,01,YEAR(p-data-atual))
                   p-prox-trim-fim = DATE(06,30,YEAR(p-data-atual))
                   p-dt-vencto     = DATE(09,30,YEAR(p-data-atual)).
        WHEN 4 THEN
            ASSIGN p-prox-trim-ini = DATE(07,01,YEAR(p-data-atual))
                   p-prox-trim-fim = DATE(09,30,YEAR(p-data-atual))
                   p-dt-vencto     = DATE(12,31,YEAR(p-data-atual)).
        WHEN 7 THEN
            ASSIGN p-prox-trim-ini = DATE(10,01,YEAR(p-data-atual))
                   p-prox-trim-fim = DATE(12,31,YEAR(p-data-atual))
                   p-dt-vencto     = DATE(03,31,YEAR(p-data-atual)).
        WHEN 10 THEN
            ASSIGN p-prox-trim-ini = DATE(01,01,YEAR(p-data-atual) + 1)
                   p-prox-trim-fim = DATE(03,31,YEAR(p-data-atual) + 1)
                   p-dt-vencto     = DATE(06,30,YEAR(p-data-atual)).
    END CASE.

    RETURN "OK".
END.

PROCEDURE pi-zera-saldo-contas-correntes:

    DEF OUTPUT PARAM p-ok AS LOG INIT YES NO-UNDO.
    
    bloco:
    DO TRANS: 
    
        FOR EACH int-cc-benef EXCLUSIVE-LOCK
            WHERE int-cc-benef.id-status      = 1  /*Ativa*/
              AND int-cc-benef.tp-movto       = 2: /*Despesa*/
              
              IF  int-cc-benef.tipo-beneficio = 22 OR int-cc-benef.tipo-beneficio = 8  THEN
                  NEXT.
    
              RUN esp/esb/esesbapi010-saldo.p (INPUT int-cc-benef.canal,
                                               INPUT int-cc-benef.tipo-beneficio,
                                               INPUT int-cc-benef.unid-neg,
                                               INPUT int-cc-benef.dt-periodo-ini,
                                               INPUT int-cc-benef.dt-periodo-fim,
                                               INPUT ?,
                                               INPUT ?,
                                               OUTPUT l-ok,
                                               OUTPUT TABLE tt-saldo,
                                               OUTPUT TABLE tt-erro-saldo).
    
              FIND FIRST tt-saldo NO-ERROR.
    
              IF  AVAIL tt-saldo AND tt-saldo.VerbaDisponivel > 0 THEN DO:
                  ASSIGN int-cc-benef.VerbaCancelada   = int-cc-benef.VerbaCancelada + tt-saldo.VerbaDisponivel
                         int-cc-benef.dec-1            = tt-saldo.VerbaDisponivel   /*Hist¢rico para saber o quanto foi ajustado.*/
                         tt-saldo.VerbaCancelada       = int-cc-benef.VerbaCancelada
                         tt-saldo.VerbaDisponivel = 0.
              END.
    
              IF  NOT l-ok THEN DO:
                  IF  NOT CAN-FIND(tt-erro-saldo) THEN DO:
                      PUT SKIP(1).
                      PUT UNFORMATTED "N∆o Foi poss°vel retornar o saldo. "                    + CHR(10) + 
                                      " Canal........: " + STRING(int-cc-benef.canal)          + CHR(10) +
                                      " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio) + CHR(10) +
                                      " Unidade......: " + int-cc-benef.unid-neg               + CHR(10) +
                                      " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini) + CHR(10) +
                                      " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim) + CHR(10).
                      ASSIGN p-ok = NO.
                      NEXT.                    
                  END.
                  ELSE DO:
                      FOR EACH tt-erro-saldo:
                          PUT SKIP(1).
                          PUT UNFORMATTED tt-erro-saldo.mensagem                                   + CHR(10) + 
                                          tt-erro-saldo.ajuda                                      + CHR(10) + 
                                          " Canal........: " + STRING(int-cc-benef.canal)          + CHR(10) +
                                          " Benef°cio....: " + STRING(int-cc-benef.tipo-beneficio) + CHR(10) +
                                          " Unidade......: " + int-cc-benef.unid-neg               + CHR(10) +
                                          " Per°odo Ini..: " + STRING(int-cc-benef.dt-periodo-ini) + CHR(10) +
                                          " Per°odo Fim..: " + STRING(int-cc-benef.dt-periodo-fim) + CHR(10).
                          ASSIGN p-ok = NO.
                      END.
                  END.
                  NEXT.
              END.
              
              FIND FIRST tt-saldo.
              IF  AVAIL tt-saldo THEN DO:
                  CREATE b-tt-saldo.
                  BUFFER-COPY tt-saldo TO b-tt-saldo.
              END.
        
        END.

        IF  NOT p-ok THEN DO:
            UNDO bloco, RETURN "NOK".
        END.
        
        IF  CAN-FIND (FIRST b-tt-saldo) THEN DO:

            DEF VAR i-max-atingido AS INTEGER INIT 0 NO-UNDO. 
            DEF VAR i-max          AS INTEGER INIT 0 NO-UNDO. 
            DEF VAR nr-saldos     AS INTEGER INIT 0 NO-UNDO.

            FOR EACH b-tt-saldo:
                nr-saldos = nr-saldos + 1.
            END.

            FOR EACH b-tt-saldo:                                                                        
                                                                                                        
                ASSIGN i-max = i-max + 1
                       i-max-atingido = i-max-atingido + 1.
                CREATE msg0159-BeneficioCanalItem.                                                      
                ASSIGN msg0159-BeneficioCanalItem.CodigoBeneficioCanal  = b-tt-saldo.CodigoBeneficioCana
                       msg0159-BeneficioCanalItem.VerbaCalculada        = b-tt-saldo.VerbaCalculada     
                       msg0159-BeneficioCanalItem.VerbaPeriodoAnterior  = b-tt-saldo.VerbaPeriodoAnterio
                       msg0159-BeneficioCanalItem.VerbaTotal            = b-tt-saldo.VerbaTotal         
                       msg0159-BeneficioCanalItem.VerbaEmpenhada        = b-tt-saldo.VerbaEmpenhadaTotal
                       msg0159-BeneficioCanalItem.VerbaReembolsada      = b-tt-saldo.VerbaReembolsada   
                       msg0159-BeneficioCanalItem.VerbaCancelada        = b-tt-saldo.VerbaCancelada     
                       msg0159-BeneficioCanalItem.VerbaAjustada         = b-tt-saldo.VerbaAjustada      
                       msg0159-BeneficioCanalItem.VerbaDisponivel       = b-tt-saldo.VerbaDisponivel.   
                                                                                                        
                IF  i-max = 100 OR i-max-atingido = nr-saldos THEN DO:
                    CREATE msg0159.                                                                         
                    CREATE msg0159-BeneficioCanalItens.                                                     

                    RUN esp/esb/out/msg0159.p (INPUT  TABLE msg0159,                                        
                                               INPUT  TABLE msg0159-BeneficioCanalItens,                    
                                               INPUT  TABLE msg0159-BeneficioCanalItem,                     
                                               OUTPUT TABLE resultado).                                     
                                                                                                            
                    RUN pi-result (INPUT "msg0159").                                                        
                    EMPTY TEMP-TABLE msg0159.                                                               
                    EMPTY TEMP-TABLE msg0159-BeneficioCanalItens.                                           
                    EMPTY TEMP-TABLE msg0159-BeneficioCanalItem.      

                    ASSIGN i-max = 0.
                END.
                                                                                                        
            END.                                                                                        

        END.
    
    END.

    ASSIGN p-ok = YES.
    RETURN "OK".
END.

PROCEDURE pi-result:

    DEFINE INPUT PARAM c-msg AS CHAR.

    FIND FIRST resultado NO-ERROR.

    PUT UNFORMATTED c-msg.
    IF AVAIL resultado THEN
        PUT UNFORMATTED " " + resultado.mensagem SKIP.
    ELSE 
        PUT UNFORMATTED " sem Resultado" SKIP.

END.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
        WHEN 08 THEN RETURN "PRICE PROTECTION".
    END CASE.

    RETURN "".
END FUNCTION.

FUNCTION fn-retorna-situacao-beneficio RETURNS CHAR
    (p-situacao AS INT):
    
    CASE p-situacao:
        WHEN 993520006 THEN RETURN "CANCELADA".
        WHEN 993520003 THEN RETURN "PENDENTE".
        WHEN 993520004 THEN RETURN "PAGA".
        OTHERWISE           RETURN "EM ANµLISE".
    END CASE.

    RETURN "".
END FUNCTION.


