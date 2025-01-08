/***********************************************************************
**  Programa..: ESSEC002
**  Autor.....: Alexandre de Freitas.Campos.Gon‡alves
**  Data......: Junho/2015 - Desenvolvimento
**  Descricao.: Relat¢rio de monitoramento de perfis por usu rio no TOTVS
**  Versao....: 001 30/06/2015
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

DEFINE BUFFER b-usuar_mestre     FOR usuar_mestre.
DEFINE BUFFER b-grp_usuar        FOR grp_usuar.
DEFINE BUFFER b-grp-usuar-resp   FOR grp-usuar-resp.
DEFINE BUFFER b-prog_dtsul_segur FOR prog_dtsul_segur.
DEFINE BUFFER b-prog_dtsul       FOR prog_dtsul. 

{include/i-prgvrs.i essec002rp 1.00.00.000}

/****************************  Definitions  ****************************/
    
{esp/sec/essec002tt.i}
define temp-table tt-ad no-undo
       field sAMAccountName    as character format 'x(12)'
       field displayName       as character format 'x(40)'
       field manager           as character format 'x(12)'
       field employeeId        as integer
       field employeeNumber    as character format 'x(11)'
       field departmentNumber  as character format 'x(8)'
       field accountDisabled   as logical
       field office            as character format 'x(10)'
       field mail              as character format 'x(40)'
       field telephoneNumber   as character format 'x(20)'
       field cod-estabel       as character format 'x(3)'
       field cod_unid_negoc    as character format 'x(3)'
       field cod_ccusto        as character format 'x(11)'
       field cod_title         as character 
       index ch-pri is primary unique sAMAccountname.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.

{utp/ut-glob.i}
{esp/es0018.i}
{utp/utapi019.i}

/****************************  Temp-Tables  ******************************/

DEFINE TEMP-TABLE tt-responsavel
    FIELD cod-usuar        LIKE usuar_mestre.cod_usuar
    FIELD nom-usuario      LIKE usuar_mestre.nom_usuario
    FIELD dat-fim-valid    LIKE usuar_mestre.dat_fim_valid
    FIELD cod-grp-usuar    LIKE grp_usuar.cod_grp_usuar
    FIELD cod-e-mail-local LIKE usuar_mestre.cod_e_mail_local.

DEFINE BUFFER b-tt-responsavel FOR tt-responsavel.    

/****************************  Frames  ***********************************/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.
/*

= c-seg-usuario NO-ERROR. */

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FOR FIRST tt-param:
END.

DEFINE STREAM s-geral.
DEFINE STREAM s-grupo.

/********************* Defini‡Æo de variaveis ****************************/

DEFINE VARIABLE h-acomp     AS HANDLE      NO-UNDO.

DEFINE VARIABLE c-mensagem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-remetente AS CHARACTER   NO-UNDO.  
DEFINE VARIABLE c-titulo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caminho   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE varquivo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-data-hora AS CHARACTER   NO-UNDO.
DEFINE VARIABLE email-resp  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-aux       AS CHARACTER   NO-UNDO. 

/********************* Defini‡Æo de Layouts ******************************/

/*FORM prog_dtsul.cod_prog_dtsul      COLUMN-LABEL "Programa"      FORMAT "x(08)"
     prog_dtsul.nom_prog_dtsul_menu COLUMN-LABEL "Nome programa" FORMAT "x(30)"  
     WITH FRAME f-ns STREAM-IO DOWN WIDTH 132.

FORM usuar_mestre.cod_usuario COLUMN-LABEL "Usu rio"
     usuar_mestre.nom_usuario COLUMN-LABEL "Nome" FORMAT "x(38)"   
     WITH FRAME b-ns STREAM-IO DOWN WIDTH 132.

FORM b-prog_dtsul.cod_prog_dtsul      COLUMN-LABEL "Programa"      FORMAT "x(08)"  
     b-prog_dtsul.nom_prog_dtsul_menu COLUMN-LABEL "Nome programa" FORMAT "x(30)"  
     WITH FRAME f-prog-email STREAM-IO DOWN WIDTH 132.

FORM tt-saida.usuario      COLUMN-LABEL "Usu rio"                       
     tt-saida.nome-usuario COLUMN-LABEL "Nome"    FORMAT "x(38)"
     WITH FRAME f-usuar-email STREAM-IO DOWN WIDTH 132.   */

