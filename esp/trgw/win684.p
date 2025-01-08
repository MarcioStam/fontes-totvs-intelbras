/********************************************************************************
 ** UPC........: win684.p - UPC WRITE item-uni-estab
 ** Data.......: Julho / 2007
 ** Objetivo...: Atualiza valor default
 ********************************************************************************/

{utp/utapi019.i}
{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-prog-ponto-aux NO-UNDO LIKE tt-prog-ponto.
DEFINE TEMP-TABLE tt-prog-ponto-2 NO-UNDO LIKE tt-prog-ponto.
DEF NEW GLOBAL SHARED var v_cod_usuar_corren AS CHARACTER NO-UNDO.

/*{cdp/cd0666.i}*/
def new global shared var l-multi as logical initial yes.

def var l-del-erros as logical init YES NO-UNDO.
def var v-nom-arquivo-cb as char format "x(50)" no-undo.
def var c-mensagem-cb    as char format "x(132)" no-undo.
def var c-dir            as char no-undo.
def var l-ativa-log      as logical NO-UNDO INITIAL YES.

DEFINE VARIABLE c-textoC AS CHARACTER FORMAT 'X(256)' NO-UNDO.
DEFINE VARIABLE c-emailC AS CHARACTER                 NO-UNDO.

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

/*Tratamento criado para que, em rotinas criticas nas quais esta include s¢ ‚ chamada para definir a tt-erro, seja possivel
  fazer com que nÆo seja definida a frame nem seja chamado o tratamento de tradu‡Æo, pois isto degrada performance.*/
/* ** Comentado devido … erros de integra‡Æo SharePoint X EMS 2.06B ** */
/* &if '{&excludeFrameDefinition}' = 'yes' &then                       */
/* &else                                                               */
/*                                                                     */
/*     form                                                            */
/*         space(04)                                                   */
/*         tt-erro.cd-erro                                             */
/*         space (02)                                                  */
/*         c-mensagem-cb                                               */
/*         with width 132 no-box down stream-io frame f-consiste.      */
/*                                                                     */
/*     run utp/ut-trfrrp.p (input frame f-consiste:handle).            */
/*     assign tt-erro.cd-erro:label in frame f-consiste = "Mensagem".  */
/*     assign c-mensagem-cb:label in frame f-consiste   = "Descricao". */
/*                                                                     */
/* &endif                                                              */

def param buffer b-item-uni-estab     for item-uni-estab.
def param buffer b-old-item-uni-estab for item-uni-estab.

DEFINE VARIABLE cNom_from   AS CHARACTER    NO-UNDO INITIAL ''.
DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE C-ALTERACAO AS char format "x(35)" no-undo initial ''.
DEFINE VARIABLE c-atu AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE c-ant AS char format "x(15)" no-undo initial ''.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.

on write of item-uni-estab override do: end.

/*---[ Relacionamento Grupo de Estoque vs Tipo Item ]----------------------------------------------------------------------*/
RUN esp/es0018p.p (INPUT "cd0147", /* Nome do programa */
                   INPUT 1,        /* Ponto do programa */
                   INPUT 0,
                   INPUT "",
                   OUTPUT TABLE tt-prog-ponto-aux).

FOR FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = b-item-uni-estab.it-codigo:

    for each tt-prog-ponto-aux:

        if  int(entry(1, tt-prog-ponto-aux.conteudo,";")) = ITEM.ge-codigo then 
            assign overlay(b-item-uni-estab.char-1, 133, 1) = string(ENTRY(2, tt-prog-ponto-aux.conteudo,";")).
        
    end. /* for each tt-prog-ponto-aux: */

    FIND FIRST int-item OF ITEM NO-LOCK NO-ERROR.

      
    IF AVAIL int-item THEN DO:
       FIND FIRST item-uni-estab 
            WHERE item-uni-estab.cod-estabel = b-item-uni-estab.cod-estabel
              AND item-uni-estab.it-codigo = b-item-uni-estab.it-codigo 
       NO-LOCK NO-ERROR.

       IF AVAIL item-uni-estab THEN DO:
          FIND FIRST int-item-uni-estab EXCLUSIVE-LOCK
                 WHERE int-item-uni-estab.cod-estabel = item-uni-estab.cod-estabel 
                   AND int-item-uni-estab.it-codigo   = item-uni-estab.it-codigo NO-ERROR.

          IF AVAIL int-item-uni-estab THEN DO:
             ASSIGN int-item-uni-estab.int-1 = int-item.motivo-situacao.
             
             /*
             MESSAGE int-item-uni-estab.cod-estabel SKIP
                     int-item-uni-estab.it-codigo   SKIP 
                     int-item-uni-estab.int-1
                 VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
             
             RELEASE int-item-uni-estab.
          END.
       END.
    END.   
        



END. /* FOR FIRST ITEM NO-LOCK */
/*----------------------------------------------------------------------[ Relacionamento Grupo de Estoque vs Tipo Item ]---*/


IF program-name(3) matches '*cd0202*' THEN DO:

   RUN esp/es0018p.p (INPUT "cd0202e", /* Nome do programa */
                      INPUT 1,        /* Ponto do programa */
                      INPUT 0,
                      INPUT "",
                      OUTPUT TABLE tt-prog-ponto-2).
   
   FOR EACH tt-prog-ponto-2: /*Novo relacionamento da item-uni-estab vindo pelo cd0202 gravar como nao*/
       IF NEW b-item-uni-estab AND b-item-uni-estab.cod-estabel = tt-prog-ponto-2.conteudo THEN DO: 
           ASSIGN b-item-uni-estab.ind-item-fat = NO.            
       END.     
   END.
END.

if  new b-item-uni-estab then do:
    
    /* chamado: C2310-1384 */
    IF  b-item-uni-estab.tp-desp-padrao = 0 THEN
        ASSIGN b-item-uni-estab.tp-desp-padrao = 1.

    IF  b-item-uni-estab.nat-despesa = 0 THEN
        ASSIGN b-item-uni-estab.nat-despesa = 1.
    /* chamado: C2310-1384 */

    assign b-item-uni-estab.reporte-ggf = 2 /* Alterado por Osnir. O item sempre deve ser reporte ggf igual a padrÆo */
           b-item-uni-estab.reporte-mob = 2.

    run esp/es0669.p (input "yes",
                     "item-uni-estab",
                     b-item-uni-estab.it-codigo,
                     b-item-uni-estab.cod-estabel,
                     "", "", "", "", "", "", "").

   /* /*Cria tabela extensao int-item-uni-estab*/
    FIND FIRST int-item-uni-estab OF b-item-uni-estab NO-LOCK NO-ERROR.
    IF NOT AVAIL int-item-uni-estab THEN DO:
        CREATE int-item-uni-estab.
        ASSIGN int-item-uni-estab.it-codigo    = b-item-uni-estab.it-codigo
               int-item-uni-estab.cod-estabel  = b-item-uni-estab.cod-estabel.
    END.*/

end.

IF (b-old-item-uni-estab.perm-saldo-neg <> b-item-uni-estab.perm-saldo-neg AND b-item-uni-estab.perm-saldo-neg <> 1) AND
    (b-item-uni-estab.cod-estabel = "102") THEN DO:

    assign c-alteracao = "Permite Saldo Negativo liberado para item x estabelecimento " + CHR(13)
           c-atu = IF b-item-uni-estab.perm-saldo-neg > 1 THEN "Sim" ELSE "NÆo"
           c-ant = IF b-old-item-uni-estab.perm-saldo-neg > 1 THEN "Sim" ELSE "NÆo".
    run pi-manda-email-item-alterado(INPUT 1). /*1-Manda email para ponto win172*/
end.

IF program-name(3) matches '*cd0202*' or
   program-name(3) matches '*cd0204*' THEN do:

    assign b-item-uni-estab.val-lim-absor = 1  /* Alteado cfe SOS 28993 solicitado por lazare. Limite Absorcao Pre‡o M‚dio = 1,00 (ce0330) */
           b-item-uni-estab.int-1 = 0.
end.

IF b-item-uni-estab.it-codigo = "" AND b-item-uni-estab.deposito-pad <> b-old-item-uni-estab.deposito-pad  THEN DO:
    assign c-alteracao = "Alteracao Deposito Padrao para estabelecimento " + CHR(13)
           c-atu = b-item-uni-estab.deposito-pad
           c-ant = b-old-item-uni-estab.deposito-pad.
    run pi-manda-email-item-alterado(INPUT 2). /*manda email para grupo.fiscal*/
END.

IF  b-item-uni-estab.ind-item-fat <> b-old-item-uni-estab.ind-item-fat then do:

    RUN esp/es0018p.p (INPUT  "LOG":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto
        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = "win684"
          AND ENTRY(2,tt-prog-ponto.conteudo,";") = OPSYS: /*unix ou win32*/
        ASSIGN c-dir = REPLACE(ENTRY(3,tt-prog-ponto.conteudo,";"), "~\":U, "/":U).
    END.
    IF c-dir <> "" THEN DO:
        IF l-ativa-log THEN DO:
            OUTPUT TO VALUE(c-dir) NO-CONVERT APPEND.
            PUT UNFORMATTED "Mudou Campo Item Faturavel - Data " STRING(TODAY) + " " STRING(TIME,"HH:MM:SS") " - Usuario = " v_cod_usuar_corren " Item " b-item-uni-estab.it-codigo " Estab " b-item-uni-estab.cod-estabel 
                                " Valor Anterior " b-old-item-uni-estab.ind-item-fat 
                                " Valor Atual " b-item-uni-estab.ind-item-fat 
                                " Programas " program-name(1) format "x(40)"
                                program-name(2) format "x(40)"
                                program-name(3) format "x(40)"
                                program-name(4) format "x(40)"
                                program-name(5) format "x(40)"
                                program-name(6) format "x(40)" skip.
            OUTPUT CLOSE.
        END.
    END.

END.

IF  b-item-uni-estab.ind-item-fat <> b-old-item-uni-estab.ind-item-fat
AND b-item-uni-estab.ind-item-fat  = YES THEN DO:

    FOR EACH lib-item-fat
        WHERE  lib-item-fat.it-codigo  = b-item-uni-estab.it-codigo   
          AND  lib-item-fat.c-status  <> "Liberado" 
          AND  lib-item-fat.c-status  <> "Cancelado" EXCLUSIVE-LOCK :

        IF lib-item-fat.cod-estab-vinculado MATCHES("*" + b-item-uni-estab.cod-estabel + "*") THEN DO:
            ASSIGN lib-item-fat.c-status     = "Liberado"
                   lib-item-fat.usuario-lib  = c-seg-usuario
                   lib-item-fat.dt-liberacao = TODAY
                   lib-item-fat.hr-liberacao = string(TIME,'HH:MM').

            FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lib-item-fat.usuario NO-LOCK NO-ERROR.
            IF AVAIL usuar_mestre THEN DO:
                ASSIGN c-emailC = usuar_mestre.cod_e_mail_local
                       c-textoC = "Solicitacao " + string(lib-item-fat.cod-solicitacao) + " de ITEM Faturavel - ITEM " + ITEM.it-codigo + " liberada.".
                RUN  piEnviaEmail (INPUT usuar_mestre.cod_e_mail_local,
                                   INPUT c-emailC,
                                   INPUT "Liberado - Solicita‡Æo ITEM Fatur vel",
                                   INPUT c-textoC,
                                   INPUT "").
            END. /* IF AVAIL int-unid-negoc THEN DO: */
        END. /* IF lib-item-fat.cod-estab-vinculado MATCHES("*" + b-item-uni-estab.cod-estabel + "*") THEN DO: */

    END.

    FIND CURRENT lib-item-fat NO-LOCK NO-ERROR.
    RELEASE lib-item-fat.

END. /* IF b-item-uni-estab.ind-item-fat = YES THEN DO: */

PROCEDURE piEnviaEmail:

/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)'  NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(250)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)'  NO-UNDO.

    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinatÿrio       */ 
           tt-envio2.remetente         = pRemetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Temporÿrio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    /*
    for each tt-erros:
        put tt-erros.desc-erro.
    end.*/

END PROCEDURE.


PROCEDURE pi-manda-email-item-alterado.
    DEFINE INPUT PARAMETER p-destino AS INTEGER NO-UNDO.
    
    FIND FIRST param-global NO-LOCK.

    FIND usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    
    IF AVAILABLE usuar_mestre THEN
       ASSIGN cNom_from = usuar_mestre.cod_e_mail_local.
    
    IF cNom_from = '' THEN
       ASSIGN cNom_from = 'ems@intelbras.com.br'.

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR EACH tt-envio2:     DELETE tt-envio2.   END.
    FOR EACH tt-mensagem:   DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.exchange    = param-global.log-1 
           tt-envio2.servidor    = param-global.serv-mail
           tt-envio2.porta       = param-global.porta-mail
           tt-envio2.remetente   = cNom_from
           tt-envio2.destino     = ""
           tt-envio2.assunto     = "URGENTE - ALTERA€ÇO ITEM x ESTABELECIMENTO NAO PERMITIDA: " + b-item-uni-estab.it-codigo + " - " + b-item-uni-estab.cod-estabel
           tt-envio2.importancia = 2
           tt-envio2.log-enviada = YES
           tt-envio2.log-lida    = NO
           tt-envio2.acomp       = NO
           tt-envio2.arq-anexo   = ?
           tt-envio2.formato     = "text".


    IF p-destino = 1 THEN DO:
        /* se for item da Maxcom e Intelbras continua enviando para ems.item*/

        RUN esp/es0018p.p (INPUT "win172", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   

        for each tt-prog-ponto:
            if entry(1, tt-prog-ponto.conteudo,";") = b-item-uni-estab.cod-estabel then 
                assign tt-envio2.destino = tt-envio2.destino + ENTRY(2, tt-prog-ponto.conteudo,";") + ";" .
        END.
    END.
    ELSE IF p-destino = 2 THEN DO:
        ASSIGN tt-envio2.destino = "grupo.fiscal@intelbras.com.br".
    END.
    
    FIND ITEM WHERE ITEM.it-codigo = b-item-uni-estab.it-codigo NO-LOCK NO-ERROR.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "**************************************************" + CHR(13) +
                                      "             ALTERACAO NAO PERMITIDA              " + CHR(13) +
                                      "**************************************************" + CHR(13) +
                                      "Item: " + b-item-uni-estab.it-codigo                + CHR(13) +
                                      "Descri‡Æo: " + item.desc-item                       + CHR(13) +
                                      "Alteracao: " + c-alteracao                          + CHR(13) +
                                      "Valor Atual: " + c-atu                              + CHR(13) + 
                                      "Valor Anterior: " + c-ant                           + CHR(13) +
                                      "Programa: " + PROGRAM-NAME(6)                       + CHR(13) +
                                      "**************************************************" + CHR(10).

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2, INPUT TABLE tt-mensagem, OUTPUT TABLE tt-erros).

    FIND FIRST tt-erros NO-LOCK NO-ERROR.
    IF AVAIL tt-erros THEN DO:
        IF OPSYS = "UNIX" THEN do:

            ASSIGN c-arquivo = session:temp-directory + c-seg-usuario + "/erros-email.log".

            output to value(c-arquivo) CONVERT TARGET SESSION:CHARSET.                               

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "x(70)" WITH STREAM-IO SIDE-LABELS.
            END.

            OUTPUT CLOSE.
        END.
        ELSE DO:
            FOR EACH tt-erro:
                DELETE tt-erro.
            END.
            FOR EACH tt-erros:
                CREATE tt-erro.
                ASSIGN i-cont = i-cont + 1
                       tt-erro.i-sequen = i-cont
                       tt-erro.cd-erro  = tt-erros.cod-erro
                       tt-erro.mensagem = tt-erros.desc-erro + tt-erros.desc-arq.
            END.
            RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        END.
    END.

    IF VALID-HANDLE(h-utapi019) THEN
       DELETE PROCEDURE h-utapi019.
END PROCEDURE.
