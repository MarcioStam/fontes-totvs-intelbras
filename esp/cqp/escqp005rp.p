{include/i-prgvrs.i ESCQP005 2.04.00.000}
/***********************************************************************
**  Programa..: ESP\CPP\ESCQP003RP.P
**  Autor.....: Giovane Oliveira
**  Data......: OUTUBRO/2005 - Desenvolvimento
**  Descricao.: Relat¢rio de Seqˆncias de AE
**  VersÆo....: 001 06/10/2005
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/cqp/escqp005tt.i}
{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

/****************************  Temp-Tables  ****************************/
/****************************  Vari veis    ****************************/
def var c-today as date initial TODAY NO-UNDO.
def var i-nr-ae     like  ae-inspecao.nr-ae NO-UNDO.
def var i-nr-ficha  like  ficha-cq.nr-ficha NO-UNDO.
def var i-emitente  like  ficha-cq.cod-emit NO-UNDO.
def var c-emitente  like  emitente.nome-emit format "x(60)" NO-UNDO.
def var c-fone      like  emitente.telefax NO-UNDO.
def var c-fax       like  emitente.telefax NO-UNDO.
def var c-mail-for  as   char format "x(60)" NO-UNDO.
def var c-mail-comp as char format "x(60)" NO-UNDO.
def var i-nota      like  ficha-cq.nro-docto NO-UNDO.
def var c-serie     like  ficha-cq.serie NO-UNDO.
def var c-nat-operacao like  ficha-cq.nat-operacao NO-UNDO.
def var d-emissao   like  docum-est.dt-emissao NO-UNDO.
def var d-entrada   like  docum-est.dt-trans   NO-UNDO.
def var d-inspecao  like  ficha-cq.dt-inspecao NO-UNDO.
def var c-it-codigo like  item.it-codigo NO-UNDO.
def var c-descricao as c format "x(36)" NO-UNDO.
def  var i-al-ipi like item-doc-est.aliquota-ipi NO-UNDO.
def  var i-al-icm like item-doc-est.aliquota-icm NO-UNDO.
def var i-recebida  like  ficha-cq.qt-original NO-UNDO.
def var i-aprovada  like  ficha-cq.qt-aprovada NO-UNDO.
def var i-apr-cond  like  ficha-cq.qt-apr-cond NO-UNDO.
def var i-rejeitada like  ficha-cq.qt-rejeitada NO-UNDO.
def var de-val-unit as    dec format ">>,>>9.9999" NO-UNDO.
def var i-cod-rej   like cod-rejeicao.codigo-rejei NO-UNDO.
def var c-cod-rej   like cod-rejeicao.descricao NO-UNDO.
def var c-cod-depos as char format "x(16)" NO-UNDO.
DEF VAR c-remetente AS CHAR NO-UNDO.

DEFINE VARIABLE c-pedido   AS CHARACTER FORMAT "x(60)"    NO-UNDO.
DEFINE VARIABLE c-embarque AS CHARACTER FORMAT "x(60)"    NO-UNDO.
DEFINE VARIABLE c-invoice  AS CHARACTER FORMAT "x(60)"    NO-UNDO.



/********** DEFINICAO DE STREAMS     ****************************************/
/********** DEFINICAO DE TEMP-TABLES ****************************************/
/********** DEFINICAO DE BUFFERS     ****************************************/


/****************************  Frames       ****************************/
form
"PS-AQU-7.4.3 "
"Intelbras S/A"
c-today format "99/99/99" at 70 skip
"E.Q.F.                             Nr. AE: " i-nr-ae   "  Roteiro: " i-nr-ficha 
skip
      "
------------------------------------------------------------------------------"
skip
"                            RELATàRIO DE INSPE€ÇO                            "
skip
"------------------------------------------------------------------------------"
skip
"Fornecedor   : " i-emitente "-" c-emitente 
skip
"Fone:"    c-fone   "Fax:"  c-fax skip
"e-mail:" c-mail-for 
skip(1)
     
"NF: "  i-nota
"S‚rie: "  c-serie
"Natureza: "  c-nat-operacao
"EmissÆo: "   d-emissao     SKIP
skip(1)
"Data da Entrada  : " d-entrada SKIP
"Data da Inspe‡Æo : " d-inspecao
skip(1)

