/*---------------------------------------------------------------------------------------*/
/*  Programa: esp/esb/esesbapi006-export.p                                               */
/*  Objetivo: Exportar a mem¢ria de c culo da conta corrente para consulta ou envio ao   */
/*            cliente (canal)                                                            */
/*---------------------------------------------------------------------------------------*/

DEF VAR c-arquivo AS CHAR FORMAT "x(200)" NO-UNDO.
DEF VAR c-label   AS CHAR FORMAT "x(500)" NO-UNDO.

/*----------------  ROTINA DE ENVIO DE EMAIL --------------*/
define temp-table tt-envio
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes.

define temp-table tt-envio2
    field versao-integracao   as integer format ">>9"
    field servidor            as char
    field porta               as integer init 0
    field exchange            as logical init no
    field destino             as char
    field copia               as char
    field remetente           as char
    field assunto             as char
    field mensagem            as char
    field arq-anexo           as char
    field importancia         as integer init 0
    field log-enviada         as logical
    field log-lida            as logical
    field acomp               as logical init yes    
    field formato             as char init "texto".

DEFINE TEMP-TABLE tt-mensagem1
    FIELD seq-mensagem        AS INTEGER
    FIELD mensagem            AS CHAR
    INDEX i-seq-mensagem
          seq-mensagem        ASCENDING.

define temp-table tt-erros-1
    field cod-erro  as integer
    field desc-erro as character format "x(256)"
    field desc-arq  as character.


DEFINE TEMP-TABLE tt-canal-email NO-UNDO
    FIELD canal        AS INTEGER 
    FIELD nome-arquivo AS CHAR FORMAT "X(100)".

DEF TEMP-TABLE tt-fat-mensal-det NO-UNDO LIKE int-fat-mensal-det.
DEF TEMP-TABLE tt-fat-mensal     NO-UNDO LIKE int-fat-mensal.

/*---------------------------------------------------------*/
DEF STREAM s-1.

/*-----------------------------------------------*/
DEF INPUT PARAM p-arquivo-unico AS LOG NO-UNDO.
DEF INPUT PARAM p-envia-email   AS LOG NO-UNDO.
DEF INPUT PARAM p-canal-ini     AS INTEGER NO-UNDO.
DEF INPUT PARAM p-canal-fim     AS INTEGER NO-UNDO.
/*-----------------------------------------------*/

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

DEF VAR l-possui-faturamento AS LOG NO-UNDO.

RUN pi-memoria-calculo.

IF  p-arquivo-unico THEN
    DOS SILENT START excel VALUE(c-arquivo).

IF  p-envia-email THEN
    RUN pi-envia-mail.


RETURN "OK".
/*FIM*/