/********************* Defini‡Æo de saida ********************************/
ASSIGN c-data-hora = replace(STRING(TODAY),"/","-") + "-" + replace(STRING(TIME,"hh:mm:ss"),":","-").

EMPTY TEMP-TABLE tt-prog-ponto.

IF OPSYS = "UNIX" THEN DO:
    RUN esp/es0018p.p (INPUT "spool-unix", /* Nome do programa */
                       INPUT 1,           /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:
        ASSIGN c-caminho = tt-prog-ponto.conteudo + "~/" + v_cod_usuar_corren + "~/".
    END.

END.
ELSE DO:
    RUN esp/es0018p.p (INPUT "spool-win", /* Nome do programa */
                       INPUT 1,          /* Ponto do programa */
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FOR FIRST tt-prog-ponto NO-LOCK:
        ASSIGN c-caminho = tt-prog-ponto.conteudo + "~\" + v_cod_usuar_corren + "~\".
    END.
END.

OS-CREATE-DIR VALUE(c-caminho).

/*****************************  Main Block  ******************************/

DO ON STOP UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i Coletando_informacoes *}
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

    /*gera um arquivo com todos os grupos*/
    OUTPUT STREAM s-geral TO VALUE (c-caminho + "essec002-geral-" + c-data-hora + ".csv") CONVERT TARGET 'iso8859-1'.

    RUN piMontaRelat.

    IF NOT SESSION:BATCH-MODE THEN
        DOS SILENT START excel VALUE(c-caminho + "essec002-geral-" + c-data-hora + ".csv").

    OUTPUT STREAM s-geral CLOSE.
    
END.

PROCEDURE piMontaRelat:
    
    RUN adQuery (INPUT YES).
    
    PUT STREAM s-geral UNFORMATTED "Grupo Usu rios;Desc Grupo Usu rios;Respons vel;Nome Respons vel;Validade Respons vel;Identifica‡Æo;C¢digo;Descri‡Æo;Validade Usu rio;Cargo;L¡der;Nome do L¡der;E-Mail do L¡der;" SKIP.
    
    FOR EACH grp_usuar NO-LOCK
       WHERE grp_usuar.cod_grp_usuar >= tt-param.grupo-ini
         AND grp_usuar.cod_grp_usuar <= tt-param.grupo-fim
    BREAK BY grp_usuar.cod_grp_usuar:

        IF FIRST-OF (grp_usuar.cod_grp_usuar) THEN DO:
            /*Gera um arquivo para cada grupo*/
            OUTPUT STREAM s-grupo TO VALUE (c-caminho + "essec002-" + IF grp_usuar.cod_grp_usuar = "*" THEN "todos" ELSE grp_usuar.cod_grp_usuar + "-" + c-data-hora + ".csv") CONVERT TARGET 'iso8859-1'.
            PUT STREAM s-grupo UNFORMATTED "Grupo Usu rios;Desc Grupo Usu rios;Respons vel;Nome Respons vel;Validade Respons vel;Identifica‡Æo;C¢digo;Descri‡Æo;Validade Usu rio;Cargo;L¡der;Nome do L¡der;E-Mail do L¡der;" SKIP.
        END.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Grupo:" +  grp_usuar.cod_grp_usuar).
        RUN pi-responsavel.

        FOR EACH tt-responsavel:
            FOR EACH prog_dtsul_segur NO-LOCK
               WHERE prog_dtsul_segur.cod_grp_usuar = grp_usuar.cod_grp_usuar:
    
                FIND FIRST prog_dtsul NO-LOCK
                     WHERE prog_dtsul.cod_prog_dtsul = prog_dtsul_segur.cod_prog_dtsul NO-ERROR.
                
                PUT STREAM s-geral UNFORMATTED grp_usuar.cod_grp_usuar + ";" + grp_usuar.des_grp_usuar + ";" + tt-responsavel.cod-usuar + ";" + tt-responsavel.nom-usuario + ";" + string(tt-responsavel.dat-fim-valid) + ";".
                PUT STREAM s-geral UNFORMATTED "Programa;" + prog_dtsul.cod_prog_dtsul + ";" + prog_dtsul.nom_prog_dtsul_menu + ";" SKIP.

                PUT STREAM s-grupo UNFORMATTED grp_usuar.cod_grp_usuar + ";" + grp_usuar.des_grp_usuar + ";" + tt-responsavel.cod-usuar + ";" + tt-responsavel.nom-usuario + ";" + string(tt-responsavel.dat-fim-valid) + ";".
                PUT STREAM s-grupo UNFORMATTED "Programa;" + prog_dtsul.cod_prog_dtsul + ";" + prog_dtsul.nom_prog_dtsul_menu + ";" SKIP.
            END.

            FOR EACH usuar_grp_usuar NO-LOCK
               WHERE usuar_grp_usuar.cod_grp_usuar = grp_usuar.cod_grp_usuar:
                
                FIND FIRST usuar_mestre NO-LOCK    
                     WHERE usuar_mestre.cod_usuario = usuar_grp_usuar.cod_usuario NO-ERROR.
                
                FIND FIRST tt-ad 
                     WHERE tt-ad.sAMAccountName = usuar_mestre.cod_usuar NO-ERROR.

                PUT STREAM s-geral UNFORMATTED grp_usuar.cod_grp_usuar + ";" + grp_usuar.des_grp_usuar + ";" + tt-responsavel.cod-usuar + ";" + tt-responsavel.nom-usuario + ";" string(tt-responsavel.dat-fim-valid) + ";".
                PUT STREAM s-geral UNFORMATTED "Usu rio;" + usuar_mestre.cod_usuario + ";" + usuar_mestre.nom_usuario + ";" + string(usuar_mestre.dat_fim_valid) + ";".

                PUT STREAM s-grupo UNFORMATTED grp_usuar.cod_grp_usuar + ";" + grp_usuar.des_grp_usuar + ";" + tt-responsavel.cod-usuar + ";" + tt-responsavel.nom-usuario + ";" string(tt-responsavel.dat-fim-valid) + ";".
                PUT STREAM s-grupo UNFORMATTED "Usu rio;" + usuar_mestre.cod_usuario + ";" + usuar_mestre.nom_usuario + ";" + string(usuar_mestre.dat_fim_valid) + ";".

                IF AVAIL tt-ad THEN DO:
                    FIND FIRST usuar_mestre NO-LOCK
                         WHERE usuar_mestre.cod_usuar = tt-ad.manager NO-ERROR.
                    IF usuar_mestre.dat_fim_valid > TODAY THEN DO:
                        PUT STREAM s-geral UNFORMATTED tt-ad.cod_title + ";" + tt-ad.manager + ";" usuar_mestre.nom_usuario + ";" + usuar_mestre.cod_e_mail_local.
                        PUT STREAM s-grupo UNFORMATTED tt-ad.cod_title + ";" + tt-ad.manager + ";" usuar_mestre.nom_usuario + ";" + usuar_mestre.cod_e_mail_local.
                    END.
                END.

                IF usuar_mestre.dat_fim_valid < TODAY THEN DO:
                    PUT STREAM s-geral UNFORMATTED "Inativo". 
                    PUT STREAM s-grupo UNFORMATTED "Inativo". 
                END.

                PUT STREAM s-geral SKIP.
                PUT STREAM s-grupo SKIP.
            END.
        END. /*tt-responsavel*/
        IF LAST-OF (grp_usuar.cod_grp_usuar) THEN DO:
            /*Gera um arquivo para cada grupo*/
            OUTPUT STREAM s-grupo CLOSE.
        END.
        IF tt-param.email = YES THEN DO:
            RUN piTrataEmail.
        END.
    END.

    RUN pi-finalizar IN h-acomp.
    
END PROCEDURE.

PROCEDURE pi-responsavel:
    EMPTY TEMP-TABLE tt-responsavel.

    FOR EACH b-grp_usuar NO-LOCK
       WHERE b-grp_usuar.cod_grp_usuar = grp_usuar.cod_grp_usuar:
        
        FOR EACH b-grp-usuar-resp NO-LOCK
            WHERE b-grp-usuar-resp.cod-grp-usuar = b-grp_usuar.cod_grp_usuar
            BREAK BY b-grp-usuar-resp.cod-usuario:
            
            FIND FIRST b-usuar_mestre NO-LOCK
                 WHERE b-usuar_mestre.cod_usuario = b-grp-usuar-resp.cod-usuario NO-ERROR.

            CREATE tt-responsavel.
            ASSIGN tt-responsavel.cod-usuar        = b-usuar_mestre.cod_usuario
                   tt-responsavel.nom-usuario      = b-usuar_mestre.nom_usuario
                   tt-responsavel.dat-fim-valid    = b-usuar_mestre.dat_fim_valid
                   tt-responsavel.cod-grp-usuar    = b-grp_usuar.cod_grp_usuar
                   tt-responsavel.cod-e-mail-local = b-usuar_mestre.cod_e_mail_local.
        END.
    END.
END PROCEDURE.

PROCEDURE piTrataEmail:

    DEFINE VARIABLE c-destinataios AS CHARACTER   NO-UNDO.

    FOR EACH tt-responsavel
    BREAK BY tt-responsavel.cod-grp-usuar:

        IF FIRST-OF (tt-responsavel.cod-grp-usuar) THEN DO:
            FIND FIRST grp_usuar NO-LOCK
                 WHERE grp_usuar.cod_grp_usuar = tt-responsavel.cod-grp-usuar NO-ERROR.

            /*Mosta lista de destinat rios com todos os respons veis do grupo*/
            ASSIGN c-destinataios = "".
            FOR EACH b-tt-responsavel
               WHERE b-tt-responsavel.cod-grp-usuar = tt-responsavel.cod-grp-usuar:
                IF c-destinataios = "" THEN
                    ASSIGN c-destinataios = b-tt-responsavel.cod-e-mail-local.
                ELSE 
                    ASSIGN c-destinataios = c-destinataios + ";" + b-tt-responsavel.cod-e-mail-local.
            END.

            ASSIGN varquivo    = c-caminho + "essec002-" + IF grp_usuar.cod_grp_usuar = "*" THEN "todos" ELSE grp_usuar.cod_grp_usuar + "-" + c-data-hora + ".csv"
                   c-remetente = "ems@intelbras.com.br"
                   email-resp  = c-destinataios
                   c-titulo    = "Auditoria de acessos TOTVS - " + tt-responsavel.cod-grp-usuar
                   c-mensagem  = "Prezado colaborador." + "~n" + "~n" +
                                 "Em conformidade com a Pol¡tica de Seguran‡a da Intelbras e com a instru‡Æo de trabalho IT-INF-012-TIC, est  se iniciando um novo ciclo do processo de revisÆo dos Perfis de Acesso ao sistema Totvs." + "~n" + "~n" +
                                 "Vocˆ, que ‚ Usu rio Chave de um ou mais processos de neg¢cio, est  recebendo para an lise os Perfis que estÆo sob sua responsabilidade. Se necess rio, esta consulta tamb‚m pode ser realizada no sistema Totvs acessando o menu Foundation/Seguran‡a/Relat¢rios." + "~n" + "~n" + 
                                 "Seu envolvimento nesta revisÆo ‚ certificar que os Colaboradores inclusos nos Perfils realmente precisam deles e, que os Programas estÆo coerentes com o Processo."                                   + "~n" + "~n" +
                                 "Exemplos: um colaborador da Contabilidade nÆo deve ter acesso ao Perfil do Financeiro, da mesma forma que um programa de manuten‡Æo de Pedidos de Compra nÆo pode estar no Perfil da Expedi‡Æo, pois, nÆo estariam coerentes com a Fun‡Æo do Perfil." + "~n" + "~n" + 
                                 "Admissäes, desligamentos e movimenta‡äes internas de Colaboradores tamb‚m afetam os Perfis e devem ser revisados."  + "~n" + "~n" +
                                 "No caso de identificar inconsistˆncias, vocˆ deve solicitar a corre‡Æo … TIC, atrav‚s de Chamado, de acordo com os procedimentos IT-INF-001-TIC, IT-INF-001-TIC Anexo A."                             + "~n" + "~n" +
                                 "Vocˆ tem o prazo de 1 mˆs para conclusÆo deste trabalho. Ap¢s o t‚rmino da revisÆo, favor encaminhar um e-mail para o grupo.auditoriainterna com a planilha e o parecer da revisÆo."                  + "~n" + "~n" +
                                 "Esse procedimento ser  documentado e entregue para Auditoria Externa, a qual, realiza a valida‡Æo das demonstra‡äes financeiras da Intelbras.".

            ASSIGN c-endereco = email-resp 
                   c-arquivo  = varquivo.
            
            RUN pi-envia-email(INPUT c-remetente,
                               INPUT c-endereco,
                               INPUT c-titulo,
                               INPUT c-mensagem,
                               INPUT c-arquivo).
        END.
    END.

END PROCEDURE.

PROCEDURE pi-envia-email:
    
    RUN pi-acompanhar in h-acomp (input "Enviando Email: " + c-endereco).
    
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.
    
    EMPTY TEMP-TABLE tt-envio NO-ERROR.

    CREATE tt-envio.
    ASSIGN tt-envio.Remetente     = pRemetente
           tt-envio.destino       = pdestino
           tt-envio.Assunto       = pAssunto
           tt-envio.arq-anexo     = pArquivo
           tt-envio.Mensagem      = pDescEmail.
    
    RUN utp/utapi019.p PERSISTENT SET h-utapi019.

    FOR FIRST tt-envio:

        EMPTY TEMP-TABLE tt-envio2 NO-ERROR.
        EMPTY TEMP-TABLE tt-mensagem NO-ERROR.

        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.servidor          = param-global.serv-mail  /* Servidor de E-Mail */ 
               tt-envio2.porta             = param-global.porta-mail /* Porta do Servidor  */ 
               tt-envio2.destino           = tt-envio.Destino        /* Destinat rio       */ 
               tt-envio2.remetente         = tt-envio.Remetente      /* Remetente          */ 
               tt-envio2.assunto           = tt-envio.Assunto        /* Assunto            */
               tt-envio2.arq-anexo         = tt-envio.arq-anexo      /* Arquivo Tempor rio */
               tt-envio2.formato           = "CSV".
        
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = 1
               tt-mensagem.mensagem     = tt-envio.Mensagem.         /* Mensagem de e-mail */

        RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros).

        FIND FIRST tt-erros NO-LOCK NO-ERROR.
        IF  AVAIL tt-erros THEN DO:
            OUTPUT TO erros-comerc.LOG APPEND.

            FOR EACH tt-erros:
                DISP tt-erros.cod-erro
                     tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
            END.
            OUTPUT CLOSE.
        END. /* IF  AVAIL tt-erros THEN DO: */
    END. /* FOR FIRST tt-mail: */
    
    DELETE PROCEDURE h-utapi019. 
