/********************************************************************************
 ** UPC........: wad098.p - UPC WRITE emitente
 ** Data.......: Novembro / 2004
 ** Objetivo...: Repassa inclus‰es e modificaá‰es de emitente para a Base Oracle
 ********************************************************************************/
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usuario Corrente"
    column-label "Usuario Corrente"
    no-undo. 

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.
   
DEF PARAM BUFFER b-emitente      FOR emitente.
DEF PARAM BUFFER b-old-emitente  FOR emitente.

DEF TEMP-TABLE tt-emitente NO-UNDO LIKE emitente.

EMPTY TEMP-TABLE tt-emitente.

CREATE tt-emitente.
BUFFER-COPY b-emitente TO tt-emitente.

DEFINE VAR cRemetente    AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDestino      AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CAssunto      AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR CDescEmail    AS CHAR FORMAT 'x(2000)' NO-UNDO.
DEFINE VAR CArqEmail     AS CHAR FORMAT 'x(60)'   NO-UNDO.
DEFINE VAR level         AS INT  INITIAL 1.

DEFINE VARIABLE v_num_cont AS INTEGER     NO-UNDO.
DEFINE VARIABLE ctrace     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-rua  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comp AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cChangedFields      AS CHARACTER  NO-UNDO.

{esapi/esapi010tt.i} /****** TEMP-TABLE tt-email *****/
{utp/utapi019.i} 

/*
{esp/crm/escrm001.i}
{esp/crm/escrm001a.i1}
*/
/* {esp/es0018.i} */

DEFINE VARIABLE c-array        AS CHARACTER  NO-UNDO EXTENT 36
             INIT [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
                    "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1",
                    "2", "3", "4", "5", "6", "7", "8", "9" ].

{esp/es4950.i19}.

DEFINE VARIABLE c-arquivo-log1 AS CHARACTER   NO-UNDO.

/*
run esp/es0669.p (input "yes", 
                  "emitente", 
                  string(b-emitente.cod-emitente,"999999999"),
                  "", "", "", "", "", "", "", "").
*/
IF AVAIL b-emitente THEN
    ASSIGN b-emitente.ind-abrange-aval = 2. /* Por solicitaá∆o financeiro 05/12/2013 */

IF NEW(b-emitente) THEN DO:
    FIND FIRST para-fat NO-LOCK NO-ERROR.
    IF AVAIL para-fat THEN
        ASSIGN b-emitente.tip-cob-desp = para-fat.tip-cob-desp.
END.

IF NEW(b-emitente) THEN DO:

    IF b-emitente.mod-prefer  = 0 THEN ASSIGN b-emitente.mod-prefer  = 1.
    IF b-emitente.portador    = 0 THEN ASSIGN b-emitente.portador    = 999. 
    IF b-emitente.modalidade  = 0 THEN ASSIGN b-emitente.modalidade  = 6.
    IF b-emitente.port-prefer = 0 THEN ASSIGN b-emitente.port-prefer = 0.
    IF b-emitente.mod-prefer  = 0 THEN ASSIGN b-emitente.mod-prefer  = 1.

END.

IF b-emitente.ind-cre-cli <> 2 THEN DO:

    FIND FIRST ponto-programa NO-LOCK 
         WHERE ponto-programa.nome-programa = "escdp005":U
           AND ponto-programa.ponto         = 1 NO-ERROR.

    IF AVAILABLE ponto-programa THEN DO:  /* chamado 79803*/
        IF CAN-FIND (FIRST conteudo-programa
                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                       AND conteudo-programa.conteudo     = string(b-emitente.cod-emitente)) THEN DO:

            ASSIGN b-emitente.ind-cre-cli = 2.
            
            IF OPSYS <> "UNIX":U THEN
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 17006,
                                   INPUT "Clientes de OEM n∆o podem ser diferentes de autom†tico.~~Situá∆o do cliente foi alterado para autom†tico. ES0018: ESCDP005 - 1":U).

        END.
    END.
END.

IF AVAIL b-emitente AND
   AVAIL b-old-emitente and
    b-emitente.cod-rep <> b-old-emitente.cod-rep THEN DO:
    FOR EACH canal-cliente EXCLUSIVE-LOCK
       WHERE canal-cliente.cod-emitente   = b-emitente.cod-emitente:

        IF canal-cliente.cod-transp <> b-emitente.cod-transp  THEN
            ASSIGN canal-cliente.cod-transp = b-emitente.cod-transp.

        IF canal-cliente.cod-rep <> b-emitente.cod-rep  THEN
            ASSIGN canal-cliente.cod-rep = b-emitente.cod-rep.
    END.
