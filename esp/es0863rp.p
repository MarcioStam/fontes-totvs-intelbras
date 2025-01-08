/*****************************************************************************
**
**   Programa:  es0863rp.p
**
**   Funcao:  Embarques atrasados
**
**   Data:  Convertido em 08/03/2010
**
**   Autor:  Osnir Ribeiro Jr
**
******************************************************************************/


{include/i-prgvrs.i es0863rp 2.00.00.000}
{esp/es0863.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/********** INCLUDES PADROES         ***************************************/   

def buffer b-comp for componente.

def var c-desc              as char format "X(36)".
def var h-acomp             as handle    no-undo.
define variable c-remetente as character no-undo.
define variable c-descemail as character no-undo.
define variable c-destino   as character no-undo.
def var i-dias              as INT       NO-UNDO.
define variable i-seq       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-conhecto-master AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nome-abrev AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-assunto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-comprador AS CHARACTER NO-UNDO.
/* {esp/es0002.i} /* Controle de permissoes */ */

{esp/es0018.i}

def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".

/********** DEFINICAO DE TEMP-TABLES ****************************************/
def temp-table tt-comunic
    FIELD cod-estabel LIKE embarque-imp.cod-estabel
    field embarque like embarque-imp.embarque
    field dt-ult-prev like historico-embarque.dt-ult-prev
    field cod-itiner like historico-embarque.cod-itiner
    field cod-pto-contr like historico-embarque.cod-pto-contr.

create tt-param.
raw-transfer raw-param to tt-param.

/********** CORPO DO PROGRAMA        ***************************************/      
find first param-global no-lock no-error.
find first mgcad.empresa no-lock
   where empresa.ep-codigo = param-global.empresa-pri no-error.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Embarques atrasados"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "es0863"
       c-versao       = "2.04"
       c-revisao      = "002". 

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Embarques Atrasados").

{include/i-rpcab.i}
{include/i-rpout.i}

ASSIGN c-destino = "".    
/*if weekday(today) = 2 or
   weekday(today) = 4 then DO:*/
     /* sequencia 1 recebe todos os dias */
    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "es0863rp"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia    <> 2:

        IF c-destino = "" THEN
            ASSIGN c-destino = conteudo-programa.conteudo.
        ELSE
            ASSIGN c-destino = c-destino + ";" + conteudo-programa.conteudo.
    END.

//END.
    
if weekday(today) = 3 or
   weekday(today) = 5 or
   weekday(today) = 6 then DO:

    /*Somente sequencia 2 recebe nas tercas, quintas e sextas*/
    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "es0863rp"
          AND ponto-programa.ponto         = 1,
        FIRST conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
          AND conteudo-programa.sequencia    = 2:
        ASSIGN c-destino = c-destino + ";" + conteudo-programa.conteudo.
    END.

END.
    
if weekday(today) = 7 or weekday(today) = 1 OR c-destino = "":U then RETURN "ok".

for each embarque-imp no-lock
   where embarque-imp.situacao = 1:
   find first historico-embarque of embarque-imp no-lock
        where historico-embarque.dt-efetiva = ? no-error.
   if not avail historico-embarque then next.
   if historico-embarque.dt-ult-prev >= today then next.

   run pi-acompanhar in h-acomp (input "Embarque " + embarque-imp.embarque).

   find FIRST decl-itiner no-lock
        where decl-itiner.cod-itiner = historico-embarque.cod-itiner
          and decl-itiner.cod-pto-contr                     = historico-embarque.cod-pto-contr     no-error.
    if avail decl-itiner then 
        assign i-dias = decl-itiner.dias-tolerancia.
    else
        assign i-dias = 1.
    if historico-embarque.dt-ult-prev + i-dias <= today then do:
        create tt-comunic.
        assign tt-comunic.cod-estabel = embarque-imp.cod-estabel
               tt-comunic.embarque = embarque-imp.embarque
               tt-comunic.cod-itiner = historico-embarque.cod-itiner
               tt-comunic.cod-pto-contr = historico-embarque.cod-pto-contr
               tt-comunic.dt-ult-prev = historico-embarque.dt-ult-prev.
    end.
end.

{include/i-rpclo.i}

assign c-assunto = "Embarques em Atraso"
       /*c-arquivo = SESSION:TEMP-DIRECTORY + "embarques_atrasados.csv".*/
       c-arquivo = c-dir-arquivo-session + "embarques_atrasados.csv".

OUTPUT TO VALUE(c-Arquivo) CONVERT TARGET "iso8859-1".

PUT UNFORMATTED "Est;Embarque;Conhecimento;Comprador;Fornecedor;Itinerario;Previsao;Atraso;Status" SKIP.

for each tt-comunic 
   break by tt-comunic.cod-pto-contr
         by tt-comunic.dt-ult-prev:
    if first-of(tt-comunic.cod-pto-cont) then do:
        FIND itinerario WHERE itinerario.cod-itiner = tt-comunic.cod-itiner  NO-LOCK NO-ERROR.
        FIND pto-contr NO-LOCK WHERE pto-contr.cod-pto-contr = tt-comunic.cod-pto-contr NO-ERROR.

        IF NOT AVAIL itinerario THEN NEXT.
        IF NOT AVAIL pto-contr THEN NEXT.
        
    end.

    find embarque-imp NO-LOCK where 
         embarque-imp.cod-estabel = tt-comunic.cod-estabel AND
         embarque-imp.embarque = tt-comunic.embarque NO-ERROR.

    find first ordens-embarque of embarque-imp NO-LOCK NO-ERROR.

    ASSIGN c-comprador = "".
    IF AVAIL ordens-embarque THEN DO:
        find ordem-compra where ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
        find emitente no-lock
             where emitente.cod-emitente = ordem-compra.cod-emitente NO-ERROR.
        FIND FIRST comprador NO-LOCK
             WHERE comprador.cod-comprado = ordem-compra.cod-comprado NO-ERROR.
        IF AVAIL comprador THEN
            ASSIGN c-comprador = comprador.nome.
        ELSE
            ASSIGN c-comprador = IF AVAIL ordem-compra THEN ordem-compra.cod-comprado ELSE "".
    END.

    find itinerario  no-lock
         where itinerario.cod-itiner = tt-comunic.cod-itiner NO-ERROR.

    
    ASSIGN c-cod-conhecto-master = if embarque-imp.cod-conhecto-master <> "" THEN embarque-imp.cod-conhecto-master else ""
           c-nome-abrev          = IF AVAIL emitente THEN emitente.nome-abrev ELSE "".

    FIND pto-contr NO-LOCK WHERE pto-contr.cod-pto-contr = tt-comunic.cod-pto-contr NO-ERROR.

    PUT UNFORMATTED embarque-imp.cod-estabel ";"
                    embarque-imp.embarque ";"
                    c-cod-conhecto-master ";"
                    c-comprador ";"
                    c-nome-abrev ";"
                    itinerario.descricao ";"
                    string(tt-comunic.dt-ult-prev,"99/99/9999") ";"
                    string(today - tt-comunic.dt-ult-prev,">>>>>9") ";"
                    pto-contr.descricao SKIP.
end.


output close.

run pi-acompanhar in h-acomp (input "Enviando e-mail").

assign c-remetente = "ems@intelbras.com.br"
       c-descemail = "Segue em anexo relatorio com os embarques com pontos atrasados" + chr(10) + chr(13).


run piEnviaEmail (input c-remetente,
                  input c-destino,
                  input c-assunto,
                  input c-descemail,
                  input c-arquivo).

run pi-finalizar in h-acomp.

RETURN "ok".


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
             tt-envio2.destino           = tt-mail.Destinatario     /* Destinat rio       */
             tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */
             tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
             tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor rio */
             tt-envio2.formato           = "TEXTO".

      create tt-mensagem.
      assign tt-mensagem.seq-mensagem = 1
             tt-mensagem.mensagem     = tt-mail.Mensagem.
           
      run pi-execute2 in h-utapi019 (input  table tt-envio2,
                                     input  table tt-mensagem,
                                     output table tt-erros).

      DELETE PROCEDURE h-utapi019.
      ASSIGN h-utapi019 = ?.
           
      if can-find (first tt-erros) then
         return "NOK".
   end.
end procedure.


