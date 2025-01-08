/*****************************************************************************
**     Programa.........: esp/acr/ESFTP074rp.p
**     Descricao .......: Envia Email para clientes de SC
**     Versao...........: 1.00.000
**     Autor............: Cenci
**     Criado...........: 15/01/2013
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP074 2.04.00.001}

{esp/ftp/esftp074.i}
{utp/ut-glob.i}
{include/i-rpvar.i}
{cdp/cd0666.i}
{esinc/es0006.i}  /*** include com a procedure pi-busca-unid-negoc-item ***/
{utp/utapi019.i}

RUN utp/utapi019.p PERSISTENT SET h-utapi019.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF TEMP-TABLE  tt-emitente           
FIELD cod-emitente LIKE emitente.cod-emitente
INDEX ch-codigo cod-emitente.
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

def var h-acomp      as handle no-undo.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="0"}

FORM nota-fiscal.nr-nota-fis
    nota-fiscal.serie
   nota-fiscal.cod-estabel
   nota-fiscal.cod-emitente
   emitente.nome-emit
   emitente.e-mail 
   WITH FRAME f-detalhe WIDTH 232 64 DOWN STREAM-IO.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Envia e-mail para Clientes SC"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP074"
       c-versao       = "2.04"
       c-revisao      = "001".

/******** FAZ A CARGA DOS DADOS NA TABELA TEMPORARIA *******/
run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Calculando...").
  

run pi-acompanhar in h-acomp (input "Buscando Informa‡äes").


run pi-inicializar in h-acomp (input "Imprimindo...").
run pi-acompanhar in h-acomp (input "Imprimindo NFS").

for each nota-fiscal no-lock USE-INDEX ch-distancia
       where nota-fiscal.dt-emis-nota  >= tt-param.dt-emis-nota-ini
         and nota-fiscal.dt-emis-nota  <= tt-param.dt-emis-nota-fim
         and nota-fiscal.dt-cancela = ?
         AND nota-fiscal.estado = "SC":
    
       run pi-acompanhar in h-acomp (INPUT "Faturamento. Data: " + STRING(nota-fiscal.dt-emis-nota) + "   NF: " + nota-fiscal.nr-nota-fis). 
       
       find FIRST emitente 
            where emitente.cod-emitente = nota-fiscal.cod-emitente
            no-lock no-error.
       IF NOT AVAIL emitente THEN DO:
           RUN piCriaErro(INPUT 17006,
                          INPUT "NÆo Encontrado Cliente para a Nota.: " + nota-fiscal.nr-nota-fis + ".Favor Verificar").
            NEXT. 
       END.
      
       /*validando parametros selecao*/
       IF tt-param.cod-emitente <> 0 AND
          nota-fiscal.cod-emitente <> tt-param.cod-emitente THEN NEXT.
    
       IF INDEX(tt-param.cod-estabel,nota-fiscal.cod-estabel) = 0 THEN NEXT.
    
       FIND natur-oper
            WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
       IF AVAIL natur-oper
           AND natur-oper.tipo = 2 AND
          CAN-FIND(FIRST it-nota-fisc OF nota-fiscal NO-LOCK
                   WHERE it-nota-fisc.aliquota-icm = 10
                     AND it-nota-fisc.cd-trib-icm = 1) THEN DO:
          
          FIND FIRST int-emitente-historico
               WHERE int-emitente-historico.cod-emitente = nota-fiscal.cod-emitente
                 AND int-emitente-historico.sequencia = 9999
               EXCLUSIVE-LOCK NO-ERROR.
              
          IF NOT AVAIL int-emitente-historico THEN DO:
             CREATE int-emitente-historico.
             ASSIGN int-emitente-historico.cod-emitente = nota-fiscal.cod-emitente
                    int-emitente-historico.sequencia = 9999.
             RUN EnviaEmail.
          END.
          ELSE
              IF tt-param.reenvia THEN DO:
                  FIND tt-emitente
                      WHERE tt-emitente.cod-emitente = nota-fiscal.cod-emitente
                      NO-LOCK NO-ERROR.
                  IF NOT AVAIL tt-emitente  THEN DO:
                      CREATE tt-emitente.
                      ASSIGN tt-emitente.cod-emitente = nota-fiscal.cod-emitente.
                      RUN EnviaEmail.
                  END.
                  
              END.
           
       END.
       
END.
run pi-finalizar in h-acomp.
{include/i-rpclo.i}
RETURN "OK".