"Item : " c-it-codigo format "x(7)" c-descricao "-" item.un " - CF:" 
item.class-fiscal "ICMS/IPI" i-al-icm
"-" i-al-ipi skip(1)

skip(1)

"Qtd. Recebida :" i-recebida 
"        Valor Unit rio:" de-val-unit
skip
"Qtd. Aprovada :" i-aprovada 
"   Qtd. Aprovada Cond.:" i-apr-cond 
skip
"Qtd. Rejeitada:" i-rejeitada 
skip
"Cod.  Rejei‡Æo:" i-cod-rej " - " c-cod-rej skip
"Dep¢sito:" c-cod-depos
skip(1)
"O produto foi inspecionado segundo a norma NBR 5426" 
skip(1)
"Plano Amostra: Simples   N¡vel: S4   NQA:0,40  Inspe‡Æo: Comum" skip
"(crit‚rios de amostragem podem ser alterados em fun‡Æo do hist¢rico de" skip
"fornecimento)." skip(1)
/*
"Duplicatas:                                   Comprador: " item.cod-comprado
*/
"Comprador: " item.cod-comprado SKIP
"   Pedido: " c-pedido   SKIP
" Embarque: " c-embarque SKIP
"  Invoice: " c-invoice
     with  /* page-top */ no-label frame f-cabecalho STREAM-IO.
     
form 
"================= R E S U L T A D O   D A   I N S P E C A O ================"
skip
    with no-label frame f-resultado.


form 
"INSPETOR(A):"
skip(1)
"============================================================================"
skip
"                                              ATEN€ÇO"  skip
"                            INSTRU€OES AO FORNECEDOR" skip(1)
"FAVOR ANALISAR AS CAUSAS DA NÇO CONFORMIDADE E ENVIAR RELATàRIO DE A€ÇO"
"CORRETIVA · INTELBRAS PARA O SETOR DE EQF " skip
"(indicando o nr. do Roteiro de Inspe‡Æo correspondente)."
/*skip(1)
"Por fax: (48)281-9637" skip
"Por e-mail: eqf@intelbras.com.br" 
    skip(2)  */
/* "Anexo B PS-2-EQF-4.10-1                                               REV 00"
    skip
    "Data 04.05.00"
   */
   with no-label frame f-fornecedor PAGE-BOTTOM  STREAM-IO.
   
form 
"Valor Total do Item:______________ Valor Total da Nota:__________________"
SKIP(1)
"Cod.Cliente: _____________________ Transportadora: _______________________"
skip(1)
"Frete: ( ) Pago  ( ) A Pagar   Nat.Oper.:______ NFS _______ Data __/__/____" 
with no-labels frame f-nota  STREAM-IO.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = ""
       c-empresa      = v_cod_empres_usuar /*if avail empresa then empresa.razao-social else ''*/
       c-programa     = "ESCQP005"
       c-versao       = "2.04"
       c-revisao      = "000".


/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i}

    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */

   run utp/ut-acomp.p persistent set h-acomp.  

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   IF tt-param.destino = 4 THEN DO:

       find usuar_mestre no-lock
            where usuar_mestre.cod_usuario = c-seg-usuario no-error.

      if avail usuar_mestre then 
           c-remetente = usuar_mestre.cod_e_mail_local.

      IF NOT AVAIL usuar_mestre OR c-remetente = "" THEN

           c-remetente = "intelbras@intelbras.com.br".

       RUN piEnviaEmail (INPUT c-remetente,
                         INPUT tt-param.enderecos,
                         INPUT "Intelbras - Inspe‡Æo",
                         INPUT "Verifique o arquivo anexo",
                         INPUT tt-param.arquivo).
   END.
                         .
   RETURN "OK".
end.




