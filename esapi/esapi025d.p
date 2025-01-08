{esp/es0018.i}

DEF TEMP-TABLE tt-fci-param 
    FIELD it-codigo        AS CHAR
    FIELD tot-parcela      AS DEC 
    FIELD valor-medio      AS DEC 
    FIELD contr-importacao AS DEC.

DEFINE TEMP-TABLE ttFCI NO-UNDO
    FIELD cod-estabel          LIKE estabelec.cod-estabel
    FIELD nome                 LIKE estabelec.nome
    FIELD endereco             LIKE estabelec.endereco
    FIELD cidade               LIKE estabelec.cidade
    FIELD estado               LIKE estabelec.estado
    FIELD ins-estadual         LIKE estabelec.ins-estadual
    FIELD cgc                  LIKE estabelec.cgc
    FIELD it-codigo            LIKE item.it-codigo
    FIELD desc-item            LIKE item.desc-item
    FIELD class-fiscal         LIKE item.class-fiscal
    FIELD cod-ean              AS CHAR FORMAT "X(20)"
    FIELD un                   LIKE item.un
    FIELD tipo-item            AS INTEGER /* 1 - Industrializado | 2 - Revenda*/
    FIELD desc-tipo-item       AS CHAR  
    FIELD vl-parc-importada    AS DEC  FORMAT "->>>>>>>>>>>>>9.99<<<<<<"
    FIELD vl-saida-interestad  AS DEC  FORMAT "->>>>>>>>>>>>>9.99<<<<<<"
    FIELD vl-perc-cont-import  AS DEC  FORMAT "->9.99"
    FIELD vl-perc-ci-nfe       AS DEC  FORMAT "->9.99"
    FIELD nro-fci             AS CHARACTER FORMAT "X(36)"
    FIELD dt-implant          AS DATE FORMAT "99/99/9999"
    FIELD r-Rowid             AS ROWID                   
    INDEX ch-ttFCI cod-estabel it-codigo dt-implant.

DEFINE TEMP-TABLE tt-fci-excec NO-UNDO
    FIELD cod-estabel LIKE ttFCI.cod-estabel
    FIELD it-codigo   LIKE ttFCI.it-codigo
    FIELD dt-implant  LIKE ttFCI.dt-implant
    FIELD erro        AS   CHARACTER FORMAT "x(05)"
    INDEX ch-exec cod-estabel it-codigo dt-implant erro.

DEF TEMP-TABLE RowErrors NO-UNDO
    FIELD errorSequence     AS INT
    FIELD errorNumber       AS INT
    FIELD errorDescription  AS CHAR
    FIELD errorParameters   AS CHAR
    FIELD errorType         AS CHAR
    FIELD errorHelp         AS CHAR
    FIELD errorsubtype      AS CHAR.

DEFINE TEMP-TABLE ttFCI-aux NO-UNDO LIKE ttFCI
    FIELD marcar AS CHAR FORMAT "x(1)"
    INDEX ch-marc marcar. 

DEFINE VARIABLE c-versao-fci   AS CHARACTER FORMAT "x(4)"      NO-UNDO.
DEFINE VARIABLE c-local-fci    AS CHARACTER FORMAT "x(256)"    NO-UNDO.
DEFINE VARIABLE c-registros    AS CHARACTER FORMAT "X(20)"     NO-UNDO.
DEFINE VARIABLE c-cnpj         AS CHARACTER FORMAT "X(14)"     NO-UNDO.
DEFINE VARIABLE c-fci          AS CHARACTER FORMAT "X(36)"     NO-UNDO.
DEFINE VARIABLE c-date         AS CHARACTER FORMAT "X(8)"      NO-UNDO.
DEFINE VARIABLE c-hora         AS CHARACTER FORMAT "X(6)"      NO-UNDO.
DEFINE VARIABLE c-nome-arquivo AS CHARACTER FORMAT "x(70)"     NO-UNDO.
DEFINE VARIABLE c-diretorio    AS CHARACTER FORMAT "x(256)"    NO-UNDO.
DEFINE VARIABLE c-cod-estab    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-fill         AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-ean      AS CHARACTER FORMAT "99999999999999" NO-UNDO.
DEFINE VARIABLE h-bodi735      AS HANDLE    NO-UNDO.
DEFINE VARIABLE i-tot-reg      AS INTEGER   NO-UNDO.
DEFINE VARIABLE l-error        AS LOGICAL   NO-UNDO.