END.
               
/* Comentado conforme chamado 126827
IF b-emitente.identific        > 1 and
   b-emitente.natureza         = 1   and
   b-old-emitente.cod-emitente = 0   and
   b-old-emitente.cgc          = ""  THEN DO:
    ASSIGN cDescEmail = "Fornecedor: " + string(b-emitente.cod-emitente) +
                        " Cadastrado como Pessoa Fisica " +
                        " CPF: " + string(b-emitente.CGC) +
                        " Nome: " + b-emitente.nome-emit +
                        " Usuario: " + v_cod_usuar_corren +
                        " Data: " + STRING(TODAY,"99/99/9999") +
                        " Hora: " + STRING(TIME,"HH:MM:ss")
           cDestino = "sagaz@intelbras.com.br"
           cAssunto = "Cadastro de Fornecedor Pessoa Fisica " 
           cRemetente = "sagaz@intelbras.com.br".
  
    RUN piEnviaEmail(INPUT cRemetente,
                     INPUT cDestino,
                     INPUT cAssunto,
                     INPUT cDescEmail,
                     INPUT cArqEmail).
  
end. */



/* Chamada da API ESSDCV001API de integraá∆o com o OutBuyCenter (SDCV) - In°cio */
IF b-emitente.identific     <> 1 OR
   b-old-emitente.identific <> 1 THEN DO:

    IF  NEW b-emitente                                           or
        b-emitente.cod-emitente   <> b-old-emitente.cod-emitente or
        b-emitente.nome-emit      <> b-old-emitente.nome-emit    or
        b-emitente.endereco       <> b-old-emitente.endereco     or
        b-emitente.bairro         <> b-old-emitente.bairro       or
        b-emitente.cep            <> b-old-emitente.cep          or
        b-emitente.cidade         <> b-old-emitente.cidade       or
        b-emitente.estado         <> b-old-emitente.estado       or
        b-emitente.cgc            <> b-old-emitente.cgc          or
        b-emitente.ins-estadual   <> b-old-emitente.ins-estadual or
        b-emitente.ins-municipal  <> b-old-emitente.ins-municipal  THEN DO:

        IF (SEARCH("esp/sdcv/essdcv001api.p":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.p":U) <> "":U) OR
           (SEARCH("esp/sdcv/essdcv001api.r":U) <> ? AND SEARCH("esp/sdcv/essdcv001api.r":U) <> "":U) THEN DO:
            /* Definiá∆o da temp-table "ttRawTabela" */
            {esp/sdcv/essdcv001api.i}
    
            /* Definiá∆o da temp-table "RowErrors" */
            {method/dbotterr.i}
    
            CREATE ttRawTabela.
            RAW-TRANSFER tt-emitente TO ttRawTabela.rawTabela.
    
            IF NEW b-emitente THEN
                RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                             INPUT  "I":U,
                                             INPUT  TABLE ttRawTabela,
                                             OUTPUT TABLE RowErrors).
            ELSE DO:
                IF b-emitente.identific      = 1 AND
                   b-old-emitente.identific <> 1 THEN
                    RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                                 INPUT  "E":U,
                                                 INPUT  TABLE ttRawTabela,
                                                 OUTPUT TABLE RowErrors).
                ELSE DO:
                    IF b-emitente.identific     <> 1 AND
                       b-old-emitente.identific  = 1 THEN
                        RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                                     INPUT  "I":U,
                                                     INPUT  TABLE ttRawTabela,
                                                     OUTPUT TABLE RowErrors).
                    ELSE
                        RUN esp/sdcv/essdcv001api.p (INPUT  "emitente":U,
                                                     INPUT  "A":U,
                                                     INPUT  TABLE ttRawTabela,
                                                     OUTPUT TABLE RowErrors).
                END.
            END.
        END.
    END.
END.
/* Chamada da API ESSDCV001API de integraá∆o com o OutBuyCenter (SDCV) - Final */