PROCEDURE pi-memoria-calculo:

    DEF VAR de-base-apur AS DEC NO-UNDO.
    DEF VAR de-base-fat  AS DEC NO-UNDO.
    DEF VAR de-base-dev  AS DEC NO-UNDO.
    
    ASSIGN /*Dados da conta corrente*/
           c-label = "Canal;Unidade;Per¡do Ini;Per¡odo Fim;Beneficio;% Beneficio;Classific;Categoria;Saldo Orig;Saldo Anterior;Saldo Atual;Transa‡Æo;Vencimento;Base Calc.Apura‡Æo;"
           /*Dados nota do faturamento*/
           c-label = c-label + "Mˆs;Tp.Movto;Base Faturamento;Base Devolu‡äes;Base Apurada;Estab;S‚rie;Nr.Nota;Nr.Seq.;ITEM;Qtde Fat.;Valor Faturado;Data EmissÆo;"
           /*Dados da devolu‡Æo*/
           c-label = c-label + "S‚rie Dev;Nr Nota Dev;Emitente Dev;Nat.Oper;Seq;Qtde.Dev;Val.Dev;Data Dev".
    /* Arquivo Gen‚rico contendo todos os canais */
    IF  p-arquivo-unico THEN  DO:
        ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "calc_benef_canais_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
        OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".
        PUT STREAM s-1 c-label SKIP.
    END.
    
    FOR EACH int-cc-benef NO-LOCK
        WHERE int-cc-benef.tp-movto = 2
          AND int-cc-benef.canal     >= p-canal-ini
          AND int-cc-benef.canal     <= p-canal-fim
          AND int-cc-benef.id-status = 1 /* CONTA ATIVA*/ 
          
        , FIRST emitente
            WHERE emitente.cod-emitente = int-cc-benef.canal NO-LOCK
        , FIRST int-class-canal NO-LOCK
            WHERE int-class-canal.codigo-classificacao = int-cc-benef.classificacao
        BREAK BY int-cc-benef.canal
              BY int-cc-benef.unid-neg
              BY int-cc-benef.tipo-beneficio 
              BY int-cc-benef.dt-periodo-ini
              BY int-cc-benef.dt-periodo-fim:

        IF  FIRST-OF (int-cc-benef.canal) THEN DO:
           /* Gera 1 arquivo por canal */
           IF  NOT p-arquivo-unico  THEN DO:

               ASSIGN c-arquivo = STRING(SESSION:TEMP-DIRECTORY) + "calc_benef_canal_cgc_" + emitente.cgc + "_" + STRING(TODAY, "99-99-9999") + "_"+ STRING(TIME) + ".csv".
               OUTPUT STREAM s-1 TO value(c-arquivo) CONVERT TARGET "iso8859-1".
               PUT STREAM s-1 c-label SKIP.

               CREATE tt-canal-email.
               ASSIGN tt-canal-email.canal         = int-cc-benef.canal
                      tt-canal-email.nome-arquivo  = c-arquivo.

           END.
        END.
        
        /* Busca os faturamentos para exporta para arquivo */
        RUN pi-busca-faturamentos.

        IF  LAST-OF(int-cc-benef.canal)
        AND NOT p-arquivo-unico 
        THEN
            OUTPUT STREAM s-1 CLOSE. 

    END.

    IF  p-arquivo-unico THEN
        OUTPUT STREAM s-1 CLOSE. 

END.


PROCEDURE pi-busca-faturamentos:

   ASSIGN l-possui-faturamento = NO.

   FOR EACH int-fat-mensal NO-LOCK
       WHERE int-fat-mensal.canal     =  int-cc-benef.canal            
         AND int-fat-mensal.ano       =  YEAR(int-cc-benef.dt-periodo-fim)
         AND int-fat-mensal.mes      >= MONTH(int-cc-benef.dt-periodo-ini)
         AND int-fat-mensal.mes      <= MONTH(int-cc-benef.dt-periodo-fim)
         AND int-fat-mensal.unid-neg = int-cc-benef.unid-neg       
    , EACH int-fat-mensal-det NO-LOCK
       WHERE int-fat-mensal-det.canal-central = int-fat-mensal.canal
         AND int-fat-mensal-det.ano           = int-fat-mensal.ano 
         AND int-fat-mensal-det.mes           = int-fat-mensal.mes
         AND int-fat-mensal-det.unid-neg      = int-fat-mensal.unid-neg
             BREAK BY int-fat-mensal.canal      
                   BY int-fat-mensal.ano 
                   BY int-fat-mensal.mes
                   BY int-fat-mensal.unid-neg:
       
        EXPORT STREAM s-1 DELIMITER ";"  
              int-cc-benef.canal         
              upper(int-cc-benef.unid-neg)
              int-cc-benef.dt-periodo-ini
              int-cc-benef.dt-periodo-fim
              fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio)
              int-cc-benef.perc-benef
              int-class-canal.nome
              int-cc-benef.categoria
              int-cc-benef.vl-saldo-ori   
              int-cc-benef.vl-saldo-anterior    
              int-cc-benef.vl-saldo
              int-cc-benef.dt-transacao  
              int-cc-benef.dt-vencimento
              int-cc-benef.vl-base-calc
              int-fat-mensal.mes
              IF  int-fat-mensal-det.tp-movto = 1 THEN "Faturamento" ELSE "Devolu‡Æo"
              /*----------------------------------*/
              /*  Faturamentos/Devolu‡äes mensais */
              /*----------------------------------*/
              int-fat-mensal.vl-faturado  
              int-fat-mensal.vl-devolvido 
              int-fat-mensal.vl-apurado   
              /*----------------------------------*/
              /*  Detalhes do faturamento Mensal  */  
              /*----------------------------------*/
              
              int-fat-mensal-det.cod-estabel     
              int-fat-mensal-det.serie      
              int-fat-mensal-det.nr-nota-fis
              int-fat-mensal-det.nr-seq-fat 
              int-fat-mensal-det.it-codigo  
              int-fat-mensal-det.qt-faturada
              int-fat-mensal-det.vl-faturado
              IF  int-fat-mensal-det.tp-movto = 1 THEN string(int-fat-mensal-det.data, "99/99/9999") ELSE ""
              /*----------------------------------*/
              /*    Detalhes Devolu‡äes Mensal    */  
              /*----------------------------------*/
              int-fat-mensal-det.serie-docto 
              int-fat-mensal-det.nro-docto   
              int-fat-mensal-det.cod-emitente
              int-fat-mensal-det.nat-operacao
              int-fat-mensal-det.sequencia   
              int-fat-mensal-det.qt-devolvida
              int-fat-mensal-det.vl-devolvido
              IF  int-fat-mensal-det.tp-movto = 2 THEN string(int-fat-mensal-det.data, "99/99/9999") ELSE "".

           l-possui-faturamento = YES.
   END.

   /* A conta foi criada manualmente pelo usu rio, logo nÆo foi calculada e nÆo tem faturamento detalhado */
   IF  NOT l-possui-faturamento THEN DO:
       EXPORT STREAM s-1 DELIMITER ";"  
           int-cc-benef.canal         
           upper(int-cc-benef.unid-neg)
           int-cc-benef.dt-periodo-ini
           int-cc-benef.dt-periodo-fim
           fn-retorna-nome-beneficio(int-cc-benef.tipo-beneficio)
           int-cc-benef.perc-benef
           int-class-canal.nome
           int-cc-benef.categoria
           int-cc-benef.vl-saldo-ori   
           int-cc-benef.vl-saldo-anterior    
           int-cc-benef.vl-saldo
           int-cc-benef.dt-transacao  
           int-cc-benef.dt-vencimento
           int-cc-benef.vl-base-calc.
   END.