DEFINE VARIABLE c-arquivo-log1  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE l-gerador-solar AS LOGICAL     NO-UNDO.

/* Parametros */
DEF INPUT  PARAM TABLE FOR tt-fci-param. 
DEF OUTPUT PARAM TABLE FOR tt-fci-excec.

{cdp/virtualTableTT.i param-fci 2.09 dibo/bodi735.i} /*definiá∆o tabela virtual*/
        
DEFINE VARIABLE de-perc-import LIKE ttFCI.vl-perc-cont-import NO-UNDO.
DEFINE VARIABLE h-bodi538    AS HANDLE      NO-UNDO.

ASSIGN c-date = STRING(YEAR(TODAY), "9999") + string(MONTH(TODAY),"99") + string(DAY(TODAY), "99")
       c-hora = REPLACE(STRING(TIME, "hh:mm:ss"),":","").

RUN dibo/bodi735.p PERSISTENT SET h-bodi735.

EMPTY TEMP-TABLE tt-param-fci       NO-ERROR.


RUN dibo/bodi735.p PERSISTENT SET h-bodi735.

EMPTY TEMP-TABLE tt-param-fci       NO-ERROR.

IF OPSYS = "unix":U THEN
   ASSIGN c-arquivo-log1 = '/mnt/spool/is055792/esapi025-D_PROD.txt'.
ELSE
   ASSIGN c-arquivo-log1 = 'c:/temp/esapi025-D.txt'.


FIND FIRST tt-fci-param NO-LOCK NO-ERROR.

IF NOT AVAIL tt-fci-param THEN DO:
   CREATE tt-fci-excec.
   ASSIGN tt-fci-excec.erro  = "0 - Nenhum registro existente".

   RETURN 'NOK'.
END.



FIND FIRST ITEM WHERE ITEM.it-codigo = tt-fci-param.it-codigo NO-LOCK NO-ERROR.

RUN virtualTableSetconstraintIndex IN h-bodi735(INPUT "paramfci-id",
                                                INPUT ITEM.cod-estabel,
                                                INPUT ITEM.cod-estabel). 

RUN openQueryStatic IN h-bodi735 (INPUT "virtualTableOpenQueryIndex").

RUN getBatchRecords IN h-bodi735 (INPUT ?,
                                  INPUT NO,
                                  INPUT 0,
                                  OUTPUT i-tot-reg,
                                  OUTPUT TABLE tt-param-fci). 

IF NOT VALID-HANDLE(h-bodi538) THEN
   RUN dibo/bodi538.p PERSISTENT SET h-bodi538.

RUN pi-gerar-dados-extrato("pi-Valida-FCI , ESAPI025D").

RUN pi-Valida-FCI IN h-bodi538 (INPUT "Incluir" ,
                                INPUT 1, //"Industrializaá∆o"
                                INPUT ITEM.cod-estabel,
                                INPUT tt-fci-param.it-codigo,
                                INPUT TODAY,
                                INPUT tt-fci-param.tot-parcela,
                                INPUT tt-fci-param.valor-medio,
                                INPUT tt-fci-param.contr-importacao,
                                INPUT ROUND((tt-fci-param.tot-parcela / tt-fci-param.valor-medio) * 100,2),
                                OUTPUT TABLE rowErrors).


FOR EACH rowErrors
    WHERE rowErrors.ErrorSubType = "ERROR":
    RUN pi-gerar-dados-extrato("ERRO: pi-Valida-FCI , ESAPI025D - " + rowErrors.errorDescription).
END.