/* IF b-emitente.cod-emitente = 15135 OR
   b-emitente.cod-emitente = 22299 OR
   b-emitente.cod-emitente = 4409 OR
   b-emitente.cod-emitente = 9897 OR
   b-emitente.cod-emitente = 18370 OR
   b-emitente.cod-emitente = 10558 OR
   b-emitente.cod-emitente = 23812 OR
   b-emitente.cod-emitente = 36115 OR
   b-emitente.cod-emitente = 100447 OR
   b-emitente.cod-emitente = 18605 OR
   b-emitente.cod-emitente = 22329 OR
   b-emitente.cod-emitente = 105127 THEN DO: */



IF b-old-emitente.portador    <> b-emitente.portador
OR b-old-emitente.modalidade  <> b-emitente.modalidade
OR b-old-emitente.port-prefer <> b-emitente.port-prefer
OR b-old-emitente.mod-prefer  <> b-emitente.mod-prefer  
THEN DO:

     assign v_num_cont = 1.
     bloco:
     repeat:
         if program-name(v_num_cont) = ? then 
             leave bloco.
         assign ctrace = ctrace + string(v_num_cont) + ': ' + program-name(v_num_cont) + chr(10).
         if v_num_cont = 10 then
             leave bloco.
         assign v_num_cont = v_num_cont + 1.
     end.

     ASSIGN cDescEmail = "Port Anterior: "      + STRING(b-old-emitente.portador)        +
                         " Port Atual: "        + STRING(b-emitente.portador)            + CHR(10) +
                         "Port Pref Anterior: " + STRING(b-old-emitente.port-prefer)     +
                         " Port Pref Atual: "   + STRING(b-emitente.port-prefer)         + CHR(10) + CHR(10) +
                         "Modalidade: "         + STRING(INT(b-old-emitente.modalidade)) +
                         " Modalidade: "        + STRING(INT(b-emitente.modalidade))     + CHR(10) +
                         "Modalidade Pref: "    + STRING(INT(b-old-emitente.mod-prefer)) +
                         " Modalidade Pref: "   + STRING(INT(b-emitente.mod-prefer))     + CHR(10) + CHR(10) +
                         "Usuario: "       + v_cod_usuar_corren         +
                         " Data: "         + STRING(TODAY,"99/99/9999") +
                         " Hora: "         + STRING(TIME,"HH:MM:ss")    + CHR(10) + CHR(10) +
                         "Trace: "        + ctrace
            cDestino = "andrey.oliveira@intelbras.com.br"
            cAssunto = "Alteraá∆o Cliente " + string(b-emitente.cod-emitente)
            cRemetente = "andrey.oliveira@intelbras.com.br".

     RUN piEnviaEmail(INPUT cRemetente, 
                      INPUT cDestino,
                      INPUT cAssunto,
                      INPUT cDescEmail,
                      INPUT cArqEmail).
  
END.

/*Inicio Integraá∆o Canais/Portal Fornecedores*/
DEF VAR raw-param   AS RAW  NO-UNDO.

FIND FIRST int-emitente-canal NO-LOCK
     WHERE int-emitente-canal.cod-emitente = b-emitente.cod-emitente NO-ERROR.

FIND FIRST int-emitente NO-LOCK
     WHERE int-emitente.cod-emitente = b-emitente.cod-emitente NO-ERROR.

IF AVAIL int-emitente THEN DO:
   RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
   RUN pi-trata-endereco IN h-cdapi704 (INPUT b-emitente.endereco,
                                        OUTPUT c-rua, 
                                        OUTPUT c-nro, 
                                        OUTPUT c-comp).

   FIND CURRENT int-emitente EXCLUSIVE-LOCK NO-ERROR.

   IF int-emitente.numero = '' 
      AND c-nro > '' THEN
      ASSIGN int-emitente.numero      = c-nro.
             
   IF int-emitente.complemento = ''
      and  c-comp > '' THEN
      ASSIGN int-emitente.complemento = trim(c-comp).     

   FIND CURRENT int-emitente NO-LOCK NO-ERROR.

   RUN pi-trata-endereco IN h-cdapi704 (INPUT b-emitente.endereco-cob,
                                        OUTPUT c-rua, 
                                        OUTPUT c-nro, 
                                        OUTPUT c-comp).

   FIND CURRENT int-emitente EXCLUSIVE-LOCK NO-ERROR.
   
   IF int-emitente.numero-cob = '' 
       AND c-nro > '' THEN
      ASSIGN int-emitente.numero-cob      = c-nro.
   
   IF int-emitente.complemento-cob = ''
       AND c-comp > '' THEN
      ASSIGN int-emitente.complemento-cob = trim(c-comp).     

   DELETE PROCEDURE h-cdapi704.
   ASSIGN h-cdapi704 = ?.