END.

PROCEDURE pi-envia-mail:

     DEF VAR h-utapi019 AS HANDLE NO-UNDO.
    
     EMPTY TEMP-TABLE tt-envio2.
     EMPTY TEMP-TABLE tt-mensagem1.
     EMPTY TEMP-TABLE tt-erros-1.

     FIND FIRST param-global    NO-LOCK NO-ERROR.

     DEF VAR c-msg-cab    AS CHAR NO-UNDO.
     DEF VAR c-mensagem   AS CHAR NO-UNDO.
     DEF VAR c-mensagem-1 AS CHAR NO-UNDO.
     DEF VAR c-assunto    AS CHAR NO-UNDO.
     DEF VAR c-ncm        LIKE classif-fisc.class-fiscal NO-UNDO.


     ASSIGN c-msg-cab = "<html>Prezado Cliente, " + "<BR><BR>" +                                                                         
                        "    Segue Anexo arquivo de Log de C lculo dos benef¡cios competentes a sua empresa, referentes ao Programa de Canais." + "<BR><BR>" + 
                        "Atenciosamente, ".

     
     /************************************************************** ENVIO **************************************************/
     RUN utp/utapi019.p PERSISTENT SET h-utapi019.


     FOR EACH tt-canal-email:
         EMPTY TEMP-TABLE tt-envio2.
         EMPTY TEMP-TABLE tt-mensagem1.
 
         create tt-envio2.
         assign tt-envio2.versao-integracao = 1
                tt-envio2.servidor          = param-global.serv-mail
                tt-envio2.porta             = param-global.porta-mail
                tt-envio2.remetente         = "EMS@intelbras.com.br"
                tt-envio2.destino           = "roger.bruhn@verticalti.com.br" /* Esse campo guarda o destinatÿrio(s) para o qual se vai enviar o log de altera»’o dos itens*/
                tt-envio2.assunto           = "Apura‡Æo Benef¡cios Programa de Canais"
                tt-envio2.arq-anexo         = tt-canal-email.nome-arquivo
                tt-envio2.formato           = "HTML"
                tt-envio2.exchange          = NO.
         CREATE tt-mensagem1.
         ASSIGN tt-mensagem1.seq-mensagem = 1
                tt-mensagem1.mensagem = c-msg-cab.
         RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                        INPUT TABLE tt-mensagem1,
                                        OUTPUT TABLE tt-erros-1).
     END.

     DELETE PROCEDURE h-utapi019.

END.

FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE PàS-VENDA".
    END CASE.

    RETURN "".

END FUNCTION.