END PROCEDURE.  

procedure adQuery:
   define input parameter queryEnabled as logical no-undo.

   define variable adConn     as com-handle  no-undo.
   define variable adRS       as com-handle  no-undo.
   define variable adSysInfo  as com-handle  no-undo.
   define variable adRootDSE  as com-handle  no-undo.

   define variable adQuery    as character   no-undo.
   define variable numRecs    as integer     no-undo.
   define variable opts       as integer     no-undo.

   define variable i          as integer     no-undo.

   create "ADODB.Connection" adConn no-error.
   adConn:Provider = "ADsDSOObject".
   
/*    /*Comentar*/                                                   */
/*    adConn:Properties("User ID") = "intelbras\verticalti.gustavo". */
/*    adConn:Properties("Password") = .                */
/*    adConn:Properties("Encrypt Password") = TRUE.                  */
/*    /**/                                                           */
     
   adConn:open = "ADSI Providers".
   
   create "ADODB.Recordset" adRS NO-ERROR.
   assign adQuery = "select displayName, samaccountname, employeeID from 'LDAP://intelbras.local'".
   adRS = adConn:execute(adQuery, output numRecs, opts) no-error.

   if valid-handle(adRS) then do:
      release object adRS.
        
      do i = 65 to 90:
         create '' adRootDSE connect to 'LDAP://RootDSE' NO-ERROR.
         adRS = adConn:execute('<LDAP://' + adRootDSE:get('defaultNamingContext') + '>;(&(employeeID>=0)(employeeID<=999999999999999999999999999)(' + (if not queryEnabled then '' else '!') + 'userAccountControl:1.2.840.113556.1.4.803:=2)(sAMAccountName=' + chr(i) + '*));displayName,userAccountControl,mail,employeeId,employeeNumber,employeeType,distinguishedName,PhysicalDeliveryOfficeName,telephoneNumber,title,samaccountname,manager;subtree',,) no-error.
         
         if valid-handle(adRS) then do:
            do while not adRS:eof:
               create tt-ad.
               assign tt-ad.sAMAccountName   = adRS:fields('samaccountname'):value
                      tt-ad.displayName      = adRS:fields('displayName'):value
                      tt-ad.manager          = adRS:fields('manager'):value
                      tt-ad.employeeId       = int(adRS:fields('employeeId'):value)
                      tt-ad.employeeNumber   = adRS:fields('employeeNumber'):value
                      tt-ad.departmentNumber = adRS:fields('employeeType'):value /** Campo multivalorado nÆo funciona no Progress **/
                      tt-ad.office           = adRS:fields('PhysicalDeliveryOfficeName'):value
                      tt-ad.mail             = adRS:fields('mail'):value
                      tt-ad.telephoneNumber  = adRS:fields('telephoneNumber'):value
                      tt-ad.cod_title        = adRS:fields('title'):value
                      tt-ad.accountDisabled  = queryEnabled.

               if tt-ad.telephoneNumber = ? then
                  assign tt-ad.telephoneNumber = ''.
               if tt-ad.mail = ? then
                  assign tt-ad.mail = ''.
               if tt-ad.employeeNumber = ? then
                  assign tt-ad.employeeNumber = ''.
               if tt-ad.manager = ? then
                  assign tt-ad.manager = ''.

               case tt-ad.office:
                  when "Matriz" then
                     assign tt-ad.cod-estabel = "101".
                  when "Filial SC" then
                     assign tt-ad.cod-estabel = "104".
                  when "Filial MG" then
                     assign tt-ad.cod-estabel = "103".
                  when "Filial AM" then
                     assign tt-ad.cod-estabel = "105".
                  when "Filial BNU" then
                     assign tt-ad.cod-estabel = "106".
                  when "Filial PH" then
                     assign tt-ad.cod-estabel = "107".
               end case.

               if tt-ad.manager <> '' then
                  assign tt-ad.manager = entry(1, entry(2, tt-ad.manager, '='), ',').

               assign tt-ad.cod_unid_negoc = substring(tt-ad.departmentNumber, 1, 3)
                      tt-ad.cod_ccusto     = substring(tt-ad.departmentNumber, 4).

               run pi-acompanhar in h-acomp (input substitute("Lendo do ActiveDirectory: &1", tt-ad.sAMAccountName)).

               adRS:movenext.
            end.

            release object adRS.
         end.
      end.
   end.

   if valid-handle(adRS) then
      release object adRS.

   if valid-handle(adConn) then
      release object adConn.

end procedure.