/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    
    FOR FIRST tt-param:
        
        ASSIGN i-nr-ficha  = tt-param.nr-ficha
               i-recebida  = 0
               i-aprovada  = 0
               i-apr-cond  = 0
               i-rejeitada = 0.

        find first ae-inspecao where ae-inspecao.nr-ficha = i-nr-ficha no-lock no-error.

        if avail ae-inspecao then do:

            assign i-nr-ae = ae-inspecao.nr-ae.  

            find first ae-item
                where ae-item.cod-estabel = ae-inspecao.cod-estabel
                and   ae-item.it-codigo   = ae-inspecao.it-codigo
                and   ae-item.roteiro     = i-nr-ficha no-lock no-error.

            if avail ae-item then 
                assign c-cod-depos = ae-item.cod-depos + "-" + ae-item.localizacao.
            else 
                assign c-cod-depos = "".

        end.

        find FIRST ficha-cq
            where ficha-cq.nr-ficha = i-nr-ficha no-lock no-error.

        assign  i-recebida  = i-recebida  + ficha-cq.qt-original
                i-aprovada  = i-aprovada  + ficha-cq.qt-aprovada
                i-apr-cond  = i-apr-cond  + ficha-cq.qt-apr-cond
                i-rejeitada = i-rejeitada + ficha-cq.qt-rejeitada.

        find FIRST emitente 
            where emitente.cod-emitente = ficha-cq.cod-emitente no-lock no-error.

        find first cont-emit
            where cont-emit.cod-emitente = emitente.cod-emitente no-lock no-error.

        if avail cont-emit then 
            assign c-mail-for = cont-emit.e-mail.
        else 
            assign c-mail-for = "".

        FIND FIRST item 
            where item.it-codigo = ficha-cq.it-codigo no-lock no-error.

        assign i-cod-rej = 0
               c-cod-rej = "".

        FIND FIRST rej-ficha NO-LOCK
             WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha NO-ERROR.
        IF AVAIL rej-ficha THEN DO:
           find FIRST cod-rejeicao 
               where cod-rejeicao.codigo-rejei =  rej-ficha.codigo-rejei no-lock no-error.
           
           if avail cod-rejeicao then
               assign i-cod-rej = cod-rejeicao.codigo
                      c-cod-rej = cod-rejeicao.descricao.
        END.

        find FIRST docum-est
            WHERE docum-est.serie-docto  = ficha-cq.serie   
            AND   docum-est.nro-docto    = ficha-cq.nro-docto     
            AND   docum-est.cod-emitente = ficha-cq.cod-emitente  
            AND   docum-est.nat-operacao = ficha-cq.nat-operacao no-lock no-error.

        IF AVAIL docum-est THEN DO:
            
            ASSIGN c-embarque = substring(docum-est.char-1,1,12)
                   c-invoice  = "".

            IF c-embarque <> "" THEN DO:

                FOR EACH invoice-emb-imp NO-LOCK
                    WHERE invoice-emb-imp.cod-estabel = docum-est.cod-estabel
                    AND   invoice-emb-imp.embarque    = c-embarque:

                    IF c-invoice = "" THEN
                        ASSIGN c-invoice = invoice-emb-imp.nr-invoice.
                    ELSE
                        ASSIGN c-invoice = c-invoice + " , " + invoice-emb-imp.nr-invoice.

                END.

            END.

        END.
             
        find first item-doc-est
            where item-doc-est.cod-emitente = ficha-cq.cod-emitente  
            AND   item-doc-est.serie-docto  = ficha-cq.serie   
            AND   item-doc-est.nro-docto    = ficha-cq.nro-docto     
            AND   item-doc-est.nat-operacao = ficha-cq.nat-operacao  
            AND   item-doc-est.it-codigo    = ficha-cq.it-codigo no-lock no-error.

        if avail item-doc-est THEN DO:

            assign de-val-unit = item-doc-est.preco-total[1] / item-doc-est.quantidade 
                   i-al-icm    = item-doc-est.aliquota-icm
                   i-al-ipi    = item-doc-est.aliquota-ipi
                   d-emissao   = docum-est.dt-emissao
                   d-entrada   = docum-est.dt-trans.

            ASSIGN c-pedido   = STRING(item-doc-est.num-pedido).

        END.

        if not avail docum-est then do:

            find FIRST doc-fisico
                where doc-fisico.cod-emitente = ficha-cq.cod-emitente  
                and doc-fisico.serie-docto  = ficha-cq.serie
                and doc-fisico.nro-docto    = ficha-cq.nro-docto no-lock no-error.

            if avail doc-fisico then 
                assign d-emissao = doc-fisico.dt-emissao
                       d-entrada = doc-fisico.dt-trans.

        end.

        assign i-emitente     = ficha-cq.cod-emitente
               c-emitente     = emitente.nome-emit
               c-fone         = emitente.telefone[1]
               c-fax          = emitente.telefax
               i-nr-ficha     =  ficha-cq.nr-ficha
               i-nota         = ficha-cq.nro-docto
               c-serie        = ficha-cq.serie
               c-nat-operacao = ficha-cq.nat-operacao
               d-inspecao     = ficha-cq.dt-inspecao
               c-it-codigo    = ficha-cq.it-codigo 
               c-descricao    = item.descricao-1 + item.descricao-2.

        disp i-emitente 
             c-emitente
             c-fone
             c-fax
             i-nr-ficha
             i-nota
             c-serie
             c-nat-operacao
             d-inspecao
             c-it-codigo
             c-descricao
             i-nr-ae
             c-mail-for
             d-emissao
             d-entrada
             d-inspecao
             i-recebida
             i-aprovada
             i-apr-cond
             i-rejeitada
             i-cod-rej
             c-cod-rej
             item.cod-comprado
             c-pedido
             c-embarque
             c-invoice
             item.un
             item.class-fiscal
             i-al-icm
             i-al-ipi
             de-val-unit
             c-cod-depos
            with frame f-cabecalho.

        view frame f-resultado.

        if ficha-cq.narrativa <> "" then
            put ficha-cq.narrativa skip.
        else 
            put " " skip.   

        IF i-rejeitada > 0 THEN 
            PUT  "		________________________________________________________"skip
                 "		********************************************************"skip
                 "		*   _____   ___   ___          ___   ___         ___   *"skip        
                 "		*  |  _  | |     |     |   |  |     |   |     | |   |  *"skip      
                 "		*  | |_| | |     |     |   |  |     |   |     | |   |  *"skip                
                 "		*  |  ___| |___  |     |   |   __   |___|  ___| |   |  *"skip                         
                 "		*  |  \    |     |     |   |     |  |   | |   | |   |  *"skip                         
                 "		*  |   \   |     |     |   |     |  |   | |   | |   |  *"skip                        
                 "		*  |    \  |___  |___  |___|  ___|  |   | |___| |___|  *"skip                                 
                 "		*                                                      *"skip
                 "		********************************************************"SKIP SKIP.

        view frame f-fornecedor.

    END.