END.

FIND CURRENT int-emitente NO-LOCK NO-ERROR.


IF b-emitente.ind-cre-cli <> b-old-emitente.ind-cre-cli
AND b-emitente.ind-cre-cli = 1 THEN DO: //tirando de suspenso e deixando normal, forcar o cliente como ativo
    FIND CURRENT int-emitente EXCLUSIVE-LOCK NO-ERROR.
    ASSIGN int-emitente.id-ativo = YES.
    FIND CURRENT int-emitente NO-LOCK NO-ERROR.
END.




/*Controle de loop ficou a cargo do barramento*/
/* /*Campo com initial YES para evitar loop na integraá∆o*/                                                                                                                  */
/* IF (AVAIL int-emitente-canal                                                                                                                                              */
/*       AND int-emitente-canal.IntegraTrigger)                                                                                                                              */
/* OR NOT AVAIL int-emitente-canal THEN DO:                                                                                                                                  */
/*                                                                                                                                                                           */
/*     /*s¢ integra se participa de canais*/                                                                                                                                 */
/*     IF  AVAIL int-emitente                                                                                                                                                */
/*     AND (int-emitente.ind-participa-portal-fornec > 0                                                                                                                     */
/*      OR  int-emitente.ind-participa-canais > 993520000) THEN DO:                                                                                                          */
/*         RAW-TRANSFER b-emitente TO raw-param.                                                                                                                             */
/*         {esp/esb/esesb006.i 'msg0072' 'wad098' 'emitente'}                                                                                                                */
/*     END.                                                                                                                                                                  */
/* END.                                                                                                                                                                      */
/* ELSE IF AVAIL int-emitente-canal THEN DO:                                                                                                                                 */
/*     /*Campo Ç setado como NO na msg0072 de entrada, indica que veio por integraá∆o e nao deve enviar a mensagem de sa°da, seta como yes para envia na pr¢xima alteraá∆o*/ */
/*     ASSIGN int-emitente-canal.IntegraTrigger = YES.                                                                                                                       */
/* END.                                                                                                                                                                      */
IF AVAIL int-emitente                                                                                                                                                
   /*  AND (int-emitente.ind-participa-portal-fornec > 0                                                                                                                     
      OR  int-emitente.ind-participa-canais > 993520000) */ THEN DO:                                                                                                          
          RAW-TRANSFER tt-emitente TO raw-param.                                                                                                                             
          {esp/esb/esesb006.i 'msg0072' 'wad098' 'emitente'}                                                                                                                
END.           
/*Fim Integraá∆o Canais/Portal Fornecedores*/



IF AVAIL b-emitente AND
   AVAIL b-old-emitente and
   b-emitente.identific <> 1 AND
   b-emitente.cod-cond-pag <> b-old-emitente.cod-cond-pag THEN DO:
    FOR EACH item-fornec-estab EXCLUSIVE-LOCK
       WHERE item-fornec-estab.cod-emitente = b-emitente.cod-emitente:
       ASSIGN item-fornec-estab.cod-cond-pag = b-emitente.cod-cond-pag.
    END.

    FOR EACH item-fornec EXCLUSIVE-LOCK
       WHERE item-fornec.cod-emitente = b-emitente.cod-emitente:
       ASSIGN item-fornec.cod-cond-pag = b-emitente.cod-cond-pag.
    END.
END.

   



/*
/********************** Integracao do Ems para o CRM *****************/
IF  l-web-service = NO THEN DO:
    if b-emitente.identific <> 2 then do:
        if index(program-name(3),"cdapi329") > 0 and new b-emitente then do:
        end.
        else do:
            run esp/crm/escrm001a.p (input "Emitente",
                                     input "W",
                                     input rowid(b-emitente),
                                     input table tt-raw-transfer).
        END.

        if index(program-name(3),"cd0704") > 0 then do:
            for each  loc-entr no-lock
                where loc-entr.nome-abrev = b-emitente.nome-abrev:

                run esp/crm/escrm001a.p (input "Loc-entr",
                                         input "W" ,
                                         input rowid(loc-entr),
                                         input table tt-raw-transfer).
            end.
        end.
    end.
END.
*/



/** SupplierCard - Se o cliente teve uma alteraá∆o do endereáo de cobranáa, email ou telefone, **
 ** cria uma pendància para que essa informaá∆o seja repassada para a SupplierCard             **/
