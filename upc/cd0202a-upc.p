/*****************************************************************************
**
**   Programa: cd0202a-upc.p
**
**   Funcao: Quando salva uma nova familia envia um e-mail para determinado
**           grupo de e-mail vindo do es0018
**   Data: 29/08/2018
**
**   Autor: Nicolas Martinez - INTELBRAS S/A.
**   
******************************************************************************/
{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{esp/es0018.i}

/*************************** Parametros Padrao ************************************/
DEFINE INPUT PARAM p-ind-event                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-ind-object                        AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-wgh-object                        AS HANDLE           NO-UNDO.
DEFINE INPUT PARAM p-wgh-frame                         AS WIDGET-HANDLE    NO-UNDO.
DEFINE INPUT PARAM p-cod-table                         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAM p-row-table                         AS ROWID            NO-UNDO.

DEFINE VARIABLE c-objeto  AS CHARACTER   NO-UNDO.

/* Identificar o objeto de tela */
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/":U), p-wgh-object:PRIVATE-DATA, "~/":U).

/*Mensagem para verificar o ponto UPC do programa*/
/*  MESSAGE "Evento: ":U   p-ind-event          SKIP                             
          "Objeto: ":U   p-ind-object         SKIP                             
          "Nome Obj: ":U c-objeto             SKIP                             
          "Frame: ":U    p-wgh-frame          SKIP                             
          "Tabela: ":U   p-cod-table          SKIP                             
          "Rowid: ":U    STRING(p-row-table)  SKIP
      VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Ponto UPC do CD0202a":U.
*/
DEF NEW GLOBAL SHARED VAR l-add     AS LOG        NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-rowant  AS CHAR       NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-rowdep  AS CHAR       NO-UNDO.

define variable c-remetente as character no-undo.
define variable c-destino   as character no-undo.
define variable c-assunto   as character no-undo.
define variable c-descemail as character no-undo.
define variable c-arquivo   as character no-undo.

IF p-ind-event = "AFTER-ENABLE":U AND
   c-objeto    = "v21in122.w":U 
THEN DO:
   ASSIGN r-rowant = string(p-row-table).
END.
    

IF p-ind-event = "ASSIGN":U AND
   c-objeto    = "v21in122.w":U 
THEN DO:
    ASSIGN r-rowdep = string(p-row-table).

    IF r-rowdep <> r-rowant THEN l-add = YES.
END.

IF p-ind-event  = "ADD":U AND
   p-ind-object = "VIEWER" 
THEN DO:
    ASSIGN l-add = YES.
END.

/* Envia e-mail no final de criar uma familia */
IF p-ind-event  = "END-UPDATE":U AND
   p-ind-object = "VIEWER"       AND
   l-add        = YES
THEN DO:

   /* Logica de envio de e-mail */
   RUN pi-busca-destino.

   assign c-remetente = "ems@intelbras.com.br"
          c-assunto   = "Cadastro de nova fam¡lia de materiais".

   FIND FIRST familia
        WHERE ROWID(familia) = p-row-table NO-LOCK NO-ERROR.

   IF AVAIL familia 
   THEN ASSIGN c-descemail = "Foi cadastrada uma nova fam¡lia de materiais: " 
                           + CHR(13)
                           + familia.fm-codigo
                           + " - " 
                           + familia.descricao.

   run piEnviaEmail (input c-remetente,
                     input c-destino,
                     input c-assunto,
                     input c-descemail,
                     input c-arquivo). 

   ASSIGN l-add = NO.
END.

IF p-ind-event  = "DESTROY":U AND
   p-ind-object = "CONTAINER" AND
   l-add        = YES
THEN DO:
   ASSIGN l-add = NO.
END.

RETURN "OK":U.

procedure piEnviaEmail:
   define input parameter premetente as character no-undo.
   define input parameter pDestino   as character no-undo.
   define input parameter pAssunto   as character no-undo.
   define input parameter pDescEmail as character no-undo.
   define input parameter pArquivo   as character no-undo.

   empty temp-table tt-mail.
   find first param-global no-lock no-error.

   create tt-mail.
   assign tt-mail.Remetente     = pRemetente
          tt-mail.Destinatario  = pdestino
          tt-mail.Assunto       = pAssunto
          tt-mail.Arquivo       = if pArquivo <> "" then search(pArquivo) else ""
          tt-mail.Mensagem      = pDescEmail.

   run utp/utapi019.p persistent set h-utapi019.

   for each tt-mail:
      empty temp-table tt-envio2.
      empty temp-table tt-mensagem.

      create tt-envio2.
      assign tt-envio2.versao-integracao = 1
             tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */
             tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */
             tt-envio2.destino           = tt-mail.Destinatario     /* Destinatÿrio       */
             tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */
             tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
             tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Temporÿrio */
             tt-envio2.formato           = "TEXTO".

      create tt-mensagem.
      assign tt-mensagem.seq-mensagem = 1
             tt-mensagem.mensagem     = tt-mail.Mensagem.
           
      run pi-execute2 in h-utapi019 (input  table tt-envio2,
                                     input  table tt-mensagem,
                                     output table tt-erros).
           
      if can-find (first tt-erros) then
         return "NOK".
   end.
end procedure.

PROCEDURE pi-busca-destino:

   ASSIGN c-destino = "".

   EMPTY TEMP-TABLE tt-prog-ponto.

   /* Seleciona usuarios de destino do e-mail  */
   RUN esp/es0018p.p (INPUT "cd0202a", /* Nome do programa */
                      INPUT 1,         /* Ponto do programa */
                      INPUT 0,
                      INPUT "",
                      OUTPUT TABLE tt-prog-ponto) NO-ERROR.

   FOR EACH tt-prog-ponto:
       IF c-destino = '' 
          THEN ASSIGN c-destino = tt-prog-ponto.conteudo.
          ELSE ASSIGN c-destino = c-destino + ',' + tt-prog-ponto.conteudo.
   END.

END PROCEDURE. 

