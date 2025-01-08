{include/i-prgvrs.i ESFTP001 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP001RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de Vendas
**              ConversÆo do programa es0520.p - Claudiney
**  VersÆo....: 001 11/11/2004
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp017tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/

DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.
DEF VAR l-volta                     AS LOG.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita to tt-digita.
END. 

DEF VAR h-acomp        AS HANDLE NO-UNDO.
FOR FIRST param-global NO-LOCK.  END.
FOR FIRST mgcad.empresa NO-LOCK WHERE
          empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Gera‡Æo de Pr‚-faturamento para Notas Fiscais"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP017"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").







   
   /* Coloquei estas linhas no programa - Clayton Antunes */
   DEF VAR i-nome-programa AS CHAR.
   DEF VAR i-ponto AS INT.
   DEF VAR i-sequencia AS INT.
   DEF VAR i-conteudo AS CHAR.
   {esp/es0018.i}

   DEF TEMP-TABLE tt-prog-ponto-tmp
       FIELD nome-programa    LIKE ponto-programa.nome-programa
       FIELD ponto            LIKE ponto-programa.ponto
       FIELD sequencia        LIKE conteudo-programa.sequencia 
       FIELD conteudo         LIKE conteudo-programa.conteudo
       INDEX seq-campo nome-programa ponto sequencia.   
   DEF BUFFER b-ponto-programa FOR ponto-programa.

   FOR EACH b-ponto-programa WHERE 
            b-ponto-programa.nome-programa = "esftp017":
       RUN esp\es0018p.p (INPUT b-ponto-programa.nome-programa,
                          INPUT b-ponto-programa.ponto,
                          INPUT i-sequencia,
                          INPUT i-conteudo,
                          OUTPUT TABLE tt-prog-ponto) NO-ERROR.
       FOR EACH TT-PROG-PONTO:
           CREATE tt-prog-ponto-tmp.
           BUFFER-COPY TT-PROG-PONTO TO tt-prog-ponto-tmp.
       END.
   END.
   /* Fim */










   RUN piImprimeRelat.

   RUN pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.

/* **********************  Internal Procedures  *********************** */
/*
A fam¡lia Comercial dever  seguir o seguinte formato:
GGSSMMCC
Onde: 
 GG - Indica‡Æo do grupo do Produto (Num‚rico);     1,2
 SS - Indica‡Æo do subgrupo do Produto (Num‚rico);  3,2
 MM - Indica‡Æo da Marca do Produto (Num‚rico);     5,2
 CC - Indica‡Æo do Complemento (Num‚rico).          7,2
*/

PROCEDURE piImprimeRelat:

    FIND FIRST embarque NO-LOCK WHERE embarque.cdd-embarq = tt-param.nr-embarque NO-ERROR.

    IF NOT AVAIL embarque THEN RETURN 'nok'.

    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = embarque.cod-estabel NO-ERROR.

    BLOCK_notas:
    FOR EACH tt-digita NO-LOCK WHERE
             tt-digita.selecionado,
             FIRST nota-fiscal EXCLUSIVE-LOCK WHERE
                   nota-fiscal.cod-estabel = tt-digita.cod-estab   AND
                   nota-fiscal.serie       = tt-digita.serie       AND
                   nota-fiscal.nr-nota-fis = tt-digita.nr-nota-fis AND
                   nota-fiscal.dt-cancela  = ?,
             FIRST natur-oper NO-LOCK WHERE
                   natur-oper.nat-operacao = nota-fiscal.nat-operacao:
                   
                   
        IF tt-digita.cod-estab <> embarque.cod-estabel THEN NEXT.
                   
                   //{esinc/es0004.i} /*ValidaNaturezasImpressÆoNFs*/
                   
                   
                   FIND FIRST pre-fatur WHERE 
                              pre-fatur.cdd-embarq = nota-fiscal.cdd-embarq         AND
                              pre-fatur.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis) AND 
                              pre-fatur.nome-abrev  = nota-fiscal.nome-ab-cli          AND 
                              pre-fatur.nr-pedcli   = nota-fiscal.nr-pedcli            NO-ERROR.
                   IF NOT AVAIL pre-fatur THEN DO:
                      CREATE pre-fatur.
                      ASSIGN pre-fatur.cod-estabel   = nota-fiscal.cod-estabel
                             pre-fatur.cdd-embarq   = embarque.cdd-embarq
                             pre-fatur.nr-resumo     = INTEGER(nota-fiscal.nr-nota-fis)
                             pre-fatur.nome-abrev    = nota-fiscal.nome-ab-cli
                             pre-fatur.nr-pedcli     = nota-fiscal.nr-pedcli
                             pre-fatur.estado        = nota-fiscal.estado
                             pre-fatur.dt-embarque   = embarque.dt-embarque
                             pre-fatur.nome-transp   = nota-fiscal.nome-transp
                             pre-fatur.cod-sit-pre   = 3.

                      ASSIGN nota-fiscal.cdd-embarq = embarque.cdd-embarq
                             nota-fiscal.nr-resumo   = INTEGER(nota-fiscal.nr-nota-fis).

                      FOR EACH it-nota-fisc EXCLUSIVE-LOCK OF nota-fiscal ON ERROR UNDO BLOCK_notas, NEXT BLOCK_notas:
                               CREATE it-pre-fat.
                               ASSIGN it-pre-fat.aliquota-ipi  = it-nota-fisc.aliquota-ipi
                                      it-pre-fat.aliquota-tax  = it-nota-fisc.aliquota-tax
                                      it-pre-fat.baixa-estoq   = it-nota-fisc.baixa-estoq
                                      it-pre-fat.cd-referencia = ''
                                      it-pre-fat.class-fiscal  = it-nota-fisc.class-fiscal
                                      it-pre-fat.cod-refer     = it-nota-fisc.cod-refer
                                      it-pre-fat.cod-tax       = it-nota-fisc.cod-tax 
                                      it-pre-fat.cod-vat       = it-nota-fisc.cod-vat 
                                      it-pre-fat.ct-cuscon     = it-nota-fisc.ct-cuscon 
                                      it-pre-fat.dt-entrega    = it-nota-fisc.dt-emis-nota
                                      it-pre-fat.dt-prev-fat   = it-nota-fisc.dt-emis-nota
                                      it-pre-fat.it-codigo     = it-nota-fisc.it-codigo 
                                      it-pre-fat.narrativa     = it-nota-fisc.nat-docum 
                                      it-pre-fat.nat-operacao  = it-nota-fisc.nat-operacao 
                                      it-pre-fat.nome-abrev    = it-nota-fisc.nome-ab-cli 
                                      it-pre-fat.cdd-embarq   = embarque.cdd-embarq
                                      it-pre-fat.nr-entrega    = it-nota-fisc.nr-entrega 
                                      it-pre-fat.nr-pedcli     = it-nota-fisc.nr-pedcli
                                      it-pre-fat.nr-resumo     = INTEGER(nota-fiscal.nr-nota-fis)
                                      it-pre-fat.nr-sequencia  = it-nota-fisc.nr-seq-fat 
                                      it-pre-fat.qt-alocada    = it-nota-fisc.qt-faturada[1] 
                                      it-pre-fat.qt-faturada   = it-nota-fisc.qt-faturada[1] 
                                      it-pre-fat.qt-rejeita    = 0
                                      /*it-pre-fat.qt-transfer   = ???*/
                                      it-pre-fat.sc-cuscon     = it-nota-fisc.sc-cuscon 
                                      it-pre-fat.tipo-atend    = it-nota-fisc.tipo-atend 
                                      it-pre-fat.un            = it-nota-fisc.un-fatur[1] 
                                      it-pre-fat.user-rej      = ''
                                      it-pre-fat.vl-cuscontab  = it-nota-fisc.vl-cuscontab.
                               ASSIGN it-nota-fisc.cdd-embarq = embarque.cdd-embarq.    
                      END.

                      DISP embarque.cdd-embarq
                           tt-digita.cod-estab  
                           tt-digita.serie      
                           tt-digita.nr-nota-fis
                           tt-digita.nome-ab-cli
                           nota-fiscal.estado
                           WITH STREAM-IO.
                   END.
                   ELSE DO:
                       IF nota-fiscal.cdd-embarq = 0 THEN DO:
                       
                                FOR EACH it-pre-fat OF pre-fatur:
                                    ASSIGN it-pre-fat.cdd-embarq = embarque.cdd-embarq.
                                END.
                               ASSIGN pre-fatur.cdd-embarq   = embarque.cdd-embarq
                                      nota-fiscal.cdd-embarq = embarque.cdd-embarq.
                               PUT "alterou nota " embarque.cdd-embarq nota-fiscal.nr-nota-fis SKIP.
                               FOR EACH it-nota-fisc OF nota-fiscal:
                                   ASSIGN it-nota-fisc.cdd-embarq = embarque.cdd-embarq.    
                               END.
                       END.
                   END.
    END.

    PUT
         UNFORMATTED
        'OK'.
END PROCEDURE.