IF      CAN-FIND(FIRST int-emitente-supcard NO-LOCK
                 WHERE int-emitente-supcard.raiz-cnpj = SUBSTRING(b-emitente.cgc,1,8)) AND
    NOT CAN-FIND(FIRST int-pendencias-supcard NO-LOCK
                 WHERE int-pendencias-supcard.cnpj-cliente = b-emitente.cgc
                 AND   int-pendencias-supcard.identific    = 06 /* Alteraá∆o de Dados Cadastrais */
                 AND   int-pendencias-supcard.dat-criacao  = TODAY) THEN DO:
    IF  b-emitente.endereco-cob <> b-old-emitente.endereco-cob OR
        b-emitente.cep-cob      <> b-old-emitente.cep-cob      OR
        b-emitente.cidade-cob   <> b-old-emitente.cidade-cob   OR
        b-emitente.bairro-cob   <> b-old-emitente.bairro-cob   OR
        b-emitente.estado-cob   <> b-old-emitente.estado-cob   OR
        b-emitente.e-mail       <> b-old-emitente.e-mail       OR
        b-emitente.telefone[1]  <> b-old-emitente.telefone[1]  THEN DO:
        CREATE int-pendencias-supcard.
        ASSIGN int-pendencias-supcard.cnpj-cliente = b-emitente.cgc
               int-pendencias-supcard.dat-criacao  = TODAY
               int-pendencias-supcard.cod-usuar    = c-seg-usuario
               int-pendencias-supcard.identific    = 06 /* Alteraá∆o de Dados Cadastrais */.
    END.
END.



IF b-emitente.ins-estadual <> "ISENTO" THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "WAD098":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto WHERE
        ENTRY(1,tt-prog-ponto.conteudo) =  b-emitente.cidade AND
        ENTRY(2,tt-prog-ponto.conteudo) =  b-emitente.estado:
       FIND sit-tribut-relacto
           WHERE sit-tribut-relacto.cdn-tribut                  = 12                                                               
             AND sit-tribut-relacto.cdn-sit-tribut              = int(ENTRY(3,tt-prog-ponto.conteudo))
             AND sit-tribut-relacto.idi-tip-docto               = 2
/*              AND sit-tribut-relacto.dat-valid-inic              = TODAY */
             AND sit-tribut-relacto.cod-estab                   = "*"
             AND sit-tribut-relacto.cod-natur-operac            = "*"
             AND sit-tribut-relacto.cod-ncm                     = "*"
             AND sit-tribut-relacto.cod-item                    = "*"
             AND sit-tribut-relacto.cdn-grp-emit                = 0
             AND sit-tribut-relacto.cdn-emitente                = b-emitente.cod-emitente                            NO-LOCK NO-ERROR.
       IF NOT AVAIL sit-tribut-relacto THEN DO:
           CREATE sit-tribut-relacto.
           ASSIGN sit-tribut-relacto.cdn-tribut                  =  12                                   
                  sit-tribut-relacto.cdn-sit-tribut              =  int(ENTRY(3,tt-prog-ponto.conteudo)) 
                  sit-tribut-relacto.idi-tip-docto               =  2                                  
                  sit-tribut-relacto.dat-valid-inic              =  TODAY                                
                  sit-tribut-relacto.cod-estab                   =  "*"                                  
                  sit-tribut-relacto.cod-natur-operac            =  "*"                                  
                  sit-tribut-relacto.cod-ncm                     =  "*"                                  
                  sit-tribut-relacto.cod-item                    =  "*"                                  
                  sit-tribut-relacto.cdn-grp-emit                =  0                                  
                  sit-tribut-relacto.cdn-emitente                =  b-emitente.cod-emitente.
        END.
    END.
END.


/* M2108-211 - 24/08/21 ; Envio da alteraá∆o de cliente para Salesforce */
IF AVAIL b-emitente
  AND b-emitente.identific <> 2  THEN
   RUN esp/wso/eswso0008.p (INPUT b-emitente.cod-emitente).

IF AVAIL b-emitente THEN DO:
    FOR EACH loc-entr EXCLUSIVE-LOCK
       WHERE loc-entr.nome-abrev = b-emitente.nome-abrev:
        ASSIGN loc-entr.cgc          = b-emitente.cgc
               loc-entr.ins-estadual = b-emitente.ins-estadual.
    END.
END.

RETURN "OK".

