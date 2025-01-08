/***********************************************************************
**  Programa..: ESP\FTP\esftp9006RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio de Vendas
**              ConversÆo do programa es0520.p - Claudiney
**  VersÆo....: 001 11/11/2004
**                  Desenvolvimento Programa
************************************************************************/
DISABLE TRIGGERS FOR LOAD OF nota-fiscal.
DISABLE TRIGGERS FOR LOAD OF docum-est.

DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp9006 2.04.00.002}
{esapi/esapi010tt.i} 
/****************************  Definitions  ****************************/
{esp/ftp/esftp9006tt.i}
{cdp/cd0666.i}
{include/i-rpvar.i}
{method/dbotterr.i} 
{esp/es0018.i}
{esp/es0043.i}

/****************************  Temp-Tables  ****************************/
/* form tt-digita.cd-gr
     fam-comerc.descricao
     with frame f-mostra row 3 12 down overlay col 30. */
/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */
def var h-boes464             as handle  no-undo.
def var da-data          as date.
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.
def var de-perc-acordo   as decimal no-undo.
def var d-dt-ent         like ped-venda.dt-emiss.
def var c-obs            as char format "X(85)".
def var i-atendente      like ped-venda.tp-pedido.
def var c-mail           as char format "X(40)".
def var c-desc-grupo     like gr-cli.descricao.
DEFINE VARIABLE c-sit-ped AS CHARACTER FORMAT "x(12)"  NO-UNDO.
DEFINE VARIABLE c-cod-gerente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nom-gerente AS CHARACTER   NO-UNDO.
def var i-p-medio        as dec format ">>>>>>9".
def var c-unid-neg       as char format "X(10)".
DEF VAR c-unid-nota      as char format "X(10)".
def var de-perc-comissao as dec format ">9.99".
DEF VAR c-desc-cond      LIKE cond-pagto.descricao.
DEF VAR de-preco-min     LIKE preco-item.preco-venda.
DEFINE VARIABLE dt-dt-implant LIKE ped-venda.dt-implant.
DEFINE VARIABLE c-desc-item AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-obs-aux AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-observ-item AS CHARACTER   NO-UNDO.
 
    DEFINE VARIABLE cMensagem            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE vArqMail             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lErro       AS LOGICAL      NO-UNDO INITIAL NO.
 
def buffer b-emitente for emitente.
/****************************  Frames       ****************************/
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
 
create tt-param.
raw-transfer raw-param to tt-param.
 
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
 
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
 
assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Atualiza STATUS notas pendentes - NAO ATUALIZA ESTOQUE "
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP9006"
       c-versao       = "2.04"
       c-revisao      = "001".
 
/* ***************************  Main Block  *************************** */
RUN esbo/boes464.p PERSISTENT SET h-boes464.
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   RUN piEnviaEmail.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}

   RETURN "OK".
end.
DELETE PROCEDURE h-boes464.    
 
 
 
PROCEDURE piImprimeRelat:

    //ASSIGN vArqMail = SESSION:TEMP-DIRECTORY + "EnvMailNF.txt".
    ASSIGN vArqMail = c-dir-arquivo-session + "EnvMailNF.txt".

    OUTPUT TO VALUE(vArqMail).

    PUT "NOTAS DE SAIDA ATUALIZADAS NO ESTOQUE MAS SEM MOVIMENTA€ÇO - DESATUALIZE A NOTA E ATUALIZE NOVAMENTE VIA FT2100" SKIP.

      FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.dt-emis-nota >= TT-PARAM.da-data-ini
        AND nota-fiscal.dt-confirma <> ?
        AND nota-fiscal.dt-cancel   = ?,
          EACH it-nota-fisc OF nota-fiscal NO-LOCK
          WHERE it-nota-fisc.baixa-estoq = YES:
         IF NOT CAN-FIND(FIRST movto-estoq
                         WHERE movto-estoq.cod-estabel = nota-fiscal.cod-estabel
                           AND movto-estoq.it-codigo   = it-nota-fisc.it-codigo
                           AND movto-estoq.nro-docto   = nota-fiscal.nr-nota-fis
                           AND movto-estoq.serie-docto = nota-fiscal.serie 
                           AND movto-estoq.cod-emitente = nota-fiscal.cod-emitente) THEN DO:
            DISP nota-fiscal.cod-estabel
                 nota-fiscal.serie
                 nota-fiscal.nr-nota-fis
                 nota-fiscal.dt-emis-nota
                 it-nota-fisc.it-codigo
                 it-nota-fisc.qt-faturada[2]
                WITH FRAME f-detalhe WIDTH 130 64 DOWN.
            DOWN WITH frame f-detalhe.
         END.
    END.

    PUT "" SKIP "NOTAS DE SAIDA COM STATUS ATUALIZADO SEM ATUALIZAR ESTOQUE" SKIP
        "" SKIP.
     FOR EACH nota-fiscal
        WHERE nota-fiscal.dt-emis-nota >= TT-PARAM.da-data-ini
        AND nota-fiscal.dt-confirma = ?
        AND nota-fiscal.dt-cancel   = ?:
        DISP nota-fiscal.cod-estabel
             nota-fiscal.serie
             nota-fiscal.nr-nota-fis
             nota-fiscal.dt-emis-nota.
        ASSIGN nota-fiscal.dt-confirma = TODAY.
    
    END.
    PUT "" SKIP
        "NOTAS DE ENTRADA COM STATUS ATUALIZADO SEM ATUALIZAR ESTOQUE" SKIP
        "" SKIP.
    FOR EACH docum-est WHERE docum-est.ce-atual = NO:
        DISP docum-est.nro-docto 
            docum-est.serie
            docum-est.nat-operacao 
            docum-est.cod-estabel
            docum-est.dt-trans.
        ASSIGN docum-est.ce-atual = YES.
    END.
    OUTPUT CLOSE.
END PROCEDURE.

/* Rotinas Especificas */
PROCEDURE piEnviaEmail:

    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT "esftp9006":U, 
                       INPUT 1, 
                       INPUT 0, 
                       INPUT "":U, 
                       OUTPUT TABLE tt-prog-ponto).

    ASSIGN c-mail = "".
    FOR EACH tt-prog-ponto:
        ASSIGN c-mail = IF c-mail = "" THEN tt-prog-ponto.conteudo ELSE c-mail + "," + tt-prog-ponto.conteudo.
    END.
    
    FOR EACH tt-mail.
        DELETE tt-mail.
    END.

    ASSIGN cMensagem = "Em anexo Notas Com STATUS Atualizado sem atualizar estoques" + CHR(10) + CHR(10).

    CREATE tt-mail.
    ASSIGN tt-mail.Destinatario  = c-mail
           tt-mail.Assunto       = "Notas Com STATUS Atualizado "
           tt-mail.Mensagem      = cMensagem
           tt-mail.Arquivo       = vArqMail.
        

    ASSIGN tt-mail.Remetente = "ems@intelbras.com.br".

    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    
    FOR EACH tt-erro:
        PUT tt-erro.mensagem FORMAT "x(100)" SKIP.
                
    END.
    
    FOR EACH tt-mail:
        DELETE tt-mail.
    END.

END PROCEDURE.