IF NOT CAN-FIND (FIRST rowErrors
                 WHERE rowErrors.ErrorSubType = "ERROR") THEN DO:
        
   RUN pi-gerar-dados-extrato(" pi-Valida-FCI SEM ERROS , ESAPI025D ").
   
   /*
   MESSAGE 'tt-fci-param.tot-parcela          '      tt-fci-param.tot-parcela      skip                                     
           'tt-fci-param.valor-medio          '      tt-fci-param.valor-medio      skip                                      
           'tt-fci-param.contr-importacao     '      tt-fci-param.contr-importacao skip                                      
           '((tt-fci-param.tot-parcela / tt-fci-param.valor-medio) * 100,2))     '      ROUND((tt-fci-param.tot-parcela / tt-fci-param.valor-medio) * 100,2)
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/ 


   RUN pi-Inclui-Altera-FCI IN h-bodi538 (INPUT 1, //"Industrializaá∆o"
                                          INPUT ITEM.cod-estabel,
                                          INPUT tt-fci-param.it-codigo,
                                          INPUT TODAY,
                                          INPUT ''   ,
                                          INPUT tt-fci-param.tot-parcela,
                                          INPUT tt-fci-param.valor-medio,
                                          //INPUT tt-fci-param.contr-importacao,
                                          INPUT ROUND((tt-fci-param.tot-parcela / tt-fci-param.valor-medio) * 100,2),
                                          INPUT ROUND((tt-fci-param.tot-parcela / tt-fci-param.valor-medio) * 100,2)).

   ASSIGN l-gerador-solar = NO.

   RUN esp/es0018p.p (INPUT  'esapi025',
                      INPUT  3,
                      INPUT  0,
                      INPUT  "":U,
                      OUTPUT TABLE tt-prog-ponto).
    
   FOR EACH tt-prog-ponto:
       IF INDEX(ITEM.class-fiscal,tt-prog-ponto.conteudo) <> 0 THEN
           ASSIGN l-gerador-solar = YES.
   END.

   IF l-gerador-solar THEN LEAVE.

   IF (ITEM.ge-codigo = 40 OR ITEM.ge-codigo = 42) THEN DO:

      IF ITEM.cod-estabel = '103' OR ITEM.cod-estabel = '104' THEN DO:
         IF ITEM.cod-estabel = '104' THEN
            RUN pi-Inclui-Altera-FCI IN h-bodi538 (INPUT 2, //Revenda
                                                   INPUT '101',
                                                   INPUT tt-fci-param.it-codigo,
                                                   INPUT TODAY,
                                                   INPUT ''   ,
                                                   INPUT 0,
                                                   INPUT 0,
                                                   INPUT 0,
                                                   INPUT 0).

         RUN pi-Inclui-Altera-FCI IN h-bodi538 (INPUT 2, //Revenda
                                                INPUT '110',
                                                INPUT tt-fci-param.it-codigo,
                                                INPUT TODAY,
                                                INPUT '',
                                                INPUT 0,
                                                INPUT 0,
                                                INPUT 0,
                                                INPUT 0).

      END.                                                                                                                  
   END.

   IF ITEM.cod-estabel = '602' THEN
      RUN pi-Inclui-Altera-FCI IN h-bodi538 (INPUT 2, //Revenda
                                             INPUT '601',
                                             INPUT tt-fci-param.it-codigo,
                                             INPUT TODAY,
                                             INPUT '',
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0,
                                             INPUT 0).

END.      
 



FOR EACH ttFCI: DELETE ttFCI. END.

RUN pi-CarregattFCI IN h-bodi538 (INPUT ITEM.cod-estabel,
                                  INPUT ITEM.cod-estabel,
                                  INPUT tt-fci-param.it-codigo,
                                  INPUT tt-fci-param.it-codigo,
                                  INPUT TODAY ,
                                  INPUT TODAY ,
                                  INPUT '',
                                  INPUT '',
                                  INPUT YES, /*tg-nro-fci-inf*/ 
                                  INPUT YES, /*tg-nro-fci-naoinf,*/
                                  INPUT YES,
                                  INPUT NO,
                                  OUTPUT TABLE ttFCI).