END.

{utp/utapi019.i}

PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEF VAR c-linha AS CHAR NO-UNDO.

    DEF VAR c-arq-saida AS CHAR NO-UNDO.


    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    
    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.
    
    FOR FIRST param-global NO-LOCK:
    END.
    
    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pDestino     /* Destinatÿrio       */ 
           tt-envio2.remetente         = pRemetente        /* Remetente          */ 
           tt-envio2.assunto           = pAssunto          /* Assunto            */
           tt-envio2.arq-anexo         = ""          /* Arquivo Temporÿrio */
           tt-envio2.formato           = "TEXTO".
    
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = "". /* Mensagem           */
                
    /* Por solicita‡Æo do usu ria Renata em 08/02/06 */
    INPUT FROM VALUE(pArquivo) CONVERT SOURCE SESSION:CHARSET.
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        ASSIGN tt-mensagem.mensagem = tt-mensagem.mensagem + c-linha + "~n".
    END.
    OUTPUT CLOSE.
    
    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    IF CAN-FIND(FIRST tt-erros) THEN DO:

        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT  IF OPSYS = "UNIX":U THEN "SPOOL-UNIX":U ELSE "SPOOL-WIN":U,
                           INPUT  1,
                           INPUT  0,
                           INPUT  "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-arq-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U) + "/erros-email.LOG".
        END.

        OUTPUT TO VALUE(c-arq-saida).
    
        FOR EACH tt-erros:
            DISP tt-erros.cod-erro
                 tt-erros.desc-erro + tt-erros.desc-arq WITH STREAM-IO.
        END.

        OUTPUT CLOSE.
    
    END.

    DELETE PROCEDURE h-utapi019.

    ASSIGN h-utapi019 = ?.

END.