PROCEDURE piEnviaEmail:

    DEFINE INPUT  PARAM premetente AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDestino   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pAssunto   AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pDescEmail AS CHAR FORMAT 'x(60)' NO-UNDO.
    DEFINE INPUT  PARAM pArquivo   AS CHAR FORMAT 'x(60)' NO-UNDO.

    FOR EACH tt-mail:
        DELETE tt-mail.
    END.
    DEF VAR icont AS INT. 
    FOR FIRST param-global NO-LOCK:
    END.

    CREATE tt-mail.
    ASSIGN tt-mail.Remetente     = pRemetente
           tt-mail.Destinatario  = pdestino
           tt-mail.Assunto       = pAssunto
           tt-mail.Arquivo       = IF pArquivo <> "" then
                                      SEARCH(pArquivo) 
                                   ELSE
                                       "" 
           tt-mail.Mensagem      = pDescEmail.

       RUN utp/utapi019.p PERSISTENT SET h-utapi019.

       FOR EACH tt-mail:

           FOR EACH tt-envio2.   DELETE tt-envio2.   END.
           FOR EACH tt-mensagem. DELETE tt-mensagem. END.

           CREATE tt-envio2.
           ASSIGN tt-envio2.versao-integracao = 1
                  tt-envio2.servidor          = param-global.serv-mail   /* Servidor de E-Mail */ 
                  tt-envio2.porta             = param-global.porta-mail  /* Porta do Servidor  */ 
                  tt-envio2.destino           = tt-mail.Destinatario     /* Destinat†rio       */ 
                  tt-envio2.remetente         = tt-mail.Remetente        /* Remetente          */ 
                  tt-envio2.assunto           = tt-mail.Assunto          /* Assunto            */
                  tt-envio2.arq-anexo         = tt-mail.Arquivo          /* Arquivo Tempor†rio */
                  tt-envio2.formato           = "TEXTO".

           CREATE tt-mensagem.
           ASSIGN tt-mensagem.seq-mensagem = 1
                  tt-mensagem.mensagem     = tt-mail.Mensagem + CHR(13). /* Mensagem           */
                   /*"<h1><center>message body 1</pre>"*/

/*            CREATE tt-mensagem. */
/*            ASSIGN tt-mensagem.seq-mensagem = 2 */
/*                   tt-mensagem.mensagem     = "Port Pref Anterior: " + string(b-old-emitente.port-prefer) + */
/*                                              " Mod: " + STRING(INT(b-old-emitente.mod-prefer)) + */
/*                                              "Port Pref Atual: " + string(b-emitente.port-prefer) + */
/*                                              " Mod: " + STRING(INT(b-emitente.mod-prefer)) + CHR(13). */
/*    */
/*           REPEAT WHILE PROGRAM-NAME(level) <> ?. */
/*                   CREATE tt-mensagem. */
/*                   ASSIGN tt-mensagem.seq-mensagem = level + 2 */
/*                          tt-mensagem.mensagem     = "Nivel: " + string(LEVEL) + */
/*                                                     "  Programa: " + PROGRAM-NAME(level) + CHR(13) */
/*                          level = level + 1. */
/*            END. */

       /*    PUT 'TST 1 ' SKIP.*/
           RUN pi-execute2 in h-utapi019 (INPUT  TABLE tt-envio2,
                                          INPUT  TABLE tt-mensagem,
                                          OUTPUT TABLE tt-erros).
   
/*           ASSIGN tt-mail.lEnviado = CAN-FIND(FIRST tt-erros). */
           FIND FIRST tt-erros NO-LOCK NO-ERROR.
           IF AVAIL tt-erros THEN
               OUTPUT TO erros-comerc.LOG APPEND.

           FOR EACH tt-erros:
               DISP tt-erros.cod-erro
                    tt-erros.desc-erro + tt-erros.desc-arq FORMAT "X(200)" WITH STREAM-IO WIDTH 202.
           END.
           OUTPUT CLOSE.
       END.

       IF  VALID-HANDLE(h-utapi019)
       THEN
           DELETE PROCEDURE h-utapi019.
       ASSIGN h-utapi019 = ?.

/*    RUN esapi/esapi010.p (INPUT-OUTPUT TABLE tt-mail,
                          OUTPUT TABLE tt-erro).
    IF CAN-FIND(FIRST tt-erro) THEN
        RUN cdp\cd0666.w (INPUT TABLE tt-erro). 
  */
END PROCEDURE.






