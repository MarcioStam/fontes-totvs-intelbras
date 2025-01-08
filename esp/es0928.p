/*****************************************************************************
**
**   Programa:  es0928.p
**
**   Funcao:  Relatorio de saldo em terceiros pendente
**
**   Data:  30/09/2003
**
**   Autor:  Claudiney Klitzke  - INTELBRAS S/A.
**
******************************************************************************/

/* run cralias2.p. */

{cdp/cd9500.i} /* variaveis do cabecalho de impressao */
def var c-programa as char.
def var l-xxxtmp as log.

assign c-programa     = "ES/0928".

/********** INCLUDES PADROES         ***************************************/   

def buffer b-comp for componente.
def var c-desc    as char format "X(36)".


/* {esp/es0002.i} /* Controle de permissoes */ */

{esp/es0006a.i} /* Definicao de variaveis para relatorio html */
{esp/es0006.i} /* Controle para geracao de relatorio em html */
{utp/utapi019.i}
{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

DEFINE STREAM sTerminal.
def temp-table tt-erro no-undo
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char format "x(255)".


def temp-table tt-notas
    field nro-docto       like saldo-terc.nro-docto
    field serie           like saldo-terc.serie
    field nat-operacao    like saldo-ter.nat-operacao
    field denominacao     like natur-oper.denominacao
    field it-codigo       as char format "X(7)"
    field descricao       as char format "X(36)"
    field cod-emitente    like saldo-terc.cod-emitente
    field nome-abrev      like emitente.nome-abrev
    field dt-retorno      like componente.dt-retorno
    field quantidade      like saldo-terc.quantidade
    field valor           as dec format "->>>,>>>,>>9.99"
    field usuario-magnus  like ped-fiscal.usuario-magnus
    field e-mail          like usuar_mestre.cod_e_mail_local
    field observ-nota     like nota-fiscal.observ-nota
    field enviados        as log
    index tt-notas is primary usuario-magnus nro-docto serie nat-operacao it-codigo.

for each saldo-terc no-lock
    where saldo-terc.quantidade <> 0
      and saldo-terc.nat-operacao <> "694930"
      and saldo-terc.nat-operacao <> "594930"
      and saldo-terc.nat-operacao <> "694951"
      and saldo-terc.nat-operacao <> "594951"
      and saldo-terc.nat-operacao <> "594927"
      and saldo-terc.nat-operacao <> "694927"
      and saldo-terc.nat-operacao <> "594940"
      and saldo-terc.nat-operacao <> "694941",
    first emitente no-lock 
          where emitente.cod-emitente = saldo-terc.cod-emitente,
    first mgind.item no-lock 
          where item.it-codigo = saldo-terc.it-codigo,
    first natur-oper no-lock 
          where natur-oper.nat-operacao = saldo-terc.nat-operacao:
              
    find first componente of saldo-terc no-lock 
         where componente.componente = 1 no-error.
    IF NOT AVAIL componente THEN NEXT.

    find first nota-fiscal no-lock
         where nota-fiscal.nr-nota-fis = saldo-terc.nro-docto
           and nota-fiscal.serie       = "3"
           and nota-fiscal.cod-estabel = saldo-terc.cod-estabel
         no-error.
    if not avail nota-fiscal then
       find first nota-fiscal no-lock
            where nota-fiscal.nr-nota-fis = saldo-terc.nro-docto
              and nota-fiscal.serie       = "1"
              and nota-fiscal.cod-estabel = saldo-terc.cod-estabel
            no-error.

    if componente.narrativa <> "" then
       assign c-desc = componente.narrativa.
    else
       assign c-desc = item.descricao-1 + item.descricao-2.
               
    find first ped-fiscal no-lock where
         ped-fiscal.cod-estabel = saldo-terc.cod-estabel AND
         ped-fiscal.serie       = nota-fiscal.serie      AND
         ped-fiscal.nr-nota-fis = saldo-terc.nro-docto no-error.
                 
    if avail ped-fiscal then do:
      find first usuar_mestre no-lock 
           where usuar_mestre.cod_usuario = ped-fiscal.usuario-magnus no-error.
    end.

    if componente.dt-retorno <= today - 160 then do:
       create tt-notas.
       assign tt-notas.nro-docto    = saldo-terc.nro-docto
              tt-notas.serie        = saldo-terc.serie
              tt-notas.nat-operacao = saldo-terc.nat-operacao 
              tt-notas.denominacao  = natur-oper.denominacao 
              tt-notas.it-codigo    = saldo-terc.it-codigo 
              tt-notas.descricao    = c-desc
              tt-notas.cod-emitente = saldo-terc.cod-emitente
              tt-notas.nome-abrev   = emitente.nome-abrev     
              tt-notas.dt-retorno   = componente.dt-retorno   
              tt-notas.quantidade   = saldo-terc.quantidade   
              tt-notas.valor        = saldo-terc.valor[1] *
                                      saldo-terc.quantidade 
              tt-notas.usuario-magnus =  if avail ped-fiscal then
                                           ped-fiscal.usuario-magnus
                                        else
                                            " "
              tt-notas.e-mail         = if avail usuar_mestre then
                                           usuar_mestre.cod_e_mail_local
                                        else
                                           " "
              tt-notas.enviados       = if avail usuar_mestre then
                                           yes
                                        else
                                           no
              tt-notas.observ-nota = if avail nota-fiscal then
                                           nota-fiscal.observ-nota 
                                        else
                                           " ".
    end.
end.

/****** ENVIA E-MAIL PARA OS RESPONSAVEIS PELO SALDO EM TERCEIROS ****/
for each tt-notas where
    tt-notas.e-mail <> "" 
    break by tt-notas.usuario-magnus
          by tt-notas.cod-emitente
          by tt-notas.nro-docto:
    
    if first-of(tt-notas.usuario-magnus) then do:
       
       //ASSIGN c-Arquivo = SESSION:TEMP-DIRECTORY + "saldo-terc.htm"
       ASSIGN c-Arquivo = c-dir-arquivo-session + "saldo-terc.htm"
              c-texto-html = "".

       OUTPUT TO VALUE(c-Arquivo) CONVERT TARGET "iso8859-1".


       assign c-texto-html[1] = "Prezado Colaborador, " + chr(13) + "                                                                                                                                                                                               "
              c-texto-html[2] = "Favor providenciar junto ao fornecedor ou cliente a devolucao das notas fiscais em anexo, pois de acordo com a legislacao tributaria, essas mercadorias tem um prazo de 180 dias a partir da emissao da nota fiscal para retornar a Intelbras, caso nao retorne devera ser recolhido os devidos impostos ( ICMS e IPI ) SENDO ALOCADO AO CENTRO DE CUSTO DO SOLICITANTE.                                                                                                                                                                                                                                                                                                      "
              c-texto-html[3] = "Lembramos que mensalmente sera encaminhado e-mail com posicao atualizada das notas fiscais que ainda se encontram pendentes, para devidas providencias. " + chr(13) + "                                                                                                                                                            "      
              c-texto-html[4] = "Duvidas entre em contato com a Controladoria. " + chr(13) + "                                                                                                                                            "
              c-texto-html[5] = "Aguardamos retorno. " + chr(13) + "                                                                                                                                                                            "
              c-texto-html[6] = "" 
              c-texto-html[7] = ""
              c-texto-html[8] = "Controladoria"
              c-texto-html[9] = "grupo.contabil@intelbras.com.br"
              c-tam-tab       = "1500".
       
       run html-inicio("Saldo em poder de terceiros PENDENTE").
 
       assign c-tit-html = "Aguardando retorno de saldo em poder de terceiros PENDENTE a mais de 160 dias".

       run html-titulo(c-tit-html).
               
       run html-ini-tab.             
    
       run html-ini-lin-tab.           

       run html-cab-tab("Docto").    
       run html-cab-tab("Ser").    
       run html-cab-tab("Nat Op").    
       run html-cab-tab("Descricao").    
       run html-cab-tab("Item").    
       run html-cab-tab("Descricao").
       run html-cab-tab("Fornec").
       run html-cab-tab("Nome Abrev").
       run html-cab-tab("Dt Envio").
       run html-cab-tab("Qtde").    
       run html-cab-tab("Valor").    
       run html-cab-tab("Usuario").    
       run html-cab-tab("Observacao").    
       run html-fim-lin-tab.          
    end.
    
    run html-ini-lin-tab.
    run html-con-tab(tt-notas.nro-docto, "right").
    run html-con-tab(tt-notas.serie, "left").
    run html-con-tab(tt-notas.nat-operacao, "left").
    run html-con-tab(tt-notas.denominacao, "left").
    run html-con-tab(tt-notas.it-codigo, "left").
    run html-con-tab(tt-notas.descricao, "left").
    run html-con-tab(tt-notas.cod-emitente, "right").
    run html-con-tab(tt-notas.nome-abrev, "left").
    run html-con-tab(tt-notas.dt-retorno, "left").
    run html-con-tab(tt-notas.quantidade, "right").
    run html-con-tab(tt-notas.valor, "right").
    run html-con-tab(tt-notas.usuario-magnus, "left").
    run html-con-tab(tt-notas.observ-nota, "left").

    if last-of(tt-notas.usuario-magnus) then do:
       output close.

       assign c-endereco = tt-notas.e-mail 
              c-assunto = "Saldo em poder de terceiros PENDENTE".
       
       RUN piEnviaEmail(INPUT "grupo.contabil@intelbras.com.br",
                        INPUT c-endereco,
                        INPUT c-assunto,
                        INPUT c-assunto,
                        INPUT c-arquivo).
   end.
end.
   
/****** ENVIA RELATORIO COMPLETO PARA grupo.contabil,LUCIANO E SUELEN ******/
for each tt-notas where
    break by tt-notas.enviados
          by tt-notas.cod-emitente
          by tt-notas.nro-docto:
    
    if first(tt-notas.enviados) then do:

       //ASSIGN c-Arquivo = SESSION:TEMP-DIRECTORY + "saldo-terc.htm"
       ASSIGN c-Arquivo = c-dir-arquivo-session + "saldo-terc.htm"
              c-texto-html = "".

       OUTPUT TO VALUE(c-Arquivo) CONVERT TARGET "iso8859-1".
              
       assign c-texto-html[1] = "Anexo relatorio geral de saldos em poder de terceiros PENDENTE"
              c-tam-tab       = "1500".
    
       run html-inicio("Relatorio de saldo em poder de terceiros PENDENTE").

    end.
       
    if first-of(tt-notas.enviados) then do:   
    
       assign c-tit-html = if tt-notas.enviados then
                              "Enviados"
                           else
                              "Nao enviados".

       run html-titulo(c-tit-html).
               
       run html-ini-tab.             
    
       run html-ini-lin-tab.           

       run html-cab-tab("Docto").    
       run html-cab-tab("Ser").    
       run html-cab-tab("Nat Op").    
       run html-cab-tab("Descricao").    
       run html-cab-tab("Item").    
       run html-cab-tab("Descricao").
       run html-cab-tab("Fornec").
       run html-cab-tab("Nome Abrev").
       run html-cab-tab("Dt Envio").
       run html-cab-tab("Qtde").    
       run html-cab-tab("Valor").    
       run html-cab-tab("Usuario").    
       run html-cab-tab("Observacao").    
       run html-fim-lin-tab.          
    end.
    
    run html-ini-lin-tab.
    run html-con-tab(tt-notas.nro-docto, "right").
    run html-con-tab(tt-notas.serie, "left").
    run html-con-tab(tt-notas.nat-operacao, "left").
    run html-con-tab(tt-notas.denominacao, "left").
    run html-con-tab(tt-notas.it-codigo, "left").
    run html-con-tab(tt-notas.descricao, "left").
    run html-con-tab(tt-notas.cod-emitente, "right").
    run html-con-tab(tt-notas.nome-abrev, "left").
    run html-con-tab(tt-notas.dt-retorno, "left").
    run html-con-tab(tt-notas.quantidade, "right").
    run html-con-tab(tt-notas.valor, "right").
    run html-con-tab(tt-notas.usuario-magnus, "left").
    run html-con-tab(tt-notas.observ-nota, "left").
    run html-fim-lin-tab.

    if last-of(tt-notas.enviados) then 
       run html-fim-tab.
    if last(tt-notas.enviados) then do:
       output close.

       FOR EACH tt-prog-ponto:
           DELETE tt-prog-ponto.
       END.

       RUN esp/es0018p.p (INPUT "es0928",
                          INPUT 1, 
                          INPUT 0,
                          INPUT "", 
                          OUTPUT TABLE tt-prog-ponto).

       ASSIGN c-endereco = "".

       for each tt-prog-ponto:
           ASSIGN c-endereco = c-endereco + tt-prog-ponto.conteudo + ",".
       END.

       assign c-assunto = "Saldo em poder de terceiros PENDENTE".
      
       RUN piEnviaEmail(INPUT "ems@intelbras.com.br",
                        INPUT c-endereco,
                        INPUT c-assunto,
                        INPUT c-assunto,
                        INPUT c-arquivo).
/*
       FOR EACH tt-erro:
            MESSAGE tt-erro.mensagem
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
       END.
 */
   end.
end.

PROCEDURE piEnviaEmail:
    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK: END.    

    RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    

    FOR EACH tt-envio2.   DELETE tt-envio2.   END.
    FOR EACH tt-mensagem. DELETE tt-mensagem. END.

    CREATE tt-envio2.
    ASSIGN tt-envio2.versao-integracao = 1
           tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
           tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
           tt-envio2.destino           = pdestino                 /* Destinat rio       */ 
           tt-envio2.remetente         = pRemetente               /* Remetente          */ 
           tt-envio2.assunto           = pAssunto                 /* Assunto            */
           tt-envio2.arq-anexo         = pArquivo                 /* Arquivo Tempor rio */
           tt-envio2.formato           = "TEXTO".
    CREATE tt-mensagem.
    ASSIGN tt-mensagem.seq-mensagem = 1
           tt-mensagem.mensagem     = pDescEmail.          /* Mensagem           */


    RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                   INPUT  TABLE tt-mensagem,
                                   OUTPUT TABLE tt-erros).
    FOR EACH tt-erros:
        CREATE tt-erro.
        ASSIGN iCont             = iCont + 1
               tt-erro.i-sequen  = iCont
               tt-erro.cd-erro   = tt-erros.cod-erro
               tt-erro.mensagem  = tt-erros.desc-erro + tt-erros.desc-arq.
    END.
 
    DELETE PROCEDURE h-utapi019.

END PROCEDURE.