PROCEDURE EnviaEmail:

    EMPTY TEMP-TABLE tt-envio2.
    EMPTY TEMP-TABLE tt-mensagem.
    EMPTY TEMP-TABLE tt-erros.

    DEF VAR c-mensagem AS CHAR NO-UNDO.

    FOR FIRST param-global NO-LOCK: END.

    DISP nota-fiscal.nr-nota-fis
         nota-fiscal.serie
        nota-fiscal.cod-estabel
        nota-fiscal.cod-emitente
        emitente.nome-emit
        emitente.e-mail 
        WITH FRAME f-detalhe.
        DOWN WITH FRAME f-detalhe.


    IF NOTA-FISCAL.COD-ESTABEL = "101" THEN DO:
        ASSIGN c-mensagem           = 
            "<HTML> Para: " + emitente.nome-emit + " (" + STRING(emitente.cod-emitente) + ")" + "<BR>"  + "<BR>" +
            "A/C Depto Fiscal" + "<BR>"  + "<BR>" +
            "<font color='FF0000'> FAVOR CONFIRMAR O RECEBIMENTO DESTE E-MAIL. </font>" + "<BR>"  + "<BR>" +
            "<BR>" + "<B>COMUNICA€ÇO AO DESTINATµRIO - OBRIGA€ÇO DE ESTORNO</B>" + "<BR>"  + "<BR>" + 
            "<BR>" + "A empresa <B> INTELBRAS SA - INDéSTRIA DE TELEC. ELETR. BRASILEIRA</B>, inscrita no CNPJ sob o n§ 82.901.000/0001-27, Inscri‡Æo Estadual n§ 250.082.764, domiciliada na Rodovia BR 101, Km 210, S/N, Bairro µrea Industrial, em SÆo Jos‚/SC, em razÆo de tratamento tribut rio diferenciado concedido a este estabelecimento importador, informamos a V.S¦ que, relativamente aos documentos fiscais de sa¡da de mercadoria importada emitidos por este estabelecimento e remetidos para esse estabelecimento destinat rio, com destaque de imposto de 10% (dez por cento) sobre a base de c lculo, em decorrˆncia de diferimento parcial do ICMS, ou com utiliza‡Æo de redu‡Æo de base de c lculo que tenha resultado em destaque de imposto com al¡quota efetiva entre 4% (quatro por cento) e 10% (dez por cento), deve-se observar o seguinte:" + "<BR>" + 
            "<BR>" + "1. se esse estabelecimento destinat rio efetuar sa¡da da mercadoria recebida atrav‚s dos documentos fiscais acima referidos, em opera‡Æo sobre a qual incida a al¡quota de 4% (quatro por cento), esse estabelecimento destinat rio dever  estornar eventual saldo credor proporcional decorrente da entrada da referida mercadoria, apurado levando em considera‡Æo apenas os valores de cr‚dito e d‚bito correspondentes …s respectivas opera‡äes de entrada e sa¡da da mercadoria importada;" + "<BR>" + 
            "<BR>" + "2. A obriga‡Æo de estorno, calculado conforme indicado o item 1, aplica-se tamb‚m:" + "<BR>" + 
            "<BR>" + "&nbsp;&nbsp;&nbsp;2.1. caso a mercadoria, recebida atrav‚s dos documentos fiscais de sa¡da emitidos por este estabelecimento importador, acima referidos, venha a compor produto industrializado, sobre cuja sa¡da desse estabelecimento destinat rio incida a al¡quota de 4% (quatro por cento);" + "<BR>" + 
            "<BR>" + "&nbsp;&nbsp;&nbsp;2.2. caso a mercadoria, recebida atrav‚s dos documentos fiscais de sa¡da emitidos por este estabelecimento importador, acima referidos, ou o produto do qual esta fa‡a parte, venha a ser enviada(o) por esse estabelecimento destinat rio a qualquer estabelecimento do mesmo titular ou de empresa interdependente, situado no Estado, e, sobre a opera‡Æo de sa¡da promovida por tal estabelecimento incidir a al¡quota de 4% (quatro por cento);" + "<BR>" + 
            "<BR>" + "3. O estorno deve ser feito no mˆs em que ocorrer a sa¡da sobre a qual incida a al¡quota de 4% (quatro por cento);" + "<BR>" + 
            "<BR>" + "4. Deve-se manter, pelo prazo decadencial, relat¢rio mensal, preferencialmente sob a forma de planilha eletr“nica, correspondente …s opera‡äes que demandam o estorno de cr‚dito mencionado nesta comunica‡Æo, a fim de exibi-lo ao Fisco Estadual, quando solicitado." + "<BR><BR>" +
            "<font color='FF0000'> FAVOR CONFIRMAR O RECEBIMENTO DESTE E-MAIL. </font>".

    END.
    ELSE IF nota-fiscal.cod-estabel = "104" THEN DO:
            ASSIGN c-mensagem           = 
                "<HTML> Para: " + emitente.nome-emit + " (" + STRING(emitente.cod-emitente) + ")" + "<BR>"  + "<BR>" +
                "A/C Depto Fiscal" + "<BR>"  + "<BR>" +
                "<font color='FF0000'> FAVOR CONFIRMAR O RECEBIMENTO DESTE E-MAIL. </font>" + "<BR><BR>" + 
                "<BR>" + "<B>COMUNICA€ÇO AO DESTINATµRIO - OBRIGA€ÇO DE ESTORNO</B>" + "<BR><BR>" + 
                "<BR>" + "A empresa <B> INTELBRAS SA - INDéSTRIA DE TELEC. ELETR. BRASILEIRA</B>, inscrita no CNPJ sob o n§ 82.901.000/0014-41, Inscri‡Æo Estadual n§ 255.713.460, domiciliada na Rodovia SC 407, Km 4,5, S/N, Bairro SertÆo do Maruim, em SÆo Jos‚/SC, em razÆo de tratamento tribut rio diferenciado concedido a este estabelecimento importador, informamos a V.S¦ que, relativamente aos documentos fiscais de sa¡da de mercadoria importada emitidos por este estabelecimento e remetidos para esse estabelecimento destinat rio, com destaque de imposto de 10% (dez por cento) sobre a base de c lculo, em decorrˆncia de diferimento parcial do ICMS, ou com utiliza‡Æo de redu‡Æo de base de c lculo que tenha resultado em destaque de imposto com al¡quota efetiva entre 4% (quatro por cento) e 10% (dez por cento), deve-se observar o seguinte:" + "<BR>" + 
                "<BR>" + "1. se esse estabelecimento destinat rio efetuar sa¡da da mercadoria recebida atrav‚s dos documentos fiscais acima referidos, em opera‡Æo sobre a qual incida a al¡quota de 4% (quatro por cento), esse estabelecimento destinat rio dever  estornar eventual saldo credor proporcional decorrente da entrada da referida mercadoria, apurado levando em considera‡Æo apenas os valores de cr‚dito e d‚bito correspondentes …s respectivas opera‡äes de entrada e sa¡da da mercadoria importada;" + "<BR>" + 
                "<BR>" + "2. A obriga‡Æo de estorno, calculado conforme indicado o item 1, aplica-se tamb‚m:" + "<BR>" + 
                "<BR>" + "&nbsp;&nbsp;&nbsp;2.1. caso a mercadoria, recebida atrav‚s dos documentos fiscais de sa¡da emitidos por este estabelecimento importador, acima referidos, venha a compor produto industrializado, sobre cuja sa¡da desse estabelecimento destinat rio incida a al¡quota de 4% (quatro por cento);" + "<BR>" + 
                "<BR>" + "&nbsp;&nbsp;&nbsp;2.2. caso a mercadoria, recebida atrav‚s dos documentos fiscais de sa¡da emitidos por este estabelecimento importador, acima referidos, ou o produto do qual esta fa‡a parte, venha a ser enviada(o) por esse estabelecimento destinat rio a qualquer estabelecimento do mesmo titular ou de empresa interdependente, situado no Estado, e, sobre a opera‡Æo de sa¡da promovida por tal estabelecimento incidir a al¡quota de 4% (quatro por cento);" + "<BR>" + 
                "<BR>" + "3. O estorno deve ser feito no mˆs em que ocorrer a sa¡da sobre a qual incida a al¡quota de 4% (quatro por cento);" + "<BR>" + 
                "<BR>" + "4. Deve-se manter, pelo prazo decadencial, relat¢rio mensal, preferencialmente sob a forma de planilha eletr“nica, correspondente …s opera‡äes que demandam o estorno de cr‚dito mencionado nesta comunica‡Æo, a fim de exibi-lo ao Fisco Estadual, quando solicitado." + "<BR><BR>" +
                "<font color='FF0000'> FAVOR CONFIRMAR O RECEBIMENTO DESTE E-MAIL. </font>".

    END.

    create tt-envio2.
    assign tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail
           tt-envio2.porta             = param-global.porta-mail
           tt-envio2.remetente         = "clientes.sc@intelbras.com.br"
           tt-envio2.destino           = emitente.e-mail + ",clientes.sc@intelbras.com.br" 
           tt-envio2.assunto           = "COMUNICA€ÇO AO DESTINATµRIO - OBRIGA€ÇO DE ESTORNO"
           tt-envio2.formato           = "HTML"
           tt-envio2.exchange          = NO.

    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem = c-mensagem.

    RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,
                                   INPUT TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).

    if  return-value = "NOK" 
    AND AVAIL tt-erros then 
        RUN pi-cria-erro (106,"Erro na rotina de gera‡Æo autom tica de email "). 

END.
