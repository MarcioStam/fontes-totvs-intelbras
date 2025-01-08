DISABLE TRIGGERS FOR LOAD OF cc_uni_estab.
DISABLE TRIGGERS FOR LOAD OF usuar_univ.

DEFINE BUFFER brateio-equipamentos FOR rateio-equipamentos.

DEFINE TEMP-TABLE tt-int-centro-custo NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-cc-equipamentos NO-UNDO
        FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-rateio-equipamentos NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-cli-difer NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-tarifador NO-UNDO
    FIELD r-rowid AS ROWID.

DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.


OUTPUT TO "saida.txt".

acerto:
DO TRANS ON ERROR UNDO acerto,LEAVE acerto:
    
    /*Fabiano - alterado conforme mail de qua 18/09/2013 16:51*/
    FOR EACH cc_uni_estab EXCLUSIVE-LOCK:
        /*J  possui unidade de neg¢cio na tabela cod_unid_negoc*/
        ASSIGN cc_uni_estab.cc_codigo = SUBSTRING(cc_uni_estab.cc_codigo,4,5).
    END.
      
    /*Hoepers - Criar unidade de neg¢cio, esutp002*/
    FOR EACH cc-equipamentos NO-LOCK:
        CREATE tt-cc-equipamentos.
        ASSIGN tt-cc-equipamentos.r-rowid = ROWID(cc-equipamentos).
    END.
    
    FOR EACH tt-cc-equipamentos:
        FIND FIRST cc-equipamentos EXCLUSIVE-LOCK
            WHERE rowid(cc-equipamentos) = tt-cc-equipamentos.r-rowid NO-ERROR.
    
        FIND FIRST unid_negoc NO-LOCK
            WHERE unid_negoc.cdn_unid_negoc = INT(SUBSTRING(cc-equipamentos.cc-codigo,1,3)) NO-ERROR.
    
        ASSIGN cc-equipamentos.cc-codigo = SUBSTRING(cc-equipamentos.cc-codigo,4,5)
               cc-equipamentos.cod-unid-negoc = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE "".
    
    END.
    
    /*Hoepers - Criar unidade de neg¢cio */
    FOR EACH rateio-equipamentos NO-LOCK:
         CREATE tt-rateio-equipamentos.
         ASSIGN tt-rateio-equipamentos.r-rowid = ROWID(rateio-equipamentos).
    END.
    
    rateio:
    FOR EACH tt-rateio-equipamentos:
        FIND FIRST rateio-equipamentos EXCLUSIVE-LOCK
            WHERE rowid(rateio-equipamentos) = tt-rateio-equipamentos.r-rowid NO-ERROR.
    
        FIND FIRST unid_negoc NO-LOCK
            WHERE unid_negoc.cdn_unid_negoc = INT(SUBSTRING(rateio-equipamentos.cc-codigo,1,3)) NO-ERROR.

        IF CAN-FIND (FIRST brateio-equipamentos
                     WHERE ROWID(brateio-equipamentos)     <> ROWID(rateio-equipamentos)
                       AND brateio-equipamentos.tipo        = rateio-equipamentos.tipo
                       AND brateio-equipamentos.cod-estabel = rateio-equipamentos.cod-estabel
                       AND brateio-equipamentos.equipamento = rateio-equipamentos.equipamento
                       AND brateio-equipamentos.mes-ref     = rateio-equipamentos.mes-ref
                       AND brateio-equipamentos.ct-codigo   = rateio-equipamentos.ct-codigo
                       AND brateio-equipamentos.cc-codigo   = SUBSTRING(rateio-equipamentos.cc-codigo,4,5)) THEN
            NEXT rateio.
    
        ASSIGN rateio-equipamentos.cc-codigo      = SUBSTRING(rateio-equipamentos.cc-codigo,4,5)
               rateio-equipamentos.cod-unid-negoc = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE "".
    END.
    
    /*Fabiano - alterado conforme mail de qua 18/09/2013 16:51*/
    FOR EACH conta-programa EXCLUSIVE-LOCK:
    
        FIND FIRST unid_negoc NO-LOCK
            WHERE unid_negoc.cdn_unid_negoc = INT(SUBSTRING(conta-programa.sc-codigo,1,3)) NO-ERROR.
    
        ASSIGN conta-programa.cod-unid-negoc = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE ""
               conta-programa.sc-codigo      = SUBSTRING(conta-programa.sc-codigo,4,5).
    END.
    
    /*Hoepers - NÆo usa unidade de negocio*/
    FOR EACH correios EXCLUSIVE-LOCK:
        ASSIGN correios.cc-codigo = SUBSTRING(correios.cc-codigo,4,5).
    END.
    
    /*Hoepers - NÆo usa unidade de neg¢cio*/
    DO i-cont = 1 TO 10:
        FOR EACH correios-cartao EXCLUSIVE-LOCK:
            ASSIGN correios-cartao.cc-codigo[i-cont] = SUBSTRING(correios-cartao.cc-codigo[i-cont],4,5).
        END.
        ASSIGN i-cont = i-cont + 1.
    END.
    
    /*Emerson/Cenci - nao precisa undiade de neg¢cio - ???*/
    FOR EACH int-centro-custo NO-LOCK:
        CREATE tt-int-centro-custo.
        ASSIGN tt-int-centro-custo.r-rowid = ROWID(int-centro-custo).
    END.
    
    FOR EACH tt-int-centro-custo:
        FIND FIRST int-centro-custo EXCLUSIVE-LOCK
            WHERE ROWID(int-centro-custo) = tt-int-centro-custo.r-rowid NO-ERROR.
    
        FIND FIRST unid_negoc NO-LOCK
           WHERE unid_negoc.cdn_unid_negoc = INT(SUBSTRING(int-centro-custo.cc-codigo ,1,3)) NO-ERROR.
        IF LENGTH(int-centro-custo.cc-codigo) = 8 THEN DO:
            ASSIGN int-centro-custo.cod-unid-negoc = IF AVAIL unid_negoc THEN unid_negoc.cod_unid_negoc ELSE "".
            ASSIGN int-centro-custo.cc-codigo = SUBSTRING(int-centro-custo.cc-codigo,4,5).                        
        END.
           
    END.
    
    /*Gizelle - ???*/
    FOR EACH int-cont-emit EXCLUSIVE-LOCK:
        ASSIGN int-cont-emit.cc-codigo = SUBSTRING(int-cont-emit.cc-codigo,4,5).
    END.
    
    /*Hoepers - nao usa unidade de negocio*/
    FOR EACH int-nota-conhec EXCLUSIVE-LOCK:
        ASSIGN int-nota-conhec.centro-custo-frete = SUBSTRING(int-nota-conhec.centro-custo-frete,4,5).
    END.
    
    /*Gizelle - Vamos s¢ truncar, aparentemente a tabela nao ‚ mais utilizada*/
    FOR EACH pend-mi EXCLUSIVE-LOCK:
        ASSIGN pend-mi.cc-codigo =  SUBSTRING(pend-mi.cc-codigo,4,5).
    END.
    
    /*Gizelle - Vamos s¢ truncar, aparentemente a tabela nao ‚ mais utilizada*/
    FOR EACH teste EXCLUSIVE-LOCK:
        ASSIGN teste.cc-codigo = SUBSTRING(teste.cc-codigo,4,5).
    END.
    
    /*Cenci - nao precisa undiade de neg¢cio*/
    FOR EACH ped-fiscal EXCLUSIVE-LOCK:
        ASSIGN ped-fiscal.sc-codigo = SUBSTRING(ped-fiscal.sc-codigo,4,5).
    END.
    
    /*Cenci - nÆo precisa unidade de neg¢cio*/
    FOR EACH cli-difer NO-LOCK:
        CREATE tt-cli-difer.
        ASSIGN tt-cli-difer.r-rowid = ROWID(cli-difer).
    END.
    
    FOR EACH tt-cli-difer:
        FIND FIRST cli-difer EXCLUSIVE-LOCK
            WHERE ROWID(cli-difer) = tt-cli-difer.r-rowid NO-ERROR.
    
        ASSIGN cli-difer.cc-codigo =  SUBSTRING(cli-difer.cc-codigo,4,5).
    END.
    
    /*Fabiano - verificar*/
    FOR EACH comis-deb-cred EXCLUSIVE-LOCK:
        /*J  tem o campo unidade de negocio na tabela*/
        IF LENGTH(string(comis-deb-cred.sc-codigo)) - 4 > 0 THEN DO:
            ASSIGN comis-deb-cred.sc-codigo = int(SUBstring(STRING(comis-deb-cred.sc-codigo),LENGTH(string(comis-deb-cred.sc-codigo)) - 4,5)).
        END.    
    END.

    /*Popula usuar_univ.cod_ccusto com usu-inf.usuario-magnus*/
    FOR EACH  usuar_mestre NO-LOCK
        WHERE usuar_mestre.dat_valid_senha >= ADD-INTERVAL(TODAY,-1,"MONTH"),
        EACH  usu-inf NO-LOCK
        WHERE usu-inf.usuario-magnus = usuar_mestre.cod_usuario:
        FIND FIRST usuar_univ EXCLUSIVE-LOCK
            WHERE  usuar_univ.cod_usuario = usu-inf.usuario-magnus NO-ERROR.
        IF  NOT AVAIL usuar_univ THEN DO:
            CREATE usuar_univ.
            ASSIGN usuar_univ.cod_usuario = usu-inf.usuario-magnus
                   usuar_univ.cod_empresa = "1"
                   usuar_univ.cod_estab   = usu-inf.setor.
        END.

        ASSIGN usuar_univ.cod_ccusto = SUBSTRING(usu-inf.cc-codigo,4,5).    
    END.
    
    /*foi necess rio alterar o cadastro de Tipos de Verba para que o campo ct-codigo ficasse na tabela cta-tipo-verba ao inv‚s da tipo-verba como era no EMS206B.*/
    FOR EACH tipo-verba NO-LOCK:
        FOR EACH ctb-tipo-verba OF tipo-verba EXCLUSIVE-LOCK:
            ASSIGN ctb-tipo-verba.ct-codigo = tipo-verba.ct-codigo.
        END.
    END.

    /*Acerta campos de usu rio nas tabelas que usavam formato inteiro*/
    FOR EACH equipamentos EXCLUSIVE-LOCK:
        FIND FIRST usu-inf NO-LOCK
            WHERE usu-inf.cod-usuario = equipamentos.cod-usuario NO-ERROR.

        IF AVAIL usu-inf THEN
            ASSIGN equipamentos.cod_usuario = usu-inf.usuario-magnus.

        FIND FIRST usu-inf NO-LOCK
            WHERE usu-inf.cod-usuario = equipamentos.gestor-cobranca NO-ERROR.

        IF AVAIL usu-inf THEN
            ASSIGN equipamentos.cod_gestor_cobranca = usu-inf.usuario-magnus.
    END.

    FOR EACH fedex EXCLUSIVE-LOCK:
        FIND FIRST usu-inf NO-LOCK
            WHERE usu-inf.cod-usuario = fedex.cod-usuario NO-ERROR.

        IF AVAIL usu-inf THEN
            ASSIGN fedex.cod_usuario = usu-inf.usuario-magnus.
    END.

    FOR EACH int-centro-custo EXCLUSIVE-LOCK:
        FIND FIRST usu-inf NO-LOCK
            WHERE usu-inf.cod-usuario = int-centro-custo.cod-usuario NO-ERROR.

        IF AVAIL usu-inf THEN
            ASSIGN int-centro-custo.cod_usuario = usu-inf.usuario-magnus.

        FIND FIRST usu-inf NO-LOCK
            WHERE usu-inf.cod-usuario = int-centro-custo.cod-diretor NO-ERROR.

        IF AVAIL usu-inf THEN
            ASSIGN int-centro-custo.cod_diretor = usu-inf.usuario-magnus.
    END.

    /*Acertar indice PU*/
    FOR EACH tarifador NO-LOCK:
        CREATE tt-tarifador.
        ASSIGN tt-tarifador.r-rowid = ROWID(tarifador).
    END.

    FOR EACH tt-tarifador NO-LOCK:
        FIND FIRST tarifador EXCLUSIVE-LOCK
            WHERE  ROWID(tarifador) = tt-tarifador.r-rowid NO-ERROR.

        FIND FIRST usu-inf NO-LOCK
            WHERE  usu-inf.cod-usuario = tarifador.cod-usuario NO-ERROR.
        IF  AVAIL  usu-inf THEN
            ASSIGN tarifador.cod_usuario = usu-inf.usuario-magnus.
    END.
    /* GKO */
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0001"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ENTRADAGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "ENTRADAGKOWIN32;~\~\totvs~\transport~\gko~\entrada~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ENTRADAGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "ENTRADAGKOUNIX;/opt/totvs/arquivos/transport/gko/entrada/".
  
  
    END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0002"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\totvs~\transport~\gko~\saida~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/transport/gko/saida/".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\totvs~\transport~\gko~\integradoems~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/gko/integradoems/".


     END.
    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0004"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            
        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\totvs~\transport~\gko~\integradoems~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\totvs~\transport~\gko~\saida~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/gko/saida/".


     END.

    FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0005"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\totvs~\transport~\gko~\saida~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/gko/saida/".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\totvs~\transport~\gko~\integradoems~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/".

     END.

     FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0006"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOWIN32;~\~\totvs~\transport~\gko~\saida~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "SAIDAGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "SAIDAGKOUNIX;/opt/totvs/arquivos/gko/saida/".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOWIN32;~\~\totvs~\transport~\gko~\integradoems~\".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "BACKUPGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "BACKUPGKOUNIX;/opt/totvs/arquivos/transport/gko/integradoems/".

     END.

     FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0007"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOWIN32"
        THEN
            ASSIGN conteudo-programa.conteudo = "ARQSPEDGKOWIN32;~\~\totvs~\transport~\gko~\saida~\sped~\sped.csv".

        IF  ENTRY(1,conteudo-programa.conteudo,";") = "ARQSPEDGKOUNIX"
        THEN
            ASSIGN conteudo-programa.conteudo = "ARQSPEDGKOUNIX;/opt/totvs/arquivos/gko/saida/sped/sped.csv".
                                                                                                           

     END.

     FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0011"
          AND ponto-programa.ponto         = 1,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            

        IF  conteudo-programa.sequencia = 1
        THEN
            ASSIGN conteudo-programa.conteudo = "~\~\totvs~\transport~\gko~\saida~\nfentregues".

        IF  conteudo-programa.sequencia = 1
        THEN
            ASSIGN conteudo-programa.conteudo = "/opt/totvs/arquivos/transport/nfentregues".
                                                                                                           

     END.
     FOR FIRST ponto-programa
        WHERE ponto-programa.nome-programa = "gk0011"
          AND ponto-programa.ponto         = 2,
         EACH conteudo-programa exclusive-lock
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:
            

        IF  conteudo-programa.sequencia = 1
        THEN
            ASSIGN conteudo-programa.conteudo = "~\~\totvs~\transport~\gko~\saida~\nfentregues~\backup".

        IF  conteudo-programa.sequencia = 1
        THEN
            ASSIGN conteudo-programa.conteudo = "/opt/totvs/arquivos/transport/nfentregues/backup".
                                                                                                           

     END.
     FOR EACH prog_dtsul where
              prog_dtsul.log_outro_produt_dtsul = YES AND
              prog_dtsul.cod_prog_dtsul BEGINS "es" EXCLUSIVE-LOCK:
    
        ASSIGN prog_dtsul.log_outro_produt_dtsul = NO.
     END.

END.

OUTPUT CLOSE.