FIND FIRST ttFCI NO-ERROR.

RUN pi-gerar-dados-extrato("pi-CarregattFCI, avail ttFCI - " + STRING(AVAIL ttFCI) ).




bloco_arquivo:
FOR EACH ttFCI:
    
    ASSIGN de-perc-import = ROUND(( (ttFCI.vl-parc-importada / ttFCI.vl-saida-interestad) * 100 ),2).

    RUN pi-gerar-dados-extrato("ttFCI.it-codigo - " + STRING(ttFCI.it-codigo) ).
    RUN pi-gerar-dados-extrato("ttFCI.vl-parc-importada   - " + STRING(ttFCI.vl-parc-importada) ).
    RUN pi-gerar-dados-extrato("ttFCI.vl-saida-interestad - " + STRING(ttFCI.vl-saida-interestad) ).
    RUN pi-gerar-dados-extrato("ttFCI.vl-perc-cont-import - " + STRING(ttFCI.vl-perc-cont-import ) ).
    RUN pi-gerar-dados-extrato("de-perc-import - " + STRING(de-perc-import ) ).


    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = ttFCI.cod-estabel: 
    END.   

    ASSIGN c-cnpj = estabelec.cgc
           c-fci  = ttFCI.nro-fci
           c-cod-estab = "Estab. " + estabelec.cod-estabel.

   ASSIGN l-error = NO.

   IF ttFCI.vl-parc-importada <= 0 THEN DO: /*valor entrada*/
    
      ASSIGN l-error = YES.
    
      IF  NOT CAN-FIND (FIRST tt-fci-excec NO-LOCK 
          WHERE tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
          AND   tt-fci-excec.it-codigo   = ttFCI.it-codigo
          AND   tt-fci-excec.dt-implant  = ttFCI.dt-implant
          AND   tt-fci-excec.erro        = "1") THEN DO:
    
          CREATE tt-fci-excec.
          ASSIGN tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
                 tt-fci-excec.it-codigo   = ttFCI.it-codigo  
                 tt-fci-excec.dt-implant  = ttFCI.dt-implant 
                 tt-fci-excec.erro        = "1".
      END.
    END.
    
    IF  ttFCI.vl-saida-interestad <= 0 THEN DO: /*valor saida*/
    
        ASSIGN l-error = YES.
    
        IF  NOT CAN-FIND (FIRST tt-fci-excec NO-LOCK 
            WHERE tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
            AND   tt-fci-excec.it-codigo   = ttFCI.it-codigo
            AND   tt-fci-excec.dt-implant  = ttFCI.dt-implant
            AND   tt-fci-excec.erro        = "2") THEN DO:
    
            CREATE tt-fci-excec.
            ASSIGN tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
                   tt-fci-excec.it-codigo   = ttFCI.it-codigo  
                   tt-fci-excec.dt-implant  = ttFCI.dt-implant 
                   tt-fci-excec.erro        = "2".
        END.
    END.
    
    IF ttFCI.vl-perc-cont-import <= 0
    OR ttFCI.vl-perc-cont-import >= 999 THEN DO: /*perc import %CI*/
        
        ASSIGN l-error = YES.
    
        IF  NOT CAN-FIND (FIRST tt-fci-excec NO-LOCK 
            WHERE tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
            AND   tt-fci-excec.it-codigo   = ttFCI.it-codigo
            AND   tt-fci-excec.dt-implant  = ttFCI.dt-implant
            AND   tt-fci-excec.erro        = "3") THEN DO:
    
            CREATE tt-fci-excec.
            ASSIGN tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
                   tt-fci-excec.it-codigo   = ttFCI.it-codigo  
                   tt-fci-excec.dt-implant  = ttFCI.dt-implant 
                   tt-fci-excec.erro        = "3".
        END.
    END.
      
    ASSIGN de-perc-import = ROUND(( (ttFCI.vl-parc-importada / ttFCI.vl-saida-interestad) * 100 ),2).
    
    /* Comentado 22/12/21 
    
    IF de-perc-import <> ROUND(ttFCI.vl-perc-cont-import, 2) THEN DO:
    
       ASSIGN l-error = YES.
       
       IF  NOT CAN-FIND (FIRST tt-fci-excec NO-LOCK 
           WHERE tt-fci-excec.cod-estabel = ttFCI.cod-estabel  
           AND   tt-fci-excec.it-codigo   = ttFCI.it-codigo
           AND   tt-fci-excec.dt-implant  = ttFCI.dt-implant
           AND   tt-fci-excec.erro        = "4") THEN DO:
       
           CREATE tt-fci-excec.
           ASSIGN tt-fci-excec.cod-estabel = ttFCI.cod-estabel 
                  tt-fci-excec.it-codigo   = ttFCI.it-codigo  
                  tt-fci-excec.dt-implant  = ttFCI.dt-implant 
                  tt-fci-excec.erro        = "4 - " + STRING(ROUND(ttFCI.vl-perc-cont-import, 2)) + ' - ' + string(de-perc-import) .
       END.
    END.*/
    
    /*
    IF l-error THEN DO:
        DELETE ttFCI.
        NEXT bloco_arquivo.
    END.*/
    
    IF ttFCI.cod-ean <> "" THEN
        ASSIGN c-cod-ean = STRING(DEC(ttFCI.cod-ean), "99999999999999").
    ELSE
        ASSIGN c-cod-ean = "". 

    /*verifica diretorio e vers∆o do arquivo fci na tabela virtual*/
    FOR FIRST tt-param-fci NO-LOCK
        WHERE tt-param-fci.cod-estab = ttFCI.cod-estabel: 
    END.

    IF  AVAIL tt-param-fci THEN
        ASSIGN c-local-fci  = tt-param-fci.des-dir-arq-fci     
               c-versao-fci = tt-param-fci.cod-vers-layout-fci.

    IF  c-versao-fci = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-versao-do-layout-nao-informada AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Vers∆o_do_Layout_n∆o_Informada" *}
        ASSIGN c-lbl-liter-versao-do-layout-nao-informada = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-necessario-informar-o-versao-d AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Necessario_informar_o_Vers∆o_do_Layout_no_programa_FT0330_(PAR∂METROS_FCI)_para_geraá∆o_do_Arquivo_Digital" *}
        ASSIGN c-lbl-liter-necessario-informar-o-versao-d = TRIM(RETURN-VALUE).

        /*
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT c-lbl-liter-versao-do-layout-nao-informada + '!' + '~~' + 
                             c-lbl-liter-necessario-informar-o-versao-d + '.').
        
        RETURN ERROR.*/

        CREATE tt-fci-excec.                                    
        ASSIGN tt-fci-excec.cod-estabel = ttFCI.cod-estabel     
               tt-fci-excec.it-codigo   = ttFCI.it-codigo       
               tt-fci-excec.dt-implant  = ttFCI.dt-implant      
               tt-fci-excec.erro        = "5 - " + c-lbl-liter-versao-do-layout-nao-informada + '!' + '~~' +                    
                                                   c-lbl-liter-necessario-informar-o-versao-d.          

    END.

    IF  c-local-fci = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-diretorio-de-arquivos-nao-info AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Diret¢rio_de_Arquivos_n∆o_Informado" *}
        ASSIGN c-lbl-liter-diretorio-de-arquivos-nao-info = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-e-necessario-informar-o-direto AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "ê_necessario_informar_o_Diret¢rio_de_Arquivos_no_programa_FT0330_(PAR∂METROS_FCI)_para_geraá∆o_do_Arquivo_Digital" *}
        ASSIGN c-lbl-liter-e-necessario-informar-o-direto = TRIM(RETURN-VALUE).
        
        /*RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT c-lbl-liter-diretorio-de-arquivos-nao-info + '!' + '~~' + 
                                 c-lbl-liter-e-necessario-informar-o-direto + '.').
        RETURN ERROR.*/

        CREATE tt-fci-excec.                                    
        ASSIGN tt-fci-excec.cod-estabel = ttFCI.cod-estabel     
               tt-fci-excec.it-codigo   = ttFCI.it-codigo       
               tt-fci-excec.dt-implant  = ttFCI.dt-implant      
               tt-fci-excec.erro        = "6 - " + c-lbl-liter-diretorio-de-arquivos-nao-info + '!' + '~~' +  
                                                   c-lbl-liter-e-necessario-informar-o-direto.         


    END.

    /*nome do arquivo txt*/
    ASSIGN c-nome-arquivo = TRIM(STRING("FCI_" + c-cnpj + "_" + c-date + c-hora + ".txt")).
    
    ASSIGN c-local-fci = REPLACE(c-local-fci,"~\","/").
    
    IF SUBSTRING(c-local-fci, LENGTH(c-local-fci), 1) <> "/" THEN
       ASSIGN c-local-fci = c-local-fci + "/".
        
    ASSIGN c-diretorio = c-local-fci + "ESTAB_" + estabelec.cod-estabel + "/" + c-nome-arquivo.

END.



FOR EACH tt-fci-excec NO-LOCK
    BREAK BY(tt-fci-excec.it-codigo):

    IF  tt-FCI-excec.erro = "1"  THEN
        ASSIGN tt-FCI-excec.erro = "1 - Valor ENTRADA deve ser diferente de 0.".

    IF  tt-FCI-excec.erro = "2"  THEN
        ASSIGN tt-FCI-excec.erro = "2 - Valor SA÷DA deve ser diferente de 0.".

    IF  tt-FCI-excec.erro = "3"  THEN
        ASSIGN tt-FCI-excec.erro = "3 - Valor c†lculado do %CI Ç inv†lido.".

    IF  tt-FCI-excec.erro = "4"  THEN
        ASSIGN tt-FCI-excec.erro = "4 - Valor c†lculado do %CI '( entr / said ) * 100' est† incorreto.".

    RUN pi-gerar-dados-extrato("tt-FCI-excec.erro == " +  tt-FCI-excec.erro).
END.



RUN pi-geraArquivos.



PROCEDURE pi-geraArquivos:

    DEFINE VARIABLE h-ft0919a AS HANDLE NO-UNDO.

    RUN ftp/ft0919a.p PERSISTENT SET h-ft0919a.

    /*
    MESSAGE ' pi-geraArquivos'  SKIP(1) 
            c-versao-fci skip 
            c-local-fci  skip 
            c-date       skip 
            c-hora       skip 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

    FOR EACH ttFCI:
        CREATE ttFCI-aux.
        BUFFER-COPY ttFCI TO ttFCI-aux.
        ASSIGN ttFCI-aux.marcar = '*'.
    END.

    RUN pi-gerar-dados-extrato("pi-geraArquivos , c-versao-fci == " + c-versao-fci).
    RUN pi-gerar-dados-extrato("pi-geraArquivos , c-local-fci == " + c-local-fci).
    
    RUN pi-geraArquivos IN h-ft0919a (INPUT TABLE ttFCI-aux,
                                      INPUT c-versao-fci,
                                      INPUT c-local-fci,
                                      INPUT c-date,
                                      INPUT c-hora).
    DELETE PROCEDURE h-ft0919a. 
    DELETE PROCEDURE h-bodi735.

    ASSIGN h-ft0919a = ?
           h-bodi735 = ?. 

END PROCEDURE.


PROCEDURE pi-gerar-dados-extrato:
    DEF INPUT PARAM p-string AS CHAR NO-UNDO.
            
    IF c-arquivo-log1 <> "" AND c-arquivo-log1 <> ? THEN DO:
       OUTPUT TO VALUE(c-arquivo-log1) APPEND.
            PUT p-string + " - " + STRING(DATETIME(TODAY, MTIME))  FORMAT "x(500)" SKIP.
       OUTPUT CLOSE. 
    END.
END PROCEDURE.



