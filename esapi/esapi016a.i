/*-------------------------------------------------------------------------------
  Purpose: Rotina de impress∆o de todos os modelos    
  Parameters:  <none>
  Notes:   Carlos Daniel - 07/10/2015
------------------------------------------------------------------------------*/

/* OUTRAS */
IF  modelo-etiq.tipo = 6 THEN  DO:

    FOR FIRST it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.
    END.    

    IF NOT AVAIL it-mod-img-etiq THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").
        RETURN "NOK".
    END.

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    /*Etiqueta exportaá∆o */
    PUT UNFORMATTED "^XA" SKIP.
    PUT UNFORMATTED "^FO1,1^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".

    PUT "^PQ" STRING(p-qtd-etiquetas, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
    PUT "^XZ" SKIP.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".
END.

//Item Etq Produto
IF modelo-etiq.tipo = 9 THEN  DO:

    IF p-cod-modelo = 621 
    THEN DO:
        {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
        
        /*Etiqueta exportaá∆o */
        PUT UNFORMATTED "^XA" SKIP.

        PUT UNFORMATTED "^FO30,10^A0N,15,15^FDPRAZO DE VALIDADE:" caps(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,30^A0N,15,15^FDCOMPOSIÄ«O:" caps(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,15,15^FD" caps(item-ean.texto[15]) "^FS" SKIP.

        PUT UNFORMATTED "^FO330,10^A0N,15,15^FDPRAZO DE VALIDADE:" caps(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO330,30^A0N,15,15^FDCOMPOSIÄ«O:" caps(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO330,50^A0N,15,15^FD" caps(item-ean.texto[15]) "^FS" SKIP.

        PUT "^PQ" STRING(p-qtd-etiquetas, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
       
        /* Limpa a imagem da impressora */
        PUT UNFORMATTED
            "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ". 
    END.
END.


/* ---[ Impress∆o Modelo 2 ]---------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 2 THEN DO:

    RUN piCargaImagem("local-anatel5").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */

        PUT UNFORMATTED "^FO450,50^A0N,14,14^FDNEC Brasil S/A^FS"                                    SKIP.
        PUT UNFORMATTED "^FO450,65^A0N,14,14^FB365,1,0,L^FDCNPJ:49.074.412/0001-65^FS"               SKIP.
        PUT UNFORMATTED "^FO450,80^A0N,14,14^FB365,1,0,L^FDProduzido por 82 901 000/0001-27^FS"      SKIP.
        PUT UNFORMATTED "^FO450,95^A0N,14,14^FB365,1,0,L^FDAv. Paulista, 2300 - Sao Paulo - SP^FS"   SKIP.
        PUT UNFORMATTED "^FO450,110^A0N,14,14^FB365,1,0,L^FDCep: 01310-300^FS"                       SKIP.
        PUT UNFORMATTED "^FO450,125^A0N,14,14^FB365,1,0,L^FDSAC:(11)3003-2010/0800-7270806^FS"       SKIP.
        PUT UNFORMATTED "^FO667,50^A0N,14,14^FB365,1,0,L^FDINDÈSTRIA BRASILEIRA^FS"                  SKIP.
        PUT UNFORMATTED "^FO450,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS"             SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO731,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO607,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO450,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP. 
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END.  /* IF  p-cod-modelo = 2 THEN DO: */


/* ---[ Impress∆o Modelo 13 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 13 THEN DO:

    /* Carrega a imagem para a impressora */
    RUN piCargaImagem("local-logo").
    RUN piCargaImagem("local-logoma1").
    RUN piCargaImagem("local-tensao").
    RUN piCargaImagem("local-fcc").
    RUN piCargaImagem("local-ce").

    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ? o numero de Dot¡s que formam nr colunas da etiqueta */
        "^MNY"        SKIP     /* Papel de etiquetas contnuo */
        "^XZ" skip.
        
    FOR EACH tt-lista-ns:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        ASSIGN c-data = "D:" + STRING(MONTH(num-serie.data), "99") + string(SUBSTRING(STRING(YEAR(num-serie.data)),3,2), "99").

        PUT UNFORMATTED
            "^XA" SKIP
            "^FO04,10^XGlocal-logo.GRF^FS" SKIP  /* Impressao da Imagem IntelBras */
            "^FO04,48^A0N,20,20^FD"  item-ean.linha[1]    /* Imprime descricao Equipto */ "^FS" SKIP
            "^FO134,45^XGlocal-logoma1.GRF^FS" SKIP  /* Impressao da Imagem Conheªa manaus */
            "^FO04,70^A0N,20,15^FDNS:" num-serie.n-serie "^FS" SKIP /* Valor do Codigo de Barras EAN128 Número de S≤rie */
            "^FO04,90^XGlocal-tensao.GRF^FS" SKIP  /* Impressao da Imagem Tens∆o */
            "^FO134,95^A0N,18,18^FD"  c-data "^FS" SKIP   /* Data */
            "^FO195,95^A0N,18,18^FD" num-serie.sigla "^FS" SKIP /* Valor do Codigo de Barras EAN128 Número de S≤rie */
            "^FO15,125^A0N,15,15^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP /* Tens∆o */
            "^FO04,140^A0N,15,15^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP /* Corrente */
            "^FO119,110^XGlocal-fcc.GRF^FS" SKIP  /* Impressao da Imagem FCC */
            "^FO170,110^XGlocal-ce.GRF^FS" SKIP  /* Impressao da Imagem CE */
            "^FO04,160^A0N,17,17^FD" item-ean.fone /*"Suporte:(48) 2106-0006"*/ "^FS" SKIP

            /*etiqueta 2 */
            "^FO262,10^XGlocal-logo.GRF^FS" SKIP  /* Impressao da Imagem IntelBras */
            "^FO262,48^A0N,20,15^FDNS:" num-serie.n-serie "^FS" SKIP /* Valor do Codigo de Barras EAN128 Número de s≤rie */
            "^FO262,68^A0N,22,22^FD"  item-ean.linha[1] "^FS" SKIP   /* Imprime descricao Equipto */
            "^FO295,85^A0N,18,18^FD"  c-data "^FS" SKIP   /* Data */
            "^FO370,85^A0N,18,18^FD"  num-serie.sigla "^FS" SKIP   /* Sigla */
            "^FO395,50^XGlocal-logoma1.GRF^FS" SKIP  /* Impressao da Imagem Conheªa manaus */
            "^FO262,90^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP /* Imprime c´digo do item */
            "^FO295,100^BY1,3.0^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Número de s≤rie EAN 128 */
            "^FO285,130^BY2^BEN,25,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.       /* Codigo de Barras EAN 13 */


        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT UNFORMATTED
            "^PQ" STRING(1, "99999") SKIP  /* Quantidade de etiquetas a imprimir */
            "^XZ".

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-logo.GRF^FS^XZ"
        "^XA^IDlocal-logoma1.GRF^FS^XZ"
        "^XA^IDlocal-tensao.GRF^FS^XZ"
        "^XA^IDlocal-fcc.GRF^FS^XZ"
        "^XA^IDlocal-ce.GRF^FS^XZ".

END.  /* IF  p-cod-modelo = 13 THEN DO: */


/* ---[ Impress∆o Modelo 21 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 21 THEN DO:

    PUT UNFORMATTED
        "^XA"         SKIP   /* Inicio Label */
        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        "^PON"        SKIP   /* Orientacao impressora N = Normal */
        "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
        "^LL296"      SKIP   /* 824 ? o numero de Dot¡s que formam nr colunas da etiqueta */
        "^MNY"        SKIP   /* Papel de etiquetas contnuo */
        "^XZ" skip.
    
    ASSIGN iColuna = 1.
    
    FOR EACH tt-lista-ns,
        FIRST num-serie NO-LOCK
        WHERE num-serie.n-serie = tt-lista-ns.num-serie:

       
        IF  iColuna = 1 THEN DO:
            PUT UNFORMATTED "^XA" SKIP
                    "^FO15,5^BY1^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Numero de serie EAN 128 - Etiqueta Pequena 1 */
                    "^FO55,60^A0N,15,15,^FDNS:" num-serie.n-serie "^FS" SKIP.     /* Numero de serie - Etiqueta Pequena 1 */
                
            ASSIGN iColuna = 2.
        END. /* IF  iColuna = 1 THEN DO: */
        ELSE DO:
            PUT UNFORMATTED 
                    "^FO321,5^BY1^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Numero de serie EAN 128 - Etiqueta Pequena 2 */
                    "^FO360,60^A0N,15,15,^FDNS:" num-serie.n-serie "^FS" SKIP           /* Numero de serie - Etiqueta Pequena 2 */
                    "^XZ" SKIP.
    
            ASSIGN iColuna = 1.
        END. /* ELSE DO: */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.
        
            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT UNFORMATTED
            "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        
        IF l-reimp THEN RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    
    END. /* FOR EACH tt-lista-ns: */
    

    IF  iColuna = 2 THEN
        PUT UNFORMATTED 
            "^XZ" SKIP.

END.  /* IF  p-cod-modelo = 21 THEN DO: */


/* ---[ Impress∆o Modelo 22 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 22 THEN DO:

    FIND FIRST impressora NO-LOCK
        WHERE impressora.nom_impressora = imprsor_usuar.nom_impressora NO-ERROR.
    IF AVAIL impressora 
        AND impressora.des_localiz_imprsor BEGINS "300dpi" THEN DO:

        PUT UNFORMATTED
            "^XA"         SKIP   /* Inicio Label */
            "^PW1248"     SKIP   /* Para zebra com 300dpi */
            "^JUS"        SKIP   /* Novo comando para zebra 600 */
            "^PON"        SKIP   /* Orientacao impressora N = Normal */
            "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
            "^MNY"        SKIP   /* Papel de etiquetas contnuo */
            "^XZ" skip.

        ASSIGN iColuna = 1.

        FOR EACH tt-lista-ns,
            FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
            
            IF l-escpp105-imp-data THEN
                ASSIGN c-data = "".
            ELSE
                ASSIGN c-data = STRING(num-serie.data,"99/99/99").
    
            IF  iColuna = 1 THEN DO:
                PUT UNFORMATTED "^XA" SKIP
                    "^FO45,10^A0N,20,20^FD" num-serie.it-codigo "^FS" SKIP         /* Item - Etiqueta Pequena 1 */
                    "^FO330,10^A0N,20,20^FD" c-data "^FS" SKIP                     /* Data - Etiqueta Pequena 1 */
                    "^FO45,30^BY2^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Numero de serie EAN 128 - Etiqueta Pequena 1 */
                    "^FO110,85^A0N,20,30,^FDNS:" num-serie.n-serie "^FS" SKIP.     /* Numero de serie - Etiqueta Pequena 1 */
                    
                ASSIGN iColuna = 2.
            END. /* IF  iColuna = 1 THEN DO: */
            ELSE DO:
                PUT UNFORMATTED 
                    "^FO490,10^A0N,20,20^FD" num-serie.it-codigo "^FS" SKIP            /* Item - Etiqueta Pequena 2 */
                    "^FO775,10^A0N,20,20^FD" c-data  "^FS" SKIP                        /* Data - Etiqueta Pequena 2 */
                    "^FO490,30^BY2^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Numero de serie EAN 128 - Etiqueta Pequena 2 */
                    "^FO540,85^A0N,20,30,^FDNS:" num-serie.n-serie "^FS" SKIP           /* Numero de serie - Etiqueta Pequena 2 */
                    "^XZ" SKIP.
    
                ASSIGN iColuna = 1.
            END. /* ELSE DO: */
            
            IF l-reimp = NO AND
               l-registra-dup = YES
            THEN DO:
                FIND FIRST tt-ns-dup WHERE
                           tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                           NO-LOCK NO-ERROR.
            
                IF NOT AVAIL tt-ns-dup 
                THEN DO:
                    CREATE tt-ns-dup.
                    ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                           tt-ns-dup.n-serie-bd  = num-serie.n-serie
                           tt-ns-dup.modelo      = p-cod-modelo
                           tt-ns-dup.it-codigo   = item-ean.it-codigo
                           tt-ns-dup.duplicado   = NO.
                END.
                ELSE DO:
                    ASSIGN tt-ns-dup.duplicado   = YES.
                END.
            END.

            PUT UNFORMATTED
                "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            
            IF l-reimp THEN RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    
        END. /* FOR EACH tt-lista-ns: */


    END.
    ELSE DO:
    
        PUT UNFORMATTED
            "^XA"         SKIP   /* Inicio Label */
            "^PW832"      SKIP   /* Novo comando para zebra 600 */
            "^JUS"        SKIP   /* Novo comando para zebra 600 */
            "^PON"        SKIP   /* Orientacao impressora N = Normal */
            "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
            "^LL296"      SKIP   /* 824 ? o numero de Dot¡s que formam nr colunas da etiqueta */
            "^MNY"        SKIP   /* Papel de etiquetas contnuo */
            "^XZ" skip.
    
        ASSIGN iColuna = 1.
    
        FOR EACH tt-lista-ns,
            FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
            
            IF l-escpp105-imp-data THEN
                ASSIGN c-data = "".
            ELSE
                ASSIGN c-data = STRING(num-serie.data,"99/99/99").
    
            IF  iColuna = 1 THEN DO:
                PUT UNFORMATTED "^XA" SKIP
                    "^FO75,20^A0N,15,20^FD" num-serie.it-codigo "^FS" SKIP                 /* Item - Etiqueta Pequena 1 */
                    "^FO180,20^A0N,15,20^FD" c-data "^FS" SKIP                             /* Data - Etiqueta Pequena 1 */
                    "^FO75,35^BY1,3.0^BCN,26,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP      /* Numero de serie EAN 128 - Etiqueta Pequena 1 */
                    "^FO75,65^A0N,15,20,^FB180,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de serie - Etiqueta Pequena 1 */
                    
                ASSIGN iColuna = 2.
            END. /* IF  iColuna = 1 THEN DO: */
            ELSE DO:
                PUT UNFORMATTED 
                    "^FO371,20^A0N,15,20^FD" num-serie.it-codigo "^FS" SKIP            /* Item - Etiqueta Pequena 2 */
                    "^FO476,20^A0N,15,20^FD" c-data  "^FS" SKIP                        /* Data - Etiqueta Pequena 2 */
                    "^FO371,35^BY1,3.0^BCN,26,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP  /* Numero de serie EAN 128 - Etiqueta Pequena 2 */
                    "^FO371,65^A0N,15,20,^FB180,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP           /* Numero de serie - Etiqueta Pequena 2 */
                    "^XZ" SKIP.
    
                ASSIGN iColuna = 1.
            END. /* ELSE DO: */
            
            IF l-reimp = NO AND
               l-registra-dup = YES
            THEN DO:
                FIND FIRST tt-ns-dup WHERE
                           tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                           NO-LOCK NO-ERROR.
            
                IF NOT AVAIL tt-ns-dup 
                THEN DO:
                    CREATE tt-ns-dup.
                    ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                           tt-ns-dup.n-serie-bd  = num-serie.n-serie
                           tt-ns-dup.modelo      = p-cod-modelo
                           tt-ns-dup.it-codigo   = item-ean.it-codigo
                           tt-ns-dup.duplicado   = NO.
                END.
                ELSE DO:
                    ASSIGN tt-ns-dup.duplicado   = YES.
                END.
            END.

            PUT UNFORMATTED
                "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            
            IF l-reimp THEN RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    
        END. /* FOR EACH tt-lista-ns: */
    END.

    IF  iColuna = 2 THEN
        PUT UNFORMATTED 
            "^XZ" SKIP.

END.  /* IF  p-cod-modelo = 22 THEN DO: */

/* ---[ Impress∆o Modelo 23 ]---------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 23 THEN DO:
    
    PUT UNFORMATTED
         "^XA"         SKIP   /* Inicio Label */
         "^PW832"      SKIP   /* Novo comando para zebra 600 */
         "^JUS"        SKIP   /* Novo comando para zebra 600 */
         "^LL296"      SKIP   /* 824 ? o numero de Dot¡s que formam nr colunas da etiqueta */
         "^MNY"        SKIP     /* Papel de etiquetas com quebra de etiquetas */
         "^FWN"        SKIP.   /* Orientacao dos Campos N = Normal */

    FOR FIRST item-dun NO-LOCK
        WHERE item-dun.it-codigo = p-it-codigo
        AND   item-dun.qtd-emb   = p-qtd-embalagem:
    
        PUT UNFORMATTED "^FO60,35^A0B,30,30^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO140,35^BY3,^BCN,100,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
        PUT UNFORMATTED "^FO520,35^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
        IF item-ean.destaque = "" THEN DO:
            PUT UNFORMATTED "^FO60,180^A0N,42,34^FB495,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO60,230^A0N,42,34^FB495,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO60,170^GB495,0,100^FS^LRN" SKIP.  /* Quadro preto */
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO60,180^A0N,42,34^FB420,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO60,230^A0N,42,34^FB420,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO60,170^GB420,0,100^FS^LRN" SKIP.  /* Quadro preto */ 
        
            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO480,175^XGlocal-chave.GRF^FS" SKIP. 
            END.
            ELSE
                PUT UNFORMATTED "^FO505,190,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
        
            PUT UNFORMATTED "^LRY^FO490,170^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */
        END.
        
        PUT UNFORMATTED "^FO390,280^A0N,42,22^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */

        PUT UNFORMATTED
             "^PQ" STRING(p-qtd-etiquetas, "99999") SKIP                               /* Repetiá‰es */
             "^XZ".

    END. 
END.  


/* ---[ Impress∆o Modelo 39 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 39 THEN DO:

    /* Carrega a imagem para a impressora */
    RUN piCargaImagem("local-logo").
    RUN piCargaImagem("local-logoma1").
    RUN piCargaImagem("local-cloud").
    
    PUT "^XA"         SKIP.   /* Inicio Label */
    PUT "^PW832"      SKIP.   /* Width 832 */
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
    PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
    PUT "^JUS"        SKIP.   /* Grava Configuracao */
    PUT "^XZ"         SKIP.
    
    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        ASSIGN c-data = "D:" + STRING(MONTH(num-serie.data), "99") + string(SUBSTRING(STRING(YEAR(num-serie.data)),3,2), "99").
    
        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO40,30^A0B,18,16^FD" c-data "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO30,100^A0N,20,20^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO66,30^BY2^BEN,104,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO270,30^A0B,20,20^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO20,170^A0N,24,20^FD"  item-ean.linha[1]    /* Imprime descricao Equipto */
                                  " " 
                                  item-ean.linha[2] 
                                  "^FS" SKIP.
        PUT UNFORMATTED "^FO20,195^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO20,225^A0N,24,20^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO220,225^A0N,24,20^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED
            "^FO340,30^XGlocal-logo.GRF^FS" SKIP  /* Impressao da Imagem IntelBras */
            "^FO340,60^XGlocal-cloud.GRF^FS" SKIP  /* Cloud */
            "^FO360,85^BQN,2,6^FDQA," num-serie.n-serie "^FS" SKIP  /* C¢digo de Barras do N£mero de SÇrie */
            "^FO350,230^A0N,24,20^FDID:" num-serie.n-serie "^FS" SKIP. /* N£mero de SÇrie */
        PUT UNFORMATTED
            /* 560 */
            "^FO550,20^XGlocal-logo.GRF^FS" SKIP  /* Impressao da Imagem IntelBras */
            "^FO550,58^A0N,20,20^FD"  item-ean.linha[1]    /* Imprime descricao Equipto */ "^FS" SKIP
            "^FO720,55^XGlocal-logoma1.GRF^FS" SKIP  /* Impressao da Imagem Conheªa manaus */
            "^FO550,80^A0N,20,15^FDNS:" num-serie.n-serie "^FS" SKIP /* Valor do Codigo de Barras EAN128 */
            "^FO580,105^BY2^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP       /* Codigo de Barras EAN 13 */
            "^FO785,110^A0B,18,15^FD" num-serie.sigla "^FS" SKIP  /* Sigla */
            "^FO785,130^A0B,18,15^FD" c-data "^FS" SKIP  /* Imprime Data na Vertical */
            "^FO565,160^A0N,18,18^FD" item-ean.fone /*"Suporte:(48) 2106-0006"*/ "^FS" SKIP.
        PUT UNFORMATTED "^FO640,210^A0N,22,18^FD" num-serie.sigla "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */
        PUT UNFORMATTED "^FO740,210^A0N,22,18^FD" c-data "^FS" SKIP. /* Data - Etiqueta Pequena 2 */
        PUT UNFORMATTED "^FO640,233^A0N,22,18,^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s≤rie - Etiqueta Pequena 2*/

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-logo.GRF^FS^XZ"
        "^XA^IDlocal-logoma2.GRF^FS^XZ".
END.  /* IF  p-cod-modelo = 39 THEN DO: */


/* ---[ Impress∆o Modelo 44 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 44 THEN DO:

    /* Carrega a imagem para a impressora */
    RUN piCargaImagem("local-logoma2").
    
    PUT "^XA"         SKIP.   /* Inicio Label */
    PUT "^PW832"      SKIP.   /* Width 832 */
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
    PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
    PUT "^JUS"        SKIP.   /* Grava Configuracao */
    PUT "^XZ"         SKIP.

    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.
    
        /* Tempor†rio para resolver rolo de etiqueta com problema */
            
        IF item-ean.it-codigo = "4565206" 
                OR item-ean.it-codigo = "4565207"
                OR item-ean.it-codigo = "4565208"
                OR item-ean.it-codigo = "4565209"
                OR item-ean.it-codigo = "4565210"
                OR item-ean.it-codigo = "4562033"
                OR item-ean.it-codigo = "4562034" THEN DO:

            PUT "^XA" SKIP.
            
            PUT UNFORMATTED "^FO55,75,1^A0B,18,18^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */
            
            PUT UNFORMATTED "^FO75,75,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
            
            PUT UNFORMATTED "^FO145,75^BY3^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    
            PUT UNFORMATTED "^FO540,75,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
    
            
            
            PUT UNFORMATTED "^FO40,230^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
    
            PUT UNFORMATTED "^FO40,260^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
    
            PUT UNFORMATTED "^LRY^FO40,215^GB500,0,80^FS^LRN" SKIP.  /* Quadro preto */
    
    
                                      
            PUT UNFORMATTED "^FO110,310^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
            
            PUT UNFORMATTED "^FO40,350^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
            
            PUT UNFORMATTED "^FO485,345^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
    
            /**/
    
            IF item-ean.texto[1] <> "" AND
               item-ean.texto[1] <> ? THEN
                PUT UNFORMATTED "^FO40,390^A0N,18,18^FDØ " item-ean.texto[1] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[2] <> "" AND
               item-ean.texto[2] <> ? THEN
                PUT UNFORMATTED "^FO300,390^A0N,18,18^FDØ " item-ean.texto[2] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[3] <> "" AND
               item-ean.texto[3] <> ? THEN
                PUT UNFORMATTED "^FO40,420^A0N,18,18^FDØ " item-ean.texto[3] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[4] <> "" AND
               item-ean.texto[4] <> ? THEN
                PUT UNFORMATTED "^FO300,420^A0N,18,18^FDØ " item-ean.texto[4] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[5] <> "" AND
               item-ean.texto[5] <> ? THEN
                PUT UNFORMATTED "^FO40,450^A0N,18,18^FDØ " item-ean.texto[5] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[6] <> "" AND
               item-ean.texto[6] <> ? THEN
                PUT UNFORMATTED "^FO300,450^A0N,18,18^FDØ " item-ean.texto[6] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[7] <> "" AND
               item-ean.texto[7] <> ? THEN
                PUT UNFORMATTED "^FO40,480^A0N,18,18^FDØ " item-ean.texto[7] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[8] <> "" AND
               item-ean.texto[8] <> ? THEN
                PUT UNFORMATTED "^FO300,480^A0N,18,18^FDØ " item-ean.texto[8] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[9] <> "" AND
               item-ean.texto[9] <> ? THEN
                PUT UNFORMATTED "^FO40,510^A0N,18,18^FDØ " item-ean.texto[9] "^FS" SKIP. /* Sigla */
    
            IF item-ean.texto[10] <> "" AND
               item-ean.texto[10] <> ? THEN
                PUT UNFORMATTED "^FO300,510^A0N,18,18^FDØ " item-ean.texto[10] "^FS" SKIP. /* Sigla */

            

            PUT UNFORMATTED "^FO595,45^A0N,20,20^FB215,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
    
            PUT UNFORMATTED "^LRY^FO580,40^GB245,0,25^FS^LRN" SKIP.  /* Quadro preto */
            
            PUT UNFORMATTED "^FO595,70^A0N,11,11^FDINTELBRAS S/A^FS" SKIP.  /* Imprime Made In Brazil */
            
            PUT UNFORMATTED "^FO595,83^A0N,11,11^FDCNPJ:82901000/0001-27^FS" SKIP.  /* Imprime CGC */
    
            PUT UNFORMATTED "^FO595,96^A0N,11,11^FD" item-ean.fone "^FS" SKIP.
            
            PUT UNFORMATTED "^FO595,109^A0N,11,11^FDINDÈSTRIA BRASILEIRA^FS" SKIP.  /* Imprime Made In Brazil */
    
            PUT UNFORMATTED "^FO595,122^A0N,11,11^FD" item-ean.origem "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
    
            PUT UNFORMATTED "^FO595,135^A0N,11,11^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
    
            PUT UNFORMATTED "^FO595,148^A0N,11,11^FD" item-ean.flash "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
    
            PUT UNFORMATTED "^FO710,70^A0N,12,12^FB105,1,0,C^FDPRODUZIDO NO^FS" SKIP.
            PUT UNFORMATTED "^FO710,83^A0N,12,12^FB105,1,0,C^FDPOLO INDUSTRIAL^FS" SKIP.
            PUT UNFORMATTED "^FO710,96^A0N,12,12^FB105,1,0,C^FDDE MANAUS^FS" SKIP.
            PUT UNFORMATTED "^FO710,109^XGlocal-logoma2.GRF^FS" SKIP. 
            PUT UNFORMATTED "^FO710,134^A0N,11,11^FB105,1,0,C^FDCONHECA A AMAZONIA^FS" SKIP.
    
            PUT UNFORMATTED "^FO710,148^A0N,12,12^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
            
            /* */
            PUT UNFORMATTED "^FO595,220^A0N,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
    
            PUT UNFORMATTED "^FO595,245^A0N,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
    
            /**/
            /**/
    
            PUT UNFORMATTED "^FO595,325^A0N,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
    
            PUT UNFORMATTED "^FO595,350^A0N,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
                

            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
            
        END.
            /* Fim customizaá∆o tempor†ria */
        ELSE DO:
            PUT "^XA" SKIP.
            PUT UNFORMATTED "^FO45,45,1^A0B,18,18^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */
            PUT UNFORMATTED "^FO65,45,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO135,45^BY3^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
            PUT UNFORMATTED "^FO530,45,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
            PUT UNFORMATTED "^FO30,200^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO30,230^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO30,185^GB500,0,80^FS^LRN" SKIP.  /* Quadro preto */
            PUT UNFORMATTED "^FO100,280^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
            PUT UNFORMATTED "^FO30,320^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
            PUT UNFORMATTED "^FO475,315^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
            
            IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
                PUT UNFORMATTED "^FO30,360^A0N,18,18^FD" (IF item-ean.lmarcador[1] THEN "Ø " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
                PUT UNFORMATTED "^FO290,360^A0N,18,18^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
                PUT UNFORMATTED "^FO30,390^A0N,18,18^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
                PUT UNFORMATTED "^FO290,390^A0N,18,18^FD" (IF item-ean.lmarcador[4] THEN "Ø " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[5] <> "" AND item-ean.texto[5] <> ? THEN
                PUT UNFORMATTED "^FO30,420^A0N,18,18^FD" (IF item-ean.lmarcador[5] THEN "Ø " ELSE "") + item-ean.texto[5] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[6] <> "" AND item-ean.texto[6] <> ? THEN
                PUT UNFORMATTED "^FO290,420^A0N,18,18^FD" (IF item-ean.lmarcador[6] THEN "Ø " ELSE "") + item-ean.texto[6] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[7] <> "" AND item-ean.texto[7] <> ? THEN
                PUT UNFORMATTED "^FO30,450^A0N,18,18^FD" (IF item-ean.lmarcador[7] THEN "Ø " ELSE "") + item-ean.texto[7] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[8] <> "" AND item-ean.texto[8] <> ? THEN
                PUT UNFORMATTED "^FO290,450^A0N,18,18^FD" (IF item-ean.lmarcador[8] THEN "Ø " ELSE "") + item-ean.texto[8] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[9] <> "" AND item-ean.texto[9] <> ? THEN
                PUT UNFORMATTED "^FO30,480^A0N,18,18^FD" (IF item-ean.lmarcador[9] THEN "Ø " ELSE "") + item-ean.texto[9] "^FS" SKIP. /* Sigla */

            IF item-ean.texto[10] <> "" AND item-ean.texto[10] <> ? THEN
                PUT UNFORMATTED "^FO290,480^A0N,18,18^FD" (IF item-ean.lmarcador[10] THEN "Ø " ELSE "") + item-ean.texto[10] "^FS" SKIP. /* Sigla */

            PUT UNFORMATTED "^FO585,15^A0N,20,20^FB215,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO570,10^GB245,0,25^FS^LRN" SKIP.  /* Quadro preto */
            PUT UNFORMATTED "^FO585,40^A0N,11,11^FDINTELBRAS S/A^FS" SKIP.  /* Imprime Made In Brazil */
            PUT UNFORMATTED "^FO585,53^A0N,11,11^FDCNPJ:82901000/0001-27^FS" SKIP.  /* Imprime CGC */
            PUT UNFORMATTED "^FO585,66^A0N,11,11^FD" item-ean.fone "^FS" SKIP.
            PUT UNFORMATTED "^FO585,79^A0N,11,11^FDINDÈSTRIA BRASILEIRA^FS" SKIP.  /* Imprime Made In Brazil */
            PUT UNFORMATTED "^FO585,92^A0N,11,11^FD" item-ean.origem "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
            PUT UNFORMATTED "^FO585,105^A0N,11,11^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO585,118^A0N,11,11^FD" item-ean.flash "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
            PUT UNFORMATTED "^FO700,40^A0N,12,12^FB105,1,0,C^FDPRODUZIDO NO^FS" SKIP.
            PUT UNFORMATTED "^FO700,53^A0N,12,12^FB105,1,0,C^FDPOLO INDUSTRIAL^FS" SKIP.
            PUT UNFORMATTED "^FO700,66^A0N,12,12^FB105,1,0,C^FDDE MANAUS^FS" SKIP.
            PUT UNFORMATTED "^FO700,79^XGlocal-logoma2.GRF^FS" SKIP. 
            PUT UNFORMATTED "^FO700,104^A0N,11,11^FB105,1,0,C^FDCONHECA A AMAZONIA^FS" SKIP.
            PUT UNFORMATTED "^FO700,118^A0N,12,12^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
            PUT UNFORMATTED "^FO585,190^A0N,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO585,215^A0N,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
            PUT UNFORMATTED "^FO585,295^A0N,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO585,320^A0N,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
        END.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-logoma2.GRF^FS^XZ".
END.  /* IF  p-cod-modelo = 44 THEN DO: */


/* ---[ Impress∆o Modelo 45 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 45 THEN DO:
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a1.i}     /* Etiqueta item ean13 e NS */
        {esapi/esapi016a2.i 425 27 15} /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425} /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635} /* etiqueta 24x8mm esquerda */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO450,90^A0N,14,14^FD" item-ean.char-2 "^FS"                         SKIP.
        PUT UNFORMATTED "^FO450,110^A0N,14,14^FDCNPJ: " c-cgc "^FS"                            SKIP.
        PUT UNFORMATTED "^FO450,130^A0N,14,14^FD" item-ean.fone "^FS"                          SKIP.
        PUT UNFORMATTED "^FO615,130^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[1] "^FS"       SKIP.
        PUT UNFORMATTED "^FO615,150^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[2] "^FS"       SKIP.
        PUT UNFORMATTED "^FO615,90^A0N,14,14^FB200,1,0,R^FD" item-ean.origem "^FS"            SKIP. 
        PUT UNFORMATTED "^FO615,110^A0N,14,14^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO450,175^A0N,20,20^FB375,1,0,C^FDNS:" num-serie.n-serie "^FS"       SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 45 */


/* ---[ Impress∆o Modelo 46 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 46 THEN DO:
    RUN piCargaImagem("local-anatel5").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a1.i}     /* Etiqueta item ean13 e NS */
        {esapi/esapi016a2.i 425 27 15}     /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425} /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635} /* etiqueta 24x8mm esquerda */
        {esapi/esapi016a4.i "L" 450} /*Etiqueta n∆o homologada*/

        PUT UNFORMATTED "^FO675,75^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */
                        "^FO605,138^A0N,12,12^FB215,1,0,C^FD" item-ean.homolog "^FS"                   SKIP  /* homologaá∆o */
                        "^FO605,155^BY1,3.0^BCN,24,N,N,N,N^FD010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
                        "^FO605,184^A0N,12,12^FB215,1,0,C^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 46 */


/* ---[ Impress∆o Modelo 47 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 47 THEN DO:
    RUN piCargaImagem("local-manaus").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a1.i}         /* Etiqueta item ean13 e NS */
        {esapi/esapi016a2.i 425 27 15}     /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425}     /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635}     /* etiqueta 24x8mm esquerda */
        {esapi/esapi016a4.i "L" 450} /*Etiqueta n∆o homologada*/

        PUT UNFORMATTED "^FO610,68^XGlocal-manaus.GRF^FS". /* Impressao da Imagem ANATEL */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-manaus.GRF^FS^XZ".
END. /* modelo 47 */


/* ---[ Impress∆o Modelo 48 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 48 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:

        FIND FIRST estabelec 
            WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-LOCK NO-ERROR.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO20,30^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO65,30^BY2^BEN,45,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.       /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO265,30^A0B,20,20^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO290,30^A0N,14,14^FD" item-ean.char-2 "^FS"                       SKIP.
        PUT UNFORMATTED "^FO290,45^A0N,14,14^FDCNPJ: " c-cgc "^FS"                           SKIP.
        PUT UNFORMATTED "^FO290,60^A0N,14,14^FB150,1,0,L^FD" item-ean.fone "^FS"             SKIP.
        PUT UNFORMATTED "^FO290,80^A0N,18,18^FB178,1,0,L^FDNS:" num-serie.n-serie "^FS"      SKIP. /* Valor do Codigo de Barras EAN128 */

        PUT UNFORMATTED "^FO435,30^A0N,14,14^FB140,1,0,R^FD" item-ean.origem "^FS"           SKIP.

        IF  item-ean.origem = "ind£stria brasileira" THEN /**/
            PUT UNFORMATTED "^FO435,45^A0N,14,12^FB140,1,0,R^FDFABRICADO EN BRASIL^FS"       SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
            
                PUT UNFORMATTED "^FO432,65^A0N,13,12^FB140,1,0,R^FDEste produto Ç beneficiado pela^FS" SKIP.
                PUT UNFORMATTED "^FO435,80^A0N,13,12^FB140,1,0,R^FDLegislaá∆o de Inform†tica^FS"       SKIP.
        
            END.
        END.
        

        PUT UNFORMATTED "^FO118,132^BY2^BCN,25,N,N,N,N^FD" num-serie.n-serie "^FS"           SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO20,132^A0N,26,26^FB553,1,0,R^FD" num-serie.sigla "^FS"           SKIP. /* Sigla */
        
        PUT UNFORMATTED "^FO20,110^A0N,14,14^FB553,1,0,C^FD" + estabelec.endereco + ", " +
                        estabelec.bairro + ", " + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.
         
        FOR EACH traduc-item
            WHERE traduc-item.it-codigo = item-ean.it-codigo NO-LOCK:

            IF traduc-item.cod-idioma BEGINS "Por" THEN
                PUT UNFORMATTED 
                   "^FO20,165^A0N,20,24^FB553,1,0,C^FD" traduc-item.tr-desc-item 
                                            "^FS" SKIP. /* Descri? o em Portugu?s */
            
            IF traduc-item.cod-idioma  BEGINS "Esp" THEN
                PUT UNFORMATTED 
                  "^FO20,185^A0N,20,24^FB553,1,0,C^FD" traduc-item.tr-desc-item 
                                           "^FS" SKIP. /* Descri? o em Espanhol */
            
            /*IF traduc-item.cod-idioma BEGINS "Ing" THEN
                PUT UNFORMATTED 
                  "^FO20,185^A0N,20,24^FB553,1,0,C^FD" traduc-item.tr-desc-item 
                                           "^FS" SKIP. /* Descri? o em Ingl?s */        */
        END.

       /* PUT UNFORMATTED "^LRY^FO20,138^GB553,0,90^FS^LRN" SKIP. */ /* Quadro preto */
        PUT UNFORMATTED "^FO633,30^A0R,20,20^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT UNFORMATTED "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 48 */


/* ---[ Impress∆o Modelo 49 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 49 THEN DO:
    RUN piCargaImagem("local-anatel5").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento deve ser conectado obrigatoriamente em tomada de rede de energia elÇtrica que possua aterramento (tràs pinos), conforme a Norma NBR ABNT 5410, visando a seguranáa  dos usu†rios contra choques elÇtricos".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 0 27 15}      /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425}    /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635}    /* etiqueta 24x8mm esquerda */
        {esapi/esapi016a4.i "L" 20} /*Etiqueta n∆o homologada*/
        {esapi/esapi016a6.i c-texto 16 15 75} /*RetÉngulo com norma ABNT*/
        {esapi/esapi016a5.i}         /*EAN 13 50x24*/

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 49 */


/* ---[ Impress∆o Modelo 50 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 50 THEN DO:
    RUN piCargaImagem("local-anatel5").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento opera em car†ter secund†rio, isto Ç, n∆o tem direito a proteá∆o contra interferància prejudicial, mesmo de estaá‰es do mesmo tipo, e n∆o pode causar interferància a sistemas operando em car†ter prim†rio.".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 0 27 15}      /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425}    /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635}    /* etiqueta 24x8mm esquerda */
        {esapi/esapi016a4.i "L" 20} /*Etiqueta n∆o homologada*/
        {esapi/esapi016a6.i c-texto 16 15 75} /*RetÉngulo com norma ABNT*/
        {esapi/esapi016a5.i}         /*EAN 13 50x24*/

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 50 */


/* ---[ Impress∆o Modelo 51 e 56 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 51 OR p-cod-modelo = 56 THEN DO:

    RUN piCargaImagem("local-NOMNYCE").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a1.i}     /* Etiqueta item ean13 e NS */
        {esapi/esapi016a2.i 425 27 15} /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425} /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635} /* etiqueta 24x8mm esquerda */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO425,60^A0N,20,20^FB408,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO450,90^A0N,14,14^FD" item-ean.char-2 "^FS"                                              SKIP.
        PUT UNFORMATTED "^FO450,110^A0N,14,14^FDCNPJ: " c-cgc                                            "^FS" SKIP.
        PUT UNFORMATTED "^FO450,130^A0N,14,14^FD" item-ean.origem                                        "^FS" SKIP.
        PUT UNFORMATTED "^FO450,150^A0N,14,14^FB200,1,0,L^FD" STRING(num-serie.data,"99/99/99")          "^FS" SKIP.
        PUT UNFORMATTED "^FO615,90 ^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO615,110^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
        PUT UNFORMATTED "^FO615,130^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO450,175^A0N,20,20^FB375,1,0,L^FDNS:" num-serie.n-serie                       "^FS" SKIP.
        IF p-cod-modelo = 51 THEN
            PUT UNFORMATTED "^FO710,135^XGlocal-NOMNYCE.GRF^FS".

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        /*Etiqueta exportaá∆o mexico*/
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO30,30^A0N,16,16^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,14,14^FDMarca: INTELBRAS^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,14,14^FB368,1,0,R^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO30,65^A0N,14,14^FDModelo:" item-ean.nome-abrev "^FS" SKIP.

        PUT UNFORMATTED "^FO30,80^A0N,14,14^FDImportado por: Industria de Telecomunicaci¢n Electr¢nica^FS" SKIP.
        PUT UNFORMATTED "^FO30,95^A0N,14,14^FDBrasile§a de MÇxico S.A. de C.V.^FS" SKIP.
        PUT UNFORMATTED "^FO30,110^A0N,14,14^FDAvenida FÇlix Cuevas, 301 - 205^FS" SKIP.
        PUT UNFORMATTED "^FO30,125^A0N,14,14^FDCol. Del Valle, Del. Benito Juarez^FS" SKIP.
        PUT UNFORMATTED "^FO30,140^A0N,14,14^FDC.P. 03100 - MÇxico, D.F.^FS" SKIP.
        PUT UNFORMATTED "^FO30,155^A0N,14,14^FD" item-ean.texto[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,170^A0N,14,14^FD" item-ean.texto[2] "^FS" SKIP.
        IF p-cod-modelo = 51 THEN
            PUT UNFORMATTED "^FO285,155^XGlocal-NOMNYCE.GRF^FS".
        PUT UNFORMATTED "^FO30,185^A0N,14,14^FD" item-ean.texto[3] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,200^A0N,14,14^FD" item-ean.texto[4] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,215^A0N,14,14^FD" item-ean.texto[5] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,230^A0N,14,14^FD" item-ean.texto[6] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,245^A0N,14,14^FD" item-ean.texto[7] "^FS" SKIP.
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-NOMNYCE.GRF^FS^XZ".
END. /* modelo 51 */


/* ---[ Impress∆o Modelo 52 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 52 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a1.i}     /* Etiqueta item ean13 e NS */
        {esapi/esapi016a2.i 425 27 15} /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425} /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635} /* etiqueta 24x8mm esquerda */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO425,60^A0N,20,20^FB408,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO450,90^A0N,14,14^FD" item-ean.char-2 "^FS"                                         SKIP.
        PUT UNFORMATTED "^FO450,110^A0N,14,14^FDCNPJ: " c-cgc                                            "^FS" SKIP.
        PUT UNFORMATTED "^FO450,130^A0N,14,14^FD" item-ean.origem                                        "^FS" SKIP.
        PUT UNFORMATTED "^FO450,150^A0N,14,14^FB200,1,0,L^FD" STRING(num-serie.data,"99/99/99")          "^FS" SKIP.
        PUT UNFORMATTED "^FO615,90 ^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO615,110^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
        PUT UNFORMATTED "^FO615,130^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO450,175^A0N,20,20^FB375,1,0,C^FDNS:" num-serie.n-serie                       "^FS" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 52 */


/* ---[ Impress∆o Modelo 53 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 53 THEN DO:
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a7.i}     /* Etiqueta item ean13 e NS - 50x31mm */

        /*Etiqueta n∆o homologada*/

        PUT UNFORMATTED "^FO550,70^A0N,12,12^FD" item-ean.char-2 "^FS"                              SKIP.
        PUT UNFORMATTED "^FO605,70^A0N,12,12^FB200,1,0,R^FD" item-ean.origem "^FS"            SKIP.
        PUT UNFORMATTED "^FO550,85^A0N,12,12^FDCNPJ: " c-cgc "^FS"                            SKIP.
        PUT UNFORMATTED "^FO550,100^A0N,12,12^FD" item-ean.fone "^FS"                          SKIP.
        
        PUT UNFORMATTED "^FO605,85^A0N,12,12^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO605,100^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO543,145^A0N,20,20^FB280,1,0,C^FDNS:" num-serie.n-serie "^FS"       SKIP.

        PUT UNFORMATTED "^FO415,203^A0N,18,16^FB190,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
        PUT UNFORMATTED "^FO415,223^A0N,18,16^FB190,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
        PUT UNFORMATTED "^FO625,203^A0N,18,16^FB190,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */
        PUT UNFORMATTED "^FO625,223^A0N,18,16^FB190,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */
        PUT UNFORMATTED "^FO430,1^A0B,18,16^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 3 */
        PUT UNFORMATTED "^FO450,1^A0B,18,16^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 3 */
        
        PUT UNFORMATTED "^FO543,15^A0N,24,24^FB272,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO543,1^GB272,40,40^FS^LRN" SKIP.  /* Quadro preto */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 53 */


/* ---[ Impress∆o Modelo 54 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 54 THEN DO:

    RUN piCargaImagem("local-anatelpp").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a7.i}     /* Etiqueta item ean13 e NS - 50x31mm */
        {esapi/esapi016a8.i}     /* Etiquetas pequenas quintupla e modelo com tarja no topo da etiqueta a direita */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO550,50^A0N,12,12^FD" item-ean.char-2 "^FS"                        SKIP.
        PUT UNFORMATTED "^FO605,50^A0N,12,12^FB200,1,0,R^FD" item-ean.origem "^FS"            SKIP.

        PUT UNFORMATTED "^FO550,65^A0N,12,12^FDCNPJ: " c-cgc "^FS"                            SKIP.
        PUT UNFORMATTED "^FO550,80^A0N,12,12^FD" item-ean.fone "^FS"                          SKIP.
        
        PUT UNFORMATTED "^FO605,65^A0N,12,12^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO605,80^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO543,95^A0N,20,20^FB280,1,0,C^FDNS:" num-serie.n-serie "^FS"       SKIP.

        PUT UNFORMATTED "^FO540,85^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
        PUT UNFORMATTED "^FO595,115^A0N,12,12^FD" item-ean.homolog "^FS"                   SKIP.  /* homologaá∆o */
        PUT UNFORMATTED "^FO595,128^BY1,3.0^BCN,22,N,N,N,N^FD010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^FO595,154^A0N,12,12^FB215,1,0,L^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 54 */


/* ---[ Impress∆o Modelo 55 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 55 THEN DO:

    RUN piCargaImagem("local-manausp").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a7.i}     /* Etiqueta item ean13 e NS - 50x31mm */
        {esapi/esapi016a8.i}     /* Etiquetas pequenas quintupla e modelo com tarja no topo da etiqueta a direita */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO550,50^A0N,12,12^FD" item-ean.char-2 "^FS"                        SKIP.
        PUT UNFORMATTED "^FO550,95^A0N,14,12^FD" item-ean.origem "^FS"                        SKIP.

        PUT UNFORMATTED "^FO550,65^A0N,14,12^FDCNPJ: " c-cgc "^FS"                            SKIP.
        PUT UNFORMATTED "^FO550,80^A0N,14,12^FD" item-ean.fone "^FS"                          SKIP.
        
        PUT UNFORMATTED "^FO550,110^A0N,14,12^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO550,125^A0N,14,12^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO550,150^A0N,20,20^FDNS:" num-serie.n-serie "^FS"       SKIP.

        PUT UNFORMATTED "^FO680,27^XGlocal-manausp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-manausp.GRF^FS^XZ".
END. /* modelo 55 */


/* ---[ Impress∆o Modelo 57 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 57 THEN DO:

    /* Carrega a imagem para a impressora */
    RUN piCargaImagem("local-logoma2").
    
    PUT "^XA"         SKIP.   /* Inicio Label */
    PUT "^PW832"      SKIP.   /* Width 832 */
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
    PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
    PUT "^JUS"        SKIP.   /* Grava Configuracao */
    PUT "^XZ"         SKIP.

    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.
    
        /* Tempor†rio para resolver rolo de etiqueta com problema */
            
        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO45,45,1^A0B,18,18^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO65,45,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO135,45^BY3^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO530,45,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO30,200^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO30,230^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO30,185^GB500,0,80^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO100,280^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO30,320^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO475,315^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
            PUT UNFORMATTED "^FO30,360^A0N,18,18^FD" (IF item-ean.lmarcador[1] THEN "Ø " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
            PUT UNFORMATTED "^FO290,360^A0N,18,18^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
            PUT UNFORMATTED "^FO30,390^A0N,18,18^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
            PUT UNFORMATTED "^FO290,390^A0N,18,18^FD" (IF item-ean.lmarcador[4] THEN "Ø " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[5] <> "" AND item-ean.texto[5] <> ? THEN
            PUT UNFORMATTED "^FO30,420^A0N,18,18^FD" (IF item-ean.lmarcador[5] THEN "Ø " ELSE "") + item-ean.texto[5] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[6] <> "" AND item-ean.texto[6] <> ? THEN
            PUT UNFORMATTED "^FO290,420^A0N,18,18^FD" (IF item-ean.lmarcador[6] THEN "Ø " ELSE "") + item-ean.texto[6] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[7] <> "" AND item-ean.texto[7] <> ? THEN
            PUT UNFORMATTED "^FO30,450^A0N,18,18^FD" (IF item-ean.lmarcador[7] THEN "Ø " ELSE "") + item-ean.texto[7] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[8] <> "" AND item-ean.texto[8] <> ? THEN
            PUT UNFORMATTED "^FO290,450^A0N,18,18^FD" (IF item-ean.lmarcador[8] THEN "Ø " ELSE "") + item-ean.texto[8] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[9] <> "" AND item-ean.texto[9] <> ? THEN
            PUT UNFORMATTED "^FO30,480^A0N,18,18^FD" (IF item-ean.lmarcador[9] THEN "Ø " ELSE "") + item-ean.texto[9] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[10] <> "" AND item-ean.texto[10] <> ? THEN
            PUT UNFORMATTED "^FO290,480^A0N,18,18^FD" (IF item-ean.lmarcador[10] THEN "Ø " ELSE "") + item-ean.texto[10] "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FO585,15^A0N,20,20^FB215,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO570,10^GB245,0,25^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO585,40^A0N,11,11^FDINTELBRAS S/A^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO585,53^A0N,11,11^FDCNPJ:82901000/0001-27^FS" SKIP.  /* Imprime CGC */
        PUT UNFORMATTED "^FO585,66^A0N,11,11^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO585,79^A0N,11,11^FDINDÈSTRIA BRASILEIRA^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO585,92^A0N,11,11^FD" item-ean.origem "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
        PUT UNFORMATTED "^FO585,105^A0N,11,11^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO585,118^A0N,11,11^FD" item-ean.flash "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
        PUT UNFORMATTED "^FO700,40^A0N,12,12^FB105,1,0,C^FDPRODUZIDO NO^FS" SKIP.
        PUT UNFORMATTED "^FO700,53^A0N,12,12^FB105,1,0,C^FDPOLO INDUSTRIAL^FS" SKIP.
        PUT UNFORMATTED "^FO700,66^A0N,12,12^FB105,1,0,C^FDDE MANAUS^FS" SKIP.
        PUT UNFORMATTED "^FO700,79^XGlocal-logoma2.GRF^FS" SKIP. 
        PUT UNFORMATTED "^FO700,104^A0N,11,11^FB105,1,0,C^FDCONHECA A AMAZONIA^FS" SKIP.
        PUT UNFORMATTED "^FO700,118^A0N,12,12^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
        PUT UNFORMATTED "^FO585,190^A0N,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO585,215^A0N,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
        PUT UNFORMATTED "^FO585,295^A0N,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO585,320^A0N,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-logoma2.GRF^FS^XZ".
END.  /* IF  p-cod-modelo = 57 THEN DO: */


/* ---[ Impress∆o Modelo 58 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 58 THEN DO:

    RUN piCargaImagem("local-NOMNYCE").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a7.i}     /* Etiqueta item ean13 e NS - 50x31mm */
        {esapi/esapi016a8.i}     /* Etiquetas pequenas quintupla e modelo com tarja no topo da etiqueta a direita */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO550,50^A0N,14,12^FB260,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO550,75^A0N,12,12^FD" item-ean.char-2 "^FS"                                         SKIP.
        PUT UNFORMATTED "^FO550,90^A0N,12,12^FDCNPJ: " c-cgc                                            "^FS" SKIP.
        PUT UNFORMATTED "^FO550,105^A0N,12,12^FD" item-ean.origem                                        "^FS" SKIP.
        PUT UNFORMATTED "^FO550,120^A0N,12,12^FD" STRING(num-serie.data,"99/99/99")                 "^FS" SKIP.
        PUT UNFORMATTED "^FO610,75 ^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO610,90^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
        PUT UNFORMATTED "^FO610,105^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO550,145^A0N,20,18^FB260,1,0,C^FDNS:" num-serie.n-serie                       "^FS" SKIP.
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 58 */


/* ---[ Impress∆o Modelo 59 e 60 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 59 OR p-cod-modelo = 60 THEN DO:

    RUN piCargaImagem("local-NOMNYCE").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a7.i}     /* Etiqueta item ean13 e NS - 50x31mm */
        {esapi/esapi016a8.i}     /* Etiquetas pequenas quintupla e modelo com tarja no topo da etiqueta a direita */

        /*Etiqueta n∆o homologada*/
       // PUT UNFORMATTED "^FO550,50^A0N,14,12^FB260,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO550,75^A0N,12,12^FD" item-ean.char-2 "^FS"                                         SKIP.
        PUT UNFORMATTED "^FO550,90^A0N,12,12^FDCNPJ: " c-cgc                                            "^FS" SKIP.
        PUT UNFORMATTED "^FO550,105^A0N,12,12^FD" item-ean.origem                                        "^FS" SKIP.
        PUT UNFORMATTED "^FO550,120^A0N,12,12^FD" STRING(num-serie.data,"99/99/99")                 "^FS" SKIP.
        PUT UNFORMATTED "^FO610,75 ^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO610,90^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
        PUT UNFORMATTED "^FO610,105^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO550,145^A0N,20,18^FB260,1,0,L^FDNS:" num-serie.n-serie                       "^FS" SKIP.
        IF p-cod-modelo = 59 THEN
            PUT UNFORMATTED "^FO710,105^XGlocal-NOMNYCE.GRF^FS".

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        /*Etiqueta exportaá∆o mexico*/
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO30,20^A0N,16,16^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,40^A0N,14,14^FDMarca: INTELBRAS^FS" SKIP.
        PUT UNFORMATTED "^FO30,40^A0N,14,14^FB368,1,0,R^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO30,55^A0N,14,14^FDModelo:" item-ean.nome-abrev "^FS" SKIP.

        /*
        PUT UNFORMATTED "^FO30,70^A0N,14,14^FDImportado por: Industria de Telecomunicaci¢n Electr¢nica^FS" SKIP.
        PUT UNFORMATTED "^FO30,85^A0N,14,14^FDBrasile§a de MÇxico S.A. de C.V.^FS" SKIP.
        PUT UNFORMATTED "^FO30,100^A0N,14,14^FDAvenida FÇlix Cuevas, 301 - 205^FS" SKIP.
        PUT UNFORMATTED "^FO30,115^A0N,14,14^FDCol. Del Valle, Del. Benito Juarez^FS" SKIP.
        PUT UNFORMATTED "^FO30,130^A0N,14,14^FDC.P. 03100 - MÇxico, D.F.^FS" SKIP.
        */
        PUT UNFORMATTED "^FO30,70^A0N,14,14^FD" item-ean.texto[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,85^A0N,14,14^FD" item-ean.texto[2] "^FS" SKIP.
        IF p-cod-modelo = 59 THEN
            PUT UNFORMATTED "^FO285,40^XGlocal-NOMNYCE.GRF^FS".
        PUT UNFORMATTED "^FO30,100^A0N,14,14^FD" item-ean.texto[3] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,115^A0N,14,14^FD" item-ean.texto[4] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,130^A0N,14,14^FD" item-ean.texto[5] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,145^A0N,14,14^FD" item-ean.texto[6] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,160^A0N,14,14^FD" item-ean.texto[7] "^FS" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-NOMNYCE.GRF^FS^XZ".
END. /* modelo 59 e 60 */


/* ---[ Impress∆o Modelo 61 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 61 THEN DO:

    FOR FIRST it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.
    END.    

    IF NOT AVAIL it-mod-img-etiq THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").
        RETURN "NOK".
    END.

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a1.i}     /* Etiqueta item ean13 e NS */
        {esapi/esapi016a2.i 425 27 15} /* Cabeáalho modelo */
        {esapi/esapi016a3.i 425} /* etiqueta 24x8mm direita  */
        {esapi/esapi016a3.i 635} /* etiqueta 24x8mm esquerda */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO425,60^A0N,20,20^FB408,1,0,C^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO450,90^A0N,14,14^FD" item-ean.char-2 "^FS"                                              SKIP.
        PUT UNFORMATTED "^FO450,110^A0N,14,14^FDCNPJ: " c-cgc                                            "^FS" SKIP.
        PUT UNFORMATTED "^FO450,130^A0N,14,14^FD" item-ean.origem                                        "^FS" SKIP.
        PUT UNFORMATTED "^FO450,150^A0N,14,14^FB200,1,0,L^FD" STRING(num-serie.data,"99/99/99")          "^FS" SKIP.
        PUT UNFORMATTED "^FO615,90 ^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[1]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO615,110^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[2]                       "^FS" SKIP. 
        PUT UNFORMATTED "^FO615,130^A0N,14,14^FB200,1,0,R^FD" item-ean.info-tec[3]                       "^FS" SKIP.
        PUT UNFORMATTED "^FO450,175^A0N,20,20^FB375,1,0,C^FDNS:" num-serie.n-serie                       "^FS" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        /*Etiqueta exportaá∆o */
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO20,50^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".
END. /* modelo 61 */ 


/* ---[ Impress∆o Modelo 62 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 62 THEN DO:                                                                                                                                                       
                                                                                                                                                                                     
    ASSIGN i-cont = 0.                                                                                                                                                           
                                                                                                                                                                                 
    /* Carrega a imagem para a impressora */                                                                                                                                     
    RUN piCargaImagem("local-logoma2").                                                                                                                                          
                                                                                                                                                                                 
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.                                                                                                                           
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    RUN piCargaImagem("local-suframa").                                                                                                                                          
                                                                                                                                                                                 
    IF NOT AVAIL imagem-etiq THEN DO:                                                                                                                                            
        RUN piGeraErro (INPUT 17006,                                                                                                                                             
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").  
        RETURN "NOK".                                                                                                                                                            
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/                                                                                                                  
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:                                                                                                                                                        
        FOR FIRST num-serie NO-LOCK                                                                                                                                              
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:                                                                                                                     
        END.                                                                                                                                                                     
                                                                                                                                                                                 
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/                                                                                                   
                                                                                                                                                                                 
        PUT "^XA" SKIP.                                                                                                                                                          
        PUT UNFORMATTED "^FO35,35,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */                                                   
        PUT UNFORMATTED "^FO125,35^BY3^BEN,70,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */                                               
        PUT UNFORMATTED "^FO520,35,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */                                                                                    
        PUT UNFORMATTED "^FO20,160^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */                                           
        PUT UNFORMATTED "^FO20,190^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */                                             
        PUT UNFORMATTED "^LRY^FO20,145^GB500,0,80^FS^LRN" SKIP.  /* Quadro preto */                                                                                              
        PUT UNFORMATTED "^FO90,230^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */                                                          
        PUT UNFORMATTED "^FO20,270^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
        PUT UNFORMATTED "^FO465,265^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */                                                                             
                                                                                                                                                                                 
        ASSIGN i-cont = 0.                                                                                                                                                       
                                                                                                                                                                                 
        FOR EACH it-mod-img-etiq                                                                                                                                                 
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                             
            FIRST imagem-etiq                                                                                                                                                    
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:                                                                      
                                                                                                                                                                                 
            IF i-cont = 0 THEN                                                                                                                                                   
                ASSIGN i-cont = 40.                                                                                                                                              
            ELSE                                                                                                                                                                 
                ASSIGN i-cont = i-cont + 160.                                                                                                                                    
                                                                                                                                                                                 
            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",290^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".                                                                          
        END.                                                                                                                                                                     
                                                                                                                                                                                 
                                                                                                                                                                                 
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO20,460^A0N,18,18^FD" (IF item-ean.lmarcador[1] THEN "Ø " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */                                    
                                                                                                                                                                                 
        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO270,460^A0N,18,18^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */                                   
                                                                                                                                                                                 
        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO20,490^A0N,18,18^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */                                    
                                                                                                                                                                                 
        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO270,490^A0N,18,18^FD" (IF item-ean.lmarcador[4] THEN "Ø " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */                                   
                                                                                                                                                                                 
        PUT UNFORMATTED "^FO547,13^A0N,20,20^FB270,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */                                                       
        PUT UNFORMATTED "^LRY^FO547,8^GB270,0,25^FS^LRN" SKIP.  /* Quadro preto */                                                                                               
        PUT UNFORMATTED "^FO560,45^A0N,12,12^FD" item-ean.char-2 "^FS"                     SKIP.                                                                                 
        PUT UNFORMATTED "^FO560,60^A0N,12,12^FB365,1,0,L^FDCNPJ: " c-cgc "^FS"                 SKIP.                                                                             
        PUT UNFORMATTED "^FO560,075^A0N,12,12^FB365,1,0,L^FD" item-ean.fone "^FS"              SKIP.                                                                             
        PUT UNFORMATTED "^FO560,90^A0N,12,12^FB365,1,0,L^FD" item-ean.origem "^FS"            SKIP.                                                                              
        PUT UNFORMATTED "^FO560,105^A0N,12,12^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.                                                                      
        PUT UNFORMATTED "^FO560,120^A0N,12,12^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,135^A0N,12,12^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,150^A0N,18,16^FB365,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO705,40^XGlocal-suframa.GRF^FS" SKIP.                                                                                                                 
                                                                                                                                                                                 
        PUT UNFORMATTED "^FO547,203^A0N,20,20^FB215,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */                                          
        PUT UNFORMATTED "^LRY^FO547,198^GB245,0,25^FS^LRN" SKIP.  /* Quadro preto */                                                                                             
        PUT UNFORMATTED "^FO555,227^A0N,11,11^FD" item-ean.char-2 "^FS" SKIP.  /* Imprime Made In Brazil */                                                                      
        PUT UNFORMATTED "^FO555,240^A0N,11,11^FD" c-cgc "^FS" SKIP.  /* Imprime CGC */                                                                                           
        PUT UNFORMATTED "^FO555,253^A0N,11,11^FD" item-ean.fone "^FS" SKIP.                                                                                                      
        PUT UNFORMATTED "^FO555,266^A0N,11,11^FD" item-ean.origem "^FS" SKIP.  /* Imprime Made In Brazil */                                                                      
        PUT UNFORMATTED "^FO555,279^A0N,11,11^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */                                                     
        PUT UNFORMATTED "^FO555,292^A0N,11,11^FD" item-ean.info-tec[1] "^FS" SKIP. /* Imprime Data Vertical */                                                                   
        PUT UNFORMATTED "^FO680,295^A0N,11,11^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/                                                             
        PUT UNFORMATTED "^FO670,225^XGlocal-suframa.GRF^FS" SKIP.                                                                                                                
        PUT UNFORMATTED "^FO765,330^A0B,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */                                                
        PUT UNFORMATTED "^FO785,330^A0B,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "^FO570,345^A0N,16,16^FDINTELBRAS CLOUD^FS" SKIP.                                                                                                        
        PUT UNFORMATTED "^FO575,360^BQN,2,6^FDQA," num-serie.n-serie "^FS" SKIP.  /* CΩdigo de Barras do Número de S≤rie */                                                      
        PUT UNFORMATTED "^FO570,505^A0N,16,16^FDNS:" num-serie.n-serie "^FS" SKIP.                                                                                               

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */                                                                                             
        PUT "^XZ" SKIP.                                                                                                                                                          
                                                                                                                                                                                 
        IF l-reimp THEN                                                                                                                                                          
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).                                                                                                                       
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
    PUT UNFORMATTED "^XA^IDlocal-suframa.GRF^FS^XZ".                                                                                                                             
                                                                                                                                                                                     
END.  /* IF  p-cod-modelo = 62 THEN DO: */                                                                                                                                           


/* ---[ Impress∆o Modelo 63 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 63 THEN DO:

    RUN piCargaImagem("local-anatelpp").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a7.i}     /* Etiqueta item ean13 e NS - 50x31mm */

        /*Etiqueta n∆o homologada*/
        PUT UNFORMATTED "^FO543,15^A0N,24,24^FB272,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO543,1^GB272,40,40^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO550,50^A0N,12,12^FD" item-ean.char-2 "^FS"                        SKIP.
        PUT UNFORMATTED "^FO605,50^A0N,12,12^FB200,1,0,R^FD" item-ean.origem "^FS"            SKIP.

        PUT UNFORMATTED "^FO550,65^A0N,12,12^FDCNPJ: " c-cgc "^FS"                            SKIP.
        PUT UNFORMATTED "^FO550,80^A0N,12,12^FD" item-ean.fone "^FS"                          SKIP.
        
        PUT UNFORMATTED "^FO605,65^A0N,12,12^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO605,80^A0N,12,12^FB200,1,0,R^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO543,95^A0N,20,20^FB280,1,0,C^FDNS:" num-serie.n-serie "^FS"       SKIP.

        PUT UNFORMATTED "^FO540,85^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
        PUT UNFORMATTED "^FO595,115^A0N,12,12^FD" item-ean.homolog "^FS"                   SKIP.  /* homologaá∆o */
        PUT UNFORMATTED "^FO595,128^BY1,3.0^BCN,22,N,N,N,N^FD010" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^FO595,154^A0N,12,12^FB215,1,0,L^FD010" string(item-mat.cod-ean, "9(13)") "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */

        PUT UNFORMATTED "^FO625,203^A0N,18,16^FB190,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */
        PUT UNFORMATTED "^FO625,223^A0N,18,16^FB190,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 2 */

        IF modelo-etiq.usa-kit THEN DO:
            EMPTY TEMP-TABLE tt-kit-impr.
            ASSIGN kit-cont = 0.

            FOR EACH int-kit NO-LOCK
                WHERE int-kit.it-codigo = num-serie.it-codigo:

                CREATE tt-kit-impr.
                BUFFER-COPY int-kit TO tt-kit-impr.
                ASSIGN kit-cont = kit-cont + 1.
            END.

            FOR EACH num-serie-fornec
                WHERE num-serie-fornec.n-serie = num-serie.n-serie NO-LOCK:

                FOR FIRST b-ns
                    WHERE b-ns.n-serie = num-serie-fornec.n-serie-sec NO-LOCK:

                    FOR FIRST tt-kit-impr
                        WHERE tt-kit-impr.it-codigo   = num-serie.it-codigo
                        AND   tt-kit-impr.es-codigo   = b-ns.it-codigo
                        AND   tt-kit-impr.n-serie     = ""
                        AND   tt-kit-impr.n-serie-sec = "":

                        ASSIGN tt-kit-impr.n-serie = num-serie.n-serie
                               tt-kit-impr.n-serie-sec = b-ns.n-serie.
                    END.
                END.
            END.

            ASSIGN i-cont-kit = 0.

            FOR EACH tt-kit-impr
                BREAK BY tt-kit-impr.sequencia:

                FOR FIRST b-ns
                    WHERE b-ns.n-serie = tt-kit-impr.n-serie-sec NO-LOCK:

                    FOR FIRST b-item-mat
                        WHERE b-item-mat.it-codigo = b-ns.it-codigo NO-LOCK:

                        FOR FIRST b-item-ean
                            WHERE b-item-ean.it-codigo = b-ns.it-codigo NO-LOCK:

                            ASSIGN i-cont-kit = i-cont-kit + 1
                                   i-soma-kit = 285 * i-cont-kit.

                            IF (i-cont-kit = 1 OR kit-cont = 1) OR (i-cont-kit = 1 AND kit-cont = 2) THEN
                                PUT UNFORMATTED "^FO430,1^A0B,18,16^FB170,1,0,C^FD" b-item-ean.nome-abrev "^FS" /* Sigla - Etiqueta Pequena 3 */
                                                "^FO450,1^A0B,18,16^FB170,1,0,C^FDNS:" b-ns.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 3 */

                            IF (i-cont-kit = 2 OR kit-cont = 1) OR (i-cont-kit = 2 AND kit-cont = 2) THEN
                                PUT UNFORMATTED "^FO415,203^A0N,18,16^FB190,1,0,C^FD" b-item-ean.nome-abrev "^FS" /* Sigla - Etiqueta Pequena 1 */
                                                "^FO415,223^A0N,18,16^FB190,1,0,C^FDNS:" b-ns.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
                        END.
                    END.
                END.

                /* N£mero M†ximo de Conponentes para esta Etiqueta */
                IF i-cont-kit >= 2 THEN
                    LEAVE.
            END.
        END.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 63 */


/**********************************************************************************************/
/*                              NOVOS MODELOS BOPP                                            */
/**********************************************************************************************/

/* ---[ Modelo 100: Produto sem homologaá∆o - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF p-cod-modelo = 100 THEN DO:
    
    IF item-ean.tp-fabric = 1 THEN DO: /*CKD*/
    
        FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.
    
        IF NOT AVAIL ord-prod THEN DO:
        
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
        END.
    END.
    

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.

        /*DÇcio*/
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-ERROR.

        IF p-num-po = 0 THEN DO:
           {esapi/esapi016a5034.i}         /* Embalagem */
        END.
        ELSE DO:                
           {esapi/esapi016a5034c.i}        /* Embalagem */
        END.

        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        /*{esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */*/
        ASSIGN i-lin = 0.
        IF  item-ean.char-2 = "Fabricado por:"
        AND item-ean.char-3 = estabelec.cgc  THEN DO:
            PUT UNFORMATTED "^FO455,60^A0N,14,14^FD" "Distribu°do por: INTELBRAS S/A" "^FS" SKIP.

            /*Busca cgc da matriz para o "distribuido por"*/
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = "104" NO-ERROR.

            ASSIGN c-cgc = estabelec.cgc.

            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-ERROR.

        END.
        ELSE DO:
            PUT UNFORMATTED "^FO455,60^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.
        END.
        PUT UNFORMATTED "^FH^FO" (455 + 215) ",60^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.origem,'È','_e9') /* CHR(218) */ "^FS" SKIP.
        ASSIGN i-lin = 60 + 16.
        PUT UNFORMATTED "^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO" (455 + 215) "," i-lin "^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        PUT UNFORMATTED "^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        PUT UNFORMATTED "^FH^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.info-tec[1], "~~":U, "_7e":U) "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        PUT UNFORMATTED "^FH^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.info-tec[2], "~~":U, "_7e":U) "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */

        IF  item-ean.char-2 = "Fabricado por:"
        AND item-ean.char-3 = estabelec.cgc  THEN DO:

            PUT UNFORMATTED "^FO455,110^A0N,14,14^FD" "Fabricado por: DÇcio Ind£stria Metal£rgica LTDA." "^FS" SKIP.
            PUT UNFORMATTED "^FO455,125^A0N,14,14^FD" "CNPJ:" estabelec.cgc "^FS" SKIP.  
        END.
      
        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.
END. /* modelo 100 */

/* ---[ Modelo 100: Produto sem homologaá∆o - Quadrupla  ]------------------------------------------------------------------------------------ */
IF p-cod-modelo = 101 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.

        /*DÇcio*/
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-ERROR.

        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        /*{esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */*/
        ASSIGN i-lin = 0.
        IF  item-ean.char-2 = "Fabricado por:"
        AND item-ean.char-3 = estabelec.cgc  THEN DO:
            PUT UNFORMATTED "^FO455,60^A0N,14,14^FD" "Distribu°do por: INTELBRAS S/A" "^FS" SKIP.

            /*Busca cgc da matriz para o "distribuido por"*/
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = "104" NO-ERROR.

            ASSIGN c-cgc = estabelec.cgc.

            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-ERROR.

        END.
        ELSE DO:
            PUT UNFORMATTED "^FO455,60^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.
        END.
        PUT UNFORMATTED "^FO" (455 + 215) ",60^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
        ASSIGN i-lin = 60 + 16.
        PUT UNFORMATTED "^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO" (455 + 215) "," i-lin "^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        PUT UNFORMATTED "^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        PUT UNFORMATTED "^FH^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.info-tec[1], "~~":U, "_7e":U) "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        PUT UNFORMATTED "^FH^FO455," i-lin "^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.info-tec[2], "~~":U, "_7e":U) "^FS" SKIP.
        ASSIGN i-lin = i-lin + 16.
        
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */

        IF  item-ean.char-2 = "Fabricado por:"
        AND item-ean.char-3 = estabelec.cgc  THEN DO:

            PUT UNFORMATTED "^FO455,110^A0N,14,14^FD" "Fabricado por: DÇcio Ind£stria Metal£rgica LTDA." "^FS" SKIP.
            PUT UNFORMATTED "^FO455,125^A0N,14,14^FD" "CNPJ:" estabelec.cgc "^FS" SKIP.  
        END.
      
        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        //Pula etiqueta e insere informaá∆o fixa
        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO120,30^A0N,40,35^FD" "ATENÄ«O" "^FS" SKIP.
        PUT UNFORMATTED "^FO30,75^A0N,22,20^FD" "Verifique a vers∆o da placa de laáo em:" "^FS" SKIP.
        PUT UNFORMATTED "^FO30,100^A0N,22,20^FD" "Ok/menu - Informaá‰es do sistema - " "^FS" SKIP.
        PUT UNFORMATTED "^FO30,125^A0N,22,20^FD" "vers∆o Laáo." "^FS" SKIP.
        PUT UNFORMATTED "^FO30,150^A0N,22,20^FD" "Para vers‰es anteriores a 20.21 retire o" "^FS" SKIP.
        PUT UNFORMATTED "^FO30,175^A0N,22,20^FD" "jumper +8 e realize o registro do laáo." "^FS" SKIP.
        PUT UNFORMATTED "^FO30,200^A0N,22,20^FD" "A central reconhecer† como m¢dulo de" "^FS" SKIP.
        PUT UNFORMATTED "^FO30,225^A0N,22,20^FD" "entrada (MDI) e manter† as funcionalidades." "^FS" SKIP.
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP. 

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.
END. /* modelo 101 */


/* ---[ Modelo 110: Produto sem homologaá∆o - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
/* ---[ Modelo 111: Produto sem homologaá∆o - 7NS ]--------------------------------------------------------------------------------------------- */
IF p-cod-modelo = 110 OR p-cod-modelo = 111 THEN DO:

    IF item-ean.tp-fabric = 1 THEN DO: /*CKD*/
    
        FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.
    
        IF NOT AVAIL ord-prod THEN DO:
        
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
        END.
    END.


    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        IF p-num-po = 0 THEN DO:
           {esapi/esapi016a5034.i}         /* Embalagem */
        END.
        ELSE DO:                
           {esapi/esapi016a5034c.i}        /* Embalagem */
        END.



        {esapi/esapi016a11.i 1}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF p-cod-modelo = 111 THEN DO:
            PUT "^XA" SKIP.
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
        END.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.
END. /* modelo 110 */


/* ---[ Modelo 120: Produto homologado Anatel - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 120 THEN DO:

    IF item-ean.tp-fabric = 1 THEN DO: /*CKD*/
    
        FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.
    
        IF NOT AVAIL ord-prod THEN DO:
        
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
        END.
    END.

    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        IF p-num-po = 0 THEN DO:
           {esapi/esapi016a5034.i}         /* Embalagem */
        END.
        ELSE DO:                
           {esapi/esapi016a5034c.i}        /* Embalagem */
        END.



        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO735,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO610,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 120 */

IF  p-cod-modelo = 123 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */

      //  PUT UNFORMATTED "^FO435,235^ABN^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
        PUT UNFORMATTED "^FO420,235^A0N,13,13^FB200,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.
        PUT UNFORMATTED "^FO420,255^ABN^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 

        PUT UNFORMATTED "^FO638,204^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO608,240^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.
        
        PUT UNFORMATTED "^FO735,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO610,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 123 */

/* ---[ Modelo 130: Produto homologado Anatel - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
/* ---[ Modelo 132: Produto homologado Anatel - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 130 OR p-cod-modelo = 132 THEN DO:

    IF item-ean.tp-fabric = 1 THEN DO: /*CKD*/
    
        FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.
    
        IF NOT AVAIL ord-prod THEN DO:
        
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
        END.
    END.

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        IF p-num-po = 0 THEN DO:
           {esapi/esapi016a5034.i}         /* Embalagem */
        END.
        ELSE DO:                
           {esapi/esapi016a5034c.i}        /* Embalagem */
        END.



        {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF p-cod-modelo = 132 THEN DO:
            PUT "^XA" SKIP.
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
        END.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 130 */


/* ---[ Modelo 131: Produto homologado Anatel (kit) - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 131 THEN DO:

    RUN piCargaImagem("local-anatelpp").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
                
        PUT UNFORMATTED "^FO635,235^A0N,20,18^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
        PUT UNFORMATTED "^FO635,255^A0N,20,18^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 

        IF modelo-etiq.usa-kit THEN DO:
            EMPTY TEMP-TABLE tt-kit-impr.
            ASSIGN kit-cont = 0.

            FOR EACH int-kit NO-LOCK
                WHERE int-kit.it-codigo = num-serie.it-codigo:

                CREATE tt-kit-impr.
                BUFFER-COPY int-kit TO tt-kit-impr.
                ASSIGN kit-cont = kit-cont + 1.
            END.

            FOR EACH num-serie-fornec
                WHERE num-serie-fornec.n-serie = num-serie.n-serie NO-LOCK:

                FOR FIRST b-ns
                    WHERE b-ns.n-serie = num-serie-fornec.n-serie-sec NO-LOCK:

                    FOR FIRST tt-kit-impr
                        WHERE tt-kit-impr.it-codigo   = num-serie.it-codigo
                        AND   tt-kit-impr.es-codigo   = b-ns.it-codigo
                        AND   tt-kit-impr.n-serie     = ""
                        AND   tt-kit-impr.n-serie-sec = "":

                        ASSIGN tt-kit-impr.n-serie = num-serie.n-serie
                               tt-kit-impr.n-serie-sec = b-ns.n-serie.
                    END.
                END.
            END.

            ASSIGN i-cont-kit = 0.

            FOR EACH tt-kit-impr
                BREAK BY tt-kit-impr.sequencia:

                FOR FIRST b-ns
                    WHERE b-ns.n-serie = tt-kit-impr.n-serie-sec NO-LOCK:

                    FOR FIRST b-item-mat
                        WHERE b-item-mat.it-codigo = b-ns.it-codigo NO-LOCK:

                        FOR FIRST b-item-ean
                            WHERE b-item-ean.it-codigo = b-ns.it-codigo NO-LOCK:

                            ASSIGN i-cont-kit = i-cont-kit + 1
                                   i-soma-kit = 285 * i-cont-kit.

                            IF (i-cont-kit = 1 OR kit-cont = 1) OR (i-cont-kit = 1 AND kit-cont = 2) THEN
                                PUT UNFORMATTED "^FO450,15^A0B,20,18^FB170,1,0,C^FD" b-item-ean.nome-abrev "^FS" /* Sigla - Etiqueta Pequena 3 */
                                                "^FO470,15^A0B,20,18^FB170,1,0,C^FDNS:" b-ns.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 3 */

                            IF (i-cont-kit = 2 OR kit-cont = 1) OR (i-cont-kit = 2 AND kit-cont = 2) THEN
                                PUT UNFORMATTED "^FO425,235^A0N,20,18^FB210,1,0,C^FD" b-item-ean.nome-abrev "^FS" /* Sigla - Etiqueta Pequena 1 */
                                                "^FO425,255^A0N,20,18^FB210,1,0,C^FDNS:" b-ns.n-serie "^FS" SKIP. /* Sigla - Etiqueta Pequena 1 */
                        END.
                    END.
                END.

                /* N£mero M†ximo de Conponentes para esta Etiqueta */
                IF i-cont-kit >= 2 THEN
                    LEAVE.
            END.
        END.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 131 */


IF  p-cod-modelo = 133 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        
        CASE item-ean.etiq-1-tipo: 
            WHEN 1 THEN DO: /* N£m SÇrie */
               // PUT UNFORMATTED "^FO435,235^ABN^FB210,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO360,235^A0N,14,14^FB200,1,0,R^FD" item-ean.nome-abrev "^FS" SKIP.
                PUT UNFORMATTED "^FO435,255^ABN^FB210,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*C¢d. Item.*/
                PUT UNFORMATTED "^FO440,235^A0N,28,28^FB210,1,0,C^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO425,235^A0N,20,18^FB210,1,0,C^FD"    item-ean.etiq-1-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO425,255^A0N,20,18^FB210,1,0,C^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
            END.
        END CASE.
                
        PUT UNFORMATTED "^FO645,207^XGlocal-anatelpp.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO610,250^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.
        
       // PUT UNFORMATTED "^FO782,20^ABB^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
        PUT UNFORMATTED "^FO782,20^A0B,14,14^FB170,1,0,C^FD" item-ean.nome-abrev "^FS" SKIP. 
        PUT UNFORMATTED "^FO807,20^ABB^FB170,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.
       
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF p-cod-modelo = 132 THEN DO:
            PUT "^XA" SKIP.
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
        END.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 133 */


IF  p-cod-modelo = 134 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a11.i 9}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        //Repete os NS
        PUT "^XA" SKIP.
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.        

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
/*     PUT UNFORMATTED                       */
/*         "^XA^IDlocal-anatelpp.GRF^FS^XZ". */
END. /* modelo 134 */


IF  p-cod-modelo = 135 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a11.i 9}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        //Repete os NS
        PUT "^XA" SKIP.
        {esapi/esapi016a12b.i 1}         /* etiqueta 24x8mm */
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.        

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 135 */

IF  p-cod-modelo = 137 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
       /* {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}*/         /* etiqueta 24x8mm */
       
        FOR EACH num-serie-fornec NO-LOCK 
            WHERE num-serie-fornec.n-serie = tt-lista-ns.num-serie
            BREAK BY  num-serie-fornec.n-serie-sec:

            FIND FIRST b-ns 
                 WHERE b-ns.n-serie = num-serie-fornec.n-serie-sec
            NO-LOCK NO-ERROR.

            FIND FIRST b-item-ean 
                 WHERE b-item-ean.it-codigo = b-ns.it-codigo 
            NO-LOCK NO-ERROR.

            IF NOT FIRST(num-serie-fornec.n-serie-sec) THEN
               PUT "^XA" SKIP.

            {esapi/esapi016a14.i 2}  
            {esapi/esapi016a15.i 2}

             PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
             PUT "^XZ" SKIP.
        END.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 137 */

IF  p-cod-modelo = 138 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        /* C2303-1252  {esapi/esapi016a5034b.i} */         /* Embalagem */
       // {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
       // {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        FOR EACH num-serie-fornec NO-LOCK 
            WHERE num-serie-fornec.n-serie = tt-lista-ns.num-serie
            BREAK BY  num-serie-fornec.n-serie-sec:

            FIND FIRST b-ns 
                 WHERE b-ns.n-serie = num-serie-fornec.n-serie-sec
            NO-LOCK NO-ERROR.

            FIND FIRST b-item-ean 
                 WHERE b-item-ean.it-codigo = b-ns.it-codigo 
            NO-LOCK NO-ERROR.

            IF NOT FIRST(num-serie-fornec.n-serie-sec) THEN DO:
               PUT "^XA" SKIP.                                 
               {esapi/esapi016a5034b.i} /* C2303-1252 */
            END.

            {esapi/esapi016a14.i 2}  
            {esapi/esapi016a12.i 2}

             PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
             PUT "^XZ" SKIP.
        END.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 138 */

/* ---[ Modelo 140: Produto homologado Anatel Resoluá∆o 529 - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 140 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento deve ser conectado obrigatoriamente em tomada de rede de energia elÇtrica que possua aterramento (tràs pinos), conforme a Norma NBR ABNT 5410, visando a seguranáa  dos usu†rios contra choques elÇtricos".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 0 20 5}     /* Cabeáalho modelo */
        {esapi/esapi016a10.i 25 60 16}  /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a5024.i}         /*EAN 13 50x24*/
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */

        PUT UNFORMATTED "^FO325,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO17,150^A0N,14,14^FB365,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO25,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO25,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO25,200^A0N,15,15^FB365,4,0,J^FD" c-texto "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^LRY^FO20,195^GB373,0,63^FS^LRN"                   SKIP.  /* Quadro preto */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 140 */

/* ---[ Modelo 145: Produto homologado Anatel Resoluá∆o 680 - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 145 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento n∆o tem direito Ö proteá∆o contra interferància prejudicial e n∆o pode causar interferància em sistemas devidamente autorizados.".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 0 20 5}     /* Cabeáalho modelo */
        {esapi/esapi016a10.i 25 60 16}  /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a5024.i}         /*EAN 13 50x24*/
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO325,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO17,150^A0N,14,14^FB365,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO25,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO25,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO25,200^A0N,15,15^FB365,4,0,J^FD" c-texto "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^LRY^FO20,195^GB373,0,63^FS^LRN"                   SKIP.  /* Quadro preto */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 150 */

/* ---[ Modelo 150: Produto homologado Anatel Resoluá∆o 506 - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 150 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento opera em car†ter secund†rio, isto Ç, n∆o tem direito a proteá∆o contra interferància prejudicial, mesmo de estaá‰es do mesmo tipo, e n∆o pode causar interferància a sistemas operando em car†ter prim†rio.".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 0 20 5}     /* Cabeáalho modelo */
        {esapi/esapi016a10.i 25 60 16}  /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a5024.i}         /*EAN 13 50x24*/
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO325,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO17,150^A0N,14,14^FB365,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO25,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO25,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO25,200^A0N,15,15^FB365,4,0,J^FD" c-texto "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^LRY^FO20,195^GB373,0,63^FS^LRN"                   SKIP.  /* Quadro preto */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 150 */


/* ---[ Modelo 160: Produto produzido no polo industrial de Manaus - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 160 THEN DO:
    RUN piCargaImagem("local-suframa").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO700,92^XGlocal-suframa.GRF^FS" skip. /* Impressao da Imagem ANATEL */ 
                        
        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-suframa.GRF^FS^XZ".
    
END. /* modelo 160 */


/* ---[ Modelo 170: Produto produzido no polo industrial de Manaus - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 170 THEN DO:

    /*inicializa parÉmetros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    /*
    RUN piCargaImagem("local-suframa").                                             
    */

    /*PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".*/
      PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

    /************************** IMPRESSAO EM 600 dpi *****************************
    FOR EACH tt-lista-ns:                                                           
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/      
                                                                                    
        PUT "^XA" SKIP.                                                             
                                                                                    
        {esapi/esapi016a5034-600dpi.i}  /* Embalagem */                             
        {esapi/esapi016a11-600dpi.i 3}  /* Etiqueta de Produto (34x21mm) */         
        {esapi/esapi016a12-600dpi.i 2}         /* etiqueta 24x8mm */                       
                                                                                    
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.                                                             
                                                                                    
        IF l-reimp THEN                                                             
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).                          
    END.                                                                            
                                                                                    
    /* Limpa a imagem da impressora */                                              
    PUT UNFORMATTED                                                                 
        "^XA^IDselo-suframa.GRF^FS^XZ".     
    ****************************************************************************/


    RUN piCargaImagem("local-suframa"). 
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.

        {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a11.i 3}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-suframa.GRF^FS^XZ".
END. /* modelo 170 */

/* ---[ Impress∆o Modelo 181 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 181 THEN DO:

    ASSIGN i-cont = 0.

    FOR EACH it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.
    END.

    IF NOT AVAIL imagem-etiq THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").
        RETURN "NOK".
    END.

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.
    
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/
            
        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO50,35,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO115,35^BY3^BEN,70,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO520,35,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO10,160^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO10,190^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO30,145^GB485,0,80^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO95,230^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO035,270^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO465,265^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        
        ASSIGN i-cont = 0.

        FOR EACH it-mod-img-etiq
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
            FIRST imagem-etiq
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:
        
            IF i-cont = 0 THEN
                ASSIGN i-cont = 40.
            ELSE
                ASSIGN i-cont = i-cont + 160.

            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",290^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".
        END.

        
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
            PUT UNFORMATTED "^FO20,460^A0N,18,18^FD" (IF item-ean.lmarcador[1] THEN "Ø " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
            PUT UNFORMATTED "^FO270,460^A0N,18,18^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
            PUT UNFORMATTED "^FO20,490^A0N,18,18^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
            PUT UNFORMATTED "^FO270,490^A0N,18,18^FD" (IF item-ean.lmarcador[4] THEN "Ø " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */

      /* Modelo */
       PUT UNFORMATTED "^FO555,15^A0N,20,20^FB275,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
       PUT UNFORMATTED "^LRY^FO552,8^GB275,0,25^FS^LRN" SKIP.  /* Quadro preto */
       /*PUT UNFORMATTED "^LRY^FO568,5^GB320,30,30^FS^LRN" SKIP.  /* Quadro preto */*/

       /* Informaá‰es Item */
       PUT UNFORMATTED "^FO565,45^A0N,12,12^FD" item-ean.char-2 "^FS" SKIP.
       PUT UNFORMATTED "^FO616,45^A0N,12,12^FB200,1,0,R^FD" item-ean.origem "^FS" SKIP.
       PUT UNFORMATTED "^FO565,60^A0N,12,12^FB200,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
       PUT UNFORMATTED "^FO616,60^A0N,12,12^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
       PUT UNFORMATTED "^FO565,75^A0N,12,12^FB200,1,0,L^FD" item-ean.fone "^FS" SKIP.
       PUT UNFORMATTED "^FO565,90^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
       PUT UNFORMATTED "^FO565,105^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.

       /* N£mero SÇrie */
        PUT UNFORMATTED "^FO565,125^ABN^FB200,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
        PUT UNFORMATTED "^FO565,140^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

       /* PRODUTO REMANUFATURADO */
        PUT UNFORMATTED "^FO616,85^A0N,14,14^FB200,1,0,R^FDPRODUTO" "^FS" SKIP.
        PUT UNFORMATTED "^FO616,100^A0N,14,14^FB200,1,0,R^FDREMANUFATURADO" "^FS" SKIP.

        PUT UNFORMATTED "^FO567,203^A0N,20,20^FB215,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO548,198^GB265,0,25^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO562,227^A0N,11,11^FD" item-ean.char-2 "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO562,240^A0N,11,11^FD" c-cgc "^FS" SKIP.  /* Imprime CGC */
        PUT UNFORMATTED "^FO562,253^A0N,11,11^FD" item-ean.fone "^FS" SKIP.

        PUT UNFORMATTED "^FO675,227^A0N,11,11,R^FD" item-ean.origem "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO748,240^A0N,11,11,R^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        
        PUT UNFORMATTED "^FO562,266^A0N,11,11^FD" item-ean.info-tec[1] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO562,279^A0N,11,11^FD" item-ean.info-tec[2] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO562,292^A0N,11,11^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
        
        PUT UNFORMATTED "^FO585,270^A0N,13,13^FB200,1,0,R^FDPRODUTO" "^FS" SKIP.
        PUT UNFORMATTED "^FO585,285^A0N,13,13^FB200,1,0,R^FDREMANUFATURADO" "^FS" SKIP.
        
  
        
        /*Etiquetinha vertical*/
        PUT UNFORMATTED "^FO770,330^A0B,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO790,330^A0B,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/

        
        PUT UNFORMATTED "^FO585,345^A0N,16,16^FDINTELBRAS CLOUD^FS" SKIP.
        PUT UNFORMATTED "^FO585,360^BQN,2,6^FDQA," num-serie.n-serie "^FS" SKIP.  /* CΩdigo de Barras do Número de S≤rie */
        PUT UNFORMATTED "^FO585,505^A0N,16,16^FDNS:" num-serie.n-serie "^FS" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    FOR EACH it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".
    END.
    PUT UNFORMATTED "^XA^IDlocal-suframa.GRF^FS^XZ".

END.  /* IF  p-cod-modelo = 62 THEN DO: */



/* ---[ Modelo 190: Produto Exportaá∆o - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 190  OR p-cod-modelo = 192 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        IF p-cod-modelo = 192 THEN DO:
           PUT "^XA" SKIP.
    
           PUT UNFORMATTED "^FO190,20^A0N,25,25^FDAVISO^FS" SKIP.
           PUT UNFORMATTED "^FO50,60^A0N,20,20^FD" "Verifique la versi¢n de la placa Lazo en:" "^FS" SKIP.
           PUT UNFORMATTED "^FO60,85^A0N,20,20^FB320,1,0,C^FD" "OK/Men£ - informaci¢n sistema - " "^FS" SKIP.
           PUT UNFORMATTED "^FO60,110^A0N,20,20^FB320,1,0,C^FD" "Versi¢n Lazo." "^FS" SKIP.
           PUT UNFORMATTED "^FO60,135^A0N,20,20^FB320,1,0,C^FD" "Para versiones anteriores a la 20.21," "^FS" SKIP.
           PUT UNFORMATTED "^FO60,160^A0N,20,20^FB320,1,0,C^FD" "retire el jumper + 8 y registre el lazo." "^FS" SKIP.
           PUT UNFORMATTED "^FO60,185^A0N,20,20^FB320,1,0,C^FD" "la central lo reconocer† como un" "^FS" SKIP.
           PUT UNFORMATTED "^FO60,210^A0N,20,20^FB320,1,0,C^FD" "m¢dulo de (MDI) y mantendr†" "^FS" SKIP.
           PUT UNFORMATTED "^FO60,235^A0N,20,20^FB320,1,0,C^FD" "sus funcionalidades." "^FS" SKIP.
    
           PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
           PUT "^XZ" SKIP.
        END.

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034b.i}         /* Etiqueta item ean13 e NS - 50x34mm */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a5024nh.i}       /* Etiqueta produto exportaá∆o - 50x24mm */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 190 */


/* ---[ Modelo 200: Produto Exportaá∆o - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
/* ---[ Modelo 201: Produto Exportaá∆o - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 200 OR p-cod-modelo = 201 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}     /* Embalagem */
        {esapi/esapi016a12.i 2}     /* etiqueta 24x8mm */
        {esapi/esapi016a11exp.i 1}  /* Etiqueta de Produto Exportaá∆o (34x21mm) */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF p-cod-modelo = 201 THEN DO:
            PUT "^XA" SKIP.
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
        END.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 200 */

/* ---[ Modelo 191: Produto Exportaá∆o - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 191 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Etiqueta item ean13 e NS - 50x34mm */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a5024nh.i}       /* Etiqueta produto exportaá∆o - 50x24mm */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        PUT UNFORMATTED "^XA" SKIP.

        PUT UNFORMATTED "^FO550,60^A0N,40,40^FB368,1,0,l^FDLACRE DE^FS" SKIP.
        PUT UNFORMATTED "^FO535,110^A0N,40,40^FB368,1,0,l^FDSEGURIDAD^FS" SKIP.
        PUT "^XZ" SKIP.

        /* Limpa a imagem da impressora */
        PUT UNFORMATTED
            "^XA^IDlocal-NOMNYCE.GRF^FS^XZ".
    END.

END. /* modelo 191 */

/* ---[ Modelo 210 e 230: Produto Exportaá∆o MÇxico - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 230 OR p-cod-modelo = 210 THEN DO:

    RUN piCargaImagem("local-NOMNYCE").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Etiqueta item ean13 e NS - 50x34mm */
        {esapi/esapi016a5024nh.i}       /* Etiqueta produto exportaá∆o - 50x24mm */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        IF p-cod-modelo = 230 THEN
            PUT UNFORMATTED "^FO710,135^XGlocal-NOMNYCE.GRF^FS".

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        /*Etiqueta exportaá∆o mexico*/
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO30,30^A0N,16,16^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,14,14^FDMarca: INTELBRAS^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,14,14^FB368,1,0,R^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO30,65^A0N,14,14^FDModelo:" item-ean.nome-abrev "^FS" SKIP.
        /*
        PUT UNFORMATTED "^FO30,80^A0N,14,14^FDImportado por: Industria de Telecomunicaci¢n Electr¢nica^FS" SKIP.
        PUT UNFORMATTED "^FO30,95^A0N,14,14^FDBrasile§a de MÇxico S.A. de C.V.^FS" SKIP.
        PUT UNFORMATTED "^FO30,110^A0N,14,14^FDAvenida FÇlix Cuevas, 301 - 205^FS" SKIP.
        PUT UNFORMATTED "^FO30,125^A0N,14,14^FDCol. Del Valle, Del. Benito Juarez^FS" SKIP.
        PUT UNFORMATTED "^FO30,140^A0N,14,14^FDC.P. 03100 - MÇxico, D.F.^FS" SKIP.
        */
        PUT UNFORMATTED "^FO30,80^A0N,14,14^FD" item-ean.texto[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,95^A0N,14,14^FD" item-ean.texto[2] "^FS" SKIP.
        IF p-cod-modelo = 230 THEN
            PUT UNFORMATTED "^FO285,50^XGlocal-NOMNYCE.GRF^FS".
        PUT UNFORMATTED "^FO30,110^A0N,14,14^FD" item-ean.texto[3] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,125^A0N,14,14^FD" item-ean.texto[4] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,140^A0N,14,14^FD" item-ean.texto[5] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,155^A0N,14,14^FD" item-ean.texto[6] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,170^A0N,14,14^FD" item-ean.texto[7] "^FS" SKIP.
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-NOMNYCE.GRF^FS^XZ".
END. /* modelo 210 ou 230 */


/* ---[ Modelo 220 e 240: Produto Exportaá∆o MÇxico - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
/* ---[ Modelo 221 e 241: Produto Exportaá∆o MÇxico - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 220 OR p-cod-modelo = 240 OR
    p-cod-modelo = 221 OR p-cod-modelo = 241 THEN DO:

    RUN piCargaImagem("local-NOMNYCE").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}     /* Embalagem */
        {esapi/esapi016a12.i 2}     /* etiqueta 24x8mm */
        
        IF p-cod-modelo = 220 OR p-cod-modelo = 221 THEN DO:
            {esapi/esapi016a11exp.i 1}  /* Etiqueta de Produto Exportaá∆o (34x21mm) */
        END.
        ELSE DO:
            {esapi/esapi016a11exp.i 2}  /* Etiqueta de Produto Exportaá∆o (34x21mm) */
            PUT UNFORMATTED "^FO595,105^XGlocal-NOMNYCE.GRF^FS".
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        /*Etiqueta exportaá∆o mexico*/
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO30,30^A0N,16,16^FD" CAPS(item-ean.linha[2] + " " + item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,14,14^FDMarca: INTELBRAS^FS" SKIP.
        PUT UNFORMATTED "^FO30,50^A0N,14,14^FB368,1,0,R^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO30,65^A0N,14,14^FDModelo:" item-ean.nome-abrev "^FS" SKIP.

        /*
        PUT UNFORMATTED "^FO30,80^A0N,14,14^FDImportado por: Industria de Telecomunicaci¢n Electr¢nica^FS" SKIP.
        PUT UNFORMATTED "^FO30,95^A0N,14,14^FDBrasile§a de MÇxico S.A. de C.V.^FS" SKIP.
        PUT UNFORMATTED "^FO30,110^A0N,14,14^FDAvenida FÇlix Cuevas, 301 - 205^FS" SKIP.
        PUT UNFORMATTED "^FO30,125^A0N,14,14^FDCol. Del Valle, Del. Benito Juarez^FS" SKIP.
        PUT UNFORMATTED "^FO30,140^A0N,14,14^FDC.P. 03100 - MÇxico, D.F.^FS" SKIP. 
        */
        PUT UNFORMATTED "^FO30,80^A0N,14,14^FD" item-ean.texto[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,95^A0N,14,14^FD" item-ean.texto[2] "^FS" SKIP.
        
        IF p-cod-modelo = 240 OR  p-cod-modelo = 241 THEN
            PUT UNFORMATTED "^FO265,50^XGlocal-NOMNYCE.GRF^FS".
        PUT UNFORMATTED "^FO30,110^A0N,14,14^FD" item-ean.texto[3] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,125^A0N,14,14^FD" item-ean.texto[4] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,140^A0N,14,14^FD" item-ean.texto[5] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,155^A0N,14,14^FD" item-ean.texto[6] "^FS" SKIP.
        PUT UNFORMATTED "^FO30,170^A0N,14,14^FD" item-ean.texto[7] "^FS" SKIP.
        
        IF p-cod-modelo = 221 OR p-cod-modelo = 241 THEN DO:
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-NOMNYCE.GRF^FS^XZ".
END. /* modelos 220, 221, 240 e 241 */




/* ---[ Modelo 250: Produto Exportaá∆o ArgÇlia - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 250 THEN DO:

    FOR FIRST it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.
    END.    

    IF NOT AVAIL it-mod-img-etiq THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").
        RETURN "NOK".
    END.

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Etiqueta item ean13 e NS - 50x34mm */
        {esapi/esapi016a5024nh.i}       /* Etiqueta produto exportaá∆o - 50x24mm */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
                                        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).

        /*Etiqueta exportaá∆o */
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO20,50^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".
END. /* modelo 250 */ 


IF  p-cod-modelo = 260 THEN DO:                                                                                                                                                       
                                                                                                                                                       
    ASSIGN i-cont = 0.                                                                                                                                                           
                                                                                                                                                                                 
    /* Carrega a imagem para a impressora */                                                                                                                                     
    RUN piCargaImagem("local-logoma2").                                                                                                                                          
                                                                                                                                                                                 
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.                                                                                                                           
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /*
    RUN piCargaImagem("local-suframa").                                                                                                                                          
    */

    /*PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,". */
    PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

    IF NOT AVAIL imagem-etiq THEN DO:                                                                                                                                            
        RUN piGeraErro (INPUT 17006,                                                                                                                                             
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").  
        RETURN "NOK".                                                                                                                                                            
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /*inicializa parÉmetros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      
                                                                                                                                                                                 
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO140,120,1^A0B,56,56^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO390,110^BY9^BEN,230,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO1555,120,1^A0B,80,80^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO90,460^A0N,76,76^FB1460,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO90,550^A0N,76,76^FB1460,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO80,430^GB1460,0,230^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO300,680^BY6^BCN,90,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO110,800^A0N,50,50^FB1470,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        
        PUT UNFORMATTED "^FO10,800^A0N,60,60^FB1470,1,0,R^FD"  num-serie.sigla "^FS" SKIP. /* Sigla */
        
        ASSIGN i-cont = 0.

        FOR EACH it-mod-img-etiq
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
            FIRST imagem-etiq
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:

            IF i-cont = 0 THEN
                ASSIGN i-cont = 120.
            ELSE
                IF i-cont = 120 THEN
                   ASSIGN i-cont = i-cont + 470.
                ELSE
                   ASSIGN i-cont = i-cont + 440.

            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",860^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".
        END.
        
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
            PUT UNFORMATTED "^FO90,1340^A0N,50,50^FD" (IF item-ean.lmarcador[1] THEN "Ø " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
            PUT UNFORMATTED "^FO840,1340^A0N,50,50^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
            PUT UNFORMATTED "^FO90,1430^A0N,50,50^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
            PUT UNFORMATTED "^FO840,1430^A0N,50,50^FD" (IF item-ean.lmarcador[4] THEN "Ø " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FO1615,65^A0N,60,60^FB835,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO1610,45^GB835,0,75^FS^LRN" SKIP.  /* Quadro preto */
        
        PUT UNFORMATTED "^FO1655,160^A0N,38,38^FD" item-ean.char-2 "^FS"                     SKIP.
        PUT UNFORMATTED "^FO1655,200^A0N,38,38^FB565,1,0,L^FDCNPJ: " c-cgc "^FS"                 SKIP.
        PUT UNFORMATTED "^FO1655,240^A0N,38,38^FB565,1,0,L^FD" item-ean.fone "^FS"              SKIP.
        
        PUT UNFORMATTED "^FO1655,280^A0N,38,38^FB565,1,0,L^FD" item-ean.origem "^FS"            SKIP.
        PUT UNFORMATTED "^FO1655,320^A0N,38,38^FB565,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        
        PUT UNFORMATTED "^FO1655,360^A0N,38,38^FB565,1,0,L^FD" item-ean.info-tec[1] "^FS"       SKIP.
        PUT UNFORMATTED "^FO1655,400^A0N,38,38^FB565,1,0,L^FD" item-ean.info-tec[2] "^FS"       SKIP.
        PUT UNFORMATTED "^FO1655,460^A0N,50,52^FB565,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.
        PUT UNFORMATTED "^FO2095,150^XGselo-suframa.GRF^FS" SKIP.

        
        PUT UNFORMATTED "^FO1610,620^A0N,60,60^FB755,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO1605,595^GB755,0,80^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO1645,690^A0N,35,35^FD" item-ean.char-2 "^FS" SKIP.  /* Imprime Made In Brazil */
        
        PUT UNFORMATTED "^FO1645,725^A0N,35,33^FD" c-cgc "^FS" SKIP.  /* Imprime CGC */
        PUT UNFORMATTED "^FO1645,760^A0N,35,33^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO1645,795^A0N,35,33^FD" item-ean.origem "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO1645,830^A0N,35,33^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO1645,865^A0N,35,33^FD" item-ean.info-tec[1] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO2000,885^A0N,36,33^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Sigla - Etiqueta Secundòria*/
        PUT UNFORMATTED "^FO2000,690^XGselo-suframa.GRF^FS" SKIP.
        
        IF item-ean.etiq-1-tipo = 5 
        THEN DO:
            PUT UNFORMATTED "^FT2290,1150^BY4,2.0,10^BQN,2,5^FH\^FDLA," num-serie.n-serie "^FS" SKIP.
            PUT UNFORMATTED "^FO2340,980^A0B,40,40^FB715,1,0,C^FDNS:" num-serie.n-serie "^FS" skip.
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO2260,940^A0B,52,54^FB715,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO2340,940^A0B,52,54^FB715,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/
        END.

        PUT UNFORMATTED "^FO1700,1020^A0N,50,52^FDINTELBRAS CLOUD^FS" SKIP.
        PUT UNFORMATTED "^FO1805,1160^BQN,2,10^FH\^FDLA," num-serie.n-serie "^FS" SKIP.  /* CΩdigo de Barras do Número de S≤rie */
        PUT UNFORMATTED "^FO1700,1480^A0N,50,52^FDNS:" num-serie.n-serie "^FS" SKIP.
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.  

    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       

        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
    PUT UNFORMATTED "^XA^IDselo-suframa.GRF^FS^XZ".                                                                                                                             
END.

IF p-cod-modelo = 270 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/
    
        PUT "^XA" SKIP.
        
        /*-----------------*/
        /*E M B A L A G E M*/
        /*-----------------*/
        PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO78,32^BY3^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO373,32^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
        IF item-ean.destaque = "" THEN DO:
            PUT UNFORMATTED "^FO18,132^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,167^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,122^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO18,132^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,167^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,122^GB315,0,80^FS^LRN" SKIP.  /* Quadro preto */
        
            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
            END.
            ELSE
                PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
        
            PUT UNFORMATTED "^LRY^FO345,122^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */
        END.
        
        PUT UNFORMATTED "^FO28,207^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO28,237^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO343,237^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        /*------------------------*/
        /*F I M  E M B A L A G E M*/
        /*------------------------*/
    
        /*-------------*/
        /*P R O D U T O*/
        /*-------------*/
    
        /*{esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */*/
        PUT UNFORMATTED "^FO405,45^A0N,24,24^FB410,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO430,30^GB380,40,40^FS^LRN" SKIP.  /* Quadro preto */
        /*{esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */*/
        PUT UNFORMATTED "^FO445,85^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO660,85^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO445,101^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO660,101^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO445,117^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO445,133^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO445,149^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.
    
        /*--------------------*/
        /*F I M  P R O D U T O*/
        /*--------------------*/
      
        PUT UNFORMATTED "^FO445,172^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO445,190^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
        
    END.
END. /* modelo 270 */

/**********************************************************************************************/
/*                              ETIQUETAS DE APOIO                                           */
/**********************************************************************************************/

/* ---[ Modelo 500: EAN13 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 500 THEN DO:
    
    PUT UNFORMATTED "^XA" SKIP.
    PUT UNFORMATTED "^FO60,35^A0B,30,30^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
    PUT UNFORMATTED "^FO165,35^BY3^BEN,100,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    PUT UNFORMATTED "^FO520,35^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
    
    IF item-ean.destaque = "" THEN DO:
        PUT UNFORMATTED "^FO60,210^A0N,42,34^FB495,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO60,260^A0N,42,34^FB495,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO60,200^GB495,0,100^FS^LRN" SKIP.  /* Quadro preto */
    END.
    ELSE DO:
        PUT UNFORMATTED "^FO60,210^A0N,42,34^FB420,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO60,260^A0N,42,34^FB420,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO60,200^GB420,0,100^FS^LRN" SKIP.  /* Quadro preto */ 
    
        IF item-ean.destaque = "CHA" THEN DO:
            RUN piCargaImagem("local-chave").
            PUT UNFORMATTED "^FO480,205^XGlocal-chave.GRF^FS" SKIP.
        END.
        ELSE
            PUT UNFORMATTED "^FO505,220,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
    
        PUT UNFORMATTED "^LRY^FO490,200^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */
    END.

    PUT "^PQ" STRING(p-qtd-etiquetas, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
    PUT "^XZ" SKIP.
    
END.  /* fim modelo 500 */


/* ---[ Modelo 510: DUN14 ]---------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 510 THEN DO:

    IF p-num-po <> 0 THEN DO:
    
       FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.

       IF NOT AVAIL ord-prod THEN DO:
    
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
       END.
    END.

    PUT UNFORMATTED
         "^XA"         SKIP   /* Inicio Label */
         "^PW850"      SKIP   /* Novo comando para zebra 600 */
         "^JUS"        SKIP   /* Novo comando para zebra 600 */
         "^LL296"      SKIP   /* 824 ? o numero de Dot¡s que formam nr colunas da etiqueta */
         "^MNY"        SKIP     /* Papel de etiquetas com quebra de etiquetas */
         "^FWN"        SKIP.   /* Orientacao dos Campos N = Normal */

    ASSIGN iColuna = 1.

    DO i-cont = 1 TO p-qtd-etiquetas:
        FOR FIRST item-dun NO-LOCK
            WHERE item-dun.it-codigo = p-it-codigo
            AND   item-dun.qtd-emb   = p-qtd-embalagem:
    
            /*Coluna 1*/
            IF iColuna = 1 THEN DO:
                PUT "^XA" SKIP.

                PUT UNFORMATTED "^BY3,3,69^FT50,86^BCN,,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
                PUT UNFORMATTED "^FT31,142^A0N,28,28^FH\^FD" STRING(TODAY,"99/99/99") "^FS"  SKIP.
                PUT UNFORMATTED "^FT37,258^A0N,28,28^FH\^FD" item-ean.it-codigo   "^FS"  SKIP.
                
                IF item-ean.destaque = "" THEN DO:
                    PUT UNFORMATTED "^FO20,160^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO20,193^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO20,150^GB370,0,73^FS^LRN" SKIP.  /* Quadro preto */
                END.
                ELSE DO:
                    PUT UNFORMATTED "^FO20,160^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO20,193^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO10,150^GB340,0,73^FS^LRN" SKIP.  /* Quadro preto */
    
                    IF item-ean.destaque = "CHA" THEN DO:
                        RUN piCargaImagem("local-chave").
                        //PUT UNFORMATTED "^FR^FO290,155^XGlocal-chave.GRF^FS" SKIP. 
                        PUT UNFORMATTED "^FR^FO336,140^XGlocal-chave.GRF^FS" SKIP. 
                    END.
                    ELSE
                  /*      PUT UNFORMATTED "^FO505,190,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
                    PUT UNFORMATTED "^LRY^FO490,170^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */ */
                        PUT UNFORMATTED "^FO360,158,^A0B,42,30^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
                  
                    PUT UNFORMATTED "^LRY^FO355,150^GB20,73,40^FS^LRN" SKIP.  /* Quadro preto destaque */
                END.
                
                PUT UNFORMATTED "^FO220,237^A0N,28,28^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
                 
                IF p-num-po <> 0 THEN 
                   PUT UNFORMATTED "^FT37,296^A0N,28,28^FH\^FDOP:" STRING(p-num-po) "^FS" SKIP.

                PUT UNFORMATTED "^FT350,296^A0N,28,28^FH\^FD" upper(p-sigla) "^FS" SKIP.
    
                IF i-cont = p-qtd-etiquetas THEN
                    PUT UNFORMATTED "^XZ".
                ASSIGN iColuna = 2.
            END.
            /*fim Coluna 1*/
            ELSE DO:
                /*Coluna 2*/
                
                PUT UNFORMATTED "^BY3,3,69^FT475,86^BCN,,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */

                PUT UNFORMATTED "^FT456,142^A0N,28,28^FH\^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */

                PUT UNFORMATTED "^FT462,258^A0N,28,28^FH\^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
                IF item-ean.destaque = "" THEN DO:
                    PUT UNFORMATTED "^FO440,160^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO440,193^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO445,150^GB370,0,73^FS^LRN" SKIP.  /* Quadro preto */
                END.
                ELSE DO:
                    PUT UNFORMATTED "^FO440,160^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO440,193^A0N,28,20^FB350,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO432,150^GB340,0,73^FS^LRN" SKIP.  /* Quadro preto */
                
                    IF item-ean.destaque = "CHA" THEN DO:
                        RUN piCargaImagem("local-chave").
                        //PUT UNFORMATTED "^FR^FO715,155^XGlocal-chave.GRF^FS" SKIP.
                        PUT UNFORMATTED "^FR^FO758,140^XGlocal-chave.GRF^FS" SKIP. 
                    END.
                    ELSE
                        PUT UNFORMATTED "^FO780,158,^A0B,42,30^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
                
                    PUT UNFORMATTED "^LRY^FO777,150^GB20,73,40^FS^LRN" SKIP.  /* Quadro preto destaque */
                END.
                
                PUT UNFORMATTED "^FO640,237^A0N,28,28^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP. /* Quantidade */
           
                IF p-num-po <> 0 THEN 
                   PUT UNFORMATTED "^FT462,296^A0N,28,28^FH\^FDOP:" STRING(p-num-po) "^FS" SKIP.

                PUT UNFORMATTED "^FT770,296^A0N,28,28^FH\^FD" upper(p-sigla) "^FS" SKIP.

                PUT UNFORMATTED "^XZ".    
                ASSIGN iColuna = 1.
            END.
            /*fim Coluna 2*/
        END.
    
        PUT UNFORMATTED
             "^PQ" STRING(1, "99999") SKIP  /* Repetiá‰es */.
    END.                                                     

    /*
    IF p-num-po <> 0 THEN DO:
       {esapi/esapi016a16.i} 
    END.
    ELSE DO:
        DO i-cont = 1 TO p-qtd-etiquetas:
            FOR FIRST item-dun NO-LOCK
                WHERE item-dun.it-codigo = p-it-codigo
                AND   item-dun.qtd-emb   = p-qtd-embalagem:
    
                /*Coluna 1*/
                IF iColuna = 1 THEN DO:
                    PUT "^XA" SKIP.
                    PUT UNFORMATTED "^FO18,260^A0,25,25^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
                    PUT UNFORMATTED "^FO36,45^BY3,^BCN,45,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
                    PUT UNFORMATTED "^FO155,260^A0,30,25^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
            
                    IF item-ean.destaque = "" THEN DO:
                        PUT UNFORMATTED "^FO30,160^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^FO30,210^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^LRY^FO20,150^GB370,0,100^FS^LRN" SKIP.  /* Quadro preto */
                    END.
                    ELSE DO:
                        PUT UNFORMATTED "^FO30,160^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^FO30,210^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^LRY^FO10,150^GB340,0,100^FS^LRN" SKIP.  /* Quadro preto */
    
                        IF item-ean.destaque = "CHA" THEN DO:
                            RUN piCargaImagem("local-chave").
                            //PUT UNFORMATTED "^FR^FO290,155^XGlocal-chave.GRF^FS" SKIP. 
                            PUT UNFORMATTED "^FR^FO336,155^XGlocal-chave.GRF^FS" SKIP. 
                        END.
                        ELSE
                      /*      PUT UNFORMATTED "^FO505,190,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
                        PUT UNFORMATTED "^LRY^FO490,170^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */ */
                            PUT UNFORMATTED "^FO360,170,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
                      
                        PUT UNFORMATTED "^LRY^FO355,150^GB20,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */
                    END.
                    
                    PUT UNFORMATTED "^FO260,260^A0N,42,22^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
                    
    
                    IF i-cont = p-qtd-etiquetas THEN
                        PUT UNFORMATTED "^XZ".
                    ASSIGN iColuna = 2.
                END.
                /*fim Coluna 1*/
                ELSE DO:
                    /*Coluna 2*/
                    PUT UNFORMATTED "^FO450,260^A0,25,25^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
                    PUT UNFORMATTED "^FO456,45^BY3,^BCN,45,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
                    PUT UNFORMATTED "^FO575,260^A0,30,25^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
            
                    IF item-ean.destaque = "" THEN DO:
                        PUT UNFORMATTED "^FO460,160^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^FO460,210^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^LRY^FO445,150^GB370,0,100^FS^LRN" SKIP.  /* Quadro preto */
                    END.
                    ELSE DO:
                        PUT UNFORMATTED "^FO460,160^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^FO460,210^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                        PUT UNFORMATTED "^LRY^FO432,150^GB340,0,100^FS^LRN" SKIP.  /* Quadro preto */
                    
                        IF item-ean.destaque = "CHA" THEN DO:
                            RUN piCargaImagem("local-chave").
                            //PUT UNFORMATTED "^FR^FO715,155^XGlocal-chave.GRF^FS" SKIP.
                            PUT UNFORMATTED "^FR^FO758,155^XGlocal-chave.GRF^FS" SKIP. 
                        END.
                        ELSE
                            PUT UNFORMATTED "^FO780,170,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
                    
                        PUT UNFORMATTED "^LRY^FO777,150^GB20,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */
                    END.
                    
                    PUT UNFORMATTED "^FO680,260^A0N,42,22^FDCONTêM:" string(item-dun.qtd-emb) "^FS" SKIP /* Quantidade */
                                    "^XZ".    
                    ASSIGN iColuna = 1.
                END.
                /*fim Coluna 2*/
            END.
    
            PUT UNFORMATTED
                 "^PQ" STRING(1, "99999") SKIP  /* Repetiá‰es */.
        END.                                                     
    END. /* p-num-po <> 0 */ 
    */

END.  /* fim modelo 510 */



/* ---[ Modelo 511: DUN14 + N£mero de SÇrie ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 511 THEN DO:
    
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR FIRST item-dun NO-LOCK
        WHERE item-dun.it-codigo = p-it-codigo
        AND   item-dun.qtd-emb   = p-qtd-embalagem:

        FOR EACH tt-etiq-coletiva:
            PUT "^XA" SKIP.
            PUT UNFORMATTED "^FO46,35^A0B,25,25^FD" STRING(date(tt-etiq-coletiva.data),"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO136,35^BY3,^BCN,60,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
            PUT UNFORMATTED "^FO546,35^A0B,30,25^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
            
            PUT UNFORMATTED "^FO46,140^A0N,30,22^FB520,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO46,175^A0N,30,22^FB520,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO46,130^GB520,0,80^FS^LRN" SKIP.  /* Quadro preto */
            
            PUT UNFORMATTED "^FO129,220^BY2^BCN,40,N,N,N,N^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.  /* Codigo de Barras EAN 128 */
            PUT UNFORMATTED "^FO46,265^A0N,32,32^FB520,1,0,C^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.    /* Imprime descricao Equipto */
            
            PUT UNFORMATTED "^FO406,265^A0N,28,28^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
            
            PUT UNFORMATTED
                 "^PQ" STRING(1, "99999") SKIP                               /* Repetiá‰es */
                 "^XZ".
        END.
    END.
END. /* fim modelo 511 */


/* ---[ Modelo 512: DUN14 dupla + numero de serie ]---------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 512 THEN DO:

    PUT UNFORMATTED
         "^XA"         SKIP   /* Inicio Label */
         "^PW832"      SKIP   /* Novo comando para zebra 600 */
         "^JUS"        SKIP   /* Novo comando para zebra 600 */
         "^LL296"      SKIP   /* 824 ? o numero de Dot¡s que formam nr colunas da etiqueta */
         "^MNY"        SKIP     /* Papel de etiquetas com quebra de etiquetas */
         "^FWN"        SKIP.   /* Orientacao dos Campos N = Normal */

    ASSIGN iColuna = 1.
    DO i-cont = 1 TO p-qtd-etiquetas:
        FOR FIRST item-dun NO-LOCK
            WHERE item-dun.it-codigo = p-it-codigo
            AND   item-dun.qtd-emb   = p-qtd-embalagem:

            /*Coluna 1*/
            IF iColuna = 1 THEN DO:
                PUT "^XA" SKIP.
                PUT UNFORMATTED "^FO15,45^A0B,25,25^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
                PUT UNFORMATTED "^FO36,45^BY3,^BCN,45,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
                PUT UNFORMATTED "^FO375,45^A0B,30,25^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
                IF item-ean.destaque = "" THEN DO:
                    PUT UNFORMATTED "^FO30,150^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO30,190^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO20,140^GB370,0,80^FS^LRN" SKIP.  /* Quadro preto */
                END.
                ELSE DO:
                    PUT UNFORMATTED "^FO30,150^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO30,190^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO20,140^GB370,0,80^FS^LRN" SKIP.  /* Quadro preto */
                
                    IF item-ean.destaque = "CHA" THEN DO:
                        RUN piCargaImagem("local-chave").
                        PUT UNFORMATTED "^FR^FO320,135^XGlocal-chave.GRF^FS" SKIP. 
                    END.
                    ELSE
                        PUT UNFORMATTED "^FO505,190,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
                    /*PUT UNFORMATTED "^LRY^FO490,170^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */*/
                END.
                
                PUT UNFORMATTED "^FO35,230^BY2^BCN,35,N,N,N,N^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.  /* Codigo de Barras EAN 128 */
                PUT UNFORMATTED "^FO35,270^A0N,30,30^FB320,1,0,C^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.    /* Imprime descricao Equipto */

                PUT UNFORMATTED "^FO240,275^A0N,28,28^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */

                IF i-cont = p-qtd-etiquetas THEN
                    PUT UNFORMATTED "^XZ".
                ASSIGN iColuna = 2.
            END.
            /*fim Coluna 1*/
            ELSE DO:
                /*Coluna 2*/
                PUT UNFORMATTED "^FO435,45^A0B,25,25^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
                PUT UNFORMATTED "^FO456,45^BY3,^BCN,45,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
                PUT UNFORMATTED "^FO795,45^A0B,30,25^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
                IF item-ean.destaque = "" THEN DO:
                    PUT UNFORMATTED "^FO460,160^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO460,210^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO445,150^GB370,0,100^FS^LRN" SKIP.  /* Quadro preto */
                END.
                ELSE DO:
                    PUT UNFORMATTED "^FO460,160^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^FO460,210^A0N,24,24^FB320,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
                    PUT UNFORMATTED "^LRY^FO445,150^GB370,0,100^FS^LRN" SKIP.  /* Quadro preto */
                
                    IF item-ean.destaque = "CHA" THEN DO:
                        RUN piCargaImagem("local-chave").
                        PUT UNFORMATTED "^FR^FO750,155^XGlocal-chave.GRF^FS" SKIP. 
                    END.
                    ELSE
                        PUT UNFORMATTED "^FO505,190,^A0B,42,34^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */
                
                    /*PUT UNFORMATTED "^LRY^FO490,170^GB60,100,40^FS^LRN" SKIP.  /* Quadro preto destaque */*/
                END.
                
                PUT UNFORMATTED "^FO500,220^BY2^BCN,40,N,N,N,N^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.  /* Codigo de Barras EAN 128 */
                PUT UNFORMATTED "^F540,265^A0N,30,30^FB520,1,0,C^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.    /* Imprime descricao Equipto */

                PUT UNFORMATTED "^FO665,260^A0N,28,28^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP /* Quantidade */
                                "^XZ".    
                ASSIGN iColuna = 1.
            END.
            /*fim Coluna 2*/
        END.

        PUT UNFORMATTED
             "^PQ" STRING(1, "99999") SKIP  /* Repetiá‰es */.

    END. 
END.  /* fim modelo 512 */


/* ---[ Modelo 520: PALLET ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 520 THEN DO:
    
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-etiq-coletiva:
        PUT "^XA" SKIP.

        PUT UNFORMATTED "^FO46,48^A0N,30,30^FB520,1,0,C^FD" "PALLET" "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO50,33^GB520,0,50^FS^LRN" SKIP.  /* Quadro preto */        

        PUT UNFORMATTED "^FO49,93^A0B,25,25^FD" STRING(date(tt-etiq-coletiva.data),"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */ 
        PUT UNFORMATTED "^FO544,93^A0B,30,25^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

        PUT UNFORMATTED "^FO125,93^BY2^BCN,100,N,N,N,N^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO46,198^A0N,30,24^FB520,1,0,C^FD" tt-etiq-coletiva.cod-etiq "^FS" SKIP.    /* Imprime descricao Equipto */

        PUT UNFORMATTED "^FO46,238^A0N,30,22^FB520,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO46,273^A0N,30,22^FB520,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO46,228^GB520,0,80^FS^LRN" SKIP.  /* Quadro preto */        

        PUT UNFORMATTED "^FO390,198^A0N,28,28^FB90,1,0,R^FDQtd. " p-capacidade "^FS" SKIP.    /* Quantidade */
        
        PUT UNFORMATTED
             "^PQ" STRING(1, "99999") SKIP                               /* Repetiá‰es */
             "^XZ".
    END.
END. /* fim modelo 520 */

IF  p-cod-modelo = 522 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        /* Impressao da Imagem IntelBras */
        PUT UNFORMATTED "^XA" SKIP .

        PUT UNFORMATTED "^FO400,290^GFA,1600,1600,25,,::::::::::::::K018,K03CL0F8M07C3C,K07EK01F8M0FCFC,::K07CK01F8M0FCFC,K018K01F8M0FCFC,R01F8M0FCFC,K07E01FE01FFC01FF00FCFCFFI01FF07FC003FFE,K07E07FF81FFC07FFC0FCJFC003FF1IF007FFE,K07E0IFC1FFC0IFE0FCKF00FFE3IF80IFE,K07E1IFE1FFC1JF0FCKF81FFE7IFC0IFE,K07E3JF1FFC3JF8FCKF81FFCJFE1IFE,K07E3FCFF1F803FE7FCFCFFE7FC3FE8FF9FF1FC,K07E7F03F9F807F03FCFCFF81FC3F81FC07F1F8,K07E7E01F9F807E0FF8FCFF00FE7F01F803F9F8,K07E7E01F9F80FE1FE0FCFE007E7E03F801F9FC,K07E7E00F9F80FC3FC0FCFE007E7E03F001F9IF8,K07E7E00F9F80FCFF80FCFC003E7E03F001F8IFE,K07E7E00F9F80FDFE00FCFC003E7E03F001F87IF,K07E7E00F9F80IFC00FC7C007E7E03F001F83IF,K07E7E00F9F80IF87CFC7E007E7E03F001F80IF8,K07E7E00F9FC07FE0FEFC7E00FE7E01F803F8001F8,K07E7E00F8FC07FC1FCFC7F00FE7E01FC07F8001F8,K07E7E00F8FF03FC3FCFC3FC3FC7E01FF1FF8003F8,K07E7E00F87FF3JF8FC3JF87E00KF8JF8,K07E7E00F87FF1JF0FC1JF87E007JF8JF,K07E7E00F83FF8IFE0FC0JF07E003JF8JF,K07E7E00F81FFC7FFC0FC07FFE07E001JF9IFE,K07E7E00F807FC1FF00FC01FF807EI07FDF9IFC,K07E7C00F800E0038007C003C007EJ0E0F8FFE,,:::::::::::::::::^FS" SKIP.
        PUT UNFORMATTED "^FO29,35^A0B,18,16^FD" STRING(num-serie.data,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO70,35^BY2^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP. /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO270,35^A0B,18,19^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime c´digo do item */

        PUT UNFORMATTED "^FO55,110^A0N,18,19^FB178,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP. /* Valor do Codigo de Barras EAN128 */        
        PUT UNFORMATTED "^FO45,130^BY1^BCN,30,N,N,N,N^FD" num-serie.n-serie "^FS"             SKIP. /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO70,110^A0N,22,22^FB200,1,0,R^FD" num-serie.sigla "^FS"            SKIP. /* Sigla */

        /*Dados novos*/
        PUT UNFORMATTED "^FO35,170^A0N,22,17^FDSuporte a clientes: ^FS"                        SKIP.
        PUT UNFORMATTED "^FO170,170^A0N,22,17^FD(48) 2106 0006^FS"                             SKIP.
        
        PUT UNFORMATTED "^FO35,192^A0N,22,20^FDSuporte via e-mail: ^FS"                        SKIP.
        PUT UNFORMATTED "^FO35,212^A0N,22,17^FDsuporte@intelbras.com.br^FS"                    SKIP.

        PUT UNFORMATTED "^FO35,236^A0N,16,15^FDPRAZO DE VALIDADE:" caps(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO35,256^A0N,18,15^FDCOMPOSIÄ«O:" caps(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO35,278^A0N,18,15^FD" caps(item-ean.texto[15]) "^FS" SKIP.

        PUT UNFORMATTED "^FO310,30^A0N,22,20^FDSAC: ^FS"                       SKIP.
        PUT UNFORMATTED "^FO350,30^A0N,22,17^FD0800 7042767^FS"                             SKIP.

      /*  PUT UNFORMATTED "^FO310,52^A0N,22,17^FDProduzido por: ^FS"                           SKIP. Comentado por Nicolas - Conforme retorno de Tatiani e aval do juridico n∆o precisa inserir Produzido por */
        PUT UNFORMATTED "^FO310,51^A0N,22,20^FD" item-ean.char-2 "^FS"                       SKIP.
      /*  PUT UNFORMATTED "^FO435,74^A0N,22,20^FD - Ind£stria de ^FS"                            SKIP. */
        PUT UNFORMATTED "^FO310,72^A0N,22,20^FDInd£stria de Telecomunicaá∆o^FS"           SKIP. 
        PUT UNFORMATTED "^FO310,94^A0N,22,20^FDEletrìnica Brasileira^FS"     SKIP. 

        PUT UNFORMATTED "^FO310,117^A0N,22,17^FD" + estabelec.endereco + "^FS" SKIP.
        PUT UNFORMATTED "^FO310,139^A0N,22,17^FD" + estabelec.bairro + "^FS" SKIP.
        PUT UNFORMATTED "^FO310,161^A0N,22,17^FD" + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.


        PUT UNFORMATTED "^FO310,183^A0N,22,17^FDCNPJ: " c-cgc "^FS"                           SKIP.
        PUT UNFORMATTED "^FO310,202^A0N,22,19^FDwww.intelbras.com.br^FS"                      SKIP.

        PUT UNFORMATTED "^FO395,253^A0N,19,14^FB180,1,0,R^FD" item-ean.origem "^FS"           SKIP.
        IF  item-ean.origem = "ind£stria brasileira" THEN /**/
            PUT UNFORMATTED "^FO395,272^A0N,19,14^FB180,1,0,R^FDFABRICADO EN BRASIL^FS"       SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim    = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO310,224^A0N,14,15^FDEste produto Ç beneficiado pela^FS" SKIP.
                PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.      
        
        FOR EACH traduc-item
            WHERE traduc-item.it-codigo = item-ean.it-codigo NO-LOCK:
            IF traduc-item.cod-idioma BEGINS "Por" THEN
                PUT UNFORMATTED 
                   "^FH^FO40,305^A0N,20,24^FB620,1,0^FD" REPLACE(traduc-item.tr-desc-item , "~~":U, "_7e":U) 
                                            "^FS" SKIP. /* Descriá∆o em Portugu?s */
            IF traduc-item.cod-idioma  BEGINS "Esp" THEN
                PUT UNFORMATTED 
                  "^FH^FO40,330^A0N,20,24^FB620,1,0^FD" REPLACE(traduc-item.tr-desc-item , "~~":U, "_7e":U) 
                                           "^FS" SKIP. /* Descriá∆o em Espanhol */
        END.

        PUT UNFORMATTED "^LRY^FO30,295^GB555,0,60^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO633,30^A0R,20,20^FDNS:" num-serie.n-serie "^FS"                   SKIP. /* Valor do Codigo de Barras EAN128 */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT UNFORMATTED "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 522 */

IF  p-cod-modelo = 524 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        /* Impressao da Imagem IntelBras */
        PUT UNFORMATTED "^XA" SKIP .

        PUT UNFORMATTED "^FO400,290^GFA,1600,1600,25,,::::::::::::::K018,K03CL0F8M07C3C,K07EK01F8M0FCFC,::K07CK01F8M0FCFC,K018K01F8M0FCFC,R01F8M0FCFC,K07E01FE01FFC01FF00FCFCFFI01FF07FC003FFE,K07E07FF81FFC07FFC0FCJFC003FF1IF007FFE,K07E0IFC1FFC0IFE0FCKF00FFE3IF80IFE,K07E1IFE1FFC1JF0FCKF81FFE7IFC0IFE,K07E3JF1FFC3JF8FCKF81FFCJFE1IFE,K07E3FCFF1F803FE7FCFCFFE7FC3FE8FF9FF1FC,K07E7F03F9F807F03FCFCFF81FC3F81FC07F1F8,K07E7E01F9F807E0FF8FCFF00FE7F01F803F9F8,K07E7E01F9F80FE1FE0FCFE007E7E03F801F9FC,K07E7E00F9F80FC3FC0FCFE007E7E03F001F9IF8,K07E7E00F9F80FCFF80FCFC003E7E03F001F8IFE,K07E7E00F9F80FDFE00FCFC003E7E03F001F87IF,K07E7E00F9F80IFC00FC7C007E7E03F001F83IF,K07E7E00F9F80IF87CFC7E007E7E03F001F80IF8,K07E7E00F9FC07FE0FEFC7E00FE7E01F803F8001F8,K07E7E00F8FC07FC1FCFC7F00FE7E01FC07F8001F8,K07E7E00F8FF03FC3FCFC3FC3FC7E01FF1FF8003F8,K07E7E00F87FF3JF8FC3JF87E00KF8JF8,K07E7E00F87FF1JF0FC1JF87E007JF8JF,K07E7E00F83FF8IFE0FC0JF07E003JF8JF,K07E7E00F81FFC7FFC0FC07FFE07E001JF9IFE,K07E7E00F807FC1FF00FC01FF807EI07FDF9IFC,K07E7C00F800E0038007C003C007EJ0E0F8FFE,,:::::::::::::::::^FS" SKIP.

        PUT UNFORMATTED "^FO29,35^A0B,18,16^FD" STRING(num-serie.data,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO70,35^BY2^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP. /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO270,35^A0B,18,19^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime c´digo do item */

        IF item-ean.char-3 <> ""
        THEN DO:
             PUT UNFORMATTED "^FO035,120^A0N,22,20^FD" item-ean.char-2 "^FS"                       SKIP.
             PUT UNFORMATTED "^FO160,120^A0N,20,16^FD" item-ean.char-3 "^FS"                       SKIP.
        END.

        /*Dados novos*/
        PUT UNFORMATTED "^FO35,160^A0N,22,17^FD" item-ean.fone /*"Suporte a clientes:*/ "^FS" SKIP.
        //PUT UNFORMATTED "^FO170,160^A0N,22,17^FD(48) 2106 0006^FS"                          SKIP.
        
        PUT UNFORMATTED "^FO35,182^A0N,22,20^FDSuporte via e-mail: ^FS"                        SKIP.

        IF INDEX(item-ean.fone,"0800 808 0333") <> 0 THEN
           PUT UNFORMATTED "^FO35,202^A0N,22,17^FDsupport.br@dji.com^FS"                 SKIP.
        ELSE
           PUT UNFORMATTED "^FO35,202^A0N,22,17^FDsuporte@intelbras.com.br^FS"           SKIP.

        PUT UNFORMATTED "^FO35,236^A0N,16,15^FDPRAZO DE VALIDADE:" caps(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO35,254^A0N,18,15^FDCOMPOSIÄ«O:" caps(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO35,273^A0N,18,15^FD" caps(item-ean.texto[15]) "^FS" SKIP.

        PUT UNFORMATTED "^FO310,30^A0N,22,20^FDSAC: ^FS"                       SKIP.
        PUT UNFORMATTED "^FO350,30^A0N,22,17^FD0800 7042767^FS"                             SKIP.
      
        IF item-ean.char-3 <> "" 
        THEN PUT UNFORMATTED "^FO310,51^A0N,22,20^FDDistribu°do por INTELBRAS S/A^FS"             SKIP.
        ELSE PUT UNFORMATTED "^FO310,51^A0N,22,20^FD" item-ean.char-2 "^FS"                       SKIP.
        
        PUT UNFORMATTED "^FO310,72^A0N,22,20^FDInd£stria de Telecomunicaá∆o^FS"           SKIP. 
        PUT UNFORMATTED "^FO310,94^A0N,22,20^FDEletrìnica Brasileira^FS"     SKIP. 

        PUT UNFORMATTED "^FO310,117^A0N,22,17^FD" + estabelec.endereco + "^FS" SKIP.
        PUT UNFORMATTED "^FO310,139^A0N,22,17^FD" + estabelec.bairro + "^FS" SKIP.
        PUT UNFORMATTED "^FO310,161^A0N,22,17^FD" + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.


        PUT UNFORMATTED "^FO310,183^A0N,22,17^FDCNPJ: " c-cgc "^FS"                           SKIP.
        PUT UNFORMATTED "^FO310,202^A0N,22,19^FDwww.intelbras.com.br^FS"                      SKIP.

        IF item-ean.origem <> "" THEN
        PUT UNFORMATTED "^FO320,270^A0N,19,14^FB180,1,0,R^FD" item-ean.origem "^FS"           SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO310,224^A0N,14,15^FDEste produto Ç beneficiado pela^FS" SKIP.
                PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.      
        
        FOR EACH traduc-item
            WHERE traduc-item.it-codigo = item-ean.it-codigo NO-LOCK:
            IF traduc-item.cod-idioma BEGINS "Por" THEN
                PUT UNFORMATTED 
                   "^FH^FO40,305^A0N,20,24^FB620,1,0^FD" REPLACE(traduc-item.tr-desc-item , "~~":U, "_7e":U) 
                                            "^FS" SKIP. /* Descriá∆o em Portugu?s */
            IF traduc-item.cod-idioma  BEGINS "Esp" THEN
                PUT UNFORMATTED 
                  "^FH^FO40,330^A0N,20,24^FB620,1,0^FD" REPLACE(traduc-item.tr-desc-item , "~~":U, "_7e":U) 
                                           "^FS" SKIP. /* Descriá∆o em Espanhol */
        END.

        PUT UNFORMATTED "^LRY^FO30,295^GB555,0,60^FS^LRN" SKIP.  /* Quadro preto */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT UNFORMATTED "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 524 */

IF  p-cod-modelo = 523 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        /* Impressao da Imagem IntelBras */
        PUT UNFORMATTED "^XA" SKIP .

        PUT UNFORMATTED "^FO55,950^GFA,1576,1576,8,,::::::::::::::::::::J03KF9E,J03KF9F,J03KFBF8,J03KFBF,J03KF9F,J03KF8E,,:J03IFE,J03JF8,J03JFC,J03JFE,J03KF,J01KF,N03F8,N01F8,:O0F8,:N01F8,:N03F8,N0FF,J03KF,J03JFE,J03JFC,J03JF8,J03IFE,,:L03JFE,L0LF,K03LF,K07LF,K0MF,:J01FE00F8,J01F800F8,:J03FI0F8,:J03F,J01F,J01C1F8,J0187FE,K01IF8,K03IFC,K07IFE,K0KF,K0FF8FF,J01FFC3F8,J01FFE1F8,:J03F3F1F8,J03F1F8F8,J03F1FCF8,J01F0FDF8,J01F87FF8,J01FC3FF8,K0FE3FF,K0FF1FF,K07F0FE,K03F07C,K01F078,L0F03,L02,,J01LFE,J03MF,::::,:M07IFE,L07JFE,K01LF,K03LF,K07LF,K0MF,K0FF1FF,J01FC07F,J01F803F8,J01F801F8,J03F001F8,J03FI0F8,:J01F001F8,J01F801F8,J01F803F8,J01FE07F,K0FF9FF,K0JFE,K07IFE,K03IFC,L0IF,L07FC,,:J03IFC,J03JF,J03JFC,J03JFE,:J03KF,N07F8,N03F8,N01F8,:O0F8,N01F8,O0F8,L01F878,L0FFE18,K01IF8,K03IFC,K07IFE,K0KF,K0FE0FF,J01FC03F8,J01F801F8,:J03F001F8,J03FI0F8,:J01F801F8,:J01FC03F8,K0FE07F,J01KF,J03JFE,J03JFC,J03JF8,J03JF,J03IFC,,:J01801F8,J03F03FE,J03F07FF,J03F0IF8,:J03F1IF8,J03F1F9F8,J03F1F0F8,:::J03F9F0F8,J01IF0F8,:J01FFE0F8,K0FFE0F8,K07FC,K01F,,:::::::::::::::::::^FSCFC,::K07CK01F8M0FCFC,K018K01F8M0FCFC,R01F8M0FCFC,K07E01FE01FFC01FF00FCFCFFI01FF07FC003FFE,K07E07FF81FFC07FFC0FCJFC003FF1IF007FFE,K07E0IFC1FFC0IFE0FCKF00FFE3IF80IFE,K07E1IFE1FFC1JF0FCKF81FFE7IFC0IFE,K07E3JF1FFC3JF8FCKF81FFCJFE1IFE,K07E3FCFF1F803FE7FCFCFFE7FC3FE8FF9FF1FC,K07E7F03F9F807F03FCFCFF81FC3F81FC07F1F8,K07E7E01F9F807E0FF8FCFF00FE7F01F803F9F8,K07E7E01F9F80FE1FE0FCFE007E7E03F801F9FC,K07E7E00F9F80FC3FC0FCFE007E7E03F001F9IF8,K07E7E00F9F80FCFF80FCFC003E7E03F001F8IFE,K07E7E00F9F80FDFE00FCFC003E7E03F001F87IF,K07E7E00F9F80IFC00FC7C007E7E03F001F83IF,K07E7E00F9F80IF87CFC7E007E7E03F001F80IF8,K07E7E00F9FC07FE0FEFC7E00FE7E01F803F8001F8,K07E7E00F8FC07FC1FCFC7F00FE7E01FC07F8001F8,K07E7E00F8FF03FC3FCFC3FC3FC7E01FF1FF8003F8,K07E7E00F87FF3JF8FC3JF87E00KF8JF8,K07E7E00F87FF1JF0FC1JF87E007JF8JF,K07E7E00F83FF8IFE0FC0JF07E003JF8JF,K07E7E00F81FFC7FFC0FC07FFE07E001JF9IFE,K07E7E00F807FC1FF00FC01FF807EI07FDF9IFC,K07E7C00F800E0038007C003C007EJ0E0F8FFE,,:::::::::::::::::^FS" SKIP.
/*        PUT UNFORMATTED "^FO380,50^A0N,45,33^FD" STRING(num-serie.data,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO360,130^BY4^BER,130,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP. /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO390,530^A0N,45,30^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime c´digo do item */
*/
        PUT UNFORMATTED "^FO650,50^A0N,45,33^FD" STRING(num-serie.data,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO640,130^BY4^BER,130,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP. /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO670,530^A0N,45,30^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime c´digo do item */

        /*Dados novos*/
        PUT UNFORMATTED "^FO540,40^A0R,45,35^FDSuporte a clientes: ^FS"                       SKIP.
        PUT UNFORMATTED "^FO540,310^A0R,45,35^FD(48) 2106 0006^FS"                             SKIP.
    /*    PUT UNFORMATTED "^FO500,40^A0R,45,35^FDSuporte via chat: ^FS"                         SKIP.
        PUT UNFORMATTED "^FO460,40^A0R,45,35^FDintelbras.com.br/suporte-tecnico^FS"           SKIP. */
        
        PUT UNFORMATTED "^FO500,40^A0R,45,35^FDSuporte via e-mail: ^FS"                       SKIP.
        PUT UNFORMATTED "^FO460,40^A0R,45,35^FDsuporte@intelbras.com.br^FS"                   SKIP.

        PUT UNFORMATTED "^FO420,40^A0R,40,30^FD" item-ean.origem "^FS"           SKIP.
        IF  item-ean.origem = "ind£stria brasileira" THEN /**/
            PUT UNFORMATTED "^FO380,40^A0R,40,30^FDFABRICADO EN BRASIL^FS"       SKIP.

        PUT UNFORMATTED "^FO330,40^A0R,35,25^FDPRAZO DE VALIDADE:" caps(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO290,40^A0R,35,25^FDCOMPOSIÄ«O:" caps(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO250,40^A0R,35,25^FD" caps(item-ean.texto[15]) "^FS" SKIP.

        PUT UNFORMATTED "^FO200,40^A0R,35,25^FD" caps(item-ean.texto[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO160,40^A0R,35,25^FD" caps(item-ean.texto[2]) "^FS" SKIP.

        PUT UNFORMATTED "^FO720,670^A0R,45,35^FDSAC: ^FS"                       SKIP.
        PUT UNFORMATTED "^FO720,750^A0R,45,35^FD0800 7042767^FS"                             SKIP.
        //PUT UNFORMATTED "^FO680,670^A0R,45,35^FD" item-ean.char-2 "^FS"                       SKIP.
        IF item-ean.char-3 <> "" 
        THEN PUT UNFORMATTED "^FO680,670^A0R,45,35^FDDistribu°do por INTELBRAS S/A^FS"             SKIP.
        ELSE PUT UNFORMATTED "^FO680,670^A0R,45,35^FD" item-ean.char-2 "^FS"                       SKIP.

        PUT UNFORMATTED "^FO640,670^A0R,45,35^FDInd£stria de Telecomunicaá∆o^FS"           SKIP. 
        PUT UNFORMATTED "^FO600,670^A0R,45,35^FDEletrìnica Brasileira^FS"     SKIP. 

        PUT UNFORMATTED "^FO560,670^A0R,45,35^FD" + estabelec.endereco + "^FS" SKIP.
        PUT UNFORMATTED "^FO520,670^A0R,45,35^FD" + estabelec.bairro + "^FS" SKIP.
        PUT UNFORMATTED "^FO480,670^A0R,45,35^FD" + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.

        PUT UNFORMATTED "^FO440,670^A0R,45,35^FDCNPJ: " c-cgc "^FS"                           SKIP.
        PUT UNFORMATTED "^FO400,670^A0R,45,35^FDwww.intelbras.com.br^FS"                      SKIP.

        IF item-ean.char-3 <> ""
        THEN DO:
             PUT UNFORMATTED "^FO350,670^A0R,45,35^FD" item-ean.char-2 "^FS"                       SKIP.
             PUT UNFORMATTED "^FO305,670^A0R,45,35^FD" item-ean.char-3 "^FS"                       SKIP.
        END.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim    = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO270,670^A0R,45,35^FDEste produto Ç beneficiado pela^FS" SKIP.
                PUT UNFORMATTED "^FO230,670^A0R,45,35^FDLegislaá∆o de Inform†tica^FS" SKIP.
            END.
        END. 

        FOR EACH traduc-item
            WHERE traduc-item.it-codigo = item-ean.it-codigo NO-LOCK:
            IF traduc-item.cod-idioma BEGINS "Por" THEN
                PUT UNFORMATTED 
                  "^FH^FO85,60^A0R,45,30^FB720,1,0^FD" REPLACE(traduc-item.tr-desc-item , "~~":U, "_7e":U)
                                           "^FS" SKIP. /* Descriá∆o em Portugu?s */
            IF traduc-item.cod-idioma  BEGINS "Esp" THEN
                PUT UNFORMATTED 
                   "^FH^FO40,60^A0R,45,30^FB720,1,0^FD" REPLACE(traduc-item.tr-desc-item , "~~":U, "_7e":U)
                                            "^FS" SKIP. /* Descriá∆o em Espanhol */
        END.    

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT UNFORMATTED "^LRY^FO40,30^GB100,1150,100^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT UNFORMATTED "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

END. /* modelo 523 */

/*
IF p-cod-modelo = 525 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/
    
        PUT "^XA" SKIP.
        
        /*-----------------*/
        /*E M B A L A G E M*/
        /*-----------------*/
        PUT UNFORMATTED "^FO15,33^A0N,25,25^FB410,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^FO15,58^A0N,20,20^FB410,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO5,23^GB410,55,55^FS^LRN" SKIP.  /* Quadro preto */ 

        PUT UNFORMATTED "^FO20,83^A0N,17,17^FD" item-ean.char-2 "^FS" SKIP.
        //PUT UNFORMATTED "^FO236,83^A0N,17,17^FB365,1,0,L^FDValidade: Indeterminado^FS" SKIP.
        PUT UNFORMATTED "^FO170,83^A0N,12,12^FB365,1,0,L^FDPRAZO VALIDADE:" CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO220,98^A0N,12,12^FB365,1,0,L^FDCOMPOSIÄ«O:" CAPS(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO220,113^A0N,12,12^FB365,1,0,L^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.
        PUT UNFORMATTED "^FO20,100^A0N,17,17^FD" + estabelec.endereco + "^FS" SKIP.
        //PUT UNFORMATTED "^FO340,115^A0N,17,17^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO60,170^A0N,17,17^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO20,117^A0N,17,17^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO20,135^A0N,17,17^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO20,154^A0N,17,17^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.

        PUT UNFORMATTED "^FO205,130^BY2^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO80,240^A0N,20,20^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO40,187^BY2^BCN,45,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO20,180^A0B,18,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

        /*------------------------*/
        /*F I M  E M B A L A G E M*/
        /*------------------------*/
    
        /*-------------*/
        /*P R O D U T O*/
        /*-------------*/

        /*{esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */*/
        PUT UNFORMATTED "^FO420,15^A0N,20,20^FB410,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^FO420,35^A0N,15,15^FB410,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO430,10^GB400,40,40^FS^LRN" SKIP.  /* Quadro preto */ 

        /*{esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */*/
        PUT UNFORMATTED "^FO490,65^A0N,12,12^FD" item-ean.char-2 "^FS" SKIP.
        //PUT UNFORMATTED "^FO580,65^A0N,12,12^FB365,1,0,L^FDValidade: Indeterminado^FS" SKIP.
        PUT UNFORMATTED "^FO585,52^A0N,12,12^FB365,1,0,L^FDPRAZO VALIDADE:" CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO620,64^A0N,12,12^FB365,1,0,L^FDCOMPOSIÄ«O:" CAPS(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO650,78^A0N,12,12^FB365,1,0,L^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.
        PUT UNFORMATTED "^FO490,78^A0N,12,12^FD" + estabelec.endereco + "^FS" SKIP.
       // PUT UNFORMATTED "^FO650,80^A0N,12,12^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO490,92^A0N,12,12^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO490,105^A0N,12,12^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO490,120^A0N,12,12^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.

        PUT UNFORMATTED "^FO640,95^BY1^BEN,20,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO470,158^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO560,135^BY1^BCN,20,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO505,135^A0N,12,12^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO500,150^A0N,14,14^FB365,1,0,L^FD" item-ean.it-codigo "^FS" SKIP. 
       // PUT UNFORMATTED "^FO450,130^A0B,14,14^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

        /*--------------------*/
        /*F I M  P R O D U T O*/
        /*--------------------*/
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
        
    END.
END. /* modelo 270 */
*/

IF p-cod-modelo = 525 THEN DO:

    {esapi/esapi016inic.i} /*inicializa par≥metros impressora*/

    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-LOCK NO-ERROR.

    IF AVAIL estabelec THEN
       ASSIGN c-cgc = STRING(estabelec.cgc,"99.999.999/9999-99").

    PUT "^XA" SKIP.
    
    /*-----------------*/
    /*E M B A L A G E M*/
    /*-----------------*/
    
    PUT UNFORMATTED "^FO25,32^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
    PUT UNFORMATTED "^FO80,30^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    PUT UNFORMATTED "^FO373,30^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime cÆdigo do item */

    IF item-ean.destaque = "" THEN DO:
        PUT UNFORMATTED "^FO18,99^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO18,124^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO23,94^GB368,0,60^FS^LRN" SKIP.  /* Quadro preto */
    END.
    ELSE DO:
        PUT UNFORMATTED "^FO18,99^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO18,124^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO23,94^GB315,0,60^FS^LRN" SKIP.  /* Quadro preto */

        IF item-ean.destaque = "CHA" THEN DO:
            RUN piCargaImagem("local-chaveVENC").
           // PUT UNFORMATTED "^FO326,80^XGlocal-chave.GRF^FS" SKIP.
        END.
        ELSE
            PUT UNFORMATTED "^FO353,105,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

        PUT UNFORMATTED "^LRY^FO345,94^GB40,60,20^FS^LRN" SKIP.  /* Quadro preto destaque */
    END.

    PUT UNFORMATTED "^FO25,160^A0N,17,17^FD"  item-ean.char-2 "^FS" SKIP.
    PUT UNFORMATTED "^FO145,160^A0N,17,17^FD" item-ean.char-3 "^FS" SKIP.     

    PUT UNFORMATTED "^FO25,180^A0N,17,17^FD" + estabelec.endereco + "^FS" SKIP.
    PUT UNFORMATTED "^FO25,200^A0N,17,17^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
    PUT UNFORMATTED "^FO25,220^A0N,17,17^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
    PUT UNFORMATTED "^FO220,220^A0N,17,17^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
    

    PUT UNFORMATTED "^FO25,240^A0N,17,17^FB365,1,0,L^FDPRAZO DE VALIDADE:" CAPS(item-ean.texto[12]) "^FS" SKIP.
    PUT UNFORMATTED "^FO25,260^A0N,17,17^FB365,1,0,L^FDCOMPOSIÄ«O:" CAPS(item-ean.texto[14]) "^FS" SKIP.
    PUT UNFORMATTED "^FO25,280^A0N,17,17^FB365,1,0,L^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.

    /*------------------------*/
    /*F I M  E M B A L A G E M*/
    /*------------------------*/

    /*-------------*/
    /*P R O D U T O*/
    /*-------------*/
    
    PUT UNFORMATTED "^FO455,32^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.       /* Imprime Data Vertical */
    PUT UNFORMATTED "^FO507,30^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    PUT UNFORMATTED "^FO803,30^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP.                      /* Imprime cÆdigo do item */

    IF item-ean.destaque = "" THEN DO:
        PUT UNFORMATTED "^FO448,99^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO448,124^A0N,28,20^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.   /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO453,94^GB368,0,60^FS^LRN" SKIP.  /* Quadro preto */
    END.
    ELSE DO:
        PUT UNFORMATTED "^FO448,99^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO448,124^A0N,28,20^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO453,94^GB315,0,60^FS^LRN" SKIP.  /* Quadro preto */

        IF item-ean.destaque = "CHA" THEN DO:
            RUN piCargaImagem("local-chaveVENC").
           // PUT UNFORMATTED "^FO326,80^XGlocal-chave.GRF^FS" SKIP.
        END.
        ELSE
            PUT UNFORMATTED "^FO803,105,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

        PUT UNFORMATTED "^LRY^FO795,94^GB40,60,20^FS^LRN" SKIP.  /* Quadro preto destaque */
    END.

    PUT UNFORMATTED "^FO455,160^A0N,17,17^FD" item-ean.char-2 "^FS" SKIP.
    PUT UNFORMATTED "^FO565,160^A0N,17,17^FD" item-ean.char-3 "^FS" SKIP.     

    PUT UNFORMATTED "^FO455,180^A0N,17,17^FD" + estabelec.endereco + "^FS" SKIP.
    PUT UNFORMATTED "^FO455,200^A0N,17,17^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
    PUT UNFORMATTED "^FO455,220^A0N,17,17^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
    PUT UNFORMATTED "^FO650,220^A0N,17,17^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.                    

    PUT UNFORMATTED "^FO455,240^A0N,17,17^FB365,1,0,L^FDPRAZO DE VALIDADE:" CAPS(item-ean.texto[12]) "^FS" SKIP.
    PUT UNFORMATTED "^FO455,260^A0N,17,17^FB365,1,0,L^FDCOMPOSIÄ«O:" CAPS(item-ean.texto[14]) "^FS" SKIP.
    PUT UNFORMATTED "^FO455,280^A0N,17,17^FB365,1,0,L^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.

    /*--------------------*/
    /*F I M  P R O D U T O*/
    /*--------------------*/
    
    PUT "^PQ" STRING(p-qtd-etiquetas, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
    PUT "^XZ" SKIP.  

END.

IF  p-cod-modelo = 526 THEN DO:

    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
                   
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        FIND FIRST mac-address USE-INDEX num-serie 
             WHERE mac-address.n-serie = num-serie.n-serie
                   NO-LOCK NO-ERROR.

        PUT "^XA" SKIP.
        
        // Comeáo embalagem
        PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO78,32^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO373,28^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

        IF item-ean.destaque = "" THEN DO:
            PUT UNFORMATTED "^FO18,100^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,130^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,95^GB368,0,65^FS^LRN" SKIP.  /* Quadro preto */
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO18,100^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,130^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,95^GB315,0,65^FS^LRN" SKIP.  /* Quadro preto */

            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
            END.
            ELSE
                PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

            PUT UNFORMATTED "^LRY^FO345,95^GB40,65,20^FS^LRN" SKIP.  /* Quadro preto destaque */
        END.

        IF AVAIL mac-address 
        THEN DO:
            PUT UNFORMATTED "^FO35,163^BY2^BCN,24,N,N,N,N^FD" STRING(mac-address.mac) "^FS" SKIP.
            PUT UNFORMATTED "^FO35,190^ADN,18,10^FB368,1,0,C^FDMAC:" STRING(mac-address.mac) "^FS" SKIP.
        END.

        PUT UNFORMATTED "^FO28,207^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO28,237^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO343,237^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */

        // Fim embalagem

        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO735,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO610,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 526 */

IF  p-cod-modelo = 527 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        FIND FIRST mac-address USE-INDEX num-serie 
             WHERE mac-address.n-serie = num-serie.n-serie
                   NO-LOCK NO-ERROR.

        PUT "^XA" SKIP.
        
        // Comeáo embalagem
        PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO78,32^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO373,28^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */

        IF item-ean.destaque = "" THEN DO:
            PUT UNFORMATTED "^FO18,100^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,130^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,95^GB368,0,65^FS^LRN" SKIP.  /* Quadro preto */
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO18,100^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,130^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,95^GB315,0,65^FS^LRN" SKIP.  /* Quadro preto */

            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
            END.
            ELSE
                PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 

            PUT UNFORMATTED "^LRY^FO345,95^GB40,65,20^FS^LRN" SKIP.  /* Quadro preto destaque */
        END.

        IF AVAIL mac-address 
        THEN DO:
            PUT UNFORMATTED "^FO35,163^BY2^BCN,24,N,N,N,N^FD" STRING(mac-address.mac) "^FS" SKIP.
            PUT UNFORMATTED "^FO35,190^ADN,18,10^FB368,1,0,C^FDMAC:" STRING(mac-address.mac) "^FS" SKIP.
        END.

        PUT UNFORMATTED "^FO28,207^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO28,237^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO343,237^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        
      //  {esapi/esapi016a5034.i}         /* Embalagem */
        {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 130 */


IF  p-cod-modelo = 528 OR 
    p-cod-modelo = 646 /* Mibo Remanufatura */
    THEN DO:
/*
    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.  

    PUT "^XA"         SKIP.

    PUT "^FO50,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO350,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO650,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO950,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO1250,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO1550,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO1850,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.
    PUT "^FO2150,30^A0N,40,40^FD(DH)WIFI-2-^FS" SKIP.

    PUT "^FO50,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO350,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO650,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO950,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO1250,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO1550,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO1850,75^A0N,40,40^FDR88FUSA1^FS" SKIP.
    PUT "^FO2150,75^A0N,40,40^FDR88FUSA1^FS" SKIP.

    PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
    PUT "^XZ" SKIP. */


    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    /*
    RUN piCargaImagem("local-suframa").                                             
    */

    PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".
   // PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

   // RUN piCargaImagem("local-suframa"). 

   // {esapi/esapi016inic.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.

        /* Embalagem */
       // PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */ ------- trocado por today abaixo a pedido da Tatiani
        PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO165,92^BY5^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO690,100^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime cÆdigo do item */


        PUT UNFORMATTED "^FO170,270^A0N,70,60^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO110,335^A0N,60,30^FB500,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO50,260^GB680,0,150^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO120,460^BY3^BCN,120,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO168,620^ADN,50,22^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO680,620^A0N,50,50^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
  
        /* Fim Embalagem */

        /* Etiqueta de Produto (34x21mm) */
        /* Número S≤rie */

        PUT UNFORMATTED "^FO980,70^A0N,60,50^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO840,60^GB790,60,40^FS^LRN" SKIP.

        IF p-cod-modelo = 528 THEN DO:
           /* Suframa */
           PUT UNFORMATTED "^FO900,250^XGSuframa600dpi.GRF^FS" SKIP.
        END.
        ELSE DO:
           /* Remanufaturado */
           PUT UNFORMATTED "^FO860,270^GFA,03072,03072,00032,:Z64:eJztlMFL21AYwF/ymj3pttjCpN2W14TuUnrbTm9asMLEyw71IL10rn9CioobVBpbppfRXcfYoehFRGRH2WGkDMlloILgZcO4wNwxBcHC6rKXtiYRtucfsH6HkHw/fnxf3vfeA2AQf43INXyIjTmHzXlHY3J4pLO5ZjI5AmwuXsMxUJk8DgiTS6DM5IR2wAo1kmDyxtA1vhRjcjPFszCnZ5DO4hqBGoOjbIZj+RCkmANAQOL2GVykC8jyZToA1gBdP+V9RbkIF4mCSDTK9TNlOmDJ4+HqBmiktUZys9roZQjlcb+a0UFn47a66Bh2L6PS8+P7o9Y2aqdtM7lZb/cyxW4PlyEtxLAslVVVxbPdBOf6/gDjYytxkRBTSZG+ZNIOkOb7SEKSRP0XPU7XPhPg8UfbhCfhoqKk+r5Gz68/QNy6IEjCrj986UcC/n1rh/pDfn3ORQF/skDrF6hf7u1azgTuDL36sC7S/hVF8fu/8v+CLM/i8pKt4kIvszAzM/M84Ndge9yUdTLcX79xx3HaHr8jICEXy45kc0Kul4lVKpV58O/gk3ySgf+zGGl+wyNc82B6Yvcg9+xAuL2PhUMu53HZ/J0Q6Y27vrxqk4pVe9MWYRv6649Lh7KMdHtxwsiV81OTe2UZ5eXA/BRdFHmz/WB5BfyEsFpPhXkkBuZf0qlf6sw1j7ivCL16L2GEAhdY/MPG2D2xuLVO/dcQ1urkYQ2+Dey/UgfnQ+oZrT/9BaGpvfnSlFDw91/C3BpN3lJ+0Pondbe+qVQhueH5cvPw7jkunc41jdYxrX9slwzqezxu6sS6uWPR+vBjt/6vz7V3V/p/fC6fWa1dAzkIGk/nKwaS8x4nRTO1liZWw1rh1yA8FUnxe13c9v2XDkEZfNKqxBBa5ZYSWD+/EDr+/5NP7vlrNAgfhjVAwmFtnd5IHg+BJ/QRymZDoRD96L5mQZY99EEMYhB/ABE4420=:F7EF" SKIP.
        END.


        /* etiqueta 24x8mm */
        PUT UNFORMATTED "^FO895,140^A0N,25,25^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO895,165^A0N,25,25^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO895,190^A0N,24,24^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO895,215^A0N,25,25^FD" item-ean.origem "^FS" SKIP.

        PUT UNFORMATTED "^FO1270,190^A0R,25,25^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.
        PUT UNFORMATTED "^FO1300,210^A0R,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.

       // PUT UNFORMATTED "^FO880,395^A0N,25,25^FDEste produto contem o modulo " item-ean.MODULO "^FS" SKIP.
       // PUT UNFORMATTED "^FO880,420^A0N,25,25^FDcodigo de homologacao Anatel " item-ean.homolog "^FS" SKIP.
        PUT UNFORMATTED "^FO880,395^A0N,25,25^FDIncorpora produto homologado pela Anatel sob numero^FS" SKIP.
        PUT UNFORMATTED "^FO1050,420^A0N,25,25^FD" item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO880,455^A0N,30,30^FDNS:" num-serie.n-serie  "^FS" SKIP. 
        PUT UNFORMATTED "^FO1150,455^A0N,30,30^FDCHAVE ACESSO: " num-serie.ch-acesso  "^FS" SKIP. 

        //QR CODE
        ASSIGN c-qr-code  = ""
               i-mac-cont = 0
               c-macs     = "".
              // c-qr-code = "SN:5H07566PAJDC5,DT:iM4,SC:L2F9BAA5,NC:015,MAC1:XXXXXXXXXX,MAC2:XXXXXXXXXY".

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = num-serie.n-serie
                 NO-LOCK.

            ASSIGN i-mac-cont = i-mac-cont + 1.

            ASSIGN c-macs = c-macs 
                          + "MAC"
                          + STRING(i-mac-cont)
                          + ":"
                          + mac-address.mac 
                          + IF i-mac-cont = 1 AND
                               item-ean.qtd-mac > 1
                               THEN "," ELSE "".
        END.

        //comentar a linha abaixo ≤ teste
       // ASSIGN c-macs = "MAC1:ABCDEF123456,MAC2:ABCDEF654321,".

        FIND FIRST num-serie-uuid WHERE
                   num-serie-uuid.n-serie = num-serie.n-serie
                   NO-LOCK NO-ERROR.

        IF AVAIL num-serie-uuid AND 
                 num-serie-uuid.uuid <> "" 
        THEN DO:
           ASSIGN c-qr-code = "~{"
                            + "SN:" 
                            + STRING(num-serie.n-serie) + ","
                            + "DT:"
                            + "" + ","
                            + "NC:"
                            + string(item-ean.nc) + ","
                            + c-macs
                            + ",UUID:" + num-serie-uuid.uuid + ",AUTHKEY:" + num-serie-uuid.authkey
                            + "~}".

           IF LENGTH(item-ean.nc) > 3 THEN DO:

               ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                + "SC:"
                                + string(num-serie.ch-acesso) + ","
                                + "PID:"
                                + string(item-ean.nc) + ","
                                + c-macs
                                + "~}". 
           END.

           PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
        END.
        ELSE DO:
           ASSIGN c-qr-code = "~{"
                            + "SN:" 
                            + STRING(num-serie.n-serie) + ","
                            + "DT:"
                            + string(item-ean.nome-abrev) + ","
                            + "SC:"
                            + string(num-serie.ch-acesso) + ","
                            + "NC:"
                            + string(item-ean.nc) + ","
                            + c-macs
                            + "~}".

            IF LENGTH(item-ean.nc) > 3 THEN DO:

                ASSIGN c-qr-code = "~{"
                                 + "SN:" 
                                 + STRING(num-serie.n-serie) + ","
                                 + "SC:"
                                 + string(num-serie.ch-acesso) + ","
                                 + "PID:"
                                 + string(item-ean.nc) + ","
                                 + c-macs
                                 + "~}". 
            END.

           PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
        END.

        IF LENGTH(item-ean.nc) > 3 THEN DO:

            ASSIGN c-qr-code = "~{"
                             + "SN:" 
                             + STRING(num-serie.n-serie) + ","
                             + "SC:"
                             + string(num-serie.ch-acesso) + ","
                             + "PID:"
                             + string(item-ean.nc) + ","
                             + c-macs
                             + "~}". 
        END.

       // PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT1720,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT2200,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
         
        /*
        PUT UNFORMATTED "^FO1950,410^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1850,450^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.

        PUT UNFORMATTED "^FO1150,580^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1050,620^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.

        PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1850,620^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.*/
        
        CASE item-ean.etiq-1-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1850,410^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,450^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1950,410^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1730,410^A0N,40,40^FD" item-ean.etiq-1-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1730,450^A0N,40,40^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1850,410^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,450^A0N,40,40^FD" item-ean.origem "^FS" SKIP.
            END.
        END CASE.

        CASE item-ean.etiq-2-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1000,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1000,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1150,580^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO950,580^A0N,40,40^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO950,620^A0N,40,40^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
            END.
            
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1000,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1000,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE. 


        CASE item-ean.etiq-3-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1730,580^A0N,40,40^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1730,620^A0N,40,40^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE. 


        // Fim QR Code

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDSuframa600dpi.GRF^FS^XZ".

END. /* modelo 528 */



IF  /*p-cod-modelo = 528 OR */
    p-cod-modelo = 641 OR /** Iziplay **/
    p-cod-modelo = 642 OR /** Iziplay Remanufaturado **/
    p-cod-modelo = 645 OR /** Mibo **/
    p-cod-modelo = 643    /** Mibo Remanufatura **/
    THEN DO:


    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    /*
    RUN piCargaImagem("local-suframa").                                             
    */

    PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".
   // PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

   // RUN piCargaImagem("local-suframa"). 

   // {esapi/esapi016inic.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.

        /* Embalagem */
       // PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */ ------- trocado por today abaixo a pedido da Tatiani
        PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO165,92^BY5^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO690,100^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime cÆdigo do item */


        PUT UNFORMATTED "^FO170,270^A0N,70,60^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO110,335^A0N,60,30^FB500,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO50,260^GB680,0,150^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO120,460^BY3^BCN,120,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO168,620^ADN,50,22^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO680,620^A0N,50,50^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
  
        /* Fim Embalagem */

        /* Etiqueta de Produto (34x21mm) */
        /* Número S≤rie */

        PUT UNFORMATTED "^FO980,70^A0N,60,50^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO840,60^GB790,60,40^FS^LRN" SKIP.

        /* Suframa */
        IF p-cod-modelo <> 642 AND 
           p-cod-modelo <> 643 THEN
           PUT UNFORMATTED "^FO860,250^XGSuframa600dpi.GRF^FS" SKIP.
        ELSE DO:
           /* Remanufaturado */
           PUT UNFORMATTED "^FO860,270^GFA,03072,03072,00032,:Z64:eJztlMFL21AYwF/ymj3pttjCpN2W14TuUnrbTm9asMLEyw71IL10rn9CioobVBpbppfRXcfYoehFRGRH2WGkDMlloILgZcO4wNwxBcHC6rKXtiYRtucfsH6HkHw/fnxf3vfeA2AQf43INXyIjTmHzXlHY3J4pLO5ZjI5AmwuXsMxUJk8DgiTS6DM5IR2wAo1kmDyxtA1vhRjcjPFszCnZ5DO4hqBGoOjbIZj+RCkmANAQOL2GVykC8jyZToA1gBdP+V9RbkIF4mCSDTK9TNlOmDJ4+HqBmiktUZys9roZQjlcb+a0UFn47a66Bh2L6PS8+P7o9Y2aqdtM7lZb/cyxW4PlyEtxLAslVVVxbPdBOf6/gDjYytxkRBTSZG+ZNIOkOb7SEKSRP0XPU7XPhPg8UfbhCfhoqKk+r5Gz68/QNy6IEjCrj986UcC/n1rh/pDfn3ORQF/skDrF6hf7u1azgTuDL36sC7S/hVF8fu/8v+CLM/i8pKt4kIvszAzM/M84Ndge9yUdTLcX79xx3HaHr8jICEXy45kc0Kul4lVKpV58O/gk3ySgf+zGGl+wyNc82B6Yvcg9+xAuL2PhUMu53HZ/J0Q6Y27vrxqk4pVe9MWYRv6649Lh7KMdHtxwsiV81OTe2UZ5eXA/BRdFHmz/WB5BfyEsFpPhXkkBuZf0qlf6sw1j7ivCL16L2GEAhdY/MPG2D2xuLVO/dcQ1urkYQ2+Dey/UgfnQ+oZrT/9BaGpvfnSlFDw91/C3BpN3lJ+0Pondbe+qVQhueH5cvPw7jkunc41jdYxrX9slwzqezxu6sS6uWPR+vBjt/6vz7V3V/p/fC6fWa1dAzkIGk/nKwaS8x4nRTO1liZWw1rh1yA8FUnxe13c9v2XDkEZfNKqxBBa5ZYSWD+/EDr+/5NP7vlrNAgfhjVAwmFtnd5IHg+BJ/QRymZDoRD96L5mQZY99EEMYhB/ABE4420=:F7EF" SKIP.
        END.                          

        /* etiqueta 24x8mm */
        PUT UNFORMATTED "^FO895,140^A0N,25,25^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO895,165^A0N,25,25^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO895,190^A0N,24,24^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO895,215^A0N,25,25^FD" item-ean.origem "^FS" SKIP.

        //PUT UNFORMATTED "^FO1270,150^A0R,25,25^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.
        //PUT UNFORMATTED "^FO1300,210^A0R,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.

       // PUT UNFORMATTED "^FO880,395^A0N,25,25^FDEste produto contem o modulo " item-ean.MODULO "^FS" SKIP.
       // PUT UNFORMATTED "^FO880,420^A0N,25,25^FDcodigo de homologacao Anatel " item-ean.homolog "^FS" SKIP.

       PUT UNFORMATTED "~~DGlocal-anatel.GRF,02560,020,,:::::::W0JFC,V0LF80,U01FKFE0,T01FMFC,T07FNF,S01FOF,S07FOFC0,R01FPFE0,R03FQF0,R0SF8,Q01FRFC,Q07FRFE,Q0TFE,P01FFC03FOF,P07FC0H0PF80,P0FE0I01FNFC0,O03F80J07FMFE0,O0F0L01FMFE0,N01E0M0OF0,N0380M07FMF0,N060N03FMF8,N040N03FMF8,X01FMF8,Y0NFC,:Y07FLFC,Y07FLFE,::Y07FMF,Y03FMF,N01FHF80K03FMF,N07FHFE0K03FMF,N0KF80J03FMF,M03FJFE0J03FMF,M07FKFK03FMF,M0MF80I03FMF,L01FLFC0I03FMF,L03FLFE0I03FMF,L07FMFJ07FMF,L0OF80H07FMF,K01FNF80H07FMF,K01FNFC0H07FMF,K01FNFE0H07FMF,K03FNFE0H07FMF,K07FNFE0H0OF,K07FOFI0OF,K0QFH01FNF,:K0QF803FNF,::K0QF803FMFE,K0QF807FMFE,:K0QF80FNFE,K0QFH0OFE,K0QF01FNFC,K07FOF03FNFC,:K07FNFE07FNF8,K03FNFE07FNF8,K03FNFE0FOF8,K01FNFC3FOF8,L0OF83FOF0,L0OF07FOF0,L03FMF0FOFE0,L03FLFE0FOFE0,M0MF80FOFE0,M0MF01FOFC0,M07FJFE03FOFC0,M01FJF807FOFC0,N07FIFH0QF80,N03FHFC01FPF80,O03FC003FPF,,::L01F01F0FC0F87FLF8,L03F83F0F80F87FFDFFDF8,L07F83F8F81F807C1F01F8,L07F83F8F83FC0FC3F01F0,L0HF83F8F03FC0FC3F01F0,K01FF87FCF07FC0FC3F01F0,K01FF87FEF0FBC0F83FF1E0,K03EFC7FHF1FBC0F83FF1E0,K07EFC7FFE1F3C1F87FF1E0,K0FCFCFDFE3F3E1F07C03C0,K0IFCF9FE3FFE1F07C03C0,J01FHFCF8FE7FFE3F0FC03C0,J01FHFDF8FC7FFE3E0F807C0,J03F07DF0FCF83E3E0F807C0,J03E07DF07DF83E3E0F80780,J07E07DF079F83E7E0FFEFFE,J07C0FDF03BF03E7E0FFEFFE,,::::::::::::::::::::::::".

       PUT UNFORMATTED "^FO1145,285^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP. 

        //Cometado Isac - PUT UNFORMATTED "^FO880,395^A0N,25,25^FDIncorpora produto homologado pela Anatel sob numero^FS" SKIP.


        PUT UNFORMATTED "^FO1100,400^A0N,30,25^FD" item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO880,455^A0N,30,30^FDNS:" num-serie.n-serie  "^FS" SKIP. 

        IF p-cod-modelo = 645 OR p-cod-modelo = 643  THEN
           PUT UNFORMATTED "^FO1150,455^A0N,30,30^FDCHAVE ACESSO: " num-serie.ch-acesso  "^FS" SKIP. 

        //QR CODE
        ASSIGN c-qr-code  = ""
               i-mac-cont = 0
               c-macs     = "".
              // c-qr-code = "SN:5H07566PAJDC5,DT:iM4,SC:L2F9BAA5,NC:015,MAC1:XXXXXXXXXX,MAC2:XXXXXXXXXY".

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = num-serie.n-serie
                 NO-LOCK.

            ASSIGN i-mac-cont = i-mac-cont + 1.

            ASSIGN c-macs = c-macs 
                          + "MAC"
                          + STRING(i-mac-cont)
                          + ":"
                          + mac-address.mac 
                          + IF i-mac-cont = 1 AND
                               item-ean.qtd-mac > 1
                               THEN "," ELSE "".
        END.

        //comentar a linha abaixo ≤ teste
       // ASSIGN c-macs = "MAC1:ABCDEF123456,MAC2:ABCDEF654321,".
        
        
        IF p-cod-modelo = 645 OR /** Mibo **/                
           p-cod-modelo = 643    /** Mibo Remanufatura **/  
        THEN DO:
        
            FIND FIRST num-serie-uuid WHERE
                       num-serie-uuid.n-serie = num-serie.n-serie
                       NO-LOCK NO-ERROR.
    
            IF AVAIL num-serie-uuid AND 
                     num-serie-uuid.uuid <> "" 
            THEN DO:
               ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                + "DT:"
                                + "" + ","
                                + "NC:"
                                + string(item-ean.nc) + ","
                                + c-macs
                                + ",UUID:" + num-serie-uuid.uuid + ",AUTHKEY:" + num-serie-uuid.authkey
                                + "~}".


               IF p-cod-modelo = 645 OR p-cod-modelo = 643 THEN DO:
                   IF LENGTH(item-ean.nc) > 3 THEN DO:

                       ASSIGN c-qr-code = "~{"
                                        + "SN:" 
                                        + STRING(num-serie.n-serie) + ","
                                        + "SC:"
                                        + string(num-serie.ch-acesso) + ","
                                        + "PID:"
                                        + string(item-ean.nc) + ","
                                        + c-macs
                                        + "~}". 
                   END.
               END.
    
               PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
            END.
            ELSE DO:
               ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                + "DT:"
                                + string(item-ean.nome-abrev) + ","
                                + "SC:"
                                + string(num-serie.ch-acesso) + ","
                                + "NC:"
                                + string(item-ean.nc) + ","
                                + c-macs
                                + "~}".


               IF p-cod-modelo = 645 OR p-cod-modelo = 643 THEN DO:
                   IF LENGTH(item-ean.nc) > 3 THEN DO:

                       ASSIGN c-qr-code = "~{"
                                        + "SN:" 
                                        + STRING(num-serie.n-serie) + ","
                                        + "SC:"
                                        + string(num-serie.ch-acesso) + ","
                                        + "PID:"
                                        + string(item-ean.nc) + ","
                                        + c-macs
                                        + "~}". 
                   END.
               END.
    
               PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
            END.
        END.
        /** Iziplay **/
        ELSE DO:
            ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                /*+ "DT:"
                                + string(item-ean.nome-abrev) + ","
                                + "SC:"
                                + string(num-serie.ch-acesso) + ","
                                + "NC:"
                                + string(item-ean.nc) + ","*/
                                + c-macs
                                + "~}".

            IF p-cod-modelo = 645 OR p-cod-modelo = 643 THEN DO:
                IF LENGTH(item-ean.nc) > 3 THEN DO:

                    ASSIGN c-qr-code = "~{"
                                     + "SN:" 
                                     + STRING(num-serie.n-serie) + ","
                                     + "SC:"
                                     + string(num-serie.ch-acesso) + ","
                                     + "PID:"
                                     + string(item-ean.nc) + ","
                                     + c-macs
                                     + "~}". 
                END.
            END.
    
            PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
        END.

        IF p-cod-modelo = 645 OR p-cod-modelo = 643 THEN DO:
            IF LENGTH(item-ean.nc) > 3 THEN DO:

                ASSIGN c-qr-code = "~{"
                                 + "SN:" 
                                 + STRING(num-serie.n-serie) + ","
                                 + "SC:"
                                 + string(num-serie.ch-acesso) + ","
                                 + "PID:"
                                 + string(item-ean.nc) + ","
                                 + c-macs
                                 + "~}". 
            END.
        END.


       // PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT1720,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT2200,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
         
        /*
        PUT UNFORMATTED "^FO1950,410^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1850,450^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.

        PUT UNFORMATTED "^FO1150,580^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1050,620^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.

        PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1850,620^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.*/
        
       
        PUT UNFORMATTED "^FO1380,390^A0N,25,25^FD" STRING(TODAY,"99/99/9999") "^FS"   SKIP.
        PUT UNFORMATTED "^FO1380,420^A0N,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.

        
        CASE item-ean.etiq-1-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1850,410^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,450^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1950,410^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1730,410^A0N,40,40^FD" item-ean.etiq-1-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1730,450^A0N,40,40^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1850,410^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,450^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE.
        

       
         CASE item-ean.etiq-2-tipo: 
             WHEN 1 THEN DO: /* Núm S≤rie */
                 PUT UNFORMATTED "^FO1000,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                 PUT UNFORMATTED "^FO1000,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
             END.
             WHEN 2 THEN /*CΩd. Item.*/
                 PUT UNFORMATTED "^FO1150,580^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
             WHEN 3 THEN DO: /* Outros */
                 PUT UNFORMATTED "^FO950,580^A0N,40,40^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                 PUT UNFORMATTED "^FO950,620^A0N,40,40^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
             END.
             WHEN 6 THEN DO:
                 PUT UNFORMATTED "^FO1000,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                 PUT UNFORMATTED "^FO1000,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
             END.
         END CASE. 
        


        CASE item-ean.etiq-3-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1730,580^A0N,40,40^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1730,620^A0N,40,40^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE. 




        // Fim QR Code

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel.GRF^FS"
        "^XA^IDSuframa600dpi.GRF^FS^XZ".

END. /* modelo 528 */

IF  p-cod-modelo = 529 THEN DO:                                                                                                                                                       
                                                                                                                                                       
    ASSIGN i-cont = 0.                                                                                                                                                           
                                                                                                                                                                                 
    /* Carrega a imagem para a impressora */                                                                                                                                     
    RUN piCargaImagem("local-logoma2").                                                                                                                                          
                                                                                                                                                                                 
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.                                                                                                                           
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /*
    RUN piCargaImagem("local-suframa").                                                                                                                                          
    */

    /*PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,". */
    PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

    IF NOT AVAIL imagem-etiq THEN DO:                                                                                                                                            
        RUN piGeraErro (INPUT 17006,                                                                                                                                             
                        INPUT "Nío existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").  
        RETURN "NOK".                                                                                                                                                            
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */ 

    PUT "^PW2500"     SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      
                                                                                                                                                                                 
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variòvel c-cgc*/

        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO140,120,1^A0B,56,56^FD" STRING(TODAY, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO390,110^BY9^BEN,230,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO1555,120,1^A0B,80,80^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO90,460^A0N,76,76^FB1460,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO90,550^A0N,76,76^FB1460,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO80,430^GB1460,0,230^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO300,680^BY6^BCN,90,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO110,800^A0N,50,50^FB1470,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        
        PUT UNFORMATTED "^FO10,800^A0N,60,60^FB1470,1,0,R^FD"  num-serie.sigla "^FS" SKIP. /* Sigla */
        
        ASSIGN i-cont = 0.

        FOR EACH it-mod-img-etiq
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
            FIRST imagem-etiq
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:

            IF i-cont = 0 THEN
                ASSIGN i-cont = 120.
            ELSE
                IF i-cont = 120 THEN
                   ASSIGN i-cont = i-cont + 470.
                ELSE
                   ASSIGN i-cont = i-cont + 440.

            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",860^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".
        END.
        
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
            PUT UNFORMATTED "^FO90,1340^A0N,50,50^FD" (IF item-ean.lmarcador[1] THEN "Ó " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
            PUT UNFORMATTED "^FO840,1340^A0N,50,50^FD" (IF item-ean.lmarcador[2] THEN "Ó " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
            PUT UNFORMATTED "^FO90,1430^A0N,50,50^FD" (IF item-ean.lmarcador[3] THEN "Ó " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
            PUT UNFORMATTED "^FO840,1430^A0N,50,50^FD" (IF item-ean.lmarcador[4] THEN "Ó " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FO1615,65^A0N,60,60^FB835,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO1610,45^GB835,0,75^FS^LRN" SKIP.  /* Quadro preto */
        
        PUT UNFORMATTED "^FO1655,160^A0N,38,38^FD" item-ean.char-2 "^FS"                     SKIP.
        PUT UNFORMATTED "^FO1655,200^A0N,38,38^FB565,1,0,L^FDCNPJ: " c-cgc "^FS"                 SKIP.
        PUT UNFORMATTED "^FO1655,240^A0N,38,38^FB565,1,0,L^FD" item-ean.fone "^FS"              SKIP.
        
        PUT UNFORMATTED "^FH^FO1655,280^A0N,38,38^FB565,1,0,L^FD" REPLACE(item-ean.origem,'È','_e9') /* CHR(218) */ "^FS"            SKIP.
        PUT UNFORMATTED "^FO1655,320^A0N,38,38^FB565,1,0,L^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
        
        PUT UNFORMATTED "^FO1655,360^A0N,38,38^FB565,1,0,L^FD" item-ean.info-tec[1] "^FS"       SKIP.
        PUT UNFORMATTED "^FO1655,400^A0N,38,38^FB565,1,0,L^FD" item-ean.info-tec[2] "^FS"       SKIP.
        PUT UNFORMATTED "^FO1655,460^A0N,50,52^FB565,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.
        PUT UNFORMATTED "^FO2095,150^XGselo-suframa.GRF^FS" SKIP.

        
        PUT UNFORMATTED "^FO1610,620^A0N,60,60^FB755,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO1605,595^GB755,0,80^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO1645,690^A0N,35,35^FD" item-ean.char-2 "^FS" SKIP.  /* Imprime Made In Brazil */
        
        PUT UNFORMATTED "^FO1645,725^A0N,35,33^FD" c-cgc "^FS" SKIP.  /* Imprime CGC */
        PUT UNFORMATTED "^FO1645,760^A0N,35,33^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FH^FO1645,795^A0N,35,33^FD" REPLACE(item-ean.origem,'È','_e9') /* CHR(218) */ "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO1645,830^A0N,35,33^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO1645,865^A0N,35,33^FD" item-ean.info-tec[1] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO2000,885^A0N,36,33^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Sigla - Etiqueta SecundŸria*/
        PUT UNFORMATTED "^FO2000,690^XGselo-suframa.GRF^FS" SKIP.


        IF item-ean.etiq-1-tipo = 5 
        THEN DO:
            PUT UNFORMATTED "^FT2290,1150^BY4,2.0,10^BQN,2,5^FH\^FDLA," num-serie.n-serie "^FS" SKIP.
            PUT UNFORMATTED "^FO2340,980^A0B,40,40^FB715,1,0,C^FDNS:" num-serie.n-serie "^FS" skip.
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO2260,940^A0B,52,54^FB715,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO2340,940^A0B,52,54^FB715,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta SecundŸria*/
        END.

        //Etiqueta quadrada
        ASSIGN i-cont = 0.

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = tt-lista-ns.num-serie
                 NO-LOCK.

            ASSIGN i-cont = i-cont + 1.

            IF i-cont = 1 
            THEN DO:
                PUT UNFORMATTED "^FO1725,1030^BY2^BCN,90,N,N,N,N^FD" mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FO1165,1130^A0N,40,40^FB1470,1,0,C^FDMAC:" mac-address.mac "^FS" SKIP.
            END.
            
            IF i-cont = 2
            THEN DO:
                PUT UNFORMATTED "^FO1725,1200^BY2^BCN,90,N,N,N,N^FD" mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FO1165,1300^A0N,40,40^FB1470,1,0,C^FDMAC:" mac-address.mac "^FS" SKIP.
            END.

        END.
        /*
        IF item-ean.homolog <> "" AND 
           item-ean.MODULO  <> ""
        THEN DO:
            PUT UNFORMATTED "^FO1660,1360^A0N,33,33^FDEste produto contem o^FS" SKIP.
            PUT UNFORMATTED "^FO1660,1400^A0N,33,33^FDmodulo " STRING(item-ean.MODULO) "^FS" SKIP.

            PUT UNFORMATTED "^FO1660,1450^A0N,33,33^FDCodigo de homologacao^FS" SKIP.
            PUT UNFORMATTED "^FO1660,1490^A0N,33,33^FDAnatel " STRING(item-ean.homolog) "^FS" SKIP.
        END.*/

        IF item-ean.homolog <> "" 
        THEN DO:
            PUT UNFORMATTED "^FO1660,1360^A0N,33,33^FDIncorpora produto^FS" SKIP.
            PUT UNFORMATTED "^FO1660,1400^A0N,33,33^FDhomologado pela Anatel ^FS" SKIP.
            PUT UNFORMATTED "^FO1660,1450^A0N,33,33^FDsob numero^FS" SKIP.
            PUT UNFORMATTED "^FO1660,1490^A0N,33,33^FD" STRING(item-ean.homolog) "^FS" SKIP.
        END.
        //fim

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.  

    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       

        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
    PUT UNFORMATTED "^XA^IDselo-suframa.GRF^FS^XZ".                                                                                                                             
END. //fim 529

IF  p-cod-modelo = 530 THEN DO:
    ASSIGN i-cont = 0.                                                                                                                                                           
                                                                                                                                                                                 
    /* Carrega a imagem para a impressora */                                                                                                                                     
    RUN piCargaImagem("local-logoma2").                                                                                                                                          
                                                                                                                                                                                 
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.                                                                                                                           
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /*
    RUN piCargaImagem("local-suframa").                                                                                                                                          
    */

    /*PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,". */
    PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

    IF NOT AVAIL imagem-etiq THEN DO:                                                                                                                                            
        RUN piGeraErro (INPUT 17006,                                                                                                                                             
                        INPUT "Nío existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").  
        RETURN "NOK".                                                                                                                                                            
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      
                                                                                                                                                                                 
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variòvel c-cgc*/

        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO140,120,1^A0B,56,56^FD" STRING(TODAY, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO390,110^BY9^BEN,230,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO1555,120,1^A0B,80,80^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO90,460^A0N,76,76^FB1460,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO90,550^A0N,76,76^FB1460,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO80,430^GB1460,0,230^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO300,680^BY6^BCN,90,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO110,800^A0N,50,50^FB1470,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        
        PUT UNFORMATTED "^FO10,800^A0N,60,60^FB1470,1,0,R^FD"  num-serie.sigla "^FS" SKIP. /* Sigla */
        
        ASSIGN i-cont = 0.

        FOR EACH it-mod-img-etiq
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
            FIRST imagem-etiq
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:

            IF i-cont = 0 THEN
                ASSIGN i-cont = 120.
            ELSE
                IF i-cont = 120 THEN
                   ASSIGN i-cont = i-cont + 470.
                ELSE
                   ASSIGN i-cont = i-cont + 440.

            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",860^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".
        END.
    /*    
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
            PUT UNFORMATTED "^FO90,1340^A0N,50,50^FD" (IF item-ean.lmarcador[1] THEN "Ó " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
            PUT UNFORMATTED "^FO840,1340^A0N,50,50^FD" (IF item-ean.lmarcador[2] THEN "Ó " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
            PUT UNFORMATTED "^FO90,1430^A0N,50,50^FD" (IF item-ean.lmarcador[3] THEN "Ó " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
            PUT UNFORMATTED "^FO840,1430^A0N,50,50^FD" (IF item-ean.lmarcador[4] THEN "Ó " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */
      */
        PUT UNFORMATTED "^FO1615,65^A0N,60,60^FB835,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO1610,45^GB835,0,75^FS^LRN" SKIP.  /* Quadro preto */
        
        PUT UNFORMATTED "^FO1655,160^A0N,38,38^FD" item-ean.char-2 "^FS"                     SKIP.
        PUT UNFORMATTED "^FO1655,200^A0N,38,38^FB565,1,0,L^FDCNPJ: " c-cgc "^FS"                 SKIP.
        PUT UNFORMATTED "^FO1655,240^A0N,38,38^FB565,1,0,L^FD" item-ean.fone "^FS"              SKIP.
        
        PUT UNFORMATTED "^FO1655,280^A0N,38,38^FB565,1,0,L^FD" item-ean.origem "^FS"            SKIP.
        PUT UNFORMATTED "^FO1655,320^A0N,38,38^FB565,1,0,L^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
        
        PUT UNFORMATTED "^FO1655,360^A0N,38,38^FB565,1,0,L^FD" item-ean.info-tec[1] "^FS"       SKIP.
        PUT UNFORMATTED "^FO1655,400^A0N,38,38^FB565,1,0,L^FD" item-ean.info-tec[2] "^FS"       SKIP.

        PUT UNFORMATTED "^FO2180,350^A0N,45,45^FB565,1,0,L^FDPRODUTO^FS"        SKIP.
        PUT UNFORMATTED "^FO2000,400^A0N,45,45^FB565,1,0,L^FDREMANUFATURADO^FS" SKIP.

        PUT UNFORMATTED "^FO1655,460^A0N,50,52^FB565,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.
       // PUT UNFORMATTED "^FO2095,150^XGselo-suframa.GRF^FS" SKIP.

        
        PUT UNFORMATTED "^FO1610,620^A0N,60,60^FB755,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO1605,595^GB755,0,80^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO1645,690^A0N,35,35^FD" item-ean.char-2 "^FS" SKIP.  /* Imprime Made In Brazil */
        
        PUT UNFORMATTED "^FO1645,725^A0N,35,33^FD" c-cgc "^FS" SKIP.  /* Imprime CGC */
        PUT UNFORMATTED "^FO1645,760^A0N,35,33^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO1645,795^A0N,35,33^FD" item-ean.origem "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO1645,830^A0N,35,33^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO1645,865^A0N,35,33^FD" item-ean.info-tec[1] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO2000,885^A0N,36,33^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Sigla - Etiqueta SecundŸria*/
       // PUT UNFORMATTED "^FO2000,690^XGselo-suframa.GRF^FS" SKIP.
    
        PUT UNFORMATTED "^FO2180,780^A0N,35,35^FB565,1,0,L^FDPRODUTO^FS"        SKIP.
        PUT UNFORMATTED "^FO2040,830^A0N,35,35^FB565,1,0,L^FDREMANUFATURADO^FS" SKIP.

        PUT UNFORMATTED "^FO2260,940^A0B,52,54^FB715,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO2340,940^A0B,52,54^FB715,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta SecundŸria*/

        /*
        PUT UNFORMATTED "^FO1700,1020^A0N,50,52^FDINTELBRAS CLOUD^FS" SKIP.
        PUT UNFORMATTED "^FO1805,1160^BQN,2,10^FH\^FDLA," num-serie.n-serie "^FS" SKIP.  /* C´digo de Barras do Nﬂmero de S˝rie */
        PUT UNFORMATTED "^FO1700,1480^A0N,50,52^FDNS:" num-serie.n-serie "^FS" SKIP.
          */

        //Etiqueta quadrada
        ASSIGN i-cont = 0.

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = tt-lista-ns.num-serie
                 NO-LOCK.

            ASSIGN i-cont = i-cont + 1.

            IF i-cont = 1 
            THEN DO:
                PUT UNFORMATTED "^FO1725,1030^BY2^BCN,90,N,N,N,N^FD" mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FO1165,1130^A0N,40,40^FB1470,1,0,C^FDMAC:" mac-address.mac "^FS" SKIP.
            END.
            
            IF i-cont = 2
            THEN DO:
                PUT UNFORMATTED "^FO1725,1200^BY2^BCN,90,N,N,N,N^FD" mac-address.mac "^FS" SKIP.
                PUT UNFORMATTED "^FO1165,1300^A0N,40,40^FB1470,1,0,C^FDMAC:" mac-address.mac "^FS" SKIP.
            END.

        END.
        /*
        IF item-ean.homolog <> "" AND 
           item-ean.MODULO  <> ""
        THEN DO:
            PUT UNFORMATTED "^FO1710,1360^A0N,38,38^FDEste produto contem o^FS" SKIP.
            PUT UNFORMATTED "^FO1710,1400^A0N,38,38^FDmodulo " STRING(item-ean.MODULO) "^FS" SKIP.

            PUT UNFORMATTED "^FO1710,1450^A0N,38,38^FDCodigo de homologacao^FS" SKIP.
            PUT UNFORMATTED "^FO1710,1490^A0N,38,38^FDAnatel " STRING(item-ean.homolog) "^FS" SKIP.
        END.*/

        IF item-ean.homolog <> "" 
        THEN DO:
            PUT UNFORMATTED "^FO1710,1360^A0N,38,38^FDIncorpora produto^FS" SKIP.
            PUT UNFORMATTED "^FO1710,1400^A0N,38,38^FDhomologado pela Anatel ^FS" SKIP.
            PUT UNFORMATTED "^FO1710,1450^A0N,38,38^FDsob numero^FS" SKIP.
            PUT UNFORMATTED "^FO1710,1490^A0N,38,38^FD" STRING(item-ean.homolog) "^FS" SKIP.
        END.

        //fim

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.  

    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       

        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
    PUT UNFORMATTED "^XA^IDselo-suframa.GRF^FS^XZ".                                                                                                                             

/*
    ASSIGN i-cont = 0.

    FOR EACH it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.
    END.

    IF NOT AVAIL imagem-etiq THEN DO:
        RUN piGeraErro (INPUT 17006,
                        INPUT "Nío existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").
        RETURN "NOK".
    END.

    {esapi/esapi016inic.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.
    
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variòvel c-cgc*/
            
        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO50,35,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO115,35^BY3^BEN,70,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO520,35,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */
        PUT UNFORMATTED "^FO10,160^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO10,190^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO30,145^GB485,0,80^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO95,230^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO035,270^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO465,265^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        
        ASSIGN i-cont = 0.

        FOR EACH it-mod-img-etiq
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
            FIRST imagem-etiq
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:
        
            IF i-cont = 0 THEN
                ASSIGN i-cont = 40.
            ELSE
                ASSIGN i-cont = i-cont + 160.

            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",290^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".
        END.

        
        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN
            PUT UNFORMATTED "^FO20,460^A0N,18,18^FD" (IF item-ean.lmarcador[1] THEN "Ó " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN
            PUT UNFORMATTED "^FO270,460^A0N,18,18^FD" (IF item-ean.lmarcador[2] THEN "Ó " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN
            PUT UNFORMATTED "^FO20,490^A0N,18,18^FD" (IF item-ean.lmarcador[3] THEN "Ó " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */

        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN
            PUT UNFORMATTED "^FO270,490^A0N,18,18^FD" (IF item-ean.lmarcador[4] THEN "Ó " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */

      /* Modelo */
       PUT UNFORMATTED "^FO555,15^A0N,20,20^FB275,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
       PUT UNFORMATTED "^LRY^FO552,8^GB275,0,25^FS^LRN" SKIP.  /* Quadro preto */
       /*PUT UNFORMATTED "^LRY^FO568,5^GB320,30,30^FS^LRN" SKIP.  /* Quadro preto */*/

       /* InformaªÑes Item */
       PUT UNFORMATTED "^FO565,45^A0N,12,12^FD" item-ean.char-2 "^FS" SKIP.
       PUT UNFORMATTED "^FO616,45^A0N,12,12^FB200,1,0,R^FD" item-ean.origem "^FS" SKIP.
       PUT UNFORMATTED "^FO565,60^A0N,12,12^FB200,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
       PUT UNFORMATTED "^FO616,60^A0N,12,12^FB200,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
       PUT UNFORMATTED "^FO565,75^A0N,12,12^FB200,1,0,L^FD" item-ean.fone "^FS" SKIP.
       PUT UNFORMATTED "^FO565,90^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
       PUT UNFORMATTED "^FO565,105^A0N,12,12^FB200,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.

       /* Número S≤rie */
        PUT UNFORMATTED "^FO565,125^ABN^FB200,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ 
        PUT UNFORMATTED "^FO565,140^BY1^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

       /* PRODUTO REMANUFATURADO */
        PUT UNFORMATTED "^FO616,85^A0N,14,14^FB200,1,0,R^FDPRODUTO" "^FS" SKIP.
        PUT UNFORMATTED "^FO616,100^A0N,14,14^FB200,1,0,R^FDREMANUFATURADO" "^FS" SKIP.

        PUT UNFORMATTED "^FO567,203^A0N,20,20^FB215,1,0,C^FD"  caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO548,198^GB265,0,25^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO562,227^A0N,11,11^FD" item-ean.char-2 "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO562,240^A0N,11,11^FD" c-cgc "^FS" SKIP.  /* Imprime CGC */
        PUT UNFORMATTED "^FO562,253^A0N,11,11^FD" item-ean.fone "^FS" SKIP.

        PUT UNFORMATTED "^FO675,227^A0N,11,11,R^FD" item-ean.origem "^FS" SKIP.  /* Imprime Made In Brazil */
        PUT UNFORMATTED "^FO748,240^A0N,11,11,R^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        
        PUT UNFORMATTED "^FO562,266^A0N,11,11^FD" item-ean.info-tec[1] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO562,279^A0N,11,11^FD" item-ean.info-tec[2] "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO562,292^A0N,11,11^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Sigla - Etiqueta SecundŸria*/
        
        PUT UNFORMATTED "^FO585,270^A0N,13,13^FB200,1,0,R^FDPRODUTO" "^FS" SKIP.
        PUT UNFORMATTED "^FO585,285^A0N,13,13^FB200,1,0,R^FDREMANUFATURADO" "^FS" SKIP.
        
  
        
        /*Etiquetinha vertical*/
        PUT UNFORMATTED "^FO770,330^A0B,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO790,330^A0B,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta SecundŸria*/

        
        PUT UNFORMATTED "^FO585,345^A0N,16,16^FDINTELBRAS CLOUD^FS" SKIP.
        PUT UNFORMATTED "^FO585,360^BQN,2,6^FDQA," num-serie.n-serie "^FS" SKIP.  /* C´digo de Barras do Nﬂmero de S˝rie */
        PUT UNFORMATTED "^FO585,505^A0N,16,16^FDNS:" num-serie.n-serie "^FS" SKIP.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    FOR EACH it-mod-img-etiq
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,
        FIRST imagem-etiq
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:

        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".
    END.
    PUT UNFORMATTED "^XA^IDlocal-suframa.GRF^FS^XZ".
*/
END.  /* IF  p-cod-modelo = 530 THEN DO: */

/* ---[ Modelo 531: Produto homologado Anatel - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 531 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5531.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO735,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO610,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 531 */

/* ---[ Modelo 532: Produto homologado Anatel - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 532 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5531.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
    //    PUT UNFORMATTED "^FO735,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
     //                   "^FO610,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 532 */

/* ---[ Modelo 533: Produto homologado Anatel - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 533 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5531.i}         /* Embalagem */
        {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
/* Comentado so para teste de duplicaá∆o de NS
        ASSIGN i-cont = i-cont  + 1.

        IF i-cont = 2 OR 
           i-cont = 4 OR
           i-cont = 6
        THEN DO:
            CREATE btt-lista-ns.
            ASSIGN btt-lista-ns.num-serie = num-serie.n-serie.
            RETRY.
        END. */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
/*
        IF p-cod-modelo = 132 THEN DO:
            PUT "^XA" SKIP.
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
        END. */

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 533 */

/* ---[ Modelo 534: Produto homologado Anatel - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 534 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5531.i}         /* Embalagem */
        {esapi/esapi016a11.i 1}         /* Etiqueta de Produto (34x21mm) */
        {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF p-cod-modelo = 132 THEN DO:
            PUT "^XA" SKIP.
            {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.
        END.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
   // PUT UNFORMATTED
   //     "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 534 */

IF  p-cod-modelo = 535 THEN DO:

    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".

    ASSIGN i-cont = 0.

    FOR EACH tt-lista-ns:

        ASSIGN i-cont = i-cont + 1.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.

        IF i-cont = 1 
        THEN DO:

            /* Embalagem */
            PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO165,92^BY5^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
            PUT UNFORMATTED "^FO690,100^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime cÆdigo do item */
            
            
            PUT UNFORMATTED "^FO170,270^A0N,70,60^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO110,335^A0N,60,30^FB500,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO50,260^GB680,0,150^FS^LRN" SKIP.  /* Quadro preto */
            
            PUT UNFORMATTED "^FO120,420^BY3^BCN,60,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
            PUT UNFORMATTED "^FO168,490^ADN,50,22^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
            
            PUT UNFORMATTED "^FO120,550^BY3^BCN,60,N,N,N,N^FD" num-serie.char-2 "^FS" SKIP.  /* Codigo de Barras EAN 128 */
            PUT UNFORMATTED "^FO168,620^ADN,50,22^FDNS:" num-serie.char-2 "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
            
            PUT UNFORMATTED "^FO680,620^A0N,50,50^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
            
        /* Fim Embalagem */
        END.

        /* Etiqueta de Produto (34x21mm) */
        /* Número S≤rie */

        PUT UNFORMATTED "^FO980,70^A0N,60,50^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO840,60^GB790,60,40^FS^LRN" SKIP.

        /* Suframa */
        PUT UNFORMATTED "^FO900,250^XGSuframa600dpi.GRF^FS" SKIP.

        /* etiqueta 24x8mm */
        PUT UNFORMATTED "^FO895,140^A0N,25,25^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO895,165^A0N,25,25^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO895,190^A0N,24,24^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO895,215^A0N,25,25^FD" item-ean.origem "^FS" SKIP.

        PUT UNFORMATTED "^FO1270,190^A0R,25,25^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.
        PUT UNFORMATTED "^FO1300,210^A0R,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.

      //  PUT UNFORMATTED "^FO880,395^A0N,25,25^FDEste produto contem o modulo " item-ean.MODULO "^FS" SKIP.
      //  PUT UNFORMATTED "^FO880,420^A0N,25,25^FDcodigo de homologacao Anatel " item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO880,395^A0N,25,25^FDIncorpora produto homologado pela Anatel sob numero^FS" SKIP.
        PUT UNFORMATTED "^FO1050,420^A0N,25,25^FD" item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO880,455^A0N,30,30^FDNS:" num-serie.n-serie  "^FS" SKIP. 
        PUT UNFORMATTED "^FO1150,455^A0N,30,30^FDCHAVE ACESSO: " num-serie.ch-acesso  "^FS" SKIP. 

        //QR CODE
        ASSIGN c-qr-code  = ""
               i-mac-cont = 0
               c-macs     = "".

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = num-serie.n-serie
                 NO-LOCK.

            ASSIGN i-mac-cont = i-mac-cont + 1.

            ASSIGN c-macs = c-macs 
                          + "MAC"
                          + STRING(i-mac-cont)
                          + ":"
                          + mac-address.mac 
                          + IF i-mac-cont = 1 AND
                               item-ean.qtd-mac > 1
                               THEN "," ELSE "".
        END.

        //comentar a linha abaixo ≤ teste
       // ASSIGN c-macs = "MAC1:ABCDEF123456,MAC2:ABCDEF654321,".

        ASSIGN c-qr-code = "~{"
                         + "SN:" 
                         + STRING(num-serie.n-serie) + ","
                         + "DT:"
                         + string(item-ean.nome-abrev) + ","
                         + "SC:"
                         + string(num-serie.ch-acesso) + ","
                         + "NC:"
                         + string(item-ean.nc) + ","
                         + c-macs
                         + "~}".

        PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT1720,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT2200,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FO1950,410^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1850,450^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.

        PUT UNFORMATTED "^FO1150,580^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1050,620^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.

        PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" CAPS(item-ean.linha[1])  "^FS" SKIP.
        PUT UNFORMATTED "^FO1850,620^A0N,50,50^FDNS:" num-serie.n-serie  "^FS" SKIP.
        // Fim QR Code

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDSuframa600dpi.GRF^FS^XZ".

END. /* modelo 535 */

/* ---[ Modelo 536: Positron ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 536 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5532.i}         /* Embalagem */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */                   
        {esapi/esapi016a13.i}           /* Informaá‰es da etiqueta de produto */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
    //    PUT UNFORMATTED "^FO735,92^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
     //                   "^FO610,150^A0N,14,14^FB200,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO455,147^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO455,165^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 536 */

/* ---[ Modelo 537: Etiqueta Controle - Quintupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 537 THEN DO:
    RUN piCargaImagem("local-anatel5").
    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento opera em car†ter secund†rio, isto Ç, n∆o tem direito a proteá∆o contra interferància prejudicial, mesmo de estaá‰es do mesmo tipo, e n∆o pode causar interferància a sistemas operando em car†ter prim†rio.".

        PUT "^XA" SKIP.        
           {esapi/esapi016a5025.i}         /*EAN 13 50x24*/         
           {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 537 */

IF p-cod-modelo = 538 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/
    
        PUT "^XA" SKIP.
        
        /*-----------------*/
        /*E M B A L A G E M*/
        /*-----------------*/
        PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO78,32^BY3^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO373,32^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
        IF item-ean.destaque = "" THEN DO:
            PUT UNFORMATTED "^FO18,132^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,167^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,122^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO18,132^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,167^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,122^GB315,0,80^FS^LRN" SKIP.  /* Quadro preto */
        
            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
            END.
            ELSE
                PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
        
            PUT UNFORMATTED "^LRY^FO345,122^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */
        END.
        
        PUT UNFORMATTED "^FO28,207^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO28,237^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO343,237^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        /*------------------------*/
        /*F I M  E M B A L A G E M*/
        /*------------------------*/
    
        /*-------------*/
        /*P R O D U T O*/
        /*-------------*/
    
        /*{esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */*/
        PUT UNFORMATTED "^FO405,45^A0N,24,24^FB410,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO430,30^GB450,40,40^FS^LRN" SKIP.  /* Quadro preto */
        /*{esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */*/
        PUT UNFORMATTED "^FO445,85^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO660,85^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO445,101^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        
        PUT UNFORMATTED "^FO445,117^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO445,133^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO445,149^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO445,165^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.
        

        /*--------------------*/
        /*F I M  P R O D U T O*/
        /*--------------------*/
      
        PUT UNFORMATTED "^FO590,85^GFA,4264,4264,26,,:::::::::::::::R03FC,R0FFE,R0IF,Q01F0F,Q01FI01C00CM040C048C00E007,Q01F8007F03F79F1E3DC7F87FF07F83FE,R0FF80FF87FF9F1E3FCF3C7FF8FFC7DF,R07FE1E3CF8F9F1E3FCF3C7CF9F3E78F,R01FF1E3CF8F9F1E3E003C7879E1C01F,S03F9FFCF079F1E3C07FC7879E003FF,T0F9FFCF079F1E3C1FFC7879E007FF,Q01E0F9C00F8F9F1E3C1E3C7879E1EF8F,Q01F1F9E3C78F9F1E3C1E3C7879F3EF0F,R0IF1E7C7FF8FFE3C1F7C7878FFCF9F,R07FE0FF83F78FFE3C1FFC78787F87FF,R03F807EI0787DE3C0F9C78783F03CF,Y078F8S018,Y07DFT01E,Y03FEU07,Y01F8T07E,,:::::::::::::::::gV07MFC,K01XF8P03OFC,K01XF8P0EO0F,K01XF8O038O018,K01XF8O06Q0C,K01XF8O0CL0FJ06,K01XF8N018L0FJ03,K01XF8N03M0FJ018,K01XF8N03M0FK0C,K01XF8N06M0FK04,K01XF8N06M0FK06,K01XF8N0CM0FK06,K01XF8N0CM0FK02,Q0NF8S0CM0FK02,Q0NFT08M0FK03,Q0DMFT08M0FK03,Q0CMFT08M0FK03,Q0C3LFT08M0FK03,Q0C1LFT0807K0FK03,Q0C07KFT080FK0FK03,Q0C03KFT080F8J0FK03,Q0C01KFT080F8J0FK03,Q0C007JFT080F8J0FFEI03,Q0C003JFT080FCJ0IF8003,Q0CI0JFT080FCI01IFE003,Q0CI07IFT080FEI03F83F003,Q0CI01IFT080FEI07E007003,Q0CJ0IFT080FEI0FF002003,Q0CJ03FFT080FFI0FFK03,Q0CJ01FFT080F7001FF03F003,Q0CK0FFT080F7801EF0FFC03,Q0CK03FT080F3801EF1FFE03,Q0CK01FT080F3C01CF3E0E03,Q0CL07T080F3C01CF3C0203,Q0CL03T080F1C01CF78I03,Q0CL01T080F1E01CF7J03,Q0CL01T080F0E01CE7J03,Q0CL01T080F0F01CE7J03,:Q0CL01T080F0701CE7J03,Q0EL01T080F0781CE7J03,Q0F8K01T080F0381CE7J03,Q0FCK01T080F03C1CE7J03,Q0FFK01T080F01C1CE7J03,Q0FF8J01T080F01E1CE7J03,Q0FFEJ01T080F01E1CE7J03,Q0IFJ01T080F00E1CF7J03,Q0IFCI01T080F00F1CF7J03,Q0JFI01T080F0071CF7J03,Q0JF8001T080F0079CF38I03,Q0JFE001T080F0079CF3C0603,Q0KF001T080F0039CF1FFE03,Q0KFC01T080F003DEF0FFE03,Q0KFE01T080F001CEF03FC03,Q0LF81T080F001EFFK03,Q0LFC1T080F001EFFK03,Q0MF1T080FI0E7F003003,Q0MF9T080FI0F3F01F003,Q0NFT080FI071JF003,Q0NFT080FI078IFE003,L0XF8N080FI038IF8003,K01XF8N080FI03CE78I03,K01XF8N080FI03CFK03,K01XF8N080FI01CFK03,K01XF8N080FI01EFK03,K01XF8N080FJ0EFK03,K01XF8N080FJ0FFK03,:K01XF8N080FJ07FK03,K01XF8N0C0FJ07FK02,K01XF8N0C0FJ03FK02,K01XF8N040FJ03FK06,gS060FJ01FK04,gS060FJ01FK0C,gS030FJ01FK0C,gS010FK0EJ018,gS0183K0CJ03,gT0CQ06,gT07Q0C,gT018O038,gU0FO0E,gU03OF8,03FE78071E01E7FF3IF9FFC03F8N013CDEE77,03FE7C071F03E7FF3IF9FFE0FFE,03FE7E071F87E7FF3IF9IF1IF,00787F071F87E7J0F01E0F3F0F8,00707F871FCFE7J0F01E0F3C07C,00707FC71IFE7FE00F01E0E7803C,00707FE71IFE7FF00F01E1E7801C,00707BF71DFCE7FF00F01E7C7801C,007079FF1CF9E78I0F01E3C7801CI03F0F8FC07C7CF818,007078FF1C79E7J0F01E3E7803CI07F9FCEE0EKC38,0070787F1C31E7J0F01E1E3C03CI061988C60CECC0C78,0070783F1C01E7J0F01E1F3E078I061980FE0CECE38C8,0078781F1C01E7FF00F01E0F1IF8I061B80FC0CECE1D98,03FE780F1C01E7FF00F01E0F0IFJ06198CC00CECC0DFE,03FE780F1C01E7FF00F01E0F87FCJ07F9FCC00ECECCDFC,03FEgH06K03F0F8C007C7CFC18,,:::::::::::^FS" SKIP.

        PUT UNFORMATTED "^FO445,252^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO445,270^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
        
    END.
END. /* modelo 538 */

IF p-cod-modelo = 539 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/
    
        PUT "^XA" SKIP.
        
        /*-----------------*/
        /*E M B A L A G E M*/
        /*-----------------*/
        PUT UNFORMATTED "^FO23,32^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO78,32^BY3^BEN,50,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO373,32^A0B,22,22^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        
        PUT UNFORMATTED "^FO18,132^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO18,167^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO23,122^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */

      /*  IF item-ean.destaque = "" THEN DO:
            PUT UNFORMATTED "^FO18,132^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,167^A0N,32,24^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,122^GB368,0,80^FS^LRN" SKIP.  /* Quadro preto */
        END.
        ELSE DO:
            PUT UNFORMATTED "^FO18,132^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO18,167^A0N,32,24^FB315,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO23,122^GB315,0,80^FS^LRN" SKIP.  /* Quadro preto */
        
            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO326,117^XGlocal-chave.GRF^FS" SKIP.
            END.
            ELSE
                PUT UNFORMATTED "^FO353,144,^A0B,32,24^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
        
            PUT UNFORMATTED "^LRY^FO345,122^GB40,80,20^FS^LRN" SKIP.  /* Quadro preto destaque */
        END. */
        
        PUT UNFORMATTED "^FO28,207^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO28,237^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO343,237^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        /*------------------------*/
        /*F I M  E M B A L A G E M*/
        /*------------------------*/
    
        /*-------------*/
        /*P R O D U T O*/
        /*-------------*/
    
        /*{esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */*/
        PUT UNFORMATTED "^FO405,45^A0N,24,24^FB410,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO430,30^GB450,40,40^FS^LRN" SKIP.  /* Quadro preto */
        /*{esapi/esapi016a10.i 455 60 16} /* Informaá‰es da etiqueta de produto */*/
        PUT UNFORMATTED "^FO445,85^A0N,14,14^FDDistribuido por: Leucotron Tecnologia da Informaá∆o LTDA ^FS" SKIP.
        //PUT UNFORMATTED "^FO660,85^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO445,101^A0N,14,14^FB365,1,0,L^FDCNPJ: 18.149.211/0001-56 ^FS" SKIP.
        PUT UNFORMATTED "^FO445,117^A0N,14,14^FB365,1,0,L^FDRua Jorge Dionisio Barbosa, ^FS" SKIP.
        PUT UNFORMATTED "^FO445,133^A0N,14,14^FB365,1,0,L^FD312 - Boa Vista ^FS" SKIP.
        PUT UNFORMATTED "^FO445,149^A0N,14,14^FB365,1,0,L^FDSanta Rita do Sapucai / MG ^FS" SKIP.
        PUT UNFORMATTED "^FO445,165^A0N,14,14^FB365,1,0,L^FDTelefone: (35) 3471 - 9500 ^FS" SKIP.
        PUT UNFORMATTED "^FO445,181^A0N,14,14^FB365,1,0,L^FD0800 035 8000 ^FS" SKIP.

        PUT UNFORMATTED "^FO445,197^A0N,14,14^FB365,1,0,L^FDProduzido por: INTELBRAS S/A^FS" SKIP.
        PUT UNFORMATTED "^FO445,213^A0N,14,14^FB365,1,0,L^FDCNPJ:" c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO445,229^A0N,14,14^FB365,1,0,L^FD" CAPS(item-ean.info-tec[1]) "^FS" SKIP.

       /* PUT UNFORMATTED "^FO445,117^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO445,133^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO445,149^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO445,165^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.
         */

        /*--------------------*/
        /*F I M  P R O D U T O*/
        /*--------------------*/
        
        PUT UNFORMATTED "^FO650,120^GFA,1148,1148,14,,::::::::::W03FE,V07IFE,U0LFC,T07MF,S03NFC,S0OFE,R03FC0MF,R078I0LF8,W01KFC,X0KFE,X07KF,X03KF,X01KF8,:Y0KFC,:P0F8M0KFC,O0IF8L0KFE,N03IFEL0KFE,N0KF8K0KFE,M01KFCK0KFE,M03KFEK0LF,M07LFK0LF,M0MF8J0LF,L01MF8I01LF,L01MFCI01LF,L03MFEI01LF,L03MFEI03LF,:L07NFI07KFE,:L07NFI0LFE,:L07NF001LFE,L07NF001LFC,L07NF003LFC,L07NF007LFC,L07MFE007LFC,L03MFE00MF8,L03MFE01MF8,L03MFC01MF8,L01MFC03MF,M0MF807MF,M0MF00NF,M03KFE01MFE,:N0KF803MFC,N07JF007MFC,N01IFC00NFC,O07FEI0NFC,,:::J03C07C1E01F1FFE7FE1E,J07E07C1E01F1FFE7FE1E,J0FE07E1E03F81E07801E,J0FE07E1E07F81E07801E,I01FE0FF3C07F81C07803C,I03CF0FF3C0F783C0F803C,I03CF0F7BC1E783C0F803C,I078F0F7FC1E783C0FFC3C,I0F8F0F3F83C783C0FF83C,I0IF1E1F87FF8381F003C,001IF1E1F87FFC781F007C,003E0F1E0F8F83C781F0078,003C0F1E0F8F03C781E0078,003C0F3C071E03C781FF87FE,007C0F3C071E03C781FF87FE,,:^FS" SKIP.
        PUT UNFORMATTED "^FO650,210^A0N,14,14^FB365,1,0,L^FD" item-ean.homolog "^FS" SKIP.
        PUT UNFORMATTED "^FO650,230^A0N,14,14^FB365,1,0,L^FDInd£stria Brasileira^FS" SKIP.

        PUT UNFORMATTED "^FO445,252^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO445,270^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
        
    END.
END. /* modelo 539 */

IF p-cod-modelo = 540 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    DO i-cont = 1 TO p-qtd-etiquetas:
                 
        FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-LOCK NO-ERROR.


        ASSIGN c-cgc  = IF AVAIL estabelec THEN STRING(estabelec.cgc,"99.999.999/9999-99") ELSE "".

        /*Etiqueta exportaá∆o */
        PUT UNFORMATTED "^XA" SKIP.
        PUT UNFORMATTED "^FO50,30^A0N,25,25^FDConte£do:^FS" SKIP.  
        PUT UNFORMATTED "^FO50,60^A0N,25,25^FD" ENTRY(1,item-ean.desc-kit,";") "^FS" SKIP.  
        PUT UNFORMATTED "^FO50,90^A0N,25,25^FD" ENTRY(2,item-ean.desc-kit,";") "^FS" SKIP.  
        PUT UNFORMATTED "^FO50,120^A0N,25,25^FD" ENTRY(3,item-ean.desc-kit,";") "^FS" SKIP.  
        PUT UNFORMATTED "^FO50,150^A0N,25,25^FD" ENTRY(4,item-ean.desc-kit,";") "^FS" SKIP.  
        PUT UNFORMATTED "^FO50,180^A0N,25,25^FD" ENTRY(5,item-ean.desc-kit,";") "^FS" SKIP.  
        PUT UNFORMATTED "^FO50,210^A0N,25,25^FD" ENTRY(6,item-ean.desc-kit,";") "^FS" SKIP.  

        
        PUT UNFORMATTED "^FO470,30^A0N,20,20^FDDistribu°do por: Leucotron^FS" SKIP.  
        PUT UNFORMATTED "^FO470,55^A0N,20,20^FDTecnologia da Informaá∆o LTDA.^FS" SKIP.  
        PUT UNFORMATTED "^FO470,80^A0N,20,20^FDCNPJ: 18.149.211/0001-56^FS" SKIP.  
        PUT UNFORMATTED "^FO470,105^A0N,20,20^FDRua Jorge Dionisio Barbosa, 312^FS" SKIP.  
        PUT UNFORMATTED "^FO470,130^A0N,20,20^FDBoa Vista Santa Rita do Sapuca° / MG^FS" SKIP.  
        PUT UNFORMATTED "^FO470,155^A0N,20,20^FDTelefone: (35) 3471-9500 ^FS" SKIP. 
        PUT UNFORMATTED "^FO470,180^A0N,20,20^FD0800 035 8000 ^FS" SKIP. 
        PUT UNFORMATTED "^FO470,205^A0N,20,20^FDProduzido por: Intelbras S/A ^FS" SKIP.
        PUT UNFORMATTED "^FO470,230^A0N,20,20^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO470,255^A0N,20,20^FDInd£stria Brasileira ^FS" SKIP.

        PUT UNFORMATTED "^FO50,300^A0N,20,20^FDPRAZO DE VALIDADE:" caps(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO50,325^A0N,20,20^FDCOMPOSIÄ«O:" caps(item-ean.texto[14]) " " caps(item-ean.texto[15]) "^FS" SKIP.

        //PUT UNFORMATTED "^FO100,350^A0N,20,20^FDEste produto Ç beneficiado pela Legislaá∆o de Infor†mtica^FS" SKIP.
        
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO100,350^A0N,20,20^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.               
            END.
        END. 

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.
END. /* modelo 540 */

/* ---[ Modelo 532: Produto homologado Anatel - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 541 THEN DO:
    //RUN piCargaImagem("local-GTM").

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5531.i}         /* Embalagem */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */

        PUT "^XZ" SKIP.

        PUT "^XA" SKIP.

        {esapi/esapi016a2.i 23 20 5}   /* Cabeáalho modelo */
        /*{esapi/esapi016a2.i 425 20 5}*/   /* Cabeáalho modelo */
        
        ASSIGN i-lin = 0.
        
        PUT UNFORMATTED "^FO23,60^A0N,14,14^FD" item-ean.char-2 "^FS" SKIP.       
        PUT UNFORMATTED "^FO23,76^^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO23,92^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO23,110^A0N,14,14^FB365,1,0,L^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO23,128^A0N,14,14^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
       
        PUT UNFORMATTED "^FO23,146^A0N,14,14^FB365,1,0,L^FD" item-ean.texto[5] "^FS" SKIP.
        PUT UNFORMATTED "^FO23,164^A0N,14,14^FB365,1,0,L^FD" item-ean.texto[6] "^FS" SKIP.
        PUT UNFORMATTED "^FO23,182^A0N,14,14^FB365,1,0,L^FD" item-ean.texto[7] "^FS" SKIP.
       
        PUT UNFORMATTED "^FO280,60^A0N,14,14^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO280,76^A0N,14,14^FB365,1,0,L^FD" item-ean.texto[8]   "^FS" SKIP.
        PUT UNFORMATTED "^FO280,92^A0N,14,14^FB365,1,0,L^FD" item-ean.texto[9]   "^FS" SKIP.
        PUT UNFORMATTED "^FO280,110^A0N,14,14^FB365,1,0,L^FD" item-ean.texto[10] "^FS" SKIP.
       
        //LOGO GTM
        PUT UNFORMATTED "^FO290,150^GFA,1456,1456,14,O01CJ07038,O0FF1FFEF87C,N01FF9FFEF87C,N01FF9FFEFCFC,N03C7C1E0IFC,N03C3C1E0IFC,N03C001E0IFC,N03CFC1E0IFC,N03CFC1E0F7BC,N03CFC1E0F33D,N0BC3C1E0F03D8,M01BC3C1E0F03DE,M07BEFC1E0F03DF,M0F9FF81E0F03CFC,L01F0FF01E0F03C7E,L03E07E01L01F,L07CR0F8,L0FS07C,K01ES03E,K03CS01F,K078T0F,K0F8T078,K0FQ03I03C,J01EQ078001E,J03CQ0FC001E,J03CP01FEI0F,J078P03FF8007,J07Q07FFC0078,J0FQ0IFE003C,J0EP01JF003C,I01EP03JFC01C,I01CP07JFE01E,I03CP0LF00E,I038O01LF80F,I038O03LF00F,I078O07KFC007,I07P07KFI07,I07P0KFEI078,I07O01KF8I038,I0FO03KFJ038,I0FO03JFCJ038,I0EO07JF8J038,I0EO0JFEK03C,I0EN01JFCK03C,I0EN01JF8K01C,I0EN03IFEL01C,I0EN07IFCL01C,I0EN07IF8L01C,I0EJ04I0JFM01C,I0EJ06001IFEM01C1C,7F0EJ0E001IFCM01C7F,7F0EJ0F003IFN03C7F,790EI01F803FFEN03CC3,098EI01FC07FFCN03CC1,0F8EI03FE0IF8N038E3,0F0FI03FF0IFO0387F,0607I07FF9FFEO0383E,I07I0IF9FFCO078,0187I0LFCO078,1FC7800LF8O070F8,3FC38007KFP071FC,36438001JFEP0F18E,0643CI0JFCP0E106,0FC1CI07IF8O01E386,1DC1EI01IFP01E3FC,1801EJ0IFP03C0FC,1I0FJ07FEP03C01C,01F0FJ01FCP078,03F878J0F8P078F,071878J07Q0F0FF8,060C3CJ03Q0E0CF,061C1EU01E0E4,03381EU03C07C,03F80FU078038,01E3078T0F801C,I0783CS01F060C,001F83ES01E0E,003CC1FS07C184,0078C0F8R0F818E,0031C07CQ01F0186,003BC03FQ03E01CE,001F9C0F8P0FC18FC,I0E1C07EO01F81C78,J03803F8N07E01E,J07080FEM01FC0CF,J0E1C03F8L0FF01C78,J0C3801FF8J07FC0303C,J0673807FFC00IF007218,J07E1C00MFC007E,J03C0F001KFE0063C,L01F8001IFCI071C,L0393O0730E,L0307CM01F38E,L070EEM07C1C4,L061C6L0F6C1C,M01C703C1F7F0E0C,M018607E7F7386,N0CE0E7703707,N0FC0C07E3F07,N0380C07F3382,Q0E67039C,Q07E71198,Q03C3F1,,^FS" SKIP.
       
        PUT UNFORMATTED "^FO23,198^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO23,220^BY1^BCN,30,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
       
        PUT UNFORMATTED "^FO420,230^A0N,13,13^FB200,1,0,C^FD" CAPS(item-ean.etiq-1-info[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO630,230^A0N,13,13^FB200,1,0,C^FD" CAPS(item-ean.etiq-1-info[2]) "^FS" SKIP. 
        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.    

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".

END. /* modelo 541 */


/* ---[ Modelo 612: Produto homologado Anatel - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 612 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    DO i-cont = 1 TO p-qtd-etiquetas:
        
        FIND FIRST estabelec 
            WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-LOCK NO-ERROR.
        
        PUT "^XA" SKIP.
        
        //LOGO iNTELBRAS
        PUT UNFORMATTED "^FO20,50^GFA,3450,3450,46,,::::::::::::I01F8,I07FET01FFX03FE00FF8,I0IFT0IFW01FFE07FF8,I0IFS01IFW01FFE07FF8,001IF8R01IFW01FFE07FF8,::I0IFS01IFW01FFE07FF8,:I07FES01IFW01FFE07FF8,I01F8S01IFW01FFE07FF8,Y01IFW01FFE07FF8,:K0FL07EK01KFEL01F8K01FFE07FF801FCQ0FCK01FCO07KF,I03FFK0JFJ01KFEK03IFCJ01FFE07FF83IFCN01IFCI03IFEM07LF8,I0IFJ03JFCI01KFEJ01KF8I01FFE07FF9KF8M0KF801KFCK01MF,I0IFJ0LF8001KFEJ07KFEI01FFE07NFEL03KF807LFK03MF,I0IFI03LFC001KFEI01MF8001FFE07OF8K07KF01MFCJ0NF,I0IFI07MF001KFEI07MFC001FFE07OFEJ01KFE03MFEI01NF,I0IF001NF801KFCI0OF001FFE07PFJ03KFC07NFI01NF,I0IF003NFC01KFC001OF801FFE07PF8I07KF80OF8003NF,I0IF003NFE01KFC003OFC01FFE07PFCI0LF81OFC007MFE,I0IF007NFE01KFC007OFE01FFE07PFE001LF03OFE007MFE,I0IF00PF01KF800PFE01FFE07QF001KFE07PF007MFE,I0IF01JF00JF81IFK0JF801JF01FFE07JF801JF003IFCI0JFC01JF80IFC,I0IF01IFC003IF81IFJ01IFE001JF81FFE07IFEI07IF803IFJ0IFEI03IF80IF8,I0IF01IF8I0IF81IFJ03IF8003IFE01FFE07IF8I01IFC07FFEI01IFCI01IFC0IF8,I0IF03IFJ0IFC1IFJ03IFI0JFC01FFE07IFK0IFC07FFCI01IF8J0IFC0IF8,I0IF03FFEJ07FFC1IFJ03FFE001JF001FFE07FFEK07FFC07FFCI03IFK07FFE0IF8,I0IF03FFCJ03FFC1IFJ07FFC007IFE001FFE07FFEK03FFE0IF8I03FFEK03FFE07FFC,I0IF03FFCJ03FFC1IFJ07FFC00JF8001FFE07FFCK03FFE0IF8I03FFCK03FFE07KFE,I0IF03FFCJ03FFC1IFJ07FF803JFI01FFE07FFCK01FFE0IFJ07FFCK01IF03LFE,I0IF03FFCJ03FFC1IFJ07FF807IFCI01FFE07FF8K01FFE0IFJ07FFCK01IF03MFC,I0IF03FFCJ03FFC1IFJ07FF81JF8I01FFE07FF8K01FFE0IFJ07FFCK01IF01MFE,I0IF03FFCJ03FFC1IFJ07FF83IFEJ01FFE07FF8K01FFE0IFJ07FF8K01IF00NF,I0IF03FFCJ03FFC1IFJ07FF8JFCJ01FFE07FF8K01FFE0IFJ07FF8K01IF007MF8,I0IF03FFCJ03FFC1IFJ07FFBJFK01FFE07FF8K01FFE0IFJ07FFCK01IF003MFC,I0IF03FFCJ03FFC1IFJ07LFCK01FFE07FF8K01FFE0IFJ07FFCK01IFI0MFE,I0IF03FFCJ03FFC1IFJ07LF803F801FFE07FFCK03FFE0IFJ03FFCK01IFI03LFE,I0IF03FFCJ03FFC0IFJ07KFE003FF01FFE07FFCK03FFE0IFJ03FFEK03IFM07IF,I0IF03FFCJ03FFC0IFJ07KFC007FFC1FFE03FFEK07FFE0IFJ03FFEK03IFM01IF,I0IF03FFCJ03FFC0IF8I03KFI0IFC1FFE03IFK0IFC0IFJ03IFK07IFN0IF,I0IF03FFCJ03FFC0IFCI03JFE001IF81FFE03IF8I01IFC0IFJ01IF8J0JFN0IF,I0IF03FFCJ03FFC07FFEI01JF8003IF81FFE01IFCI03IF80IFJ01IFEI03JFN0IF,I0IF03FFCJ03FFC07IFI01JF800JF01FFE01JFI0JF80IFK0JFI07JFM01IF,I0IF03FFCJ03FFC03IFE040JFE07JF01FFE00JFE07JF00IFK0JFE03KFM03IF,I0IF03FFCJ03FFC03KFE07OFE01FFE007OFE00IFK07QF01OF,I0IF03FFCJ03FFC01LF07OFC01FFE003OFE00IFK03QF01NFE,I0IF03FFCJ03FFC00LF03OF801FFE001OFC00IFK01QF01NFE,I0IF03FFCJ03FFC007KF81OF001FFEI0OF800IFL0QF03NFC,I0IF03FFCJ03FFC003KFC07MFE001FFEI07MFEI0IFL07PF03NFC,I0IF03FFCJ03FFC001KFE03MF8001FFEI03MFCI0IFL01PF03NF8,I0IF03FFCJ03FFCI0LF00MFI01FFEJ0MFJ0IFM0PF03NF,I0IF03FFCJ03FFCI03KF803KFCI01FFEJ03KFEJ0IFM03OF03MFC,I0IF03FFCJ03FFCJ0JFEI0KFJ01FFEK0KFK0IFN0KF1IF03MF8,I0IF03FFCJ03FFCK0IFK0IFK01FFEL0IFL0IFO0IF81IF03LFC,,:::::^FS" SKIP.
        
        PUT UNFORMATTED "^FO400,20^A0N,26,20^FDSuporte a cliente: (48) 2106 0006^FS"                  SKIP.
        PUT UNFORMATTED "^FO400,45^A0N,22,20^FDSuporte via chat: chat.apps.intelbras.com.br^FS"       SKIP.
        PUT UNFORMATTED "^FO400,70^A0N,22,20^FDSuporte via e-mail: suporte@intelbras.com.br^FS"       SKIP.
        PUT UNFORMATTED "^FO400,95^A0N,22,20^FDF¢rum:forum.intelbras.com.br^FS"                       SKIP.
        PUT UNFORMATTED "^FO400,120^A0N,22,20^FDOnde comprar? Quem instala?^FS"                       SKIP.
        PUT UNFORMATTED "^FO400,145^A0N,22,20^FDSAC:0800 7042767^FS"                                  SKIP.
        
        PUT UNFORMATTED "^FO30,168^A0N,26,22^FD" item-ean.char-2 "^FS"                                SKIP.
        
        PUT UNFORMATTED "^FO30,194^A0N,26,22^FDIntelbras S/A - Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira^FS"           SKIP. 
        PUT UNFORMATTED "^FO30,218^A0N,20,20^FD" + estabelec.endereco + " - " + estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.
        PUT UNFORMATTED "^FO30,242^A0N,26,22^FDCNPJ:" string(estabelec.cgc,"99.999.999/9999-99") "^FS"     SKIP.
                                                                                                      
        PUT UNFORMATTED "^FO520,250^A0N,26,22^FD" item-ean.origem "^FS"                               SKIP.
        PUT UNFORMATTED "^FO525,274^A0N,26,22^FDwww.intelbras.com.br^FS"                              SKIP.
                                                                                                      
        PUT UNFORMATTED "^FO30,290^A0N,26,22^FDPRAZO DE VALIDADE: " string(CAPS(item-ean.texto[12])) "^FS"  SKIP.
        PUT UNFORMATTED "^FO30,314^A0N,26,22^FDCOMPOSIÄ«O:" string(CAPS(item-ean.texto[14])) "^FS"          SKIP.
        PUT UNFORMATTED "^FO30,340^A0N,26,22^FD" string(CAPS(item-ean.texto[15])) "^FS"                     SKIP.

        /*
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-familia
                 WHERE int-familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE int-familia 
            AND int-familia.ind-lei-informatica THEN DO: 
                PUT UNFORMATTED "^FO100,364^A0N,26,22^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.*/
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO100,364^A0N,26,22^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END.  
        
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.
END. /* modelo 612 */

/* ---[ Modelo 613: Produto homologado Anatel - 7NS ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 613 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    DO i-cont = 1 TO p-qtd-etiquetas:
            
        FIND FIRST estabelec 
            WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-LOCK NO-ERROR.
        
        PUT "^XA" SKIP.
        
        //LOGO Automatiza
        PUT UNFORMATTED
            "^FO20,10^GFA,7990,7990,47,,::::::::::::::::::::M01IF,M01IF8,::M01IFC,N0IFC,:N07FFE,::N03IF,::N01IF8,::O0IFC,::O07FFE,::O03IF,::O01IF8,:P0IF8h07F8gL03FC,P0IFCh07F8R07ER03FE,P0IFCI03FEgT03FCR07ER03FE,P07FFCI03FEgT03FCR07ER01FE,P07FFEI03FEgT03FER07ER01FF,P07FFEI03FEgT01FER07ER01FF,P07FFEI03FEgT01FER07ES0FF,P03IFI03FEgT01FER07ES0FF,P03IFI03FEgT01FFR07ES0FF8,M07LFI03FEgT01FFR07ES07F8,M0IFDIF8003FEV07CK01JFEL0FF8gL07F8,M0IFDIF8003FE03FC3MF8001FFK03KF8K0FF8007MF8001NFJ07F8,M0IF8IF8003FE03FC3MF800IFCI01MFK0FF8007MF8003NFJ03FC,L01IF8IFC003FE03FC3MF801JFI03MF8J07FC007MF8003MFEJ03FC,L01IF0IFC003FE03FC3MF807JF8007MFEJ07FC007MF87F3MFCJ03FE,L01IF07FFC003FE03FC3MF80KFC00NFEJ03FC007MF87F3MFCJ01FE,L01IF07FFE003FE03FC3MF80KFC00OFJ03FC007MF87F3MF8J01FE,L03IF07FFE003FE03FC3MF81KFE01OFJ03FE007MF87F3MF8J01FF,L03FFE03FFE003FE03FC3MF83LF01OF8I01FE007MF87F3MFL0FF,L07FFE03IF003FE03FC3MF83LF03FF8I03FF8I01FF007MF87FT0FF,L07FFC01IF003FE03FCO07FF03FF83FEK0FF8I01FFQ07FT07F8,L07FFC01IF003FE03FCO07FF01FF83FEK0FF8J0FFQ07FT07F8,L0IFC01IF803FE03FCO07FC00FF83FEK07F8J0FF8P07FT07F8,L0IF800IF803FE03FC00FFK0FF8007FC3FC07F807F800FEFF8001FCK07FK07FCJ07FBFC,L0IF800IF803FE03FC00FFK0FF8003FC3FC07F807F800FE7F8001FCK07FK0FF8J0FF3FC,K01IF800IFC03FE03FC00FFK0FF8003FC3FC07F807F801FE7FC001FCK07FJ01FFK0FF3FC,K01IFI0IFC03FE03FC00FFK0FFI03FC3FC07F807F801FC7FC001FCK07FJ01FFK0FF1FE,K01IFI07FFC03FE03FC00FFK0FFI03FC3FC07F807F801FC3FC001FCK07FJ03FFJ01FE1FE,K03IFI07FFE03FE03FC00FFK0FFI03FC3FC07F807F803FC3FE001FCK07FJ07FEJ01FE1FE,K03FFEI03FFE03FE03FC00FFK0FFI03FC3FC07F807F803F81FE001FCK07FJ0FFCJ01FE0FF,K03OFE03FE03FC00FFK0FF8003FC3FC07F807F803F81FE001FCK07FJ0FFCJ03FC0FF,K07OFE03FE03FC00FFK0FF8003FC3FC07F807F807F81FF001FCK07FI01FF8J03FC0FF,K07PF03FE03FC00FFK0FF8007FC3FC07F807F807F01FF001FCK07FI03FFK03FC0FF8,K07PF03FE03FC00FFK07FC007F83FC07F807F807F00FF001FCK07FI03FFK07F80FF8,K0QF03FE03FC00FFK07FE01FF83FC07F807F80FF00FF801FCK07FI07FEK07F807F8,K0QF83FF07FC00FFK07FF87FF83FC07F807F80FE007F801FCK07FI0FFCK0FF807FC,K0QF83FF8FFC00FFK03LF03FC07F807F80LF801FCK07FI0LF80LFC,J01QF83KFC00FFK03LF03FC07F807F81LFC01FCK07F001LFC0LFC,J01QFC1KFC00FFK01KFE03FC07F807F81LFC01FCK07F003LFC1LFE,J03QFC1KF800FFL0KFC03FC07F807F83LFC01FCK07F007LFC1LFE,J03QFC0KF800FFL07JF803FC07F807F83LFE01FCK07F007LFC1LFE,J03QFE0KFI0FFL07JF803FC07F807F83LFE01FCK07F00MFC3MF,J07QFE07IFEI0FFL01JF003FC07F807F87LFE01FCK07F01MFC3MF,J07QFE01IFCI0FFM0IFC003FC07F807F87MF01FCK07F01MFC3MF,J07RF007FEJ0FFM01FFI03FC07F807F8NF01FCK07F03MFC7MF8,hG03FC,:::::::,:::::::::::::::J07jJF8,,::::::::Y081gG08J0F8P0CL0E6,Y081gG08I01FCP0C003I0E6,Y081gG08I038CP0C003I0E6,Y081gG08I03O0400C043010E64001,Y08117BC7C02F78F8B3F3E01F87C07007D867E1F80C7F3C7CE7F1E7C7C,Y08118C6060318808C210303198606007D867739C0C7F3CCEE7B9E4E64,Y081184602021880CC6001021982060E71867331C0C7330C6E739C066,Y08118460E021803C84007020902061E61866170C0C6331FEE61983E7,Y08110467602100EC8403B020903070661866170C0C6331FEE6198FE3C,Y081104642021010C840210209020706618E6130C0C6331C0E6198C60E,Y0C11046C6021010C86063021986039E61DE7339C0C6338E667398CE4E,Y043104646021019C8212303188603FE61FE7F3FC0C633CFE77F98FEFE,Y07E10427A02100FC81F3D01E87C00FE60F67E1F80C631C7C77F187E7C,hS06,:::,:::::::::::::::::::::::::^FS" SKIP.
        
        PUT UNFORMATTED "^FO400,20^A0N,26,23^FDSuporte a cliente: (48) 2106 0006^FS"                  SKIP.
        PUT UNFORMATTED "^FO400,43^A0N,22,19^FDSuporte via chat: intelbras.com.br/suporte-tecnico^FS" SKIP.
        PUT UNFORMATTED "^FO400,62^A0N,22,19^FDSuporte via e-mail: suporte@intelbras.com.br^FS"       SKIP.
        PUT UNFORMATTED "^FO400,82^A0N,22,20^FDF¢rum:forum.intelbras.com.br^FS"                       SKIP.
        PUT UNFORMATTED "^FO400,105^A0N,22,20^FDSAC:0800 7042767^FS"                                  SKIP.
        PUT UNFORMATTED "^FO400,125^A0N,22,20^FDOnde comprar? Quem instala? 0800 7245115^FS"          SKIP.
        
        PUT UNFORMATTED "^FO30,168^A0N,26,22^FD" item-ean.char-2 "^FS"                                SKIP.
        
        PUT UNFORMATTED "^FO30,194^A0N,26,22^FDIntelbras S/A - Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira^FS"           SKIP. 
        PUT UNFORMATTED "^FO30,218^A0N,26,22^FD" + estabelec.endereco + " - " + estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.
        PUT UNFORMATTED "^FO30,242^A0N,26,22^FD" string(estabelec.cgc,"99.999.999/9999-99") "^FS"     SKIP.
                                                                                                      
        PUT UNFORMATTED "^FO520,250^A0N,26,22^FD" item-ean.origem "^FS"                               SKIP.
        PUT UNFORMATTED "^FO525,274^A0N,26,22^FDwww.intelbras.com.br^FS"                              SKIP.
                                                                                                      
        PUT UNFORMATTED "^FO30,290^A0N,26,22^FDPRAZO DE VALIDADE: " string(CAPS(item-ean.texto[12])) "^FS"   SKIP.
        PUT UNFORMATTED "^FO30,314^A0N,26,22^FDCOMPOSIÄ«O:" string(CAPS(item-ean.texto[14])) "^FS"          SKIP.
        PUT UNFORMATTED "^FO30,340^A0N,26,22^FD" string(CAPS(item-ean.texto[15])) "^FS"                     SKIP.
        
        /*
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-familia
                 WHERE int-familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE int-familia 
            AND int-familia.ind-lei-informatica THEN DO: 
                PUT UNFORMATTED "^FO100,364^A0N,26,22^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
            END.
        END. */
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO100,364^A0N,26,22^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END. 
        
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.
END. /* modelo 613 */

/* ---[ Modelo 614 (modelo base 150): Produto homologado Anatel Resoluá∆o 506 - Dupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 614 THEN DO:
    RUN piCargaImagem("local-anatel5").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento opera em car†ter secund†rio, isto Ç, n∆o tem direito a proteá∆o contra interferància prejudicial, mesmo de estaá‰es do mesmo tipo, e n∆o pode causar interferància a sistemas operando em car†ter prim†rio.".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 418 36 20}     /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 80 16}  /* Informaá‰es da etiqueta de produto */

        //trocando o {esapi/esapi016a5024.i}         /*EAN 13 50x24*/
        PUT UNFORMATTED "^FO20,30^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO70,30^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO375,30^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO20,125^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO20,165^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO20,110^GB370,0,90^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO24,220^BY2^BCN,35,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO30,267^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        /* PUT UNFORMATTED "^FO454,180^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ */
        PUT UNFORMATTED "^FO330,267^A0N,20,20^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        

        //{esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO725,119^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO425,180^A0N,14,14^FB365,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO445,178^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO445,198^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO443,232^A0N,15,15^FB365,4,0,J^FD" c-texto "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^LRY^FO440,230^GB373,0,63^FS^LRN"                   SKIP.  /* Quadro preto */

        /*
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-familia
                 WHERE int-familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE int-familia 
            AND int-familia.ind-lei-informatica THEN DO: 
                PUT UNFORMATTED "^FO28,290^A0N,17,15^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.*/
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO28,290^A0N,17,15^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END. 

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 614 */

/* ---[ Modelo 615 (modelo base 140): Produto homologado Anatel Resoluá∆o 529 - Dupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 615 THEN DO:
    RUN piCargaImagem("local-anatel5").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento deve ser conectado obrigatoriamente em tomada de rede de energia elÇtrica que possua aterramento (tràs pinos), conforme a Norma NBR ABNT 5410, visando a seguranáa  dos usu†rios contra choques elÇtricos".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 418 36 20}     /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 80 16}  /* Informaá‰es da etiqueta de produto */

        //trocando o {esapi/esapi016a5024.i}         /*EAN 13 50x24*/
        PUT UNFORMATTED "^FO20,30^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO70,30^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO375,30^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO20,125^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO20,165^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO20,110^GB370,0,90^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO24,220^BY2^BCN,35,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO30,267^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        /* PUT UNFORMATTED "^FO454,180^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ */
        PUT UNFORMATTED "^FO330,267^A0N,20,20^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        

        //{esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO725,119^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO425,180^A0N,14,14^FB365,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO445,178^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO445,198^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO443,232^A0N,15,15^FB365,4,0,J^FD" c-texto "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^LRY^FO440,230^GB373,0,63^FS^LRN"                   SKIP.  /* Quadro preto */

        /*
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-familia
                 WHERE int-familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE int-familia 
            AND int-familia.ind-lei-informatica THEN DO: 
                PUT UNFORMATTED "^FO28,290^A0N,17,15^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.*/
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO28,290^A0N,17,15^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END. 

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 615 */


/* ---[ Modelo 616 (modelo base 145): Produto homologado Anatel Resoluá∆o 680 - Dupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 616 THEN DO:
    RUN piCargaImagem("local-anatel5").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        ASSIGN c-texto = "Este equipamento n∆o tem direito Ö proteá∆o contra interferància prejudicial e n∆o pode causar interferància em sistemas devidamente autorizados.".

        PUT "^XA" SKIP.        
        {esapi/esapi016a2.i 418 36 20}     /* Cabeáalho modelo */
        {esapi/esapi016a10.i 455 80 16}  /* Informaá‰es da etiqueta de produto */

        //trocando o {esapi/esapi016a5024.i}         /*EAN 13 50x24*/
        PUT UNFORMATTED "^FO20,30^A0B,16,16^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO70,30^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO375,30^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO20,125^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO20,165^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO20,110^GB370,0,90^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO24,220^BY2^BCN,35,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO30,267^ADN,18,10^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        /* PUT UNFORMATTED "^FO454,180^A0N,14,14^FB368,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */ */
        PUT UNFORMATTED "^FO330,267^A0N,20,20^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        

        //{esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */
        
        PUT UNFORMATTED "^FO725,119^XGlocal-anatel5.GRF^FS" /* Impressao da Imagem ANATEL */ 
                        "^FO425,180^A0N,14,14^FB365,1,0,R^FD" item-ean.homolog "^FS"   SKIP.

        PUT UNFORMATTED "^FO445,178^ADN,18,10^FB368,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO445,198^BY2^BCN,24,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO443,232^A0N,15,15^FB365,4,0,J^FD" c-texto "^FS"  SKIP. /* Valor do Codigo de Barras EAN 128 - Etiqueta Secundaria */
        PUT UNFORMATTED "^LRY^FO440,230^GB373,0,63^FS^LRN"                   SKIP.  /* Quadro preto */

        /*
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-familia
                 WHERE int-familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.
            IF  AVAILABLE int-familia 
            AND int-familia.ind-lei-informatica THEN DO: 
                PUT UNFORMATTED "^FO28,290^A0N,17,15^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.*/
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO28,290^A0N,17,15^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END. 

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.    /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 616 */

IF  p-cod-modelo = 617 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    DO i-cont = 1 TO p-qtd-etiquetas:
        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.

        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").

        /* Impressao da Imagem IntelBras */
        PUT UNFORMATTED "^XA" SKIP .

       //LOGO iNTELBRAS
        PUT UNFORMATTED
            "^FO700,50^GFA,5352,5352,12,,:::::Y03E,07TFE00FF8,07TFE01FFE,07UF03IF,07UF07IF,07UF0JF8,:07UF8JF8,:::::07UF87IF,07UF83IF,07UF81FFE,07UF80FF8,Y03E,,::::07OFE,07PFC,07QF8,07QFE,07RF,07RFC,07RFE,07SF,07SF8,07SFC,07SFE,07TF,07TF8,:07TFC,:Q0KFE,Q01JFE,R0KF,R07JF,R03JF,R01JF8,S0JF8,:S07IF8,:::::::S0JF8,::R01JF8,R03JF,R07JF,R0KF,Q03JFE,P03KFE,07TFC,:07TF8,07TF,:07SFE,07SFC,07SF8,07SF,07RFE,07RF8,07RF,07QFC,07QF,07PF8,07OF8,,::::M0TFC,L07TFC,K03UFC,K0VFE,J03VFE,J07VFE,J0WFE,I03WFE,I07XF,I0YF,:001YF,003YF,007YF,:00gF,00KFEK07IF8,01KFL07IF8,01JFCL07IF8,01JF8L07IF8,03JFM07IF8,:03IFEM07IF8,03IFCM07IF8,07IFCM07IF8,::07IF8M07IF8,07IF8M03IF8,07IF8O0FF8,07IFC,::03IFC,03IF8,03FFE,03FF8I07F8,01FFI07IFC,01FE003KF8,01F801LFE,00F007MF8,00E00NFE,00403OF,J07OFC,J0PFE,I01QF,I03QF8,I07QFC,I0RFC,001RFE,001SF,003SF8,007LF3LF8,007KFE01KFC,00MF007JFC,00MF001JFE,01MF800JFE,01MFC007IFE,01MFE003JF,03MFE003JF,03NF001JF,03NF800JF8,03IFCJFC00JF8,03IFC7IFE00JF8,07IFC7IFE007IF8,07IFC3JF007IF8,07IF81JF807IF8,07IF80JFC07IF8,:07IF807IFE07IF8,07IF803JF07IF8,07IFC01JF87IF8,07IFC00JF87IF8,03IFC00JFCJF8,03IFE007IFEJF8,03IFE003NF8,03JF001NF,01JF001NF,01JF800NF,01JFC007LFE,00JFE003LFE,00KF003LFE,007JFC01LFC,007KF80LFC,003KF807KF8,003KF807KF,001KF803KF,I0KF801JFE,I07JF800JFC,I03JF8007IF8,I03JFI07IF8,J0JFI03FFE,J07IFI01FFC,J03IFJ0FF8,J01FFEJ0FF,K07FEJ07C,K01FEJ03,L07C,L01C,,::::07YFC,::07YFE,::::07gF,:::::::,:::::N03RFC,M0TFC,L03TFC,K01UFE,K07UFE,K0VFE,J03VFE,J07VFE,J0XF,I01XF,I03XF,I07XF,I0YF,001YF,:003YF,007LF7LFDJFE,007KF001KFC,00KFCI07JFC,00KFJ01JFE,01JFEK0JFE,01JFCK07IFE,01JF8K03JF,03JFL03JF,03IFEL01JF,03IFEM0JF8,03IFCM0JF8,:07IFCM07IF8,:07IF8M07IF8,::::07IFCM07IF8,:03IFCM0JF8,03IFEM0JF8,:03JFL01JF,03JFL03JF,01JF8K07JF,01JFCK07IFE,00JFEJ01JFE,00KFJ03JFE,00KFCI07JFC,007KF803KFC,007SF8,003SF,001SF,001RFE,I0RFC,I07QF8,I03QF,I01PFE,J0PFC,J07OF8,J01OF,K0NFC,K03MF8,L0LFE,L03KF,M03IF8,,::::07OF,07PF8,07QF,07QFC,07RF,07RF8,07RFE,07SF,07SF8,07SFC,07SFE,07TF,:07TF8,07TFC,:P03KFE,Q03JFE,R0JFE,R07JF,R03JF,R01JF,R01JF8,S0JF8,:S07IF8,:::::::S0JF8,:S01IF8,O0CJ07FF,M07IF8003FF,L03KF801FF,L0LFE007E,K03MF803E,K0NFE01C,J01OF00C,J07OF8,J0PFE,I01QF,I03QF8,I07QFC,I0RFC,001RFE,001SF,003SF8,007SF8,007KF003KFC,00KFCI07JFC,00KFJ03JFE,01JFEK0JFE,01JFCK07IFE,01JF8K03JF,03JFL03JF,03JFL01JF,03IFEM0JF8,:03IFCM0JF8,07IFCM07IF8,:07IF8M07IF8,::::07IFCM07IF8,:03IFCM0JF8,03IFEM0JF8,:03JFL01JF,03JFL03JF,01JF8K03JF,01JFCK07IFE,01JFEK0JFE,00KFJ03JFE,00KFCI07JFC,007KF003KFC,07TF8,:07TF,07SFE,07SFC,:07SF8,07SF,07RFE,07RF8,07RF,07QFE,07QF8,07PFE,07PF8,07OF8,,::::Q01F8,P01IF8,07FCL07IFE,07FFEJ01KF8,07IF8I03KFC,07IF8I0LFE,07IF8001MF,07IF8001MF8,07IF8003MFC,07IF8007MFC,07IF8007MFE,07IF800NFE,07IF800OF,07IF801OF,07IF801OF8,:07IF803JF3JF8,07IF803IFC0JF8,07IF803IF80JF8,07IF803IF807IF8,07IF803IF007IF8,:::::::::::07IFC03IF007IF8,07IFE07IF007IF8,07JF1JF007IF8,03OF007IF8,:03NFE007IF8,:01NFE007IF8,01NFC007IF8,00NF8007IF8,007MF8007IF8,007MFI07IF8,003LFEI01IF8,001LFCK0FF8,I0LF8,I03KF,I01JFC,J07IF,K07F8,,:::^FS" SKIP.
        
        PUT UNFORMATTED "^FO555,50^A0N,45,33^FD" STRING(TODAY,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO540,130^BY4^BER,130,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP. /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO570,530^A0N,45,30^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime cdigo do item */

        PUT UNFORMATTED "^FO420,100^A0R,40,25^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO370,125^A0R,40,25^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */

        PUT UNFORMATTED "^FO720,660^A0R,30,25^FDSuporte a cliente: (48) 2106 0006^FS"                  SKIP.
        PUT UNFORMATTED "^FO690,660^A0R,26,22^FDFrum:forum.intelbras.com.br^FS"                       SKIP.
        PUT UNFORMATTED "^FO660,660^A0R,26,22^FDSuporte via chat: intelbras.com.br/suporte-tecnico^FS" SKIP.
        PUT UNFORMATTED "^FO630,660^A0R,26,22^FDSuporte via e-mail: suporte@intelbras.com.br^FS"       SKIP.        
        PUT UNFORMATTED "^FO600,660^A0R,26,22^FDSAC:0800 7042767^FS"                                   SKIP.
        PUT UNFORMATTED "^FO570,660^A0R,26,22^FDOnde comprar? Quem instala? 0800 7245115^FS"           SKIP.

        PUT UNFORMATTED "^FO520,660^A0R,26,22^FD" item-ean.char-2 "^FS"                       SKIP.
        PUT UNFORMATTED "^FO490,660^A0R,26,22^FDIndstria de Telecomunicao^FS"           SKIP. 
        PUT UNFORMATTED "^FO460,660^A0R,26,22^FDEletrnica Brasileira^FS"     SKIP. 

        PUT UNFORMATTED "^FO430,660^A0R,26,22^FD" + estabelec.endereco + "^FS" SKIP.
        PUT UNFORMATTED "^FO400,660^A0R,26,22^FD" + estabelec.bairro + "^FS" SKIP.
        PUT UNFORMATTED "^FO370,660^A0R,26,22^FD" + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.

        PUT UNFORMATTED "^FO340,660^A0R,26,22^FDCNPJ: " c-cgc "^FS"                           SKIP.
        PUT UNFORMATTED "^FO310,660^A0R,26,22^FDwww.intelbras.com.br^FS"                      SKIP.
        PUT UNFORMATTED "^FO280,660^A0R,26,22^FD" string(item-ean.origem) "^FS"              SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO190,260^A0R,40,25^FDEste produto  beneficiado pela Legislao de Informtica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END.  

        IF AVAIL item-dun 
        THEN PUT UNFORMATTED "^FO305,330^A0R,40,25^FB368,1,0,C^FDQtd: " string(item-dun.qtd-emb) "^FS" SKIP.

        PUT UNFORMATTED "^LRY^FO350,60^GB100,490,150^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^LRY^FO685,10^GB100,590,150^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^LRY^FO10,10^GB100,590,300^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^LRY^FO10,600^GB200,100,1000^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT UNFORMATTED "^XZ" SKIP.

    END.

END. /* modelo 617 */

IF  p-cod-modelo = 618 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    DO i-cont = 1 TO p-qtd-etiquetas:

        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.

        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").

        /* Impressao da Imagem IntelBras */
        PUT UNFORMATTED "^XA" SKIP .

       //LOGO iNTELBRAS
        PUT UNFORMATTED
            "^FO700,50^GFA,5352,5352,12,,:::::Y03E,07TFE00FF8,07TFE01FFE,07UF03IF,07UF07IF,07UF0JF8,:07UF8JF8,:::::07UF87IF,07UF83IF,07UF81FFE,07UF80FF8,Y03E,,::::07OFE,07PFC,07QF8,07QFE,07RF,07RFC,07RFE,07SF,07SF8,07SFC,07SFE,07TF,07TF8,:07TFC,:Q0KFE,Q01JFE,R0KF,R07JF,R03JF,R01JF8,S0JF8,:S07IF8,:::::::S0JF8,::R01JF8,R03JF,R07JF,R0KF,Q03JFE,P03KFE,07TFC,:07TF8,07TF,:07SFE,07SFC,07SF8,07SF,07RFE,07RF8,07RF,07QFC,07QF,07PF8,07OF8,,::::M0TFC,L07TFC,K03UFC,K0VFE,J03VFE,J07VFE,J0WFE,I03WFE,I07XF,I0YF,:001YF,003YF,007YF,:00gF,00KFEK07IF8,01KFL07IF8,01JFCL07IF8,01JF8L07IF8,03JFM07IF8,:03IFEM07IF8,03IFCM07IF8,07IFCM07IF8,::07IF8M07IF8,07IF8M03IF8,07IF8O0FF8,07IFC,::03IFC,03IF8,03FFE,03FF8I07F8,01FFI07IFC,01FE003KF8,01F801LFE,00F007MF8,00E00NFE,00403OF,J07OFC,J0PFE,I01QF,I03QF8,I07QFC,I0RFC,001RFE,001SF,003SF8,007LF3LF8,007KFE01KFC,00MF007JFC,00MF001JFE,01MF800JFE,01MFC007IFE,01MFE003JF,03MFE003JF,03NF001JF,03NF800JF8,03IFCJFC00JF8,03IFC7IFE00JF8,07IFC7IFE007IF8,07IFC3JF007IF8,07IF81JF807IF8,07IF80JFC07IF8,:07IF807IFE07IF8,07IF803JF07IF8,07IFC01JF87IF8,07IFC00JF87IF8,03IFC00JFCJF8,03IFE007IFEJF8,03IFE003NF8,03JF001NF,01JF001NF,01JF800NF,01JFC007LFE,00JFE003LFE,00KF003LFE,007JFC01LFC,007KF80LFC,003KF807KF8,003KF807KF,001KF803KF,I0KF801JFE,I07JF800JFC,I03JF8007IF8,I03JFI07IF8,J0JFI03FFE,J07IFI01FFC,J03IFJ0FF8,J01FFEJ0FF,K07FEJ07C,K01FEJ03,L07C,L01C,,::::07YFC,::07YFE,::::07gF,:::::::,:::::N03RFC,M0TFC,L03TFC,K01UFE,K07UFE,K0VFE,J03VFE,J07VFE,J0XF,I01XF,I03XF,I07XF,I0YF,001YF,:003YF,007LF7LFDJFE,007KF001KFC,00KFCI07JFC,00KFJ01JFE,01JFEK0JFE,01JFCK07IFE,01JF8K03JF,03JFL03JF,03IFEL01JF,03IFEM0JF8,03IFCM0JF8,:07IFCM07IF8,:07IF8M07IF8,::::07IFCM07IF8,:03IFCM0JF8,03IFEM0JF8,:03JFL01JF,03JFL03JF,01JF8K07JF,01JFCK07IFE,00JFEJ01JFE,00KFJ03JFE,00KFCI07JFC,007KF803KFC,007SF8,003SF,001SF,001RFE,I0RFC,I07QF8,I03QF,I01PFE,J0PFC,J07OF8,J01OF,K0NFC,K03MF8,L0LFE,L03KF,M03IF8,,::::07OF,07PF8,07QF,07QFC,07RF,07RF8,07RFE,07SF,07SF8,07SFC,07SFE,07TF,:07TF8,07TFC,:P03KFE,Q03JFE,R0JFE,R07JF,R03JF,R01JF,R01JF8,S0JF8,:S07IF8,:::::::S0JF8,:S01IF8,O0CJ07FF,M07IF8003FF,L03KF801FF,L0LFE007E,K03MF803E,K0NFE01C,J01OF00C,J07OF8,J0PFE,I01QF,I03QF8,I07QFC,I0RFC,001RFE,001SF,003SF8,007SF8,007KF003KFC,00KFCI07JFC,00KFJ03JFE,01JFEK0JFE,01JFCK07IFE,01JF8K03JF,03JFL03JF,03JFL01JF,03IFEM0JF8,:03IFCM0JF8,07IFCM07IF8,:07IF8M07IF8,::::07IFCM07IF8,:03IFCM0JF8,03IFEM0JF8,:03JFL01JF,03JFL03JF,01JF8K03JF,01JFCK07IFE,01JFEK0JFE,00KFJ03JFE,00KFCI07JFC,007KF003KFC,07TF8,:07TF,07SFE,07SFC,:07SF8,07SF,07RFE,07RF8,07RF,07QFE,07QF8,07PFE,07PF8,07OF8,,::::Q01F8,P01IF8,07FCL07IFE,07FFEJ01KF8,07IF8I03KFC,07IF8I0LFE,07IF8001MF,07IF8001MF8,07IF8003MFC,07IF8007MFC,07IF8007MFE,07IF800NFE,07IF800OF,07IF801OF,07IF801OF8,:07IF803JF3JF8,07IF803IFC0JF8,07IF803IF80JF8,07IF803IF807IF8,07IF803IF007IF8,:::::::::::07IFC03IF007IF8,07IFE07IF007IF8,07JF1JF007IF8,03OF007IF8,:03NFE007IF8,:01NFE007IF8,01NFC007IF8,00NF8007IF8,007MF8007IF8,007MFI07IF8,003LFEI01IF8,001LFCK0FF8,I0LF8,I03KF,I01JFC,J07IF,K07F8,,:::^FS" SKIP.
        
        PUT UNFORMATTED "^FO555,50^A0N,45,33^FD" STRING(TODAY,"99/99/99") "^FS"      SKIP. /* Imprime Data Vertical */        
        PUT UNFORMATTED "^FO540,120^BY2^BCR,130,N,N^FD" IF AVAIL item-dun THEN STRING(item-dun.cod-dun) ELSE "" "^FS" SKIP. /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO500,220^A0R,30,30^FD" IF AVAIL item-dun THEN STRING(item-dun.cod-dun) ELSE "" "^FS" skip.
        PUT UNFORMATTED "^FO570,530^A0N,45,30^FD" item-ean.it-codigo "^FS"                    SKIP. /* Imprime cdigo do item */

        PUT UNFORMATTED "^FO420,100^A0R,40,25^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO370,125^A0R,40,25^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */

        PUT UNFORMATTED "^FO720,660^A0R,30,25^FDSuporte a cliente: (48) 2106 0006^FS"                  SKIP.
        PUT UNFORMATTED "^FO690,660^A0R,26,22^FDForum:forum.intelbras.com.br^FS"                       SKIP.
        PUT UNFORMATTED "^FO660,660^A0R,26,22^FDSuporte via chat: intelbras.com.br/suporte-tecnico^FS" SKIP.
        PUT UNFORMATTED "^FO630,660^A0R,26,22^FDSuporte via e-mail: suporte@intelbras.com.br^FS"       SKIP.        
        PUT UNFORMATTED "^FO600,660^A0R,26,22^FDSAC:0800 7042767^FS"                                   SKIP.
        PUT UNFORMATTED "^FO570,660^A0R,26,22^FDOnde comprar? Quem instala? 0800 7245115^FS"           SKIP.

        PUT UNFORMATTED "^FO520,660^A0R,26,22^FD" item-ean.char-2 "^FS"                       SKIP.
        PUT UNFORMATTED "^FO490,660^A0R,26,22^FDInd£stria de Telecomuniá∆o^FS"           SKIP. 
        PUT UNFORMATTED "^FO460,660^A0R,26,22^FDEletrìnica Brasileira^FS"     SKIP. 

        PUT UNFORMATTED "^FO430,660^A0R,26,22^FD" + estabelec.endereco + "^FS" SKIP.
        PUT UNFORMATTED "^FO400,660^A0R,26,22^FD" + estabelec.bairro + "^FS" SKIP.
        PUT UNFORMATTED "^FO370,660^A0R,26,22^FD" + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.

        PUT UNFORMATTED "^FO340,660^A0R,26,22^FDCNPJ: " c-cgc "^FS"                           SKIP.
        PUT UNFORMATTED "^FO310,660^A0R,26,22^FDwww.intelbras.com.br^FS"                      SKIP.
        PUT UNFORMATTED "^FO280,660^A0R,26,22^FD" string(item-ean.origem) "^FS"              SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO190,260^A0R,40,25^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
               // PUT UNFORMATTED "^FO310,237^A0N,14,15^FDLegislao de Informtica^FS" SKIP.
            END.
        END.  

        IF AVAIL item-dun 
        THEN PUT UNFORMATTED "^FO290,330^A0R,40,25^FB368,1,0,C^FDQtd: " string(item-dun.qtd-emb) "^FS" SKIP.

        PUT UNFORMATTED "^LRY^FO350,60^GB100,490,150^FS^LRN" SKIP.  /* Quadro preto */
        //PUT UNFORMATTED "^LRY^FO685,10^GB100,590,150^FS^LRN" SKIP.  /* Quadro preto */
        //PUT UNFORMATTED "^LRY^FO10,10^GB100,590,300^FS^LRN" SKIP.  /* Quadro preto */
        //PUT UNFORMATTED "^LRY^FO10,600^GB200,100,1000^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT UNFORMATTED "^XZ" SKIP.

    END.

END. /* modelo 618 */

IF  p-cod-modelo = 619 THEN DO:

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    ASSIGN i-cont = 0.

    FOR EACH tt-lista-ns:

        ASSIGN i-cont = i-cont + 1.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na varivel c-cgc*/        

        IF i-cont = 1
        THEN DO:
            PUT "^XA" SKIP.

            {esapi/esapi016a5035.i}         /* Embalagem */
            {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
            {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */

            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.

        END.
        ELSE DO:
            PUT "^XA" SKIP.

           // {esapi/esapi016a5034.i}         /* Embalagem */
            {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
            {esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */

            PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
            PUT "^XZ" SKIP.

            ASSIGN i-cont = 0.
        END.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 130 */

IF  p-cod-modelo = 620 THEN DO:

    //{esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    ASSIGN i-cont = 0.

    FOR EACH tt-lista-ns:

        ASSIGN i-cont = i-cont + 1.

        ASSIGN i-tot = i-tot + 1.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na varivel c-cgc*/        

        CASE i-cont:
            WHEN 1 THEN DO: /* Etiqueta 1 */
               PUT "^XA" SKIP.

               //PUT UNFORMATTED "^FT270,450^BQN,2,50^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
               PUT UNFORMATTED "^FT270,530^BY5,2.0,65^BQN,2,7^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.

               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".

               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.

                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.

                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO210,182^A0N,40,40^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                    //   IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO210,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.

                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO210,182^A0N,40,40^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO210,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.

               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.

               PUT UNFORMATTED "^FO210,132^A0N,40,40^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.    
               PUT UNFORMATTED "^FO280,550^A0N,50,50^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 

               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO280,600^A0N,30,30^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.

               IF i-tot = p-qtd-etiquetas 
               THEN DO:
                   PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                   PUT "^XZ" SKIP.
               END.
            END. /* FIM etiqueta 1 */

            WHEN 2 THEN DO: /* Etiqueta 2 */

               //PUT UNFORMATTED "^FT900,450^BQN,2,50^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
               PUT UNFORMATTED "^FT900,530^BY5,2.0,65^BQN,2,7^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.

               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".

               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.

                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.

                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO830,182^A0N,40,40^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                     //IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO830,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.
                    
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO830,182^A0N,40,40^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO830,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.

               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.

               PUT UNFORMATTED "^FO830,132^A0N,40,40^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.               
               PUT UNFORMATTED "^FO900,550^A0N,50,50^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 

               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO900,600^A0N,30,30^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.

               IF i-tot = p-qtd-etiquetas 
               THEN DO:
                   PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                   PUT "^XZ" SKIP.
               END.
            END. /* FIM etiqueta 2 */

            WHEN 3 THEN DO: /* Etiqueta 3 */

               //PUT UNFORMATTED "^FT1530,450^BQN,2,50^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
               PUT UNFORMATTED "^FT1530,530^BY5,2.0,65^BQN,2,7^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.

               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".

               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.

                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.

                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO1470,182^A0N,40,40^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                     //IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO1470,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.
                   
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO1470,182^A0N,40,40^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO1470,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.

               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.

               PUT UNFORMATTED "^FO1470,132^A0N,40,40^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.  
               PUT UNFORMATTED "^FO1540,550^A0N,50,50^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 

               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO1540,600^A0N,30,30^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.

               IF i-tot = p-qtd-etiquetas 
               THEN DO:
                   PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                   PUT "^XZ" SKIP.
               END.
            END. /* FIM etiqueta 3 */

            WHEN 4 THEN DO: /* Etiqueta 4 */

               //PUT UNFORMATTED "^FT2170,450^BQN,2,50^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
               PUT UNFORMATTED "^FT2170,530^BY5,2.0,65^BQN,2,7^FH\^FDLA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.

               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".

               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.


                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.

                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO2110,182^A0N,40,40^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                     //IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO2110,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.
                   
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO2110,182^A0N,40,40^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO2110,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.

               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.

               PUT UNFORMATTED "^FO2110,132^A0N,40,40^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.  
               PUT UNFORMATTED "^FO2180,550^A0N,50,50^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 

               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO2180,600^A0N,30,30^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.

               PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
               PUT "^XZ" SKIP.

               ASSIGN i-cont = 0.
            END. /* FIM etiqueta 4 */
        END CASE.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        FIND FIRST num-serie WHERE
                   num-serie.n-serie = tt-lista-ns.num-serie
                   EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL num-serie 
        THEN DO:
            ASSIGN num-serie.int-2 = 1.
            RELEASE num-serie.
        END.

    END.
END. /* modelo 620 */

IF p-cod-modelo = 624 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    FIND FIRST param-global NO-LOCK NO-ERROR.

    DO i-cont = 1 TO p-qtd-etiquetas:

        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.

        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = p-it-codigo NO-ERROR.

        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").    

        PUT "^XA" SKIP.

        //LOGO iNTELBRAS
        PUT UNFORMATTED "^FO20,10^GFA,3450,3450,46,,::::::::::::I01F8,I07FET01FFX03FE00FF8,I0IFT0IFW01FFE07FF8,I0IFS01IFW01FFE07FF8,001IF8R01IFW01FFE07FF8,::I0IFS01IFW01FFE07FF8,:I07FES01IFW01FFE07FF8,I01F8S01IFW01FFE07FF8,Y01IFW01FFE07FF8,:K0FL07EK01KFEL01F8K01FFE07FF801FCQ0FCK01FCO07KF,I03FFK0JFJ01KFEK03IFCJ01FFE07FF83IFCN01IFCI03IFEM07LF8,I0IFJ03JFCI01KFEJ01KF8I01FFE07FF9KF8M0KF801KFCK01MF,I0IFJ0LF8001KFEJ07KFEI01FFE07NFEL03KF807LFK03MF,I0IFI03LFC001KFEI01MF8001FFE07OF8K07KF01MFCJ0NF,I0IFI07MF001KFEI07MFC001FFE07OFEJ01KFE03MFEI01NF,I0IF001NF801KFCI0OF001FFE07PFJ03KFC07NFI01NF,I0IF003NFC01KFC001OF801FFE07PF8I07KF80OF8003NF,I0IF003NFE01KFC003OFC01FFE07PFCI0LF81OFC007MFE,I0IF007NFE01KFC007OFE01FFE07PFE001LF03OFE007MFE,I0IF00PF01KF800PFE01FFE07QF001KFE07PF007MFE,I0IF01JF00JF81IFK0JF801JF01FFE07JF801JF003IFCI0JFC01JF80IFC,I0IF01IFC003IF81IFJ01IFE001JF81FFE07IFEI07IF803IFJ0IFEI03IF80IF8,I0IF01IF8I0IF81IFJ03IF8003IFE01FFE07IF8I01IFC07FFEI01IFCI01IFC0IF8,I0IF03IFJ0IFC1IFJ03IFI0JFC01FFE07IFK0IFC07FFCI01IF8J0IFC0IF8,I0IF03FFEJ07FFC1IFJ03FFE001JF001FFE07FFEK07FFC07FFCI03IFK07FFE0IF8,I0IF03FFCJ03FFC1IFJ07FFC007IFE001FFE07FFEK03FFE0IF8I03FFEK03FFE07FFC,I0IF03FFCJ03FFC1IFJ07FFC00JF8001FFE07FFCK03FFE0IF8I03FFCK03FFE07KFE,I0IF03FFCJ03FFC1IFJ07FF803JFI01FFE07FFCK01FFE0IFJ07FFCK01IF03LFE,I0IF03FFCJ03FFC1IFJ07FF807IFCI01FFE07FF8K01FFE0IFJ07FFCK01IF03MFC,I0IF03FFCJ03FFC1IFJ07FF81JF8I01FFE07FF8K01FFE0IFJ07FFCK01IF01MFE,I0IF03FFCJ03FFC1IFJ07FF83IFEJ01FFE07FF8K01FFE0IFJ07FF8K01IF00NF,I0IF03FFCJ03FFC1IFJ07FF8JFCJ01FFE07FF8K01FFE0IFJ07FF8K01IF007MF8,I0IF03FFCJ03FFC1IFJ07FFBJFK01FFE07FF8K01FFE0IFJ07FFCK01IF003MFC,I0IF03FFCJ03FFC1IFJ07LFCK01FFE07FF8K01FFE0IFJ07FFCK01IFI0MFE,I0IF03FFCJ03FFC1IFJ07LF803F801FFE07FFCK03FFE0IFJ03FFCK01IFI03LFE,I0IF03FFCJ03FFC0IFJ07KFE003FF01FFE07FFCK03FFE0IFJ03FFEK03IFM07IF,I0IF03FFCJ03FFC0IFJ07KFC007FFC1FFE03FFEK07FFE0IFJ03FFEK03IFM01IF,I0IF03FFCJ03FFC0IF8I03KFI0IFC1FFE03IFK0IFC0IFJ03IFK07IFN0IF,I0IF03FFCJ03FFC0IFCI03JFE001IF81FFE03IF8I01IFC0IFJ01IF8J0JFN0IF,I0IF03FFCJ03FFC07FFEI01JF8003IF81FFE01IFCI03IF80IFJ01IFEI03JFN0IF,I0IF03FFCJ03FFC07IFI01JF800JF01FFE01JFI0JF80IFK0JFI07JFM01IF,I0IF03FFCJ03FFC03IFE040JFE07JF01FFE00JFE07JF00IFK0JFE03KFM03IF,I0IF03FFCJ03FFC03KFE07OFE01FFE007OFE00IFK07QF01OF,I0IF03FFCJ03FFC01LF07OFC01FFE003OFE00IFK03QF01NFE,I0IF03FFCJ03FFC00LF03OF801FFE001OFC00IFK01QF01NFE,I0IF03FFCJ03FFC007KF81OF001FFEI0OF800IFL0QF03NFC,I0IF03FFCJ03FFC003KFC07MFE001FFEI07MFEI0IFL07PF03NFC,I0IF03FFCJ03FFC001KFE03MF8001FFEI03MFCI0IFL01PF03NF8,I0IF03FFCJ03FFCI0LF00MFI01FFEJ0MFJ0IFM0PF03NF,I0IF03FFCJ03FFCI03KF803KFCI01FFEJ03KFEJ0IFM03OF03MFC,I0IF03FFCJ03FFCJ0JFEI0KFJ01FFEK0KFK0IFN0KF1IF03MF8,I0IF03FFCJ03FFCK0IFK0IFK01FFEL0IFL0IFO0IF81IF03LFC,,:::::^FS" SKIP.

      //PUT UNFORMATTED "^FO20,30^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO30,90^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO80,90^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO385,90^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO30,185^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO30,225^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO30,170^GB370,0,90^FS^LRN" SKIP.  /* Quadro preto */

       // PUT UNFORMATTED "^FO30,270^BY2^BCN,30,N,N^FD" IF AVAIL item-dun THEN STRING(item-dun.cod-dun) ELSE "" "^FS" SKIP. /* Codigo de Barras DUN 14 */
        PUT UNFORMATTED "^FO40,270^BY3,^BCN,30,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
        //PUT UNFORMATTED "^FO60,310^A0N,30,30^FD" IF AVAIL item-dun THEN STRING(item-dun.cod-dun) ELSE "" "^FS" skip.
        PUT UNFORMATTED "^FO250,310^A0N,30,20^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP. /* Quantidade */

        PUT UNFORMATTED "^FO30,340^A0N,20,17^FD" "PRAZO DE VALIDADE: " CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,360^A0N,20,17^FD" "COMPOSIÄ«O: " CAPS(item-ean.texto[14]) CAPS(item-ean.texto[15]) "^FS" SKIP.

        //Segunda parte
        PUT UNFORMATTED "^FO420,20^A0N,22,22^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO420,40^A0N,20,20^FD" "Suporte via chat:" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,60^A0N,20,20^FD" "intelbras.com.br/suporte-tecnico" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,80^A0N,20,20^FD" "Suporte via e-mail:" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,100^A0N,20,20^FD" "suporte@intelbras.com.br" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,120^A0N,20,20^FD" "F¢rum: forum.intelbras.com.br" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,140^A0N,20,20^FD" "SAC: 0800 7042767" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,160^A0N,20,20^FD" "Onde comprar? Quem instala?" "^FS" SKIP.
        PUT UNFORMATTED "^FO420,180^A0N,20,20^FD" "0800 7245115" "^FS" SKIP.

        IF  item-ean.char-2 = "INTELBRAS S/A"
        THEN DO:
           PUT UNFORMATTED "^FO420,210^A0N,22,22^FD" "Fabricado por:" "^FS" SKIP.

           PUT UNFORMATTED "^FO420,230^A0N,20,20^FD" item-ean.char-2 " - Ind£stria de" "^FS" SKIP.
           PUT UNFORMATTED "^FO420,250^A0N,20,20^FD" "Telecomunicaá∆o Eletrìnica Brasileira" "^FS" SKIP.
           PUT UNFORMATTED "^FO420,270^A0N,20,20^FD" estabelec.endereco "^FS" SKIP.
           PUT UNFORMATTED "^FO420,290^A0N,20,20^FD" estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + " - " STRING(estabelec.cep) "^FS" SKIP.
           PUT UNFORMATTED "^FO420,310^A0N,20,20^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
           

        END.

        PUT UNFORMATTED "^FO520,340^A0N,18,18^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO518,360^A0N,20,20^FD" "www.intelbras.com.br" "^FS" SKIP. /* Imprime c´digo do item */

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

    END.
END. /* modelo 624 */

IF p-cod-modelo = 625 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    FIND FIRST param-global NO-LOCK NO-ERROR.

    DO i-cont = 1 TO p-qtd-etiquetas:

        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.

        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = p-it-codigo NO-ERROR.

        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").    

        PUT "^XA" SKIP.

        //LOGO iNTELBRAS
        PUT UNFORMATTED "^FO20,10^GFA,3450,3450,46,,::::::::::::I01F8,I07FET01FFX03FE00FF8,I0IFT0IFW01FFE07FF8,I0IFS01IFW01FFE07FF8,001IF8R01IFW01FFE07FF8,::I0IFS01IFW01FFE07FF8,:I07FES01IFW01FFE07FF8,I01F8S01IFW01FFE07FF8,Y01IFW01FFE07FF8,:K0FL07EK01KFEL01F8K01FFE07FF801FCQ0FCK01FCO07KF,I03FFK0JFJ01KFEK03IFCJ01FFE07FF83IFCN01IFCI03IFEM07LF8,I0IFJ03JFCI01KFEJ01KF8I01FFE07FF9KF8M0KF801KFCK01MF,I0IFJ0LF8001KFEJ07KFEI01FFE07NFEL03KF807LFK03MF,I0IFI03LFC001KFEI01MF8001FFE07OF8K07KF01MFCJ0NF,I0IFI07MF001KFEI07MFC001FFE07OFEJ01KFE03MFEI01NF,I0IF001NF801KFCI0OF001FFE07PFJ03KFC07NFI01NF,I0IF003NFC01KFC001OF801FFE07PF8I07KF80OF8003NF,I0IF003NFE01KFC003OFC01FFE07PFCI0LF81OFC007MFE,I0IF007NFE01KFC007OFE01FFE07PFE001LF03OFE007MFE,I0IF00PF01KF800PFE01FFE07QF001KFE07PF007MFE,I0IF01JF00JF81IFK0JF801JF01FFE07JF801JF003IFCI0JFC01JF80IFC,I0IF01IFC003IF81IFJ01IFE001JF81FFE07IFEI07IF803IFJ0IFEI03IF80IF8,I0IF01IF8I0IF81IFJ03IF8003IFE01FFE07IF8I01IFC07FFEI01IFCI01IFC0IF8,I0IF03IFJ0IFC1IFJ03IFI0JFC01FFE07IFK0IFC07FFCI01IF8J0IFC0IF8,I0IF03FFEJ07FFC1IFJ03FFE001JF001FFE07FFEK07FFC07FFCI03IFK07FFE0IF8,I0IF03FFCJ03FFC1IFJ07FFC007IFE001FFE07FFEK03FFE0IF8I03FFEK03FFE07FFC,I0IF03FFCJ03FFC1IFJ07FFC00JF8001FFE07FFCK03FFE0IF8I03FFCK03FFE07KFE,I0IF03FFCJ03FFC1IFJ07FF803JFI01FFE07FFCK01FFE0IFJ07FFCK01IF03LFE,I0IF03FFCJ03FFC1IFJ07FF807IFCI01FFE07FF8K01FFE0IFJ07FFCK01IF03MFC,I0IF03FFCJ03FFC1IFJ07FF81JF8I01FFE07FF8K01FFE0IFJ07FFCK01IF01MFE,I0IF03FFCJ03FFC1IFJ07FF83IFEJ01FFE07FF8K01FFE0IFJ07FF8K01IF00NF,I0IF03FFCJ03FFC1IFJ07FF8JFCJ01FFE07FF8K01FFE0IFJ07FF8K01IF007MF8,I0IF03FFCJ03FFC1IFJ07FFBJFK01FFE07FF8K01FFE0IFJ07FFCK01IF003MFC,I0IF03FFCJ03FFC1IFJ07LFCK01FFE07FF8K01FFE0IFJ07FFCK01IFI0MFE,I0IF03FFCJ03FFC1IFJ07LF803F801FFE07FFCK03FFE0IFJ03FFCK01IFI03LFE,I0IF03FFCJ03FFC0IFJ07KFE003FF01FFE07FFCK03FFE0IFJ03FFEK03IFM07IF,I0IF03FFCJ03FFC0IFJ07KFC007FFC1FFE03FFEK07FFE0IFJ03FFEK03IFM01IF,I0IF03FFCJ03FFC0IF8I03KFI0IFC1FFE03IFK0IFC0IFJ03IFK07IFN0IF,I0IF03FFCJ03FFC0IFCI03JFE001IF81FFE03IF8I01IFC0IFJ01IF8J0JFN0IF,I0IF03FFCJ03FFC07FFEI01JF8003IF81FFE01IFCI03IF80IFJ01IFEI03JFN0IF,I0IF03FFCJ03FFC07IFI01JF800JF01FFE01JFI0JF80IFK0JFI07JFM01IF,I0IF03FFCJ03FFC03IFE040JFE07JF01FFE00JFE07JF00IFK0JFE03KFM03IF,I0IF03FFCJ03FFC03KFE07OFE01FFE007OFE00IFK07QF01OF,I0IF03FFCJ03FFC01LF07OFC01FFE003OFE00IFK03QF01NFE,I0IF03FFCJ03FFC00LF03OF801FFE001OFC00IFK01QF01NFE,I0IF03FFCJ03FFC007KF81OF001FFEI0OF800IFL0QF03NFC,I0IF03FFCJ03FFC003KFC07MFE001FFEI07MFEI0IFL07PF03NFC,I0IF03FFCJ03FFC001KFE03MF8001FFEI03MFCI0IFL01PF03NF8,I0IF03FFCJ03FFCI0LF00MFI01FFEJ0MFJ0IFM0PF03NF,I0IF03FFCJ03FFCI03KF803KFCI01FFEJ03KFEJ0IFM03OF03MFC,I0IF03FFCJ03FFCJ0JFEI0KFJ01FFEK0KFK0IFN0KF1IF03MF8,I0IF03FFCJ03FFCK0IFK0IFK01FFEL0IFL0IFO0IF81IF03LFC,,:::::^FS" SKIP.

      //PUT UNFORMATTED "^FO20,30^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO30,90^A0B,16,16^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO80,90^BY3^BEN,40,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO385,90^A0B,18,18^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime c´digo do item */
        PUT UNFORMATTED "^FO30,185^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO30,225^A0N,25,23^FB368,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO30,170^GB370,0,90^FS^LRN" SKIP.  /* Quadro preto */

       // PUT UNFORMATTED "^FO30,270^BY2^BCN,30,N,N^FD" IF AVAIL item-dun THEN STRING(item-dun.cod-dun) ELSE "" "^FS" SKIP. /* Codigo de Barras DUN 14 */
       // PUT UNFORMATTED "^FO40,270^BY3,^BCN,30,Y,N ^FD>;" STRING(item-dun.cod-dun) "^FS" SKIP. /* Codigo de Barras DUN14 */
        //PUT UNFORMATTED "^FO60,310^A0N,30,30^FD" IF AVAIL item-dun THEN STRING(item-dun.cod-dun) ELSE "" "^FS" skip.
       // PUT UNFORMATTED "^FO250,310^A0N,30,20^FB155,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP. /* Quantidade */

        PUT UNFORMATTED "^FO30,340^A0N,20,17^FD" "PRAZO DE VALIDADE: " CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,360^A0N,20,17^FD" "COMPOSIÄ«O: " CAPS(item-ean.texto[14]) CAPS(item-ean.texto[15]) "^FS" SKIP.

        IF  (item-ean.char-2 = "Fabricado por:" OR
             item-ean.char-2 = "Importado por:")
        THEN DO:
           //Segunda parte

           PUT UNFORMATTED "^FO420,20^A0N,20,20^FD" "Distribu°do por: Intelbras S/A" "^FS" SKIP.
           PUT UNFORMATTED "^FO420,40^A0N,20,20^FD" "Ind£stria de Telecomunicaá∆o" "^FS" SKIP.
           PUT UNFORMATTED "^FO420,60^A0N,20,20^FD" "Eletrìnica Brasileira" "^FS" SKIP.
           PUT UNFORMATTED "^FO420,80^A0N,20,20^FD" estabelec.endereco "^FS" SKIP.
           PUT UNFORMATTED "^FO420,100^A0N,20,20^FD" estabelec.bairro "^FS" SKIP.
           PUT UNFORMATTED "^FO420,120^A0N,20,20^FD" estabelec.cidade + "/" + estabelec.estado + " - " STRING(estabelec.cep) "^FS" SKIP.
           PUT UNFORMATTED "^FO420,140^A0N,20,20^FD" item-ean.fone "^FS" SKIP.
           PUT UNFORMATTED "^FO420,160^A0N,20,20^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
           //PUT UNFORMATTED "^FO500,160^A0N,20,20^FD" "Ind£stria Brasileira" "^FS" SKIP.

           PUT UNFORMATTED "^FO420,210^A0N,20,20^FD" item-ean.char-2 "^FS" SKIP.
           PUT UNFORMATTED "^FO420,230^A0N,20,20^FD" item-ean.char-3 "^FS" SKIP. 
           PUT UNFORMATTED "^FO420,250^A0N,20,20^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */

        END.
        ELSE DO:
           IF  item-ean.char-2 = "INTELBRAS S/A"
           THEN DO:
               //Segunda parte
               PUT UNFORMATTED "^FO420,20^A0N,22,22^FD" "Fabricado por:" "^FS" SKIP.
               PUT UNFORMATTED "^FO420,40^A0N,20,20^FD" "Intelbras S/A - Ind£stria de" "^FS" SKIP.
               PUT UNFORMATTED "^FO420,60^A0N,20,20^FD" "Telecomunicaá∆o Eletrìnica Brasileira" "^FS" SKIP.
               PUT UNFORMATTED "^FO420,80^A0N,20,20^FD" estabelec.endereco "^FS" SKIP.
               PUT UNFORMATTED "^FO420,100^A0N,20,20^FD" estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + " - " STRING(estabelec.cep) "^FS" SKIP.
               PUT UNFORMATTED "^FO420,120^A0N,20,20^FD" item-ean.fone "^FS" SKIP.
               PUT UNFORMATTED "^FO420,140^A0N,20,20^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.

               PUT UNFORMATTED "^FO520,170^A0N,18,18^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */
               PUT UNFORMATTED "^FO518,190^A0N,20,20^FD" "www.intelbras.com.br" "^FS" SKIP. /* Imprime c´digo do item */

           END.
           ELSE DO:
               //Segunda parte
               PUT UNFORMATTED "^FO420,20^A0N,20,20^FD" "Importado por: Intelbras S/A" "^FS" SKIP.
               PUT UNFORMATTED "^FO420,40^A0N,20,20^FD" "Ind£stria de Telecomunicaá∆o" "^FS" SKIP.
               PUT UNFORMATTED "^FO420,60^A0N,20,20^FD" "Eletrìnica Brasileira" "^FS" SKIP.
               PUT UNFORMATTED "^FO420,80^A0N,20,20^FD" estabelec.endereco "^FS" SKIP.
               PUT UNFORMATTED "^FO420,100^A0N,20,20^FD" estabelec.bairro "^FS" SKIP.
               PUT UNFORMATTED "^FO420,120^A0N,20,20^FD" estabelec.cidade + "/" + estabelec.estado + " - " STRING(estabelec.cep) "^FS" SKIP.
               PUT UNFORMATTED "^FO420,140^A0N,20,20^FD" item-ean.fone "^FS" SKIP.
               PUT UNFORMATTED "^FO420,160^A0N,20,20^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
              // PUT UNFORMATTED "^FO500,160^A0N,20,20^FD" "Ind£stria Brasileira" "^FS" SKIP.

              // PUT UNFORMATTED "^FO420,190^A0N,20,20^FD" item-ean.char-2 "^FS" SKIP.
              // PUT UNFORMATTED "^FO420,210^A0N,20,20^FD" item-ean.char-3 "^FS" SKIP. 
               PUT UNFORMATTED "^FO500,210^A0N,20,20^FD" item-ean.origem "^FS" SKIP. /* Imprime c´digo do item */

           END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

    END.
END. /* modelo 625 */

/* ---[ Modelo 630: Produto homologado Anatel 600 dpi - Qu≠ntupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 630 THEN DO:
 
    //RUN piCargaImagem("local-anatelpp").
  //  RUN piCargaImagem("local-anatel5").
    
    {esapi/esapi016inic-600dpi.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.
        
        //LOGO Anatel
        PUT UNFORMATTED "^FO1850,220^GFA,4428,4428,27,,:::::::::::::::::::::gU07IF8,gT03KF,gR03NFC,gR0OFE,gP0SF,gO01SF8,gN01UF,gN03UF,gM07WF,gM0XF,gL07XFC,gL0YFC,gK0JFC01TF,gJ01IFEI03SF,gJ07FCM0RFC,gJ03F8M07QFC,gU03QF,gU01QF,gV0QFC,gV07PFC,gV03QF,gV01QF,gW0QF,gW07PF,gW03PF8,gW03PFC,:gW01PFE,gX0QF,::::Y03IFU0QF,Y0JFCT0QF8,W03LFES0QFC,W07MF8R0QFC,W0NFCR0QFC,V07OF8Q0QFC,V0PFCQ0QFC,U01PFEQ0QFC,U07QFQ0QFE,U0RF8P0QFE,T01RFCP0RF,T03RFEP0RF,T03SFP0RF,T0TF8N01RF,T0TFCN01RF,S01TFCN03RF,S03TFCN03RF,S03UFN03RF,S07UFN03RF,S0VF8M03RF,S0VFCM03RF,S0VFCM07RF,S0VFCM0SF,:R01VFCM0RFE,R03VFEL03RFE,R03WFL03RFC,::R03WFL07RFC,R03WFL0SFC,:R03WFK01SFC,R03WFK03SF8,:R03WFK03SF,R03WFK07SF,R03WFK0TF,:R03WFJ01TF,R03VFEJ01TF,R03VFCJ03TF,:S0VFCJ07SFE,S0VFCJ0TFC,S0VFCI01TFC,S0VFCI03TFC,S0VF8I03TFC,S07UFJ07TF8,S03UFJ0UF,S03TFEJ0UF,S01TFCI01UF,T0TFCI03UF,T0TF8I07UF,T0TFJ0VF,T03RFEI01UFE,U0RFCI03UFC,:U0RF8I03UFC,V0PFCJ07UF8,V0PFCJ0VF8,V03OFJ01VF,V03NFEJ03VF,W03MFK07VF,W01LFCK0WF,X03JFEL0WF,X01JFCL0VFE,,:::::::O0FFI01FF003FCI03FF03KFC3JFC03FC,N01FFI03FF003FCI03FF03KFC3JFC03FC,N03FF8003FF003FCI03FF03KFC3JFC03FC,N07FFC003FF803FCI07FF0087FE183FE01003FC,N0IFC003FFC03FCI0IF8003FC003FCJ03FC,N0IFC003FFC03FC001IFC003FC003FCJ03FC,N0IFC003FFC03FC003IFC003FC003FCJ07FC,M01IFC007FFC03FC003IFC003FC003FCJ07F8,M03IFC00IFE07F8007IFC003F8003FCJ0FF,M03IFE00JF0FFI07IFC003FI07FCJ0FF,M07F8FF00JF0FFI0FF3FC007FI0FFCJ0FF,M0FF0FF00JF8FF001FE3FC00FFI0FFCJ0FF,M0FF0FF00JFCFF003FC3FC00FFI0FFCJ0FF,L01FF0FF00FF3FCFF003FC3FC00FFI0JFE00FF,L03FE0FF00FF3JF007FC3FC00FFI0KF00FF,L03FC0FF00FF3IFE007FC3FC00FFI0KF00FF,L07FC0FF00FF1IFC00FF03FC00FFI0JFE00FF,L0FF80FF00FF0IFC00FF03FC00FEI0FF8J0FF,L0FFE1FF01FE07FFC01FF87FC00FC001FFK0FF,L0LF03FC03FFC03KFE01FC003FFK0FF,K01LF03FC03FFC03KFE03FC003FFJ01FF,K03LF03FC03FFC03KFE03FC003FFJ01FE,K07FE01FF03FC01FFC07FC01FF03FC003FFJ03FE,K07FC00FF03FC00FFC0FF800FF03FC003FEJ03FC,K0FF800FF03FC00FFC0FFI0FF03FC003FEJ03FC,K0FFI0FF07F800FFC1FFI0FF03FC003FEJ03FC,K0FFI0FF0FFI03F83FEI0FF03FC003JFC03JFC,J01FFI0FF0FFI03F03FCI0FF03FC003JFC03JFC,J03FFI0FF0FFI03F03FCI0FF03FC003JFC03JFC,J03FEI07F0FFI03F03FCI0FF03FC003JFC03JFC,,:::^FS" SKIP.

        //{esapi/esapi016a5034.i}         /* Embalagem */
        //{esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        //{esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */
        {esapi/esapi016a5034-600dpi.i}  /* Embalagem */                             
        {esapi/esapi016a11-600dpi.i 2}  /* Etiqueta de Produto (34x21mm) */         
        {esapi/esapi016a12-600dpi.i 2}         /* etiqueta 24x8mm */                       
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    //PUT UNFORMATTED "^XA^IDlocal-anatelpp.GRF^FS^XZ".

    /* Limpa a imagem da impressora */
    //PUT UNFORMATTED "^XA^IDlocal-anatel5.GRF^FS^XZ".
END. /* modelo 630 */

/* ---[ Impress∆o Modelo 631 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 631 THEN DO:                                                                                                                                                       
                                                                                                                                                                                     
    ASSIGN i-cont = 0.                                                                                                                                                           
                                                                                                                                                                                 
    /* Carrega a imagem para a impressora */                                                                                                                                     
    //RUN piCargaImagem("local-logoma2").                                                                                                                                          
                                                                                                                                                                                 
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.                                                                                                                           
    END.                                                                                                                                                                         
                                                                                                                                                                                 
 //   RUN piCargaImagem("local-suframa").                                                                                                                                          
                                                                                                                                                                                 
    IF NOT AVAIL imagem-etiq THEN DO:                                                                                                                                            
        RUN piGeraErro (INPUT 17006,                                                                                                                                             
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").  
        RETURN "NOK".                                                                                                                                                            
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/                                                                                                                  
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:                                                                                                                                                        
        FOR FIRST num-serie NO-LOCK                                                                                                                                              
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:                                                                                                                     
        END.                                                                                                                                                                     
                                                                                                                                                                                 
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/                                                                                                   
                                                                                                                                                                                 
        PUT "^XA" SKIP.                                                                                                                                                          
        PUT UNFORMATTED "^FO35,35,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */                                                   
        PUT UNFORMATTED "^FO125,35^BY3^BEN,70,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */                                               
        PUT UNFORMATTED "^FO520,35,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */                                                                                    
        PUT UNFORMATTED "^FO20,160^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */                                           
        PUT UNFORMATTED "^FO20,190^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */    

        IF item-ean.destaque = "" THEN DO:
           PUT UNFORMATTED "^LRY^FO20,145^GB500,0,80^FS^LRN" SKIP.  /* Quadro preto */        
        END.
        ELSE DO:
           IF item-ean.destaque = '127V' THEN DO:
              PUT UNFORMATTED "^LRY^FO20,145^GB440,0,80^FS^LRN" SKIP.  /* Quadro preto */  
              PUT UNFORMATTED "^FO475,155,^A0B,42,30^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */

              /* Quadrado branco destaque */
              PUT UNFORMATTED "^FO465,144^GB45,0,4^FS" SKIP. /* Linha superior */
              PUT UNFORMATTED "^FO465,223^GB45,0,4^FS" SKIP. /* Linha inferior */
              PUT UNFORMATTED "^FO465,144^GB0,82,4^FS" SKIP. /* Linha lateral esquerda */
              PUT UNFORMATTED "^FO510,144^GB0,82,4^FS" SKIP. /* Linha lateral direita  */
           END.
           ELSE DO:

               PUT UNFORMATTED "^LRY^FO20,145^GB440,0,80^FS^LRN" SKIP.  /* Quadro preto */        
               PUT UNFORMATTED "^FO475,155,^A0B,42,30^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */

               PUT UNFORMATTED "^LRY^FO465,145^GB50,80,40^FS^LRN" SKIP. /* Quadro preto destaque */
           END.
        END.

        PUT UNFORMATTED "^FO90,230^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */                                                          
        PUT UNFORMATTED "^FO20,270^A0N,18,18^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
        PUT UNFORMATTED "^FO465,265^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */                                                                             
                                                                                                                                                                                 
        ASSIGN i-cont = 0.                                                                                                                                                       
                                                                                                                                                                                 
        FOR EACH it-mod-img-etiq                                                                                                                                                 
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                             
            FIRST imagem-etiq                                                                                                                                                    
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:                                                                      
                                                                                                                                                                                 
            IF i-cont = 0 THEN                                                                                                                                                   
                ASSIGN i-cont = 40.                                                                                                                                              
            ELSE                                                                                                                                                                 
                ASSIGN i-cont = i-cont + 160.                                                                                                                                    
                                                                                                                                                                                 
            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",290^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".                                                                          
        END.                                                                                                                                                                                                                                                                                                                                                          

        IF item-ean.texto[1] <> "" AND item-ean.texto[1] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO20,430^A0N,18,18^FD" (IF item-ean.lmarcador[1] THEN "Ø " ELSE "") + item-ean.texto[1] "^FS" SKIP. /* Sigla */                                    
                                                                                                                                                                                 
        IF item-ean.texto[2] <> "" AND item-ean.texto[2] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO270,430^A0N,18,18^FD" (IF item-ean.lmarcador[2] THEN "Ø " ELSE "") + item-ean.texto[2] "^FS" SKIP. /* Sigla */                                   
                                                                                                                                                                                 
        IF item-ean.texto[3] <> "" AND item-ean.texto[3] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO20,460^A0N,18,18^FD" (IF item-ean.lmarcador[3] THEN "Ø " ELSE "") + item-ean.texto[3] "^FS" SKIP. /* Sigla */                                    
                                                                                                                                                                                 
        IF item-ean.texto[4] <> "" AND item-ean.texto[4] <> ? THEN                                                                                                               
            PUT UNFORMATTED "^FO270,460^A0N,18,18^FD" (IF item-ean.lmarcador[4] THEN "Ø " ELSE "") + item-ean.texto[4] "^FS" SKIP. /* Sigla */                                   
                                                                                                                                                                                 
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
            
                PUT UNFORMATTED "^FO50,490^A0N,16,16^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
        
            END.
        END.   

        PUT UNFORMATTED "^FO547,33^A0N,20,20^FB270,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */                                                       
        PUT UNFORMATTED "^LRY^FO547,28^GB270,0,25^FS^LRN" SKIP.  /* Quadro preto */                                                                                               
        PUT UNFORMATTED "^FO560,65^A0N,12,12^FD" item-ean.char-2 "^FS"                     SKIP.                                                                                 
        PUT UNFORMATTED "^FO560,80^A0N,12,12^FB365,1,0,L^FDCNPJ: " c-cgc "^FS"                 SKIP.                                                                             
        PUT UNFORMATTED "^FO560,095^A0N,12,12^FB365,1,0,L^FD" item-ean.fone "^FS"              SKIP.                                                                             
        PUT UNFORMATTED "^FO680,65^A0N,12,12^FB365,1,0,L^FD" item-ean.origem "^FS"            SKIP.
        PUT UNFORMATTED "^FO740,80^A0N,12,12^FB365,1,0,L^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.                                                                      
        PUT UNFORMATTED "^FO560,110^A0N,12,12^FB365,1,0,L^FD" item-ean.info-tec[1] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,125^A0N,12,12^FB365,1,0,L^FD" item-ean.info-tec[2] "^FS"       SKIP.                                                                             
        
        PUT UNFORMATTED "^FO560,150^A0N,12,12^FB365,1,0,L^FD" item-ean.texto[5] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,170^A0N,12,12^FB365,1,0,L^FD" item-ean.texto[6] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,190^A0N,12,12^FB365,1,0,L^FD" item-ean.texto[7] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,210^A0N,12,12^FB365,1,0,L^FD" item-ean.texto[8] "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO560,230^BY1^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO560,270^A0N,18,16^FB365,1,0,L^FDNS:" num-serie.n-serie "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FO705,40^XGlocal-suframa.GRF^FS" SKIP. 

        PUT UNFORMATTED "^FO765,330^A0B,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */                                                
        PUT UNFORMATTED "^FO785,330^A0B,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/ 

        //Logo Inmetro
        //PUT UNFORMATTED "^FO560,345^GFA,2772,2772,21,,::::::::::::P0FE,O01FF,O03CF,O03C10300CK020C0A601807,O03E00FC3FF79E7F3F8FF8FE1FC,O01FE1CE3DE78E7F738F78EF3CE,P0FF18E78E78E7C038E39E700E,Q0FBFF78E78E783F8E39C01FE,O0387BFF78E78E707B8E39C03CE,O03C7B8078E79E78F38E39E738E,O03FF1CE3FE3DE78F38E39EF39E,O01FF1FE1FE3FE787FCE38FE3FE,P07807800E1CC303986183C1CA,U038EQ03,U03FCR0C,V0F8Q07C,,::::::::::::::J01TFCN03MFC,J01TFCN0EM07,J01TFCM018M018,J01TFCM03K0EI0C,J01TFCM04K0EI02,J01TFCM0CK0EI03,J01TFCL018K0EI018,J01TFCL01L0EJ08,:J01TFCL03L0EJ0C,N01LF8P02L0EJ04,O0LF8P02L0EJ04,O0BKF8P02L0EJ04,O08KF8P02L0EJ04,O087JF8P0207J0EJ04,O081JF8P0207J0EJ04,O080JF8P0207J0EJ04,O0803IF8P02078I0FFI04,O0801IF8P02078I0FFE004,O08007FF8P0207C001IF004,O08003FF8P0207C003E03804,O08001FF8P0207C007E01004,O08I07F8P0207E00FEJ04,O08I03F8P0206600EE1F804,O08J0F8P0206700EE3FE04,O08J078P0206700EE78E04,O08J018P0207380CEFI04,O08K08P0207381CEEI04,O08K08P0206381CECI04,O08K08P02061C1CECI04,:O08K08P02060E1CECI04,O0EK08P02060E1CECI04,O0FK08P0206061CECI04,O0FCJ08P0207071CECI04,O0FEJ08P0207071CECI04,O0FF8I08P0206039CECI04,O0FFCI08P0206039CECI04,O0IFI08P020601CCEEI04,O0IF8008P020601CCE6I04,O0IFE008P020600CCE78604,O0JF808P020600IE3FE04,O0JFC08P020600IE1FC04,O0JFE08P02060077EJ04,O0KF88P02060077E01004,O0KFC8P02060033E03804,O0LF8P02060039IF804,N01LFCP02060038IF004,J01TFCL0206001CFF8004,J01TFCL0206001CEJ04,J01TFCL0206I0CEJ04,J01TFCL0206I0EEJ04,J01TFCL0206I0FEJ04,J01TFCL0206I07EJ04,:J01TFCL0306I03EJ04,J01TFCL0306I03EJ0C,J01TFCL0107I01EJ08,gL0187I01EJ08,gM087I01EI01,gM0C7J0CI03,gM06O06,gM03O0C,gM01CM038,gN078K01E,07F381CE039FE7FF9FE00CM0MF,07F3C1CF079FE7FF9FF07F8,07F3E1CF8F9FE7FF9FF8FFC,01C3F1CF8F9800381C39E1E,01C3F9CFDF9800381C3BC0F,01C3F9CIF9FE0381C73807,01C3BDCEFB9FE0381CE3807,01C39FCE739800381CF3807I0F8F9F079F3C3,01C38FCE739800381C73C0FI0IC9B86DB2C7,01C387CE239800381C79C0EI08D81B84DB1CD,01C387CE039FE0381C39FFEI08D81F04DB0C9,07F383CE039FF0381C3C7FCI0ICD804DB05F8,07F381CE039FE0381C3C3FJ0FCF9807DF7C38,gL0303100306181,,::::::::^FS" SKIP.
      
        PUT UNFORMATTED "~~DGinmetro.GRF,03840,024,,::::M0gWF80,L03FgVFE0,L0F0gV078,K01C0gV01C,K0180gW0C,K030gX06,K070gX07,K060gX03,:K0E0gX0180K0C0gX0180:::::K0C0O0F80gL0180K0C0N03FE0gL0180K0C0N07DE0gL0180K0C0N078E0gL0180K0C0N03E03F8FFBCE7E7F1FE1F87E0L0180K0C0N03FC738E7BCE7E739EF3BCE70L0180K0C0O0FE71DC7BCE7C039C779C070L0180K0C0O01F7FDC7BCE787F9C7780FF0L0180K0C0N078F7FDC7BCE78F39C7780E70L0180K0C0N078E71DE7BCE78E39C779DC70L0180K0C0N03FE7B8FF9FE78F79C73FDEF0L0180K0C0N01FC3F0779FE787B9C71F8F70L0180K0C0T0E780O040O0180K0C0T0HFQ0F0O0180K0C0T07E0O01F0O0180K0C0gX0180::::::::::::::K0C0J0MFC0gK0180K0C0I0380K070L03FRFK0180K0C0I040L0180K07FRF80I0180K0C0I080I0E0H0C0K07FRF80I0180K0C0H010J0E0H060K07FRF80I0180K0C0H030J0E0H020K07FRF80I0180K0C0H020J0E0H010K07FRF80I0180K0C0H040J0E0H0180J07FRF80I0180K0C0H040J0E0I080J07FRF80I0180K0C0H0C0J0E0I080J07FRF80I0180K0C0H080J0E0I080J07FRFK0180K0C0H080J0E0I080N07FJF80M0180K0C0H080J0E0I080N05FJF80M0180K0C0H08180H0E0I080N04FJF80M0180K0C0H081C0H0E0I080N043FIF80M0180K0C0H081C0H0E0I080N040FIF80M0180K0C0H081E0H0HF80080N0407FHF80M0180K0C0H081E0H0HFE0080N0403FHF80M0180K0C0H081E001F9F0080N0400FHF80M0180K0C0H081F003E030080N04007FF80M0180K0C0H081B003E0I080N04003FF80M0180K0C0H081B807E070080N040H0HF80M0180K0C0H081B807E1FC080N040H07F80M0180K0C0H0819C06E78E080N040H01F80M0180K0C0H0819C0EE702080N040I0F80M0180K0C0H0818C0EHEI080N040I0380M0180K0C0H0818E0EHEI080N040I0180M0180K0C0H081860EHEI080N040J080M0180K0C0H081860EEC0H080N040J080M0180K0C0H081870EEC0H080N040J080M0180K0C0H081830EEC0H080N040J080M0180K0C0H081838EEC0H080N070J080M0180K0C0H081838EEC0H080N07C0I080M0180K0C0H08181CEEC0H080N07E0I080M0180K0C0H08181CEHEI080N07F80H080M0180K0C0H08180EIEI080N07FC0H080M0180K0C0H08180E6E60H080N07FE0H080M0180K0C0H0818066E706080N07FF80080M0180K0C0H0818076E3FE080N07FFE0080M0180K0C0H0818076E0FC080N07FHFH080M0180K0C0H081803B60I080N07FHFC080M0180K0C0H081803BE010080N07FHFE080M0180K0C0H081801DE0F8080N07FIFH8N0180K0C0H081801CFHF8080N07FIFC80M0180K0C0H081800CFFE0080N07FJF80M0180K0C0H081800EHEI080N0LF80M0180K0C0H081800EE0I080J07FRF80I0180K0C0H0818006E0I080J07FRF80I0180K0C0H0818007E0I080J07FRF80I0180K0C0H0818003E0I080J07FRF80I0180K0C0H0C18003E0I080J07FRF80I0180K0C0H0C18001E0I080J07FRF80I0180K0C0H0418001E0I080J07FRF80I0180K0C0H0418001E0H010K07FRF80I0180K0C0H02180H0E0H010K07FRFK0180K0C0H02180H0E0H020gJ0180K0C0H01880H040H040gJ0180K0C0I0C0M0C0gJ0180K0C0I060L010gK0180K0C0I0380K0E0gK0180K0C0J07FKF80gK0180K0C0gX0180K0C0V0FE707781CFF7FF3FC0FC00180K0C0V0FE7877C3CFF7FFBFE1FF00180K0C0V0387C77E7CC007038E78700180K0C0V0387E77EFCC007038670380180K0C0H0E1C701863830H0387F77FFCFE07038E60180180K0C003F3EFC3CF6C70H0386F7H7DCFE07039C60180180K0C003320CC2590CF0H03867F739CC007039C60180180K0C0031E0F825918A0H03863F719CC007038E70380180K0C003320F02590DF0H03861F701CC007038E78780180K0C003B36C02C96DF0H0FE60F701CFF07038F3FF00180K0C001E3CC03CF3C30H0FE607701CFF0703871FE00180K0C0V0FE0Y0180K0C0gX0180K060gX0380K060gX03,:K030gX07,K030gX06,K0180gW0C,L0E0gV038,L0780gU0F0,L03FgVFE0,M0gWF80,,:::::::::::::::::::::::^FS" SKIP.
           
        PUT UNFORMATTED "^FT543,490^XGinmetro.GRF,1,1^FS" SKIP.
        PUT UNFORMATTED "^FO585,470^A0N,18,16^FB365,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP.
        PUT UNFORMATTED "^FO585,490^A0N,18,16^FB365,1,0,L^FDData: " STRING(TODAY,'99/99/9999') "^FS" SKIP.

        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */                                                                                             
        PUT "^XZ" SKIP.                                                                                                                                                          
                                                                                                                                                                                 
        IF l-reimp THEN                                                                                                                                                          
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).                                                                                                                       
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
  //  PUT UNFORMATTED "^XA^IDlocal-suframa.GRF^FS^XZ". 

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDinmetro.GRF^FS^XZ".

                                                                                                                                                                                     
END.  /* FIM 631 */

/* ---[ Impress∆o Modelo 632 ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 632 THEN DO:                                                                                                                                                       
                                                                                                                                                                                     
    ASSIGN i-cont = 0.                                                                                                                                                           

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/                                                                                                                  
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:                                                                                                                                                        
        FOR FIRST num-serie NO-LOCK                                                                                                                                              
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:                                                                                                                     
        END.                                                                                                                                                                     
                                                                                                                                                                                 
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/                                                                                                   
                                                                                                                                                                                 
        PUT "^XA" SKIP.                                                                                                                                                          
        PUT UNFORMATTED "^FO55,35,1^A0B,24,22^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */                                                   
        PUT UNFORMATTED "^FO125,35^BY3^BEN,85,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */                                               
        PUT UNFORMATTED "^FO515,35,1^A0B,26,30^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */                                                                                    
        PUT UNFORMATTED "^FO20,200^A0N,35,30^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */                                           
        PUT UNFORMATTED "^FO20,240^A0N,35,30^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */                                             
        PUT UNFORMATTED "^LRY^FO15,160^GB500,0,150^FS^LRN" SKIP.  /* Quadro preto */                                                                                              
        PUT UNFORMATTED "^FO90,330^BY2^BCN,80,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */                                                          
        PUT UNFORMATTED "^FO20,420^A0N,24,24^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
        PUT UNFORMATTED "^FO440,420^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */                                                                             
                                                                                                                                                                                 
        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
            
                PUT UNFORMATTED "^FO40,460^A0N,18,18^FB500,1,0,L^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
                //PUT UNFORMATTED "^FO50,480^A0N,20,20^FB500,1,0,L^FDLegislaá∆o de Inform†tica^FS"       SKIP.
        
            END.
        END.

        ASSIGN i-cont = 0.                                                                                                                                                       

        PUT UNFORMATTED "^FO547,48^A0N,18,18^FB270,1,0,C^FD" "ESPECIFICAÄÂES NOMINAIS" "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO540,30^GB280,0,48^FS^LRN" SKIP.  /* Quadro preto */                                                                                               

        PUT UNFORMATTED "^FO560,240^A0N,14,14^FB365,1,0,L^FDCNPJ: " c-cgc "^FS"                 SKIP.                                                                             
        PUT UNFORMATTED "^FO560,260^A0N,14,14^FB365,1,0,L^FD" item-ean.fone "^FS"              SKIP.                                                                             
                
        PUT UNFORMATTED "^FH^FO560,90^A0N,14,14^FB365,1,0,L^FD"  REPLACE(item-ean.texto[5], "~~":U, "_7e":U) "^FS"       SKIP.                                                                             
        //PUT UNFORMATTED "^FO560,110^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.texto[6], "~~":U, "_7e":U) "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FH^FO560,110^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.texto[6], "~~":U, "_7e":U) "^FS" SKIP.
        PUT UNFORMATTED "^FH^FO560,130^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.texto[7], "~~":U, "_7e":U) "^FS"       SKIP.                                                                             
        PUT UNFORMATTED "^FH^FO560,150^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.texto[8], "~~":U, "_7e":U) "^FS"       SKIP.                                                                            
        PUT UNFORMATTED "^FH^FO560,170^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.texto[9], "~~":U, "_7e":U) "^FS"       SKIP.                                                                            
        PUT UNFORMATTED "^FH^FO560,190^A0N,14,14^FB365,1,0,L^FD" REPLACE(item-ean.texto[10], "~~":U, "_7e":U) "^FS"       SKIP.                                                                            

        PUT UNFORMATTED "^FO700,190^A0R,20,20^FB500,1,0,C^FD"    caps(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO690,325^GB20,210,50^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO600,340^BY1^BCR,60,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */                                                          
        PUT UNFORMATTED "^FO575,180^A0R,16,15^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             

        PUT UNFORMATTED "^FO768,330^A0B,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */                                                
        PUT UNFORMATTED "^FO785,330^A0B,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/ 

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */                                                                                             
        PUT "^XZ" SKIP.                                                                                                                                                          
                                                                                                                                                                                 
        IF l-reimp THEN                                                                                                                                                          
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).                                                                                                                       
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
  //  PUT UNFORMATTED "^XA^IDlocal-suframa.GRF^FS^XZ".                                                                                                                             
                                                                                                                                                                                     
END.  /* FIM 632 */

/*N serie com arte*/
IF  p-cod-modelo = 800 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FOR EACH tt-lista-ns:
        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        PUT "^XA" SKIP.
        PUT UNFORMATTED "^FO40,20,1^A0B,17,17^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
       // PUT UNFORMATTED "^FO50,20^BY3,^BCN,30,N,N ^FD>;" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO78,20^BY3^BEN,30,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
       // PUT UNFORMATTED "^FO140,60^A0,20,20^FD" item-mat.cod-ean "^FS" SKIP. /* Imprime cÆdigo do item */

        PUT UNFORMATTED "^FO390,20,1^A0B,17,17^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FO40,90^A0N,18,18^FB320,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO40,110^A0N,18,18^FB320,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO20,85^GB370,0,50^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO30,140^BY2^BCN,20,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO150,165^A0,17,15^FDNS:" num-serie.n-serie "^FS" SKIP. /* Imprime cÆdigo do item */

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = "104" NO-ERROR.

        PUT UNFORMATTED "^FO20,185^A0N,17,15^FD" "Distribu°do por: Intelbras S/A " "^FS" SKIP.
        PUT UNFORMATTED "^FO20,205^A0N,17,15^FD" "Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira" "^FS" SKIP.
        PUT UNFORMATTED "^FO20,225^A0N,17,15^FD" estabelec.endereco + " - " + estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + "^FS" SKIP.
        PUT UNFORMATTED "^FO20,245^A0N,17,15^FD" "CEP:" STRING(estabelec.cep) "   CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
        PUT UNFORMATTED "^FO455,125^A0N,17,15^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.    

        /*Decio*/
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-ERROR.

        IF  item-ean.char-2 = "Fabricado por:"
        AND item-ean.char-3 = estabelec.cgc  THEN DO:

            PUT UNFORMATTED "^FO20,265^A0N,17,15^FD" "Fabricado por:" "^FS" SKIP.    /* Quantidade */
            PUT UNFORMATTED "^FO125,265^A0N,17,15^FD" "DÇcio Ind£stria Metal£rgica LTDA." "^FS" SKIP.  

            PUT UNFORMATTED "^FO455,185^A0N,17,15^FD" "Fabricado por: DÇcio Ind£stria Metal£rgica LTDA." "^FS" SKIP.
            PUT UNFORMATTED "^FO455,205^A0N,17,15^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.

            PUT UNFORMATTED "^FO20,285^A0N,17,15^FD" "CNPJ:" "^FS" SKIP.  
            PUT UNFORMATTED "^FO70,285^A0N,17,15^FD" string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.    
             
        END.

        PUT UNFORMATTED "^FO260,285^A0N,17,15^FD" "Ind£stria Brasileira" "^FS" SKIP.

        /*Coluna 2*/
        PUT UNFORMATTED "^FO470,40^A0N,18,18^FB320,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO470,60^A0N,18,18^FB320,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO450,30^GB370,0,50^FS^LRN" SKIP.  /* Quadro preto */
        PUT UNFORMATTED "^FO810,90,1^A0B,17,17^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FO455,85^A0N,17,15^FD" "Distribu°do por: Intelbras S/A Ind£stria" "^FS" SKIP.    
        PUT UNFORMATTED "^FO455,105^A0N,17,15^FD" "de Telecomunicaá∆o Eletrìnica Brasileira" "^FS" SKIP.    
        
        PUT UNFORMATTED "^FO455,145^A0N,17,15^FD" "Ind£stria Brasileira" "^FS" SKIP.  
        PUT UNFORMATTED "^FO455,165^A0N,17,15^FD" item-ean.fone "^FS" SKIP.  

      //  PUT UNFORMATTED "^FO460,220^BY4^BCN,50,N,N^FD>;" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
       // PUT UNFORMATTED "^FO535,220^BY1^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO450,220^BY2^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

        PUT UNFORMATTED "^FO530,275^A0,25,25^FDNS:" num-serie.n-serie "^FS" SKIP. /* Imprime cÆdigo do item */

      //  PUT UNFORMATTED "^FO810,220,1^A0B,17,17^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO810,150,1^A0B,17,17^FD" STRING(num-serie.data, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        
        PUT UNFORMATTED "^XZ".

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

         IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
        
    END.

    PUT UNFORMATTED
         "^PQ" STRING(1, "99999") SKIP  /* RepetiªÑes */.
END.

/*dun 14*/
IF  p-cod-modelo = 801 THEN DO:
    PUT UNFORMATTED
         "^XA"         SKIP   
         "^PW850"      SKIP   
         "^JUS"        SKIP   
         "^LL296"      SKIP   
         "^MNY"        SKIP   
         "^FWN"        SKIP.  

    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    DO i-cont = 1 TO p-qtd-etiquetas:
        FOR FIRST item-dun NO-LOCK
            WHERE item-dun.it-codigo = p-it-codigo
              AND item-dun.qtd-emb   = p-qtd-embalagem:
    
            PUT "^XA" SKIP.
            PUT UNFORMATTED "^FO60,30,1^A0B,23,23^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
            PUT UNFORMATTED "^FO70,30^BY3,^BCN,50,Y,N ^FD>;" string(item-dun.cod-dun) "^FS" SKIP.  /* Codigo de Barras EAN 13 */
            PUT UNFORMATTED "^FO435,30,1^A0B,23,23^FD" item-ean.it-codigo "^FS" SKIP. 
    
            PUT UNFORMATTED "^FO80,125^A0N,25,25^FB320,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO80,155^A0N,25,25^FB320,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO40,120^GB390,0,60^FS^LRN" SKIP.  /* Quadro preto */
    
            PUT UNFORMATTED "^FO255,185^A0N,25,25^FB150,1,0,R^FDQtd. " string(item-dun.qtd-emb) "^FS" SKIP.    /* Quantidade */
    
            /*Decio*/
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
                    
            IF  item-ean.char-2 = "Fabricado por:"
            AND item-ean.char-3 = estabelec.cgc  THEN DO:
                PUT UNFORMATTED "^FO40,230^A0N,20,20^FD" "Fabricado por: DÇcio Ind£stria Metal£rgica LTDA." "^FS" SKIP.    /* Quantidade */
                PUT UNFORMATTED "^FO40,250^A0N,20,20^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.  
            END.

            /*Matrioz*/
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = "104" NO-ERROR.
    
            PUT UNFORMATTED "^FO40,270^A0N,20,20^FD" "Distribu°do por: Intelbras S/A Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira" "^FS" SKIP.
            PUT UNFORMATTED "^FO40,290^A0N,20,20^FD" estabelec.endereco + " - " + estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + " - " + STRING(estabelec.cep) + "^FS" SKIP.
            PUT UNFORMATTED "^FO40,310^A0N,20,20^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
            PUT UNFORMATTED "^FO40,330^A0N,20,20^FD" "Ind£stria Brasileira" "^FS" SKIP.
            PUT UNFORMATTED "^FO560,340^A0N,20,20^FD" "www.intelbras.com.br" "^FS" SKIP.
    
            PUT UNFORMATTED "^FO455,30^A0N,20,20^FD" item-ean.fone "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,50^A0N,20,20^FD" "Suporte via chat:" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,70^A0N,20,20^FD" "intelbras.com.br/suporte-tecnico" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,90^A0N,20,20^FD" "Suporte via e-mail" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,110^A0N,20,20^FD" "suporte@intelbras.com.br" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,130^A0N,20,20^FD" "F¢rum: forum.intelbras.com.br" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,150^A0N,20,20^FD" "SAC: 0800 7042767" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,170^A0N,20,20^FD" "Onde comprar? Quem Instala?:" "^FS" SKIP.  
            PUT UNFORMATTED "^FO455,190^A0N,20,20^FD" "0800 7245115" "^FS" SKIP.  
            
            PUT UNFORMATTED "^XZ".    
            
        END.
    
        PUT UNFORMATTED
             "^PQ" STRING(1, "99999") SKIP  /* RepetiªÑes */.
    END.
END.

/*complementar*/
IF p-cod-modelo = 802 THEN DO:
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    FIND FIRST param-global NO-LOCK NO-ERROR.

    RUN piCargaImagem("local-logo").
    PUT UNFORMATTED "~~DGrede_social.GRF,03456,036,,:::::H010,H05410O010L0410gH0140R010H04,H0HE080N0280020H0620gI0C0R020H0C,01450P010H010H0410gH014,01830P0380030H0230gH018,0140105415005401H1454504150545454011415150044541545415005415054115045410H0E008EE2E80EE028EE6CEC62ECECECEE00EE2E8EC06EHE2ECEE6E80EE2E8EE20E8C6E,H054114411004401144114H4H1H41044501445110405044514I410044114451H1I4H10H03B19820180020398231822308A008B00186039C003083318837800E030C8030188F0,I05110405001401144115441044054540104151500515H515H5140054404401054454,I0208862E80EE028C620EE620CE0EC6E00862E8EC060EE60CEE2E806E60CC020ECC6E,0101H10451004401144110041044104050104510140514051440050014504401H1H405,018319823180820398231802388A38H8301822398A030823188221808331883H318H83,0155115451004401144154H415441144501045110405044114H4510044110551H1I4510H0HE08EE2E80EE028C62CEC62E8E0EC6E00866E8EC0606E2EC6E2E00EE2E86E22ECC6E,H05410041540510114414504150404414010411050050101441414005404014114H41410K0102,K0144,L0HE,L054,,:::::02ELEC06ELE80EMEH0NE0,015L5405M5H0N5015L540,03BLB803BLB80BMB01BLBA0,015L5405M5H0N5015L540,02ELEC06ELE80EMEH0NE0,015I5405405M5H0N5015L540,03FBFBC07803FBFBFBF80BFBFBFBF01B83FBFBE0,015I5H05405M5H0J5415501505J540,02EIE86EC06ELE80EIE806E00E86EJE0,015I505540550I015005455005501505J540,03BIB83B803B0I01B80B83B003B01BLBA0,015I505540540I0150054050055015L540,02EIE86EC06E0J0E80EE0I0HEH0E860C0EE0,015H54005405401001500550I0H5015050H0540,03BBF8007803E01A01B80B80I0BF01B830H0BA0,015H54005405401501500540I0H5015050H0540,02EIE86EC06E00E00E80EE0I0HEH0E860606E0,015I5055405401001500550H015501505050540,03BIB83B803A0I01B80BB0H03BB01B830B83A0,015I505540540I01500550H015501505050540,02EIE86EC06E0J0E80EHEH06EE00E860E86E0,015I505540550I01500554005H501505050540,03FBFB83F803F80H0BF80BC003FBF01B830B83E0,015I5055405M5H0H5H0J501505050540,02EIE86EC06ELE80EMEH0E860E86E0,015I5055405M5H0N501505050540,03BIB83B803BLB80BMB01BLBA0,015L5405M5H0N5015L540,02ELEC06ELE80EMEH0NE0,015L5405M5H0N5015L540,03BBFBHBF803FBHBFBB80BHBFBHBF01BFBHBFBA0,,:::::::S040H04001140X040,S0C0H0C0028C0X0E0,V014001140X040,V018003980X0A0,0104545151040445141411541454150014150545005511,H08E6E62A28C0C6EAE6E28EE2E6E2E806E2ECEHE80EE0E,0114H451H1H404511441H1451045110041H1H451004114,019A623I398082398A3398330033800C030CA3180A198,H054H451H1500441145511451015150040504411004110,H0CAC6CE0AC80C628CEEA8C6206E0E80C060EE2080E088,H051415414500441144011451045010040504411004110,H0B3839A1A3808239823398330833180A3308A3180A398,H051010404510441145511441045110455154411045510,H062828E0E608C628E2E28AE20EE2E8C6E0E8E208CEE08,,::::::::::" SKIP.

    DO i-cont = 1 TO p-qtd-etiquetas:
        
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.
        
        PUT "^XA" SKIP.

        //PUT UNFORMATTED "^FO30,20^XGlocal-logo.GRF^FS" SKIP.  /* Impressao da Imagem IntelBras */
        PUT UNFORMATTED "^FO30,05^GFA,3450,3450,46,,::::::::::::I01F8,I07FET01FFX03FE00FF8,I0IFT0IFW01FFE07FF8,I0IFS01IFW01FFE07FF8,001IF8R01IFW01FFE07FF8,::I0IFS01IFW01FFE07FF8,:I07FES01IFW01FFE07FF8,I01F8S01IFW01FFE07FF8,Y01IFW01FFE07FF8,:K0FL07EK01KFEL01F8K01FFE07FF801FCQ0FCK01FCO07KF,I03FFK0JFJ01KFEK03IFCJ01FFE07FF83IFCN01IFCI03IFEM07LF8,I0IFJ03JFCI01KFEJ01KF8I01FFE07FF9KF8M0KF801KFCK01MF,I0IFJ0LF8001KFEJ07KFEI01FFE07NFEL03KF807LFK03MF,I0IFI03LFC001KFEI01MF8001FFE07OF8K07KF01MFCJ0NF,I0IFI07MF001KFEI07MFC001FFE07OFEJ01KFE03MFEI01NF,I0IF001NF801KFCI0OF001FFE07PFJ03KFC07NFI01NF,I0IF003NFC01KFC001OF801FFE07PF8I07KF80OF8003NF,I0IF003NFE01KFC003OFC01FFE07PFCI0LF81OFC007MFE,I0IF007NFE01KFC007OFE01FFE07PFE001LF03OFE007MFE,I0IF00PF01KF800PFE01FFE07QF001KFE07PF007MFE,I0IF01JF00JF81IFK0JF801JF01FFE07JF801JF003IFCI0JFC01JF80IFC,I0IF01IFC003IF81IFJ01IFE001JF81FFE07IFEI07IF803IFJ0IFEI03IF80IF8,I0IF01IF8I0IF81IFJ03IF8003IFE01FFE07IF8I01IFC07FFEI01IFCI01IFC0IF8,I0IF03IFJ0IFC1IFJ03IFI0JFC01FFE07IFK0IFC07FFCI01IF8J0IFC0IF8,I0IF03FFEJ07FFC1IFJ03FFE001JF001FFE07FFEK07FFC07FFCI03IFK07FFE0IF8,I0IF03FFCJ03FFC1IFJ07FFC007IFE001FFE07FFEK03FFE0IF8I03FFEK03FFE07FFC,I0IF03FFCJ03FFC1IFJ07FFC00JF8001FFE07FFCK03FFE0IF8I03FFCK03FFE07KFE,I0IF03FFCJ03FFC1IFJ07FF803JFI01FFE07FFCK01FFE0IFJ07FFCK01IF03LFE,I0IF03FFCJ03FFC1IFJ07FF807IFCI01FFE07FF8K01FFE0IFJ07FFCK01IF03MFC,I0IF03FFCJ03FFC1IFJ07FF81JF8I01FFE07FF8K01FFE0IFJ07FFCK01IF01MFE,I0IF03FFCJ03FFC1IFJ07FF83IFEJ01FFE07FF8K01FFE0IFJ07FF8K01IF00NF,I0IF03FFCJ03FFC1IFJ07FF8JFCJ01FFE07FF8K01FFE0IFJ07FF8K01IF007MF8,I0IF03FFCJ03FFC1IFJ07FFBJFK01FFE07FF8K01FFE0IFJ07FFCK01IF003MFC,I0IF03FFCJ03FFC1IFJ07LFCK01FFE07FF8K01FFE0IFJ07FFCK01IFI0MFE,I0IF03FFCJ03FFC1IFJ07LF803F801FFE07FFCK03FFE0IFJ03FFCK01IFI03LFE,I0IF03FFCJ03FFC0IFJ07KFE003FF01FFE07FFCK03FFE0IFJ03FFEK03IFM07IF,I0IF03FFCJ03FFC0IFJ07KFC007FFC1FFE03FFEK07FFE0IFJ03FFEK03IFM01IF,I0IF03FFCJ03FFC0IF8I03KFI0IFC1FFE03IFK0IFC0IFJ03IFK07IFN0IF,I0IF03FFCJ03FFC0IFCI03JFE001IF81FFE03IF8I01IFC0IFJ01IF8J0JFN0IF,I0IF03FFCJ03FFC07FFEI01JF8003IF81FFE01IFCI03IF80IFJ01IFEI03JFN0IF,I0IF03FFCJ03FFC07IFI01JF800JF01FFE01JFI0JF80IFK0JFI07JFM01IF,I0IF03FFCJ03FFC03IFE040JFE07JF01FFE00JFE07JF00IFK0JFE03KFM03IF,I0IF03FFCJ03FFC03KFE07OFE01FFE007OFE00IFK07QF01OF,I0IF03FFCJ03FFC01LF07OFC01FFE003OFE00IFK03QF01NFE,I0IF03FFCJ03FFC00LF03OF801FFE001OFC00IFK01QF01NFE,I0IF03FFCJ03FFC007KF81OF001FFEI0OF800IFL0QF03NFC,I0IF03FFCJ03FFC003KFC07MFE001FFEI07MFEI0IFL07PF03NFC,I0IF03FFCJ03FFC001KFE03MF8001FFEI03MFCI0IFL01PF03NF8,I0IF03FFCJ03FFCI0LF00MFI01FFEJ0MFJ0IFM0PF03NF,I0IF03FFCJ03FFCI03KF803KFCI01FFEJ03KFEJ0IFM03OF03MFC,I0IF03FFCJ03FFCJ0JFEI0KFJ01FFEK0KFK0IFN0KF1IF03MF8,I0IF03FFCJ03FFCK0IFK0IFK01FFEL0IFL0IFO0IF81IF03LFC,,:::::^FS" SKIP.
        //PUT UNFORMATTED "^FO30,20^GFA,5352,5352,12,,:::::Y03E,07TFE00FF8,07TFE01FFE,07UF03IF,07UF07IF,07UF0JF8,:07UF8JF8,:::::07UF87IF,07UF83IF,07UF81FFE,07UF80FF8,Y03E,,::::07OFE,07PFC,07QF8,07QFE,07RF,07RFC,07RFE,07SF,07SF8,07SFC,07SFE,07TF,07TF8,:07TFC,:Q0KFE,Q01JFE,R0KF,R07JF,R03JF,R01JF8,S0JF8,:S07IF8,:::::::S0JF8,::R01JF8,R03JF,R07JF,R0KF,Q03JFE,P03KFE,07TFC,:07TF8,07TF,:07SFE,07SFC,07SF8,07SF,07RFE,07RF8,07RF,07QFC,07QF,07PF8,07OF8,,::::M0TFC,L07TFC,K03UFC,K0VFE,J03VFE,J07VFE,J0WFE,I03WFE,I07XF,I0YF,:001YF,003YF,007YF,:00gF,00KFEK07IF8,01KFL07IF8,01JFCL07IF8,01JF8L07IF8,03JFM07IF8,:03IFEM07IF8,03IFCM07IF8,07IFCM07IF8,::07IF8M07IF8,07IF8M03IF8,07IF8O0FF8,07IFC,::03IFC,03IF8,03FFE,03FF8I07F8,01FFI07IFC,01FE003KF8,01F801LFE,00F007MF8,00E00NFE,00403OF,J07OFC,J0PFE,I01QF,I03QF8,I07QFC,I0RFC,001RFE,001SF,003SF8,007LF3LF8,007KFE01KFC,00MF007JFC,00MF001JFE,01MF800JFE,01MFC007IFE,01MFE003JF,03MFE003JF,03NF001JF,03NF800JF8,03IFCJFC00JF8,03IFC7IFE00JF8,07IFC7IFE007IF8,07IFC3JF007IF8,07IF81JF807IF8,07IF80JFC07IF8,:07IF807IFE07IF8,07IF803JF07IF8,07IFC01JF87IF8,07IFC00JF87IF8,03IFC00JFCJF8,03IFE007IFEJF8,03IFE003NF8,03JF001NF,01JF001NF,01JF800NF,01JFC007LFE,00JFE003LFE,00KF003LFE,007JFC01LFC,007KF80LFC,003KF807KF8,003KF807KF,001KF803KF,I0KF801JFE,I07JF800JFC,I03JF8007IF8,I03JFI07IF8,J0JFI03FFE,J07IFI01FFC,J03IFJ0FF8,J01FFEJ0FF,K07FEJ07C,K01FEJ03,L07C,L01C,,::::07YFC,::07YFE,::::07gF,:::::::,:::::N03RFC,M0TFC,L03TFC,K01UFE,K07UFE,K0VFE,J03VFE,J07VFE,J0XF,I01XF,I03XF,I07XF,I0YF,001YF,:003YF,007LF7LFDJFE,007KF001KFC,00KFCI07JFC,00KFJ01JFE,01JFEK0JFE,01JFCK07IFE,01JF8K03JF,03JFL03JF,03IFEL01JF,03IFEM0JF8,03IFCM0JF8,:07IFCM07IF8,:07IF8M07IF8,::::07IFCM07IF8,:03IFCM0JF8,03IFEM0JF8,:03JFL01JF,03JFL03JF,01JF8K07JF,01JFCK07IFE,00JFEJ01JFE,00KFJ03JFE,00KFCI07JFC,007KF803KFC,007SF8,003SF,001SF,001RFE,I0RFC,I07QF8,I03QF,I01PFE,J0PFC,J07OF8,J01OF,K0NFC,K03MF8,L0LFE,L03KF,M03IF8,,::::07OF,07PF8,07QF,07QFC,07RF,07RF8,07RFE,07SF,07SF8,07SFC,07SFE,07TF,:07TF8,07TFC,:P03KFE,Q03JFE,R0JFE,R07JF,R03JF,R01JF,R01JF8,S0JF8,:S07IF8,:::::::S0JF8,:S01IF8,O0CJ07FF,M07IF8003FF,L03KF801FF,L0LFE007E,K03MF803E,K0NFE01C,J01OF00C,J07OF8,J0PFE,I01QF,I03QF8,I07QFC,I0RFC,001RFE,001SF,003SF8,007SF8,007KF003KFC,00KFCI07JFC,00KFJ03JFE,01JFEK0JFE,01JFCK07IFE,01JF8K03JF,03JFL03JF,03JFL01JF,03IFEM0JF8,:03IFCM0JF8,07IFCM07IF8,:07IF8M07IF8,::::07IFCM07IF8,:03IFCM0JF8,03IFEM0JF8,:03JFL01JF,03JFL03JF,01JF8K03JF,01JFCK07IFE,01JFEK0JFE,00KFJ03JFE,00KFCI07JFC,007KF003KFC,07TF8,:07TF,07SFE,07SFC,:07SF8,07SF,07RFE,07RF8,07RF,07QFE,07QF8,07PFE,07PF8,07OF8,,::::Q01F8,P01IF8,07FCL07IFE,07FFEJ01KF8,07IF8I03KFC,07IF8I0LFE,07IF8001MF,07IF8001MF8,07IF8003MFC,07IF8007MFC,07IF8007MFE,07IF800NFE,07IF800OF,07IF801OF,07IF801OF8,:07IF803JF3JF8,07IF803IFC0JF8,07IF803IF80JF8,07IF803IF807IF8,07IF803IF007IF8,:::::::::::07IFC03IF007IF8,07IFE07IF007IF8,07JF1JF007IF8,03OF007IF8,:03NFE007IF8,:01NFE007IF8,01NFC007IF8,00NF8007IF8,007MF8007IF8,007MFI07IF8,003LFEI01IF8,001LFCK0FF8,I0LF8,I03KF,I01JFC,J07IF,K07F8,,:::^FS" SKIP.
        PUT UNFORMATTED "^FO30,80^A0N,20,18^FDEsta embalagem contÇm:^FS" SKIP.

        ASSIGN i-linha-conteudo = 100.
        DO i-conteudo = 1 TO NUM-ENTRIES(item-ean.desc-kit,";"):
            PUT UNFORMATTED "^FO30," STRING(i-linha-conteudo) "^A0N,17,15^FD" ENTRY(i-conteudo,item-ean.desc-kit,";") "^FS"            SKIP.

            ASSIGN i-linha-conteudo = i-linha-conteudo + 15.

        END.

        PUT UNFORMATTED "^FO490,20^A0N,22,20^FDSuporte a cliente: (48) 2106 0006^FS" SKIP.
        PUT UNFORMATTED "^FO490,40^A0N,22,20^FDSuporte via chat: ^FS"                SKIP.
        PUT UNFORMATTED "^FO490,60^A0N,22,20^FDintelbras.com.br/suporte-tecnico^FS"  SKIP.
        PUT UNFORMATTED "^FO490,80^A0N,22,20^FDSuporte via e-mail: ^FS"              SKIP.
        PUT UNFORMATTED "^FO490,100^A0N,22,20^FDsuporte@intelbras.com.br^FS"         SKIP.
        PUT UNFORMATTED "^FO490,120^A0N,22,20^FDF¢rum:forum.intelbras.com.br^FS"     SKIP.
        PUT UNFORMATTED "^FO490,140^A0N,22,20^FDSAC:0800 7042767^FS"                 SKIP.
        PUT UNFORMATTED "^FO490,160^A0N,22,20^FDOnde comprar? Quem instala?^FS"      SKIP.
        PUT UNFORMATTED "^FO490,180^A0N,22,20^FD0800 7245115^FS"                     SKIP.

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.

        IF  AVAIL ITEM THEN DO:

            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.

            IF  AVAILABLE int-portaria-movto THEN DO: 
                PUT UNFORMATTED "^FO490,220^A0N,22,20^FDEste produto Ç beneficiado^FS" SKIP.
                PUT UNFORMATTED "^FO490,240^A0N,22,20^FDpela Legislaá∆o de Inform†tica^FS" SKIP.
            END.
        END.

        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel = "104" NO-ERROR.
        
        PUT UNFORMATTED "^FO490,265^XGrede_social.GRF,1,1^FS" SKIP.
        PUT UNFORMATTED "^FO30,220^A0N,20,17^FD" "Distribuido por: INTELBRAS S/A." "^FS" SKIP.
        PUT UNFORMATTED "^FO30,240^A0N,20,17^FD" "Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira" "^FS" SKIP.
        PUT UNFORMATTED "^FO30,260^A0N,20,17^FD" + estabelec.endereco + " - " + estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + "^FS" SKIP.
        PUT UNFORMATTED "^FO30,280^A0N,20,17^FD" + string(estabelec.cep) + " - CNPJ " + string(estabelec.cgc, param-global.formato-id-federal) + " - Ind£stria Brasileira ^FS" SKIP.

        /*Decio*/
        FIND FIRST estabelec NO-LOCK
             WHERE estabelec.cod-estabel =  v_cod_estab_usuar NO-ERROR.
                
        IF  item-ean.char-2 = "Fabricado por:" 
        AND item-ean.char-3 = estabelec.cgc  THEN DO:
            PUT UNFORMATTED "^FO30,300^A0N,20,17^FD" "Fabricado por: DÇcio Ind£stria Metal£rgica LTDA." "^FS" SKIP.
            PUT UNFORMATTED "^FO30,320^A0N,20,17^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.  
        END.
        
        PUT UNFORMATTED "^FO30,340^A0N,20,17^FD" "PRAZO DE VALIDADE: " CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO30,360^A0N,20,17^FD" "COMPOSIÄ«O: " CAPS(item-ean.texto[14]) CAPS(item-ean.texto[15]) "^FS" SKIP.
        
        
        PUT "^PQ" STRING(1, "99999") SKIP. /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.
END.

/*Etiqueta decio impressa pelo escpp166*/
IF  p-cod-modelo = 803 THEN DO:

    FIND FIRST ord-prod NO-LOCK
         WHERE ord-prod.nr-ord-prod = i-nr-ord-prod-escpp166
           AND ord-prod.it-codigo   = p-it-codigo NO-ERROR.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF NOT AVAIL ord-prod THEN DO:
        /*
        MESSAGE PROGRAM-NAME(1) skip
                PROGRAM-NAME(2) skip
                PROGRAM-NAME(3) skip
                PROGRAM-NAME(4) skip
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
        
        IF index(PROGRAM-NAME(1),'piImpTeste') = 0  AND 
           index(PROGRAM-NAME(2),'piImpTeste') = 0  AND 
           index(PROGRAM-NAME(3),'piImpTeste') = 0  AND    
           index(PROGRAM-NAME(4),'piImpTeste') = 0 THEN
        DO:
            RUN piGeraErro (INPUT 17006,
                            INPUT "Ordem de produá∆o n∆o encontrada, ordem " + STRING(i-nr-ord-prod-escpp166) + " com item " + p-it-codigo).
            RETURN "NOK".
        END.
    END.
    
    IF AVAIL ord-prod THEN
    DO:
        FIND FIRST ped-venda NO-LOCK
             WHERE ped-venda.nr-pedido = INT(ord-prod.nr-pedido) NO-ERROR.

        FIND FIRST int-ped-venda no-lock
             WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-ERROR.
    
    
        FIND FIRST item-cli NO-LOCK
             WHERE item-cli.it-codigo  = ord-prod.it-codigo
               AND item-cli.nome-abrev = ped-venda.nome-abrev NO-ERROR.
    END.

    FIND FIRST item-mat NO-LOCK
         WHERE item-mat.it-codigo = p-it-codigo NO-ERROR.

    
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    DO i-cont = 1 TO 1:
        
        FOR FIRST item-dun NO-LOCK
            WHERE item-dun.it-codigo = p-it-codigo:
        END.

       /* IF AVAIL item-dun THEN
            ASSIGN p-qtd-embalagem = item-dun.qtd-emb.
        ELSE
           IF AVAIL ord-prod THEN
              ASSIGN p-qtd-embalagem = ord-prod.qt-ordem. 

        IF AVAIL ord-prod THEN
            ASSIGN i-qt-imprimir = ord-prod.qt-ordem.
        
        IF AVAIL item-dun THEN DO:
            ASSIGN i-qtd-vol = TRUNCATE(i-qt-imprimir / p-qtd-embalagem,0).

            IF i-qt-imprimir MOD p-qtd-embalagem <> 0 THEN
                ASSIGN i-qtd-vol = i-qtd-vol + 1.
        END.
        ELSE 
          IF AVAIL ord-prod THEN
             ASSIGN i-qtd-vol = ord-prod.qt-ordem.    */

        ASSIGN i-qt-imprimir = p-qtd-etiquetas
               i-qtd-vol     = TRUNCATE(i-qt-imprimir / p-qtd-embalagem,0).

        IF i-qt-imprimir MOD p-qtd-embalagem <> 0 THEN
            ASSIGN i-qtd-vol = i-qtd-vol + 1.

         // Impressao Teste
        IF i-nr-ord-prod-escpp166 = 0 AND i-qtd-vol = 0 THEN
           ASSIGN i-qtd-vol = 1.                        

        DO i-cont-2 = 1 TO i-qtd-vol:
            
            PUT "^XA" SKIP.
            PUT UNFORMATTED "^FO40,115,1^A0B,25,25^FD" STRING(TODAY, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */
            //PUT UNFORMATTED "^FO50,115^BY3,^BCN,40,Y,N ^FD>;" string(item-mat.cod-ean) "^FS" SKIP.  /* Codigo de Barras EAN 13 */
            PUT UNFORMATTED "^FO80,115^BY3^BEN,35,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */

            PUT UNFORMATTED "^FO415,115,1^A0B,25,25^FD" item-ean.it-codigo "^FS" SKIP. 

            IF AVAIL item-cli THEN
                PUT UNFORMATTED "^FO40,250,1^A0B,25,25^FD" item-cli.item-do-cli "^FS" SKIP.

            /*Logo DÇcio*/
            PUT UNFORMATTED "^FO30,5^GFA,03072,03072,00024,:Z64:eJzt1c1u00AQAODxj+IthKwDEeqlta1UHDi1Fw4ccBX1FbijPgheFB/yLDwEMhLiOVY8APIxQtTLzM6mSeyN1B6LMoc6+TxZ765npwDHeFJhjFnvfn+r7t00eA2clztOP4jU0P/iNWmGbvCaaY/j58rnOIbpjdPhVNACAwOnMaKut66On5msfd5Coj0uW4iaA648nrQwCOv9hzqPDrs0OJY0mtZV0b44rwx+qHBnSxUYynFOm4fQoSd249kj2jz6gy7pdt9VqTL7Qtjxt0Ynd3em2XeJD9S47BK91IATct6C1FJDRt5Ade+4061s8Ca6okX0vMlUhRu/41Gbcf6uI+1580CPwe9UJ58f5FjVzrueH8wv/f648cF+88zT48me83p/73nSbvLB1ufWM5dPIcntQyi/7+3AMy17+Wrr9v3ue6X5vWvrXA9gzy+eGHauE6wf7gN4YmQr11w/tt64b3B9mo9Gb+qTnUpZ26K23m36T0AUcJ3zuXD9yjYbPhfRBqjFZJSTIZR0G+ErBk32G0455KYS/Rke2/8+cgip9ccAp2O+Qug85IzTCXm8dffPYjYGYfN5nMv3sFx+UROYvZ48m8T58zCcYDctVp/SOh/dTGE2uxJQFyfiejq+hkIs0joc3Rbq5bsCfS5Wi3zlPIjhBby6KMSoLkAs8oRd/YqhUNM3uUjrQqCLhj2P4xymN/lJavPBjnOb1vOLsFDpzwJ9jvlX1j+Mlt9/wBmk9flI1meQLM5xfE94EUAccKkeu/fHOMYTjX/s9s/G:E43D^PQ1,0,1,Y^FS" SKIP.
    
            PUT UNFORMATTED "^FO60,200^A0N,25,25^FB320,1,0,C^FD"  caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^FO60,230^A0N,25,25^FB320,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
            PUT UNFORMATTED "^LRY^FO50,195^GB330,0,60^FS^LRN" SKIP.  /* Quadro preto */

            //IF AVAIL item-dun THEN
            //    PUT UNFORMATTED "^FO50,265^BY3,^BCN,40,Y,N ^FD>;" string(item-dun.cod-dun) "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    
            /*Decio*/
            FIND FIRST estabelec NO-LOCK
                 WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-ERROR.

            FIND FIRST unid-feder NO-LOCK
                 WHERE unid-feder.estado = estabel.estado NO-ERROR.
    
            IF AVAIL item-dun THEN DO:
                PUT UNFORMATTED "^FO490,335^A0N,25,25^FD" "Volume:" + string(i-cont-2) + "/" + string(i-qtd-vol)  "^FS" SKIP.

            
                IF i-qt-imprimir >= p-qtd-embalagem THEN DO:
                    PUT UNFORMATTED "^FO390,335^A0N,25,25^FD" p-qtd-embalagem "Pás^FS" SKIP.
                    ASSIGN i-qt-imprimir = i-qt-imprimir - p-qtd-embalagem.
                END.
                ELSE DO:
                    IF i-nr-ord-prod-escpp166 = 0 THEN // Impressao Teste
                       PUT UNFORMATTED "^FO390,335^A0N,25,25^FD" p-qtd-embalagem "Pás^FS" SKIP.
                    ELSE
                       PUT UNFORMATTED "^FO390,335^A0N,25,25^FD" i-qt-imprimir "Pás^FS" SKIP.
                END.
            END.
            ELSE IF AVAIL ord-prod THEN DO:
                IF p-qtd-embalagem = 1 
                THEN PUT UNFORMATTED "^FO390,335^A0N,25,25^FD" p-qtd-embalagem   "Pás^FS" SKIP.
                ELSE PUT UNFORMATTED "^FO390,335^A0N,25,25^FD" ord-prod.qt-ordem "Pás^FS" SKIP.
            END.

            IF AVAIL ord-prod THEN
               FIND LAST movto-estoq OF ord-prod NO-LOCK NO-ERROR.
                
            PUT UNFORMATTED "^FO460,20^A0N,20,20^FD" item-ean.char-2 "^FS" SKIP.  
            PUT UNFORMATTED "^FO460,40^A0N,20,20^FD" estabelec.nome "^FS" SKIP.  
            PUT UNFORMATTED "^FO460,60^A0N,20,20^FD" estabelec.endereco "^FS" SKIP.  
            PUT UNFORMATTED "^FO460,80^A0N,20,20^FD" estabelec.bairro + " - " + estabelec.cidade  " ^FS" SKIP.  
            PUT UNFORMATTED "^FO460,100^A0N,20,20^FD" unid-feder.no-estado "^FS" SKIP.  
            PUT UNFORMATTED "^FO460,120^A0N,20,20^FD" "CEP: " estabelec.cep "^FS" SKIP.  
            PUT UNFORMATTED "^FO460,140^A0N,20,20^FD" "CNPJ:" string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.  
            PUT UNFORMATTED "^FO460,160^A0N,20,20^FD" "48 3343 1164^FS" SKIP.  
            PUT UNFORMATTED "^FO460,180^A0N,20,20^FD" "contato@decio.ind.br" "^FS" SKIP.  

            IF AVAIL ord-prod THEN DO:
                PUT UNFORMATTED "^FO460,200^A0N,20,20^FD" "O.P.:" ord-prod.nr-ord-prod "^FS" SKIP.  

                IF AVAIL int-ped-venda THEN
                    PUT UNFORMATTED "^FO460,220^A0N,20,20^FD" "O.C.:" SUBSTRING(int-ped-venda.char-1,53,12)  "^FS" SKIP.  
            END.

            FIND ITEM NO-LOCK
                WHERE ITEM.it-codigo = p-it-codigo NO-ERROR.
            IF  AVAIL ITEM THEN DO:
                
                FIND FIRST int-portaria-movto NO-LOCK
                     WHERE int-portaria-movto.it-codigo = item.it-codigo
                       AND int-portaria-movto.dt-fim = ?
                       AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.

                IF AVAIL int-portaria-movto THEN DO:
                    IF  AVAILABLE int-portaria-movto  THEN DO: 
                        PUT UNFORMATTED "^FO50,360^A0N,26,22^FDEste produto Ç beneficiado pela Legislaá∆o de Inform†tica^FS" SKIP.
                    END.
                END.
            END.

            PUT "^PQ" STRING(1, "99999") SKIP. /* Quantidade de etiquetas a imprimir */
            PUT UNFORMATTED "^XZ".    
        END.
    END.
END.

/*Etiqueta decio impressa pelo escpp166*/
IF p-cod-modelo = 804 THEN DO:

   RUN piCargaImagem("setaCima").
   RUN piCargaImagem("guardaChuva").
   RUN piCargaImagem("fragil").

   PUT UNFORMATTED
       "^XA"         SKIP   /* Inicio Label */
       "^PW1248"     SKIP   /* Para zebra com 300dpi */
       "^JUS"        SKIP   /* Novo comando para zebra 600 */
       "^PON"        SKIP   /* Orientacao impressora N = Normal */
       "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
       "^MNY"        SKIP   /* Papel de etiquetas contnuo */
       "^XZ" skip.

   DO i-cont = 1 TO p-qtd-etiquetas:
       PUT "^XA" SKIP.
    
       PUT UNFORMATTED "^FO40,20^XGsetaCima.GRF^FS"    SKIP.
       PUT UNFORMATTED "^FO290,20^XGguardaChuva.GRF^FS" SKIP.
       PUT UNFORMATTED "^FO530,20^XGfragil.GRF^FS"      SKIP.
    
       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
       PUT "^XZ" SKIP.
   END.
    
   /* Limpa a imagem da impressora */
   PUT UNFORMATTED
       "^XA^IDsetaCima.GRF^FS^XZ"
       "^XA^IDguardaChuva.GRF^FS^XZ"
       "^XA^IDfragil.GRF^FS^XZ".
END.


/*Etiqueta decio impressa pelo escpp166*/
IF p-cod-modelo = 805 THEN DO:

   PUT UNFORMATTED "~~DGsetas.GRF,05376,024,,:::::::::T07C0X05C0,T0780X03E0,T07F0X07F0,T0BE0X0FA0,S01FF0W01FF0,T0HF80W0HF8,S01FFC0V03FFC,S03FF80V03FF8,S0IFC0V07FHF,R02F83E80U0FE3F,R03F87F0U01FC1F,R03F81B80T01F81F80,R0HF01FC0T07F00FC0,R0FE00FE0T07E007E0,Q01FC007F0S01FC007F0,R0F8003E0T0FC003F0,Q07FC003F40R01FC001F0,Q03E0H03F80R03F80H0F0,Q07D0H01FC0R07F0I0F8,Q0F80I0F80R03E0I0B8,P01FC0I07E0R07E0I07C,P01F80I07E0R0FE0I07E,P01F80I07F0Q01FC0I07E,P01F0J03A0Q01F80I03E,P07F0J01F40P07F0J01F,P03E0K0F80P03E0K0F80,P07D0J01FC0P07F0J01FC0,P0B80K03C0P0F80K0FA0,O01FC0K07E0O05FC0K0FE0,O03E0L03E0O03F80K03E0,O07F0L01F80N07F0L03F0,O03E0L01F80N0FE0L01F8,O07E0L01FC0N0FC0L01FC,O0F80M07E0N0FC0M07C,N01F80M07F0M01FC0M07C,O0F80M03F0M01B80M03E,N01F0N03F0M01F0N03F40,N03E0N03F80L03E0N01F80,N07E0N01FC0L07C0N01FC0,N0380O0F80L0F80O0F80,N0FC0O0FC0K01FC0N01FC0,N0F80O03E0L0F80O0FE0,M01F0P07F0K01F0P07F0,M01F0P01F0K03F0P03F8,M03F550L0157FC0J07F5540L057FC,M03FHFC0K03FHFE0J07FHFE0K0JFC,M07FHFC0K07FIFK07FHFC0K0JFC,M03FHF80K03FHFE0J0JFC0K0JFC,M07FHFC0K07FIFK07FHFC0K0JFC,M03FHFC0K03FHF80J07FHFE0K0JFC,M01557C0K07FHF80J07FHFC0K0JFC,P03C0K0380P0380K0F80,P07C0K070Q07C0K0FC0,P03C0K0380P03E0K0F80,P07C0K070Q07C0K0F80,P0380K0380P03C0K0F80,P07C0K0740P07C0K0FC0,P03C0K0380P03C0K0F80,P07C0K070Q07C0K0F80,P0380K0380P0380K0F80,P07C40J070Q07C0K0FC0,P03C0K0380P03E0K0F80,P07C0K070Q07C0K0F80,P0380K0380P03C0K0F80,P07C0K070Q07C0K0FC0,P03C0K0380P03C0K0F80,P07C0K070Q07C0K0F80,P0380K0380P0380K0F80,P07C0K070Q07C0K0FC0,P03C0K0380P03C0K0F80,P07C0K070Q07C0K0F80,P0380K0380P03C0K0F80,P07C0K070Q07C0K0F80,P03C0K0380P03C0K0F80,P03C0K070Q07C0K0F80,P0380K0380P0380K0F80,P07C0K070Q07C0K0FC0,P03C0K0380P03C0K0F80,P07C0K070Q07C0K0F80,P0380K0380P03C0K0F80,P07C0K070Q07C0K0F,P03C0K030Q03C0K0F80,P07C0K070Q07C0K0F80,P0380K030Q0380K0F80,P07C0K070Q07C0K0F40,P03C0K030Q03C0K0F80,P07C0K070Q07C0K0F80,P0380K0380P03C0K0F80,P07C0K070Q07C0K0F,P03C0K030Q07C0K0F80,P07C0K070Q07C0K0F80,P0380K0380P0380K0F80,P07C0K070Q07C0K0F40,P0380K030Q03C0K0F80,P07C0K070Q07C0K0F,P0380K0380P03C0K0F80,P07C0K070Q07C0K0F,P0380K030Q07C0K0F80,P07C0K070Q07C0K0F80,P0380K030Q0380K0F80,P07C0K070Q07C0K0F40,P0380K030Q03C0K0F80,P07C0K070Q07C0K0F,P0380K0380P03C0K0F80,P07C0K070Q07C0K0F,P0380K030Q07C0K0F80,P07C0K070Q07C0K0F,P0380K030Q0380K0F80,P07C0K070Q07C0K0F40,P0380K030Q07C0K0F80,P07C0K070Q07C0K0F,P0380K030Q03C0K0F80,P07C0K070Q07C0K0F,P0380K020Q07C0K0F80,P07C0K070Q07C0K0F,P0380K030Q0380K0F80,P07C0K070Q07C0K0F40,P03EFLFR07FMF80,P07FMFR07FMF,P03FMFR03FMF80,P07FMFR07FMF,P03FMFR07FMF80,P07FMFR07FMF,P01FBFBFBFA0Q03BFHFBFFA,Q0I4J540Q015L54,,::::::K0J404H404040404040H040H040H040,K0BFgXFE,J01FhF,J01BFgXFE,J01FhF,J03FgYFE,J01F5Q5DFgLF,J01A0gW01E,J05E0gW05F,J03A0gW03E,J01F0gW01F,J01A0gW01E,J01F0gW01F,J03E0gW03E,J01F0gW01F,J01A0gW01E,J05E0M040gN01F,J03E0gW03E,J01F0gW01F,J01A0gW01E,J01E0gW01F,J03E0gW03E,J01E0gW01F,J01A0gW01E,J05E0gW01F,J03E0gW03E,J01F0gW01F,J03A0gW01E,J01E0gW01F,J03E0gW03E,J01F0gW01F,J01A0gW01E,J05FhF,J03FHFBFgUFE,J01FhF,J01BFgXFE,J01FhF,J03FgYFE,J01FRFDFgKFE,N0B0M0F80R0B80L0780,N0F0L04FC0R0FC0I04047C040,N0F0M0FC0R0FC0L0780,N0F0L01FC0R0FC0L07C0,N0F0M0F80R0F80L0780,N0F0M0FC0R0FC0L07C0,N0F0M0FC0R0F80L0780,N0F0M0FC0R0FC0L07C0,N0F0M0F80R0F80L0780,N0F0J0400FC0R0FC0L07C0,N0F0M0FC0R0FC0L0780,N0F0L01FC0R0FC0L07C0,N0PF80R0PF80,N0PFC0R0PFC0,N0PF80R0PF80,N0PFC0R0PFC0,N0BFHFBFJF80R0BFNF80,N07FNF40R07FNF40,,::::::::::::::::::::::::" SKIP.
   PUT UNFORMATTED "~~DGchuva.GRF,04480,020,,::::::::N040,N080,M01D0,M02A0,M07F45545H54545454554,M02A82EAHAEAOA,M01FF7FSFC,N0XA,N07FHF7F7F7F7F7F7F7E,N02AEE0Q02E,N01FFC0Q03C,O02A80Q02A,O07FC0Q07E,P0AE0Q02E,O01FF0Q03C,P02A80P02A,P07FF0P07E,P02EE0P02E0J08,P07FFC0O03C0H0178,P02AB80O02A0I028,P07FHFP07E0H05FC,P02EAA0O02E002AAC,P07C7FC0N03C017FFC,P0280AA0N02A02AHA8,P07C1FF40M07E5FHFC040,P02E02E80M02EAAEA,P07C01FF0M03FHFD0,P02800AA0M02AIA8,P07C007F40L07FHF40,P02E002E80L0AEAA,P07C001FD0J015FFD0,P0280H0HAK02AHA80,P07C0H07FC4005FHFE,P02E0I0HEI0AEAEA,P07C0H017F007FFD7C,P0280I0HA802BAA2A,P07C0I07FC5FHF47E,P02E0I02EAIA802E,P07C0I01FIFD001C,P0280J0JA8002A,P07C00405FHFC0H07E,P02E0I0AEHE80H02E,P07C0015FIFC0H03C,P0280H0KA80H02A,P07C005FHF5FF0H07E,P02E00AAEA0AA8002E,P07C17DFD005FC001C,P0282BAA80H0HAH02A,P07FIF40I07F407E,P02AEEA0J02A802E,P07FHFL01FD03C,P02AHAM0HA02A,O05FHF40K017F47E,O0AEE80M02AA2E,M015FFD0N01FF1C,M02AHA80O0JA,L05FIFC0O07FFE,L0HAEA2A0O02AEE,K017FFD7C0O01FFC,K0ABAA0280P0IA,J01FHF407C040404040407FE,K0AEA002ASAE,J01FD0H05FTF,K0A80H02AOABAIA80,K0H4I07FUF0,P0U2AE8,P0U57F8,gK02B8,gK01FF,gL0AE80,gL07FC0,Q0U80AA0,P07FSFE17FC,P02ETE02EA,P07FSFC07FC,P02ATAH0HA,P07F5Q57E007F,P02E0Q02A0028,P07C0Q03C001C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0J07C0J03C,P0280J0FE0J02A,P07C0I014E0J07E,P02E0K0E0J02A,P07C0K060J03C,P0280K0E0J02A,P07C0J01C0J07E,P02E0J0180J02A,P07C0J070K03C,P0280J0E0K02A,P07C0I01FF0J07E,P02E0I01FE0J02A,P07C0I01FF0J03C,P0280Q02A,P07C0Q07E,P02E0Q02E,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P0280Q02A,P07C0Q07E,P02E0Q02A,P07C0Q03C,P02A0Q02A,P07FSFE,P02ARAEA,P07FSFC,P02ARABA,P07FSFE,,::P050R014,P020S02,P070R014,P020S02,P07404040404040416,P02ATA,P07FSFC,P02ATA,P07FSFE,P02ETE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAE,P07FSFC,P02ATA,P07FSFE,P02ETE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAE,P07FSFC,P02ATA,P07FSFE,P02EEAEHEAEHEAEIE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAE,P07FSFC,P02ATA,P07FSFE,P02ETE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAE,P07FSFC,P02ATA,P07FSFE,P02EEAEHEAEHEAEIE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAE,P07FSFC,P02ATA,P07FSFE,P02ETE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAE,P07FSFC,P02ATA,P07FSFE,P02EKEAEHEAEIE,P07FSFC,P02ATA,P07FSFE,P02EAEAEAEAEAEAEAA,P0U10,,:::::::::::::::" SKIP.
   PUT UNFORMATTED "~~DGfragil.GRF,06144,024,,::::::::::::::::::::::::::gK07C0,gK0B80,gK07C0,gK0F80,gJ01FC0,gK0F80,gK07C0,gK0F80,gJ01FC0,gK0F80,gK0740,,:::::gJ0I80,gH05FIF540,gG0AFJFHE8,Y017FMFD,Y0BFOFA0,X07FQF540,W02FRFEA0,V017FTF4,W0LFA8ABBFJFA,U017FIFD40I045FJF40,U02FIFE0M02FIFA0,T017FHFD0N015FIF4,T0BFHF80R0BFFA80,S01FIFT05FHFC0,S03FHF80T0BFFE0,R01FHFD0T0H1IFC,R03FFC0W03FFE,R07FFC0W01FHF,R0HFE0Y03FF80,Q01FFD0Y01FFD0,Q03FF80g0HFE0,Q07FF0gG07FF4,Q0HF80gH0HF8,P05FF0gH017FF,P03FE0gI03FE,P0HFC0gI01FF40,P0FE0gK03F80,O01FF0gK07FC0,O03FE0gL0FE0,O07FC0gL0HF0,N02FE0gM03E8,N07FD0gM05FC,N07F80gN0FE,M017FC0gN0HF,N0FE0gO07F80,M03FF0gO07FC0,M03F80gO01FE0,M07F0gP01FF0,M0FE0gQ0FE0,L01FD0gQ07FC,L01F80gQ03F8,L01FC0gQ07FF,L03E80gR0FE,K01FF0gR01FF,L0F80gS03F80,K01FC0gS01FC0,K03F80gT0FE0,K07F80gS01FF0,K03F80gT0FE0,K07F0gU07F0,K07E0gU03E0,K07D0gU01F0,K0F80gV0F8,J01FC0gV0FC,J02F0gW07C,J03F0gW07F,J03E0gW03E,J07F0gW07F,J07E0gW03E80I01FC0gW01FC0J0F80gX0F80I01F0gY0FC0I03F80gX0FC0I03F80gW01FD0I03F80gX0FE0I07F0gY07F0I07E0gY03E0H01FD0gY01F0I0F80gY01F8H01FC0gY01FCI0F80h0E8H01F0015J5Q0H5IDQ015H5H01FCH03F802FIFA80O0BFIFA80N0AFHFA80FEH07F017FJFD0M017FKFD0M05FKF07FH03E03FKFE80L03FLFE0M03FKF83EH07F1FMFD0K01FOFL01FLFD7FH0FE2FNF80J03FOFL03FMFBFH07C7FHFD57FHFC0I017FIF7FJFC0J07FOFH0FEFHFE002FHFE0I02FIF800FEFFE0J0IFE02FJF01FJF51017FHFJ07FHFD10117FHFC0H01FHF1017FIFH0JFA0J0IF80H0IFE0K0IFE0H03FF80I03FHF01FIFL07FFC001FHF40K07FHFI07FF0J01FHF03FHFA0L0HFE003FFE0M0IF800FF80K0IF01FHF80L07FF007FF10L017FFC01FFC0K01FF03FFE0M01FF80FFE0O0HF803FE0M0HF07FFC0N07FC1FFC0O07FF07FC0M07F03FF80N03FE3FE0J020J03FF8FE80N0F07FF0O01FF7FC0I01FC0I01FFDFF0N01703FC0P0JF80J0F80J0BFBFE0O0307FC0P07FHF40I01FC0J07FHFC0O0102E0Q03FFE0K0E80K0IF80,07F0Q01FFD0J01FC0J01FHF80,03E0R0HFC0K0F80K07FE,05C0Q01FFC0K0FC0K07FE,V06F0L0F80K03FE,V07F0K01FC0K01FC,V03E0L0F80L0F8,V01C0K01FC0L070,gK0F80L020,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0E80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01F40,gK0F80,gJ01F80,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01F80,gK0F80,gJ01FC0,gK0F80,gJ01F80,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gK0F80,gJ01F80,gK0F80,gJ01FC0,gK0F80,gJ01FC0,gJ03F80,gJ01F,gJ02F,W01D0J07F,X0F0J03F,W01F0J07F,X0F80I0FE,W01FD0H01FD,X0FE0H03F8,W01FF4007F4,X03FA82FE0,X01FJFD0,Y0KF80,Y07FIF,Y03FHFE,Y01FHFC,g03FF0,,::::::::::::::::::::::" SKIP.
   PUT UNFORMATTED "~~DGempilha.GRF,05376,024,,::::::::::::I0K5151I101H101,I0gOFE0I0OF80I0gPFI01FNFC0I0gPF8003FNFE0I0gPFI03FOF0I0gPF8003FNFE0I0gPFI07FNFE0I0gPFI0PFE0I0KF7FPF7F7FOFI07FOF0I0FE08K8IA8A8AHA8AMAHFE0H0HFHEIAEBFE0I0FC0gJ03FC0H0HFL01FE0I0FE0gJ03FA0H0HF80K0FE0I07C0gJ07F0H01FF0K017E0I0FE0gJ0HF8001FE80K0FE8I0FC0gJ07F0H01FE0K01FC0I0FE0gI03FE0H03FE0K03FE0I0FE0gI01FE0H01FC0K01FC0I0FE0gI03FE0H03FEAHAI03FE0I0FE0gI07FC0H03FJFI03FC0I0HFgJ0HF80H03FJF8003FE0I07F0gH017F0I03FJFI03FC0I0HF80gG03FE80H0BFJF8003F80I0HFgI01FC0I03FJFI07FC0I0HFgI03FE0I03FJF8003F80I07F0gH07FC0I0155FFC0H07F,I0HF80gG0JFE0H081FFE0H0HF80I07F80gG0KFJ01FFC0H07F,I0HF80gG0KFJ03FF80H0HF80I03F40g01FJFJ07FF0I07F,I0BFC0gG0KF80H0HFE80H0HF80I03FC0g01FJF8001FFE0I0HF,I03FE0gG0KF8003FFA0H03FE,I01FC0gG0KFI07FF0I01FE,I01FE0gG0IAHF800FFE0I03FE,I01FE0gJ07F001FFC0I01FC,J0HF80gI0FE003FF80I03FE,J0H7gK07F007FF0J07F4,J0HF80gI0FE80FFE80I0HF8,J07F80gH01FC01FFC0J07FC,J03FE0gH01FE03FF80J0HF8,J03FC0gH01FC07FF0K0HF0,J03FE0gH03FC0FFE0K0HF0,J01FE0gH01FC1FFC0J01FF0,J03FE0gH03F83FF80J01FE0,J017F0gH03F07FF0K01FE0,J01FF80gG03F8FFE0K03FE0,K0HFgI03F9FFC0K01FC0,K0HF80gG03FIF80K03F80,K07F80gG03FIFM07F,K03FC0gG03FHFE0L0HF80,K01FC0gG07FHFC0L07F,K03FE0gG07FHF80L0FE,K01FF0gG0H7HFM01FC,L0HF80g0IFE0L03FC,L07F80g07FFC0L07FC,L07F80g0IF80L0HF8,L07FC0g07FF0M07F0,L03FE0g0HFE0M0FE8,L01FF0g0HFC0L01FE0,M0HFgG0HF80L03FE0,L017F0Y01FF0M03FC0,M0HF80X03FF80L03FE8,M07FC0X01FE0M07F,M0HFE0X03FE0M0FE,M01FF0X0170M01F0,N0HF80X0F80L0BF8,N0HFC0gM07F0,N0HFE0gL03FF8,N017C0gL017F0,N03FE80gK0BFE8,O0HFC0gJ01FFC0,O0HFE0gJ03FFC0,O07FF0gJ07FF,O03FF80gI0IF80,O01FFC0gH01FFE,P07FF80gG0IF8,P07FF40g01FHF0,P03FHF80Y0IFE8,P01FHFC0X01FHFC0,Q0IFE0X03FHF80,Q01FHFY07FFE,Q03FHFE0V03FHFE,R07FHF40U07FHF4,R03FHFE0T03FIF8,R017FHFU07FHFC0,S0JFE80Q0BFIF80,S05FIFC0Q07FIF,S02FJFA0O03FIFA,T01FJF40L017FIFC0,U0LFE80I0BFKF80,U01FKFD0H05FKFC,V0BFKF800FLF8,V017FJF40177FIFC0,I080R0BFJFE03FKF80,X0KFE01FJFC,X02FIFE03FIFE0,Y01FHFE01FIF,g0BFFE03FHF8,gG05FC01FD,gG01FE03FE,gG01F601FC,gG01FE03FE,gG01FE01FC,gG01FE03FE,gG01FE03FC,gG01FE03FE,gG01FE01FC,gG01FE03FE,gG01F601F4,gG01FE03FE,gG01FE01FC,gG01FE03FE,gG017E03FC,gG01FE03FC,gG01FE01FC,gG01FE03F8,gG01F601F4,gG01FE03FE,gG01FE03FC,gG03FE03FE,gG01FE03FC,gG01FE03F8,gG01FC01FC,gG01FE03F8,gG01F603F4,gG01FE03FE,gG01FE03FC,gG01FE03FA,gG01FE01FC,gG01FE03FE,gG01FC01FC,gG01FE03FE,gG01FE03F4,gG01FE03FC,:gG03FE03FE,gG01FE03FC,gG01FE03FE,gG01FE03FC,gG01FE03F8,gG01F603F4,gG01FE03FC,gG01FE01FC,gG03FE03F8,gG01FE01FC,gG01FE03FC,gG01FE01FC,gG03FE03F8,gG01FC03F4,gG03FE03FC,gG01FC03FC,gG03FE03F8,gG01FC03FC,gG01FE03FC,gG01FC03FC,gG03FE03F8,gG01F403F4,gG03FE03FC,gG01FE03FC,gG03FE03FE,gG01FE03FC,:gG01FE01FC,gG03FE03F8,gG01F603F4,gG03FE03FC,gG01FE07FC,gG03FE03FA,gG01FE03FC,gG03FE03F8,gG01FC01FC,V0HAI23FE03FE2H2020,U01F7F7F7FC03FHF7F7F0,U0NFE0BFMF80,T01FMFE05FMFC0,T0OFE03FMFE0,T07FMFC03FNF0,S03FNFC03FNF8,S07FNFC01FNFC,S07FNF800FNFE,S07FHFL5I0L5H7HF,R03FFE080H080H080H080H0BFF80,R01FF0W01FFC0,R03FE0X0HFE0,R07FC0X07FC0,R0HF80X03FE0,R0HFC45H5J4044004J405FF0,R0gKF0,Q01FWFDFKF0,R0gKF8,Q01FgJF0,R0gKF8,Q01FYF7FIF0,R0gKF8,R07FgIF0,R03FgHFE0,,W080808080808080H08,,::::::::::::" SKIP.
   
   PUT UNFORMATTED
       "^XA"         SKIP   /* Inicio Label */
       "^PW1248"     SKIP   /* Para zebra com 300dpi */
       "^JUS"        SKIP   /* Novo comando para zebra 600 */
       "^PON"        SKIP   /* Orientacao impressora N = Normal */
       "^FWN"        SKIP   /* Orientacao dos Campos N = Normal */
       "^MNY"        SKIP   /* Papel de etiquetas contnuo */
       "^XZ" skip.

   DO i-cont = 1 TO p-qtd-etiquetas:
       PUT "^XA" SKIP.

       PUT UNFORMATTED "^FT32,320^XGsetas.GRF,1,1^FS"    SKIP.
       PUT UNFORMATTED "^FT608,320^XGchuva.GRF,1,1^FS"   SKIP.
       PUT UNFORMATTED "^FT224,320^XGfragil.GRF,1,1^FS"  SKIP.
       PUT UNFORMATTED "^FT416,320^XGempilha.GRF,1,1^FS" SKIP.

       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
       PUT "^XZ" SKIP.
   END.

   /* Limpa a imagem da impressora */
   PUT UNFORMATTED
       "^XA^IDsetas.GRF^FS^XZ"   SKIP 
       "^XA^IDchuva.GRF^FS^XZ"   SKIP
       "^XA^IDfragil.GRF^FS^XZ"  SKIP
       "^XA^IDempilha.GRF^FS^XZ" SKIP.

END.


/* ---[ Impress∆o Modelo 63 ]--------------------------------------------------------------------------------------------- */
IF p-cod-modelo = 633 THEN DO: 

  
   
   {esapi/esapi016inic-600dpi.i} /*inicializa par≥metros impressora*/

   FOR EACH tt-lista-ns:

       FOR FIRST num-serie NO-LOCK                                                                                                                                              
           WHERE num-serie.n-serie = tt-lista-ns.num-serie:                                                                                                                     
       END.     

       {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

       PUT "^XA" SKIP.
       
       //LOGO Anatel
       PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.
       
       {esapi/esapi016a5034-600dpi.i}  /* USAR - Embalagem */                             
       {esapi/esapi016a11-600dpi.i 4}  /* USAR - Etiqueta de Produto (34x21mm) */    

       PUT UNFORMATTED "^FO1330,730^ABN,46,30^FB650,1,0,C^FD" 'GUIA 1' "^FS" SKIP. 
       PUT UNFORMATTED "^FO1350,680^BQR,2,7^FDQA," 'GUIA 1'  "^FS" SKIP. 

       PUT UNFORMATTED "^FO1950,730^ABN,46,30^FB650,1,0,C^FD" 'GUIA 2' "^FS" SKIP. 
       PUT UNFORMATTED "^FO1950,680^BQR,2,7^FDQA," 'GUIA 2'  "^FS" SKIP. 

       /*
       PUT UNFORMATTED "^FO2355,3^ABB,45,15^FB390,1,0,C^FD" 'NS:' tt-lista-ns.num-serie "^FS" SKIP. 
       PUT UNFORMATTED "^FO2305,360^BQR,2,6^FDQA," 'NS:' tt-lista-ns.num-serie  "^FS" SKIP. 
       */

       PUT UNFORMATTED "^FO2355,20^ABB,30,15^FB410,1,0,C^FD" 'NS:' tt-lista-ns.num-serie "^FS" SKIP. 
       PUT UNFORMATTED "^FO2305,420^BQR,2,6^FDQA," 'NS:' tt-lista-ns.num-serie  "^FS" SKIP. 

       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
       PUT "^XZ" SKIP.


       PUT "^XA" SKIP. 
       PUT UNFORMATTED "^FO1240,70^A0N,62,62^FB870,1,0,C^FD" 'INTELBRAS CLOUD' "^FS" SKIP.    /* Imprime modelo */
       PUT UNFORMATTED "^FO1470,410^ADN,45,20^FB760,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
       PUT UNFORMATTED "^FO1570,150^BQR,2,10^FDQA," num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */


       PUT UNFORMATTED "^FO1330,730^ABN,46,30^FB650,1,0,C^FD" 'FONTE' "^FS" SKIP. 
       PUT UNFORMATTED "^FO1350,680^BQR,2,7^FDQA," 'FONTE'  "^FS" SKIP. 

       PUT UNFORMATTED "^FO1950,730^ABN,46,30^FB650,1,0,C^FD" 'KIT HD' "^FS" SKIP. 
       PUT UNFORMATTED "^FO1950,680^BQR,2,7^FDQA," 'KIT HD'  "^FS" SKIP. 

       /*
       PUT UNFORMATTED "^FO2355,3^ABB,45,15^FB390,1,0,C^FD" 'NS:' tt-lista-ns.num-serie "^FS" SKIP. 
       PUT UNFORMATTED "^FO2305,360^BQR,2,6^FDQA," 'NS:' tt-lista-ns.num-serie  "^FS" SKIP. 
       */

       PUT UNFORMATTED "^FO2355,10^ABB,46,30^FB500,1,0,C^FD" 'MOUSE' "^FS" SKIP. 
       PUT UNFORMATTED "^FO2305,420^BQR,2,7^FDQA," 'MOUSE'  "^FS" SKIP. 

       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
       PUT "^XZ" SKIP.
   END.     

   PUT UNFORMATTED "^XA^IDselo-suframa.GRF^FS^XZ".


END.

/* Aguardando testes 31/05/2022 */
/* ---[ Impress∆o Modelo 634 ]--------------------------------------------------------------------------------------------- */
IF p-cod-modelo = 634 THEN DO: 

   {esapi/esapi016inic-600dpi.i} /*inicializa par≥metros impressora*/

   ASSIGN c-mac        = ENTRY(1,c-qr-code-escpp120,'\\')  
          c-num-ns     = ENTRY(1,c-mac,';')               
          c-senha-adm  = ENTRY(3,c-mac,';')               
          c-senha-wifi = ENTRY(4,c-mac,';')
          c-mac        = ENTRY(2,c-mac,';').

   /*
   MESSAGE 1  SKIP 
       'c-mac        '  c-mac        skip
       'c-num-ns '      c-num-ns    SKIP
       'c-senha-adm  '  c-senha-adm  skip
       'c-senha-wifi '  c-senha-wifi skip
       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/

   ASSIGN c-imei = SUBSTRING(c-qr-code-escpp120,INDEX(c-qr-code-escpp120,"\\"))
          c-imei = ENTRY(2,c-imei,';').

   FIND FIRST mac-address 
        WHERE mac-address.mac = c-mac
   NO-LOCK NO-ERROR.

   FIND FIRST num-serie NO-LOCK                                                                                                                                              
        WHERE num-serie.n-serie = c-num-ns 
   NO-ERROR.

   
   IF AVAIL mac-address AND AVAIL num-serie THEN DO:
      
       /*rotina busca cnpj e guarda na variˇvel c-cgc*/
       FIND FIRST estabelec 
             WHERE estabelec.cod-estabel = num-serie.cod-estabel NO-LOCK NO-ERROR.
       
       IF AVAIL estabelec THEN
          ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").


       PUT "^XA" SKIP.

       
       {esapi/esapi016a5034-600dpi.i}  /* USAR - Embalagem */ 


       /*
       FIND FIRST mac-address USE-INDEX num-serie 
            WHERE mac-address.n-serie = num-serie.n-serie
       NO-LOCK NO-ERROR.*/

       ASSIGN c-mac       = mac-address.mac
              c-nome-wifi = CAPS(item-ean.nome-abrev) + '_' + SUBSTRING(mac-address.mac,9,4).

       /*
       ASSIGN c-formata-senha = TRIM(item-ean.texto[5]) + '||' + c-mac. 

       ASSIGN c-formata-senha = LOWER(REPLACE(c-formata-senha,' ','')).

       RUN esapi\esapi016x.p (INPUT c-formata-senha,
                              OUTPUT c-senha-wifi,
                              OUTPUT c-senha-adm).*/ 

       ASSIGN c-senha-wifi = replace(c-senha-wifi,'_','_5f')  /* Underline - chr(95) */
              c-senha-wifi = replace(c-senha-wifi,'^','_5e'). /* Chapeu - chr(94) */

       ASSIGN c-senha-adm = replace(c-senha-adm,'_','_5f')  /* Underline - chr(95) */
              c-senha-adm = replace(c-senha-adm,'^','_5e'). /* Chapeu - chr(94) */

       ASSIGN c-nome-wifi = replace(c-nome-wifi,'_','_5f').  /* Underline - chr(95) */


       /* Logo Anatel */
       PUT UNFORMATTED "^FO2245,330^GFA,4428,4428,27,,:::::::::::::::::::::gU07IF8,gT03KF,gR03NFC,gR0OFE,gP0SF,gO01SF8,gN01UF,gN03UF,gM07WF,gM0XF,gL07XFC,gL0YFC,gK0JFC01TF,gJ01IFEI03SF,gJ07FCM0RFC,gJ03F8M07QFC,gU03QF,gU01QF,gV0QFC,gV07PFC,gV03QF,gV01QF,gW0QF,gW07PF,gW03PF8,gW03PFC,:gW01PFE,gX0QF,::::Y03IFU0QF,Y0JFCT0QF8,W03LFES0QFC,W07MF8R0QFC,W0NFCR0QFC,V07OF8Q0QFC,V0PFCQ0QFC,U01PFEQ0QFC,U07QFQ0QFE,U0RF8P0QFE,T01RFCP0RF,T03RFEP0RF,T03SFP0RF,T0TF8N01RF,T0TFCN01RF,S01TFCN03RF,S03TFCN03RF,S03UFN03RF,S07UFN03RF,S0VF8M03RF,S0VFCM03RF,S0VFCM07RF,S0VFCM0SF,:R01VFCM0RFE,R03VFEL03RFE,R03WFL03RFC,::R03WFL07RFC,R03WFL0SFC,:R03WFK01SFC,R03WFK03SF8,:R03WFK03SF,R03WFK07SF,R03WFK0TF,:R03WFJ01TF,R03VFEJ01TF,R03VFCJ03TF,:S0VFCJ07SFE,S0VFCJ0TFC,S0VFCI01TFC,S0VFCI03TFC,S0VF8I03TFC,S07UFJ07TF8,S03UFJ0UF,S03TFEJ0UF,S01TFCI01UF,T0TFCI03UF,T0TF8I07UF,T0TFJ0VF,T03RFEI01UFE,U0RFCI03UFC,:U0RF8I03UFC,V0PFCJ07UF8,V0PFCJ0VF8,V03OFJ01VF,V03NFEJ03VF,W03MFK07VF,W01LFCK0WF,X03JFEL0WF,X01JFCL0VFE,,:::::::O0FFI01FF003FCI03FF03KFC3JFC03FC,N01FFI03FF003FCI03FF03KFC3JFC03FC,N03FF8003FF003FCI03FF03KFC3JFC03FC,N07FFC003FF803FCI07FF0087FE183FE01003FC,N0IFC003FFC03FCI0IF8003FC003FCJ03FC,N0IFC003FFC03FC001IFC003FC003FCJ03FC,N0IFC003FFC03FC003IFC003FC003FCJ07FC,M01IFC007FFC03FC003IFC003FC003FCJ07F8,M03IFC00IFE07F8007IFC003F8003FCJ0FF,M03IFE00JF0FFI07IFC003FI07FCJ0FF,M07F8FF00JF0FFI0FF3FC007FI0FFCJ0FF,M0FF0FF00JF8FF001FE3FC00FFI0FFCJ0FF,M0FF0FF00JFCFF003FC3FC00FFI0FFCJ0FF,L01FF0FF00FF3FCFF003FC3FC00FFI0JFE00FF,L03FE0FF00FF3JF007FC3FC00FFI0KF00FF,L03FC0FF00FF3IFE007FC3FC00FFI0KF00FF,L07FC0FF00FF1IFC00FF03FC00FFI0JFE00FF,L0FF80FF00FF0IFC00FF03FC00FEI0FF8J0FF,L0FFE1FF01FE07FFC01FF87FC00FC001FFK0FF,L0LF03FC03FFC03KFE01FC003FFK0FF,K01LF03FC03FFC03KFE03FC003FFJ01FF,K03LF03FC03FFC03KFE03FC003FFJ01FE,K07FE01FF03FC01FFC07FC01FF03FC003FFJ03FE,K07FC00FF03FC00FFC0FF800FF03FC003FEJ03FC,K0FF800FF03FC00FFC0FFI0FF03FC003FEJ03FC,K0FFI0FF07F800FFC1FFI0FF03FC003FEJ03FC,K0FFI0FF0FFI03F83FEI0FF03FC003JFC03JFC,J01FFI0FF0FFI03F03FCI0FF03FC003JFC03JFC,J03FFI0FF0FFI03F03FCI0FF03FC003JFC03JFC,J03FEI07F0FFI03F03FCI0FF03FC003JFC03JFC,,:::^FS" SKIP.
       PUT UNFORMATTED "^FO2270,500^A0N,34,28^FD" item-ean.homolog "^FS" SKIP.



       /* Modelo */
       PUT UNFORMATTED "^FO1470,60^A0N,62,62^FB870,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
       PUT UNFORMATTED "^LRY^FO1240,20^GB1250,100,100^FS^LRN" SKIP.  /* Quadro preto */

       /* Informaá‰es Item */
       PUT UNFORMATTED "^FO1330,135^A0N,34,34^FD" item-ean.char-2 "^FS" SKIP.

       PUT UNFORMATTED "^FO1330,175^A0N,34,34^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.

       PUT UNFORMATTED "^FO1330,215^A0N,34,34^FB760,1,0,L^FD" 'MAC:' c-mac "^FS" SKIP.
       PUT UNFORMATTED "^FO1330,245^BY2.5^BCN,74,N,N,N,N^FD" c-mac "^FS" SKIP.  /* Codigo de Barras EAN 128 */

       PUT UNFORMATTED "^FO1330,335^A0N,34,34^FB760,1,0,L^FD" 'NS:' num-serie.n-serie "^FS" SKIP.
       PUT UNFORMATTED "^FO1330,365^BY2.5^BCN,74,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

       IF item-ean.imei THEN DO:
          PUT UNFORMATTED "^FO1330,455^A0N,34,34^FB760,1,0,L^FD" 'IMEI:' c-imei "^FS" SKIP.
          PUT UNFORMATTED "^FO1330,485^BY2.5^BCN,74,N,N,N,N^FD" c-imei "^FS" SKIP.  /* Codigo de Barras EAN 128 */
       END.

       
       //PUT UNFORMATTED "^FO1800,300^A0N,25,25^FD" '2012-13-1060'  "^FS" SKIP. 

       ASSIGN c-monta-qr-code = 'WIFI:T:WPA;S:' + c-nome-wifi + ';P:' + c-senha-wifi + ';USER:admin;PASS:' + c-senha-adm + ';;'.

       /* QR CODE */
       //PUT UNFORMATTED "^FO1870,320^BQR,2,6^FDQA," c-monta-qr-code  "^FS" SKIP.
       PUT UNFORMATTED "^FO2240,135^BQR,2,5^FH^FDQA," c-monta-qr-code  "^FS" SKIP.






       PUT UNFORMATTED "^FO1855,135^A0N,34,34^FD" item-ean.origem "^FS" SKIP.
       PUT UNFORMATTED "^FO1855,175^A0N,34,34^FB760,1,0,L^FD" /*'Suporte:'*/ item-ean.fone "^FS" SKIP.
       PUT UNFORMATTED "^FO1855,215^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[5] "^FS" SKIP.
       PUT UNFORMATTED "^FO1855,255^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec  "^FS" SKIP.

       PUT UNFORMATTED "^FO1890,310^A0N,34,34^FB760,1,0,L^FDWIFI: " /*c-nome-wifi*/   "^FS" SKIP.
       PUT UNFORMATTED "^FO1970,310^A0N,35,45^FH^FD"  c-nome-wifi  "^FS" SKIP.

       PUT UNFORMATTED "^FO1890,360^A0N,34,34^FB760,1,0,L^FDSenha: " /*c-senha-wifi*/ "^FS" SKIP. 
       PUT UNFORMATTED "^FO2000,360^A0N,35,45^FH^FD"  c-senha-wifi  "^FS" SKIP.

       PUT UNFORMATTED "^FO1890,410^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[6] "^FS" SKIP. 
       PUT UNFORMATTED "^FO1890,460^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[7] "^FS" SKIP. 
       PUT UNFORMATTED "^FO1890,510^A0N,34,34^FB760,1,0,L^FD" 'Senha: ' /*c-senha-adm*/ "^FS" SKIP. 
       PUT UNFORMATTED "^FO2000,510^A0N,35,45^FH^FD"  c-senha-adm  "^FS" SKIP.



       PUT UNFORMATTED "^FO1260,670^ABN,40,20^FB650,1,0,C^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP. 
       PUT UNFORMATTED "^FO1260,735^ABN,40,20^FB650,1,0,C^FD" 'NS:' num-serie.n-serie "^FS" SKIP.

       PUT UNFORMATTED "^FO1880,670^ABN,40,20^FB650,1,0,C^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP. 
       PUT UNFORMATTED "^FO1880,735^ABN,40,20^FB650,1,0,C^FD" 'NS:' num-serie.n-serie "^FS" SKIP.














        /*
       PUT UNFORMATTED "^FO2050,155^A0N,34,34^FD" item-ean.origem "^FS" SKIP.
       PUT UNFORMATTED "^FO2050,195^A0N,34,34^FB760,1,0,L^FD" /*'Suporte:'*/ item-ean.fone "^FS" SKIP.
       PUT UNFORMATTED "^FO2050,235^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[5] "^FS" SKIP.
       PUT UNFORMATTED "^FO2050,275^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec  "^FS" SKIP.

       PUT UNFORMATTED "^FO2060,340^A0N,34,34^FB760,1,0,L^FDNome WIFI: " /*c-nome-wifi*/   "^FS" SKIP.
       PUT UNFORMATTED "^FO2230,340^A0N,30,30^FH^FD"  c-nome-wifi  "^FS" SKIP.

       PUT UNFORMATTED "^FO2060,380^A0N,34,34^FB760,1,0,L^FDSenha WIFI: " /*c-senha-wifi*/ "^FS" SKIP. 
       PUT UNFORMATTED "^FO2230,380^A0N,30,30^FH^FD"  c-senha-wifi  "^FS" SKIP.

       PUT UNFORMATTED "^FO2060,420^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[6] "^FS" SKIP. 
       PUT UNFORMATTED "^FO2060,460^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[7] "^FS" SKIP. 
       PUT UNFORMATTED "^FO2060,500^A0N,34,34^FB760,1,0,L^FD" 'Senha: ' /*c-senha-adm*/ "^FS" SKIP. 
       PUT UNFORMATTED "^FO2160,500^A0N,34,34^FH^FD"  c-senha-adm  "^FS" SKIP.

       PUT UNFORMATTED "^FO1260,670^ABN,40,20^FB650,1,0,C^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP. 
       PUT UNFORMATTED "^FO1260,735^ABN,40,20^FB650,1,0,C^FD" 'NS:' num-serie.n-serie "^FS" SKIP.

       PUT UNFORMATTED "^FO1880,670^ABN,40,20^FB650,1,0,C^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP. 
       PUT UNFORMATTED "^FO1880,735^ABN,40,20^FB650,1,0,C^FD" 'NS:' num-serie.n-serie "^FS" SKIP.*/

       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
       PUT "^XZ" SKIP.

   END.               

END.


/* ---[ Modelo 635: Produto Exportaá∆o Egito - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 635 OR p-cod-modelo = 636 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

    IF p-cod-modelo = 635 THEN
       PUT UNFORMATTED "~~DGEgito1.GRF,01536,016,,:::M01FLFC0J0HFE,M01FLFC0I07FHFC0,M01FLF80H07FJF8,M01FLFJ0LFE,M01FLFI03FLF80,M01FKFE0H0NFE0,M01FKFE001FNF0,M01FKFC007FNF8,M01FKFC00FOFE,M01FKF801FPF,M01FKFH03FIFH01FIF80,M01FE0K07FHF80H03FHF80,M01FE0K0IFC0J0IFE0,M01FE0J01FHFL03FFE0,M01FE0J01FFE0K01FHF0,M01FE0J03FFC0L07FF8,M01FE0J07FF0M03FFC,M01FE0J07FE0M01FFC,M01FE0J0HFE0N0HFE,M01FE0I01FF80I0E0I07FC,M01FE0I01FF8001FHFI03F8,M01FE0I03FF0H07FHF8001F0,M01FE0I03FE001FIFE001E0,M01FE0I07FE003FJF800C0,M01FE0I07FC007FJFC,M01FE0I0HFC00FKFE,M01FE0I0HF801FLF,M01FE0I0HFH03FLF80,M01FE0H01FF007FLF80,M01FE0H01FE007FFC0FHFC0,M01FE0H01FE00FHFH01FFC0,M01FE0H01FE00FFE0H0HF80,M01FE0H03FC01FF80H07F,M01FE0H03FC01FF0I03E,M01FE0H03FC03FF0I01C,M01FE0H03FC03FE0J08,M01FE0H07FC07FC,M01FE0H07F807FC,M01FE0H07F807F8,::M01FLF807F0,M01FLF80FF0,:M01FLFH0HF0,::M01FLF80FF0,M01FLFH0HF0,M01FLF807F0,M01FE0H07F807F8,::M01FE0H07F807FC,M01FE0H07FC07FC,M01FE0H03FC03FE0J08,M01FE0H03FC03FF0I01C,M01FE0H03FC01FF0I03E,M01FE0H03FC01FF80H07F,M01FE0H01FE00FFE0H0HF80,M01FE0H01FE00FHFH01FFC0,M01FE0H01FE007FFC0FHFC0,M01FE0H01FF007FLF80,M01FE0I0HFH03FLF80,M01FE0I0HF801FLF,M01FE0I0HFC00FKFE,M01FE0I07FC007FJFC,M01FE0I07FE003FJF800C0,M01FE0I03FE001FIFE001E0,M01FE0I03FF0H07FHFC001F0,M01FE0I01FF8001FHFI03F8,M01FE0I01FF80I0E0I07FC,M01FE0J0HFE0N0HFE,M01FE0J0HFE0M01FFC,M01FE0J07FF80L03FFC,M01FE0J03FFC0L07FF8,M01FE0J03FFE0L0IF0,M01FE0J01FHFL03FFE0,M01FE0K0IFC0J0IFE0,M01FE0K07FHFJ03FHFC0,M01FE0K03FIFH01FIF80,M01FE0K01FPF,M01FE0L0PFE,M01FE0L07FNF8,M01FC0L01FNF0,M01F80M0NFE0,M01F0N07FLF80,M01E0O0LFE,M01C0O07FJF8,M0180P0JFE0,M010R0HFE,," SKIP.
    ELSE
       PUT UNFORMATTED "~~DGEgito1.GRF,02048,016,,::::::::::::R07FC0O01FE,Q03FFC0O0HFE,Q0IFC0N07FFE,P03FHFC0N0IFE,P07FHFC0M03FHFE,O01FIFC0M07FHFE,O03FIFC0L01FIFE,O07FIFC0L03FIFE,O0KFC0L07FIFE,N01FJFC0L07FIFE,N03FJFC0L0KFE,N03FJFC0K01FJFE,N07FJFC0K03FJFE,N0JFE0M03FIF,M01FIFO07FHF8,M01FHFC0N0IFE0,M03FHFP0IFC0,M03FFE0N01FHF80,M07FFC0N01FHF,M07FF80N03FFC,M0IFP07FFC,M0HFE0O07FF8,L01FFE0O07FF0,L01FFC0O0HFE0,:L03FF80O0HFC0,L03FF80N01FFC0,L03FF0O01FF80,L07FF0O01FF80,L07FE0O03FF80,L07FE0O03FF,:L0HFC0O03FF,L0HFC0O03FE,:L0HFC0O07FE,L0HF80O07FE,L0HF80O07FKF80,::::K01FF80O07FKF80,::L0HF80O07FKF80,::::L0HF80O07FE,L0HFC0O07FE,:L0HFC0O03FE,L0HFC0O03FF,L07FC0O03FF,L07FE0O03FF,L07FE0O03FF80,L07FF0O01FF80,L03FF0O01FF80,L03FF0O01FFC0,L03FF80O0HFC0,L01FF80O0HFE0,L01FFC0O0HFE0,L01FFE0O07FF0,M0HFE0O07FF8,M0IFP07FFC,M07FF80N03FFC,M07FFC0N03FFE,M03FFE0N01FHF,M03FHFO01FHFC0,M01FHF80N0IFE0,M01FHFE0N07FHF8,N0JF80M07FHFE,N07FJFC0K03FJFE,N07FJFC0K01FJFE,N03FJFC0K01FJFE,N01FJFC0L0KFE,O0KFC0L07FIFE,O07FIFC0L03FIFE,O03FIFC0L01FIFE,O01FIFC0M0JFE,P07FHFC0M03FHFE,P03FHFC0M01FHFE,Q0IFC0N07FFE,Q03FFC0N01FFE,R07FC0O03FE,,:::::::::::::::::::::::::::" SKIP.

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034.i}         /* Etiqueta item ean13 e NS - 50x34mm */
        {esapi/esapi016a2.i 425 20 5}   /* Cabeáalho modelo */
        {esapi/esapi016a5024nh.i 2}     /* Etiqueta produto exportaá∆o - 50x24mm */
        {esapi/esapi016a12.i 1}         /* etiqueta 24x8mm */

        PUT UNFORMATTED "^FO700,65^XGEgito1.GRF^FS" SKIP.

        PUT UNFORMATTED "^FO680,175^A0N,12,12^FD" item-ean.homolog "^FS" SKIP.    

        /* Etiquetas Pequenas */
        /*
        PUT UNFORMATTED "^FO450,245^A0N,15,15^FD" item-ean.homolog  "^FS" SKIP. 
        PUT UNFORMATTED "^FO660,245^A0N,15,15^FD" item-ean.homolog "^FS"  SKIP. 
        */

        
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    PUT UNFORMATTED
        "^XA^IDEgito1.GRF^FS^XZ".

END. /* modelo 635 */



/* ---[ Modelo 160: Produto produzido no polo industrial de Manaus - Quadrupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 637 THEN DO:
    
    {esapi/esapi016inic-600dpi.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

        PUT "^XA" SKIP.
        
        {esapi/esapi016a5034-600dpi.i}  /* USAR - Embalagem */                             
        //{esapi/esapi016a13-600dpi.i}    /* USAR - Etiqueta de Produto (34x21mm) */   

        /* Modelo */
        PUT UNFORMATTED "^FO1400,70^A0N,62,62^FB870,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
        PUT UNFORMATTED "^LRY^FO1265,30^GB1180,100,100^FS^LRN" SKIP.  /* Quadro preto */ /* 870 */

        /* Informaá‰es Item */
        PUT UNFORMATTED "^FO1320,155^A0N,34,34^FD" item-ean.char-2 "^FS" SKIP.          
        PUT UNFORMATTED "^FO1320,195^A0N,34,34^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO1320,235^A0N,34,34^FB760,1,0,L^FD" item-ean.fone "^FS" SKIP.                    

        PUT UNFORMATTED "^FO1570,155^A0N,34,34^FB760,1,0,R^FD" item-ean.origem "^FS" SKIP.
        PUT UNFORMATTED "^FO1570,195^A0N,34,34^FB760,1,0,R^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.

        PUT UNFORMATTED "^FO1320,275^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec[1] "^FS" SKIP.
        PUT UNFORMATTED "^FO1320,315^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.

        {esapi/esapi016a12-600dpi.i 1}         /* etiqueta 24x8mm */      

        PUT UNFORMATTED "^FO2030,280^XGselo-suframa.GRF^FS" skip. /* Impressao da Imagem ANATEL */ 

        PUT UNFORMATTED "^FO1320,390^ADN,30,20^FB500,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO1320,440^BY3^BCN,50,N,N,N,N^FD" num-serie.n-serie "^FS"       SKIP. /* Codigo de Barras EAN 128 */

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDselo-suframa.GRF^FS^XZ".
    
END. /* modelo 637 */



/* ---[ Modelo 170: Produto produzido no polo industrial de Manaus - Qu°ntupla ]--------------------------------------------------------------------------------------------- */
IF  p-cod-modelo = 638 THEN DO:

    /*inicializa parÉmetros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"     SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    RUN piCargaImagem("local-anatel").
    RUN piCargaImagem("local-anatel-lado").

    /*PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".*/
      PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

    /************************** IMPRESSAO EM 600 dpi *****************************
    FOR EACH tt-lista-ns:                                                           
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/      
                                                                                    
        PUT "^XA" SKIP.                                                             
                                                                                    
        {esapi/esapi016a5034-600dpi.i}  /* Embalagem */                             
        {esapi/esapi016a11-600dpi.i 3}  /* Etiqueta de Produto (34x21mm) */         
        {esapi/esapi016a12-600dpi.i 2}         /* etiqueta 24x8mm */                       
                                                                                    
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.                                                             
                                                                                    
        IF l-reimp THEN                                                             
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).                          
    END.                                                                            
                                                                                    
    /* Limpa a imagem da impressora */                                              
    PUT UNFORMATTED                                                                 
        "^XA^IDselo-suframa.GRF^FS^XZ".     
    ****************************************************************************/


    {esapi/esapi016inic-600dpi.i} /*inicializa par≥metros impressora*/   

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.

        //LOGO Anatel
        PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

        {esapi/esapi016a5034-600dpi.i}  /* USAR - Embalagem */                             
        {esapi/esapi016a11-600dpi.i 3}  /* Etiqueta de Produto (34x21mm) */         
        {esapi/esapi016a12-600dpi.i 2}  /* etiqueta 24x8mm */  


        



        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDselo-suframa.GRF^FS^XZ".
END. /* modelo 638 */


/* Modelo similiar ao 620 porem para 200dpi, etiqueta tripla */ 
IF  p-cod-modelo = 639 THEN DO:

    ASSIGN i-cont = 0.

    FOR EACH tt-lista-ns:

        ASSIGN i-cont = i-cont + 1.

        ASSIGN i-tot = i-tot + 1.

        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na varivel c-cgc*/        

        CASE i-cont:
            WHEN 1 THEN DO: /* Etiqueta 1 */
               PUT "^XA" SKIP.
       
               PUT UNFORMATTED "^FO110,30^BQR,2,3^FDQA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
               
       
               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".
       
               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.
       
                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.
       
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO70,15^A0B,16,16^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                    //   IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO210,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.
       
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO70,15^A0B,16,16^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO90,15^A0B,16,16^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.
       
               
               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.
       
               PUT UNFORMATTED "^FO50,30^A0B,16,16^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.    
               PUT UNFORMATTED "^FO240,60^A0B,16,16^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 
       
               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO260,40^A0B,16,16^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.
               
       
               IF i-tot = p-qtd-etiquetas 
               THEN DO:
                   PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                   PUT "^XZ" SKIP.
               END.
            END. /* FIM etiqueta 1 */
       
            WHEN 2 THEN DO: /* Etiqueta 2 */
       
               
               PUT UNFORMATTED "^FO390,30^BQR,2,3^FDQA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
       
               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".
       
               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.
       
                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.
       
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO350,15^A0B,16,16^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                     //IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO830,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.
                    
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO350,15^A0B,16,16^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO370,15^A0B,16,16^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.
       
               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.
       
               PUT UNFORMATTED "^FO330,30^A0B,16,16^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.               
               PUT UNFORMATTED "^FO520,60^A0B,16,16^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 
       
               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO540,40^A0B,16,16^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.
       
               IF i-tot = p-qtd-etiquetas 
               THEN DO:
                   PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                   PUT "^XZ" SKIP.
               END.
            END. /* FIM etiqueta 2 */
       
            WHEN 3 THEN DO: /* Etiqueta 3 */
       
               
               PUT UNFORMATTED "^FO670,30^BQR,2,3^FDQA," + "~{SN:" + num-serie.n-serie. // + "~}" + "^FS" SKIP.
       
               ASSIGN i-tot-mac    = 0
                      c-mac        = ""
                      c-mac-ext[1] = ""
                      c-mac-ext[2] = "".
       
               FOR EACH mac-address USE-INDEX num-serie WHERE
                        mac-address.n-serie = num-serie.n-serie
                        NO-LOCK.
                   
                   ASSIGN i-tot-mac = i-tot-mac + 1.
       
                   IF item-ean.qtd-mac = 1 
                   THEN DO:
                       ASSIGN c-mac = c-mac + ",MAC2" + ":" + mac-address.mac.
       
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO630,15^A0B,16,16^FDMAC2:"  + STRING(mac-address.mac) + "^FS".
                     //IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO1470,232^A0N,40,40^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
                   ELSE DO:
                       ASSIGN c-mac = c-mac + ",MAC" + STRING(i-tot-mac) + ":" + mac-address.mac.
                   
                       IF i-tot-mac = 1 THEN ASSIGN c-mac-ext[1] = "^FO630,15^A0B,16,16^FDMAC1:"  + STRING(mac-address.mac) + "^FS".
                       IF i-tot-mac = 2 THEN ASSIGN c-mac-ext[2] = "^FO650,15^A0B,16,16^FDMAC2:" + STRING(mac-address.mac) + "^FS".
                   END.
               END.
       
               PUT UNFORMATTED c-mac + "~}" + "^FS" SKIP.
       
               PUT UNFORMATTED "^FO610,30^A0B,16,16^FDNS:" STRING(num-serie.n-serie) "^FS" SKIP. /* Imprime Data Vertical */ 
               PUT UNFORMATTED c-mac-ext[1] SKIP.
               PUT UNFORMATTED c-mac-ext[2] SKIP.  
               PUT UNFORMATTED "^FO800,60^A0B,16,16^FD" STRING(num-serie.it-codigo) "^FS" SKIP. /* Imprime Data Vertical */ 
       
               IF num-serie.int-2 <> 0 
               THEN DO:
                   PUT UNFORMATTED "^FO820,40^A0B,16,16^FDREIMP:" c-seg-usuario "^FS" SKIP. /* Imprime Data Vertical */ 
               END.
       
               IF i-tot = p-qtd-etiquetas 
               THEN DO:
                   PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
                   PUT "^XZ" SKIP.
               END.
            END. /* FIM etiqueta 3 */
        END CASE.
       
       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        FIND FIRST num-serie WHERE
                   num-serie.n-serie = tt-lista-ns.num-serie
                   EXCLUSIVE-LOCK NO-ERROR.

        IF AVAIL num-serie 
        THEN DO:
            ASSIGN num-serie.int-2 = 1.
            RELEASE num-serie.
        END.

    END.
END. /* modelo  639 */


IF p-cod-modelo = 640 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    RUN piCargaImagem("local-anatel5").
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FOR EACH tt-lista-ns:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        /*
        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.*/
        
        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = p-it-codigo NO-ERROR.
        
        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99"). 


        PUT "^XA" SKIP.

        //LOGO INTELBRAS
        PUT UNFORMATTED "^FO244,0^GFA,03840,03840,00040,:Z64:eJztlT1y2zAQRpfDeFioYJPUPAqcG7gI6xwF0LhQ6Sv4HKngUZEyZVpo0rhkyYLi5vtAiiIo2dIBiBlZJvT4tNwfSGRd61rXJ6t093GVj29Pw1X2+PUDzoRobYcru+8/5aqbnG3mPr3B3faZO333xpc+78e+IX+385LLfb7RetMnQTZBSgX4y9G3ecfm5lXKV7zpdFsVxHZSgSvU02eV3k60w4dnzoQMF/QZvOBTdZJrnxOxc67AJ/RZGOxeVRuo+5K8zjns4NVmIODD3xb6zmA3S7gKhpFz0RfDtdjN+P/E4c4WXA7CR1/PUOnNEx+5SpuCXPQpQm3oLRIfvqErqURE0adO9UBvmXJH7arjU6l/taHvJ8I8HvRIX/3jzOEpetTX9IKo9toW8DW5BtOXky1yvlDU1yBs+nymb9xCEosFlyt9iJDxeQHnwOX6MucO6gYOSWT+UIUDZJ1kqW/ikCDWA1X9p1L28O36hMOdiM8GG+s7bEXfDhmd+zJ9IRf7hRx96Edy7aXvDY0S+5lbkXue5zly2La/NQzzMfm28/pOvj9DP898W9Y6iY8+7qU+Z9msy+/V/sv5eVkydeYq15bv5/wxL25zlWvKDg8N7pQ/h5dP4kMljYaqZWlFT/WAa87RR86bFr7YLxL7BZxdcJwJZ1tMSMgZJGTlFV/BEc7Qf54DsCWHtriMDxMzzIfnfDyTi++68OUjZz1SC7FwmmM9Lrjd4ENqcbYgsNGX5g+37+N54HE6dBmTOHJpfd3IqefM0meu+nB7YBNZDBrPFR59MZRFX+H2Jp5/mD1mECf24Fv0KZLfVOxnTCXjEB6Vy77nfs6pc0y/YWXxAQ4HcOHEffteS1aL4HcXZ0n9iJ/geC0PUj/UtaxrXetaV7L+A5e5BEU=:5C33^FS" SKIP.

        PUT UNFORMATTED "^FT82,179^A0B,34,33^FH\^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO190,90^BY5^BEN,80,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FT808,179^A0B,34,33^FH\^FD" item-ean.it-codigo "^FS" SKIP.
        PUT UNFORMATTED "^FO230,225^A0N,39,38^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO258,280^A0N,39,38^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO50,203^GB771,0,127^FS^LRN" SKIP. /* Quadro preto */

        PUT UNFORMATTED "^FO80,380^BY4^BCN,45,N,N,N,N^FD" num-serie.n-serie "^FS"        SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO210,430^ADN,30,15^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Valor do Codigo de Barras EAN128 */

        PUT UNFORMATTED "^FO320,470^A0N,35,35^FD" "LOTE: " TRIM(STRING(i-nr-ord-prod-escpp166,'>,>>>,>99')) "^FS" SKIP.

        PUT UNFORMATTED "^FO740,450^A0N,50,45^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FT194,364^A0N,28,28^FH\^FD" CAPS(item-ean.texto[13]) /*"CFOAC-BLI A/B-CM-01-FO-CO-LSZH"*/ "^FS" SKIP.

        PUT UNFORMATTED "^FO61,528^A0N,20,20^FD" "Produzido por:" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO340,528^A0N,20,20^FD" "Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira^FS" SKIP.

        PUT UNFORMATTED "^FO61,560^A0N,22,22^FD" estabelec.endereco + " - " + estabelec.bairro "^FS" SKIP.
        PUT UNFORMATTED "^FO61,590^A0N,22,22^FD" estabelec.cidade + "/" + upper(estabelec.estado) + " - " STRING(estabelec.cep) "^FS" SKIP.
        PUT UNFORMATTED "^FO61,620^A0N,22,22^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
        PUT UNFORMATTED "^FO61,650^A0N,25,24^FD" "www.intelbras.com.br  Ind£stria Brasileira" "^FS" SKIP.              

        PUT UNFORMATTED "^FO61,877^A0N,25,24^FD" "Prazo de validade: " CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO61,905^A0N,23,24^FD" "Composiá∆o: " CAPS(item-ean.texto[14])   "^FS" SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FT61,953^A0N,23,24^FD" "Este produto Ç beneficiado pela legislaá∆o de inform†tica^FS" SKIP.
            END.
        END.  

        PUT UNFORMATTED "^FO61,970^A0N,23,24^FD" "Suporte a clientes: "  item-ean.fone   "^FS" SKIP.
        PUT UNFORMATTED "^FO61,998^A0N,23,24^FD" "F¢rum: forum.intelbras.com.br" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,1026^A0N,23,24^FD" "Suporte via chat: intelbras.com.br/suporte-tecnico" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,1053^A0N,23,24^FD" "Suporte via e-mail: suporte@intelbras.com.br" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,1081^A0N,23,24^FD" "SAC: 0800 7042767" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,1109^A0N,23,24^FD" "Onde comprar? Quem instala? 0800 7245115" "^FS" SKIP.
        PUT UNFORMATTED "^FO63,511^GB775,0,2^FS" SKIP.

        /* Imagens */

        PUT UNFORMATTED "^FO308,682^GFA,03200,03200,00020,:Z64:eJztlj1u2zAUx0kKMAsO0gkKrQFRGD1B05t0DYIeQYiYBEiBDL1CNQpE4DN469j2BOFoaCjUTYNiluR7iklJ6NahaJ5tGX745a/3SYWQ/8LKceFiWqu574O1C3DnbK5mne1Tn9TOmtTnsZkg64It5axdys0iBCy98e5neJnIxZHrI58AOd1Gvron9TzAS4f6+A4nF+1R8hhl4RMNgtFtg2aayCt/2foKnhJ5+5xykgjGeOLe+0vhOZNyoYQzX7bGrXSEzgvjzVdwjRtm3LyA3pYdJmRWwGD1CidX9NY4X8CH519Zv+SgbjJuCIc867hxDOK6jCewBJ1ET4JOoldDwxI9P3nOt/Xf6KLYiJibGhHrcSxwzE2TF29IgQWOB1BgI+IBLBGIuTB4O9jgKb5zWDUacxKFYr16hQt161QSH3Aqi+cAV5fF8wIrqXjMwe6qjb8+/IFDPbGiV8YcHC0qWeA64qZ5hnyVjPWQq+P9gPqp8NWkdUk4rJ+O9w36QZODKATWwQloYm4M5XveX0iUJXowBzzhNuHky6GK6AtKfVA9nS9BSKYHagDqlPMNVlOX0fzAQBqnc034uun0/PP7xmecm7xms9ulT5DaQjLLJ82/Y+6Z0GeGujr/skOFTkMOzDAjO9MdLpAbyJAZ3r9++vH0HTnWkpY17gnSEv8Jxgc6clP0ZHSnG9Ylb8nDRuWBnrhypEe+Lwc6ZD3FcZZuUoSSTu3EvasyW+yvBtpzQ3H85AXrhLoIMTIDvqrij1+uB6fGn26Ra8/Y/T1p3F2FvmkwjYp/e6S9j9F+wr9tPm7uPrPG6eVqA76sr4qvNjOji1HxPaSrtbjRzM2zEoopSNcei9tjYT1HkHPLIW46oQ9CCcLAV+yr8nos1Vg4rkBOSUFa/1bS/YCykKuSjOfEoecTtyXbnLzZkjZXW53D3Neeq64c56awtMEniZTk7MxLSi2W/xK92Iv9RfsNIyzlNw==:A502^FS". /* Impressao da Imagem ANATEL */   
        PUT UNFORMATTED "^FO266,837^A0N,28,28^FD" CAPS(item-ean.homolog) "^FS" SKIP.

        PUT UNFORMATTED "^FO61,1153^A0N,28,28^FD" "Siga a Intelbras nas redes sociais:" "^FS" SKIP.

        PUT UNFORMATTED "^FO692,1120^GFA,01152,01152,00012,:Z64:eJztkjFuwzAMRRUYSEajCDLrGp2sU/QszZKwQAaPvVK2zr2BegN1qgeFrCiKkhIU6JYu5eKHB0GiP2nMn9VAqbywZY7CjhmFgZmEM9IL40r4rB4LD50vnB/YEH09Fx4oGDOqT58tC+ZTOqF+JFrUW6QIxXNzIB4f08NOPO6Td+JjZvHxsNjqwQ/Vw9tH8esIc6BJvb208zZCPe8Q1B+Zfce/eJjqPZd0f/OvS+tn/vy5z7BpHl3z9X/XeEw5TF0+TnOjllvipeRGM1HQnN93uwfN2fNwio+8EzIvzAP2tzPtZ327D7onhTNe7VW/byNzEF49pTL/dbf6BhiiJkA=:A9D6^FS". /* Instagram */
        PUT UNFORMATTED "^FO628,1120^GFA,00768,00768,00012,:Z64:eJy90rEKwyAQBuCTGzL2ATqkj9C9BR8tzZsFfBG3ro6CoTb6w3lJKO0Qei4fR/wNekR/LZOX8nBXHOG++AXb4gxX5mlrA9cgTrksGP2AeKc8ymG/+SnmGp+i/LJ8o+3mO0tOvFLzhQYxKfNk4TTGzlvpn0Jzf4B58TncDs1cOem+m20cvtzVzmH7dqze1+D+/Yd5eOxmRs+SnjFqW1u9AeKNMLo=:3289^FS". /* Linkedin */
        PUT UNFORMATTED "^FO596,1120^GFA,00512,00512,00008,:Z64:eJy90bENwjAQBdBvpXCZETwIiIxF6YzmUSwxAC5dAMf/5wSJCikFbp5iJ3ffF+A/azauB5DkC1ikHfKZhz0Nm+/frfrzzWqU1cokWypB9nl127TCDZsMd9W5QlJmQ6LMiri572f1o953/Ri+rFDfkxUox9l0d+CisjrHqLEUlvOc/Mzz8fVRJx+ci891n2+U/fd/eQPWpK42:A777^FS". /* Twitter */
        PUT UNFORMATTED "^FO532,1120^GFA,00512,00512,00008,:Z64:eJy9kbERgCAQBGEMCI2MtROasB9wLMTcJrQUSzA0cMRXlkASjbyAmx0enj+U+l3T2MjqguhQOtzyRfTZRF/wtXz6Vr/7hF9HdhtCf7mwhr2Lrmq4hAtYw/LGm6UwsoXZp84bmHu8henT0d/Qf4Dtl3my+dcsnyXllnJMuYqq9sNnnGQWFxQ=:715B^FS". /* Youtube */
        PUT UNFORMATTED "^FO468,1120^GFA,00512,00512,00008,:Z64:eJzF0L0RgCAMBeDnWVgygqOwkSuE0TIKI1BScGACNLHwPC18zdfk5+4BP2dpkgxsagWc2oDdGOCNbAR1yzRP0zRe5Kt+3GG6NWHMv7Xy8ejPF4P2ZXTd3i+T9LuqRYqXJYo4AXYE4X4=:C66B^FS" skip. /* Facebook */
        
        PUT UNFORMATTED "^PQ1,0,1,Y^XZ" SKIP.
        
        /* Etiqueta Caixa */
        
        PUT "^XA" SKIP.

        //LOGO INTELBRAS
        PUT UNFORMATTED "^FO244,0^GFA,03840,03840,00040,:Z64:eJztlT1y2zAQRpfDeFioYJPUPAqcG7gI6xwF0LhQ6Sv4HKngUZEyZVpo0rhkyYLi5vtAiiIo2dIBiBlZJvT4tNwfSGRd61rXJ6t093GVj29Pw1X2+PUDzoRobYcru+8/5aqbnG3mPr3B3faZO333xpc+78e+IX+385LLfb7RetMnQTZBSgX4y9G3ecfm5lXKV7zpdFsVxHZSgSvU02eV3k60w4dnzoQMF/QZvOBTdZJrnxOxc67AJ/RZGOxeVRuo+5K8zjns4NVmIODD3xb6zmA3S7gKhpFz0RfDtdjN+P/E4c4WXA7CR1/PUOnNEx+5SpuCXPQpQm3oLRIfvqErqURE0adO9UBvmXJH7arjU6l/taHvJ8I8HvRIX/3jzOEpetTX9IKo9toW8DW5BtOXky1yvlDU1yBs+nymb9xCEosFlyt9iJDxeQHnwOX6MucO6gYOSWT+UIUDZJ1kqW/ikCDWA1X9p1L28O36hMOdiM8GG+s7bEXfDhmd+zJ9IRf7hRx96Edy7aXvDY0S+5lbkXue5zly2La/NQzzMfm28/pOvj9DP898W9Y6iY8+7qU+Z9msy+/V/sv5eVkydeYq15bv5/wxL25zlWvKDg8N7pQ/h5dP4kMljYaqZWlFT/WAa87RR86bFr7YLxL7BZxdcJwJZ1tMSMgZJGTlFV/BEc7Qf54DsCWHtriMDxMzzIfnfDyTi++68OUjZz1SC7FwmmM9Lrjd4ENqcbYgsNGX5g+37+N54HE6dBmTOHJpfd3IqefM0meu+nB7YBNZDBrPFR59MZRFX+H2Jp5/mD1mECf24Fv0KZLfVOxnTCXjEB6Vy77nfs6pc0y/YWXxAQ4HcOHEffteS1aL4HcXZ0n9iJ/geC0PUj/UtaxrXetaV7L+A5e5BEU=:5C33^FS" SKIP.

        PUT UNFORMATTED "^FT82,179^A0B,34,33^FH\^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO190,90^BY5^BEN,80,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FT808,179^A0B,34,33^FH\^FD" item-ean.it-codigo "^FS" SKIP.
        PUT UNFORMATTED "^FO230,225^A0N,39,38^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO258,280^A0N,39,38^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO50,203^GB771,0,127^FS^LRN" SKIP. /* Quadro preto */

        PUT UNFORMATTED "^FO80,380^BY4^BCN,45,N,N,N,N^FD" num-serie.n-serie "^FS"        SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO210,430^ADN,30,15^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Valor do Codigo de Barras EAN128 */
        
        PUT UNFORMATTED "^FO320,470^A0N,35,35^FD" "LOTE: " TRIM(STRING(i-nr-ord-prod-escpp166,'>,>>>,>99'))  "^FS" SKIP.

        PUT UNFORMATTED "^FO740,450^A0N,50,45^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
        
        PUT UNFORMATTED "^FO194,344^A0N,28,28^FD" CAPS(item-ean.texto[13]) /*"CFOAC-BLI A/B-CM-01-FO-CO-LSZH"*/ "^FS" SKIP.

        PUT UNFORMATTED "^FO61,528^A0N,22,20^FD" "Produzido por:" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO340,528^A0N,22,20^FD" "Ind£stria de Telecomunicaá∆o Eletrìnica Brasileira^FS" SKIP.

        PUT UNFORMATTED "^FO61,560^A0N,22,22^FD" estabelec.endereco + " - " + estabelec.bairro "^FS" SKIP.
        PUT UNFORMATTED "^FO61,590^A0N,22,22^FD" estabelec.cidade + "/" + upper(estabelec.estado) + " - " STRING(estabelec.cep) "^FS" SKIP.
        PUT UNFORMATTED "^FO61,620^A0N,22,22^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
        
        PUT UNFORMATTED "^FO61,670^A0N,23,24^FD" "Prazo de validade: " CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO61,700^A0N,23,24^FD" "Composiá∆o: " CAPS(item-ean.texto[14])   "^FS" SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
                PUT UNFORMATTED "^FO61,730^A0N,23,24^FD" "Este produto Ç beneficiado pela legislaá∆o de inform†tica^FS" SKIP.
            END.
        END.                                    

        PUT UNFORMATTED "^FO61,760^A0N,25,24^FD" "www.intelbras.com.br  Ind£stria Brasileira" "^FS" SKIP.             

        PUT UNFORMATTED "^FO61,790^A0N,23,24^FD" "Suporte a clientes: "  item-ean.fone   "^FS" SKIP.
        PUT UNFORMATTED "^FO61,820^A0N,23,24^FD" "F¢rum: forum.intelbras.com.br" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,850^A0N,23,24^FD" "Suporte via chat: intelbras.com.br/suporte-tecnico" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,880^A0N,23,24^FD" "Suporte via e-mail: suporte@intelbras.com.br" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,910^A0N,23,24^FD" "SAC: 0800 7042767" "^FS" SKIP.
        PUT UNFORMATTED "^FO61,940^A0N,23,24^FD" "Onde comprar? Quem instala? 0800 7245115" "^FS" SKIP.
        PUT UNFORMATTED "^FO63,511^GB775,0,2^FS" SKIP.

        /* Imagens */

        /* Retangulo */
        PUT UNFORMATTED "^FO57,961^GB722,163,8^FS" SKIP.

        /* Setas */
        PUT UNFORMATTED "^FO500,960^GFA,02560,02560,00016,:Z64:eJzt1TEOgkAQBVA2mmynrYUJp7DmFMSj2IlH4yJEjkAnBeHLfGfHsLEjGlSmmPCYDfuzxZIkS0W1Y1+b9+ybyN58Zk9jX4LBp6weuwhePYyny6E7NGrPiUNrbuhOnXLi0UcO84yTFNBARWQAXDV2AcaQjTgZem0u6UbjcmL2tDNvaVnVmluu6jRucK9xZSJvoXFlQjNgfpTtD7mdz+vz+3e7meWZmn+q3/39Zf/Fv+nP1qoCbqfh0q+uvOHlxxHqGz33ugP3clMJ:6C45" SKIP.

        /* Guarda Chuva*/ 
        PUT UNFORMATTED "^FO596,960^GFA,03840,03840,00024,:Z64:eJztlj1qwzAUx5/ipA4E6m7N4OKOHTtminOEHiDgK2To0CFg05Nk7Bk66Sg+godAM8RWnz/19RQopFCoH0KYH38//SVZzwIY4w8Fc/CJg984+K2D7x38ROPZmebMoWeFI//BwTcOfr2YcZpPMpr7Dh5QfAqQUuI5wJriS4CY4qumWbnr5ZwSci+nc/sUnzv0O9Rzguf016Zs7Z3Dy6PK69zoPQRjk4N2zHq63NRjvOFIGu+84OheZruaIY82BnxqXVk7ELaziEyOK8cyWz/dtucxNPikOthGUJoKQfFACPFBOBd1mNYBFg3PqewYpck90UZm8KTjR4N3WFSUmzo44cZ2lAxcrxAD1gdgkmsDeApXB4gUrs4gVrhaglKFq4YUrBpS7aiGPI1LQ4HGCweX+kjj0lCscTmB1KHXsJxAY/9LDP3Aq3cUieoT+xifs56XLD1DWj5gn5SQ9BPGQxLlsDgtgxP2sOj1eBTvcwiK0C/AP8oq4eMrHAvkCl/EB8glxzPr8xAhNvairHSGbYm9enjryrbBtm16+ydglcIuzIPYx/KH+mvl3/5y/tH/5fyj/8v5R/8X8mPhIf3jvZDMjxWOzs8d/gt4JfkOnkm+ZzuSr8nbW/2T4SQPqozkrrv8/45vyqV9wA==:B7EC" SKIP.

        /* Copo */
        PUT UNFORMATTED "^FO340,960^GFA,02560,02560,00016,:Z64:eJzdVTtu3DAQpaAAKrd0Fx2FY8DBljmCj+FSupl1hBxBRQ6gwoUKQcybH0nJNnYDBAmQAVbS28f5D8kQ/jehWv6IxeQyC2wyXgS3Ga+CrxlvgrsT3/0mf1nZJxOGl/e43TkQwfS8EF13JH/d6Mjvsr5fTFWMACOtjl03H/Nx1hhqzGsOvJRC8TBTQAyBKj5K6dIo/AS8nPCJH34+PekXnvh3QDVG+TIeeDKetbQ7kfnHRPQomIwPmZ88atUvOCqeHT+8vABrlrtNwVjx+hLeqsovx8gdU8BVKHy3W5Ucb0d9rrBU2brab8f1vPbAL9a1ds1VFoyus6ALdK34wXnVb5DeQZ+reKn54Lz4b5PFaFMmuIpfnqov+cPKIX+hqqnpC94LLvUVKpapktJb/Ucbgqr/+vnKX+g6p8+PNHnmOjo2X4thtaRWv4aC3/D4wpmk3JncQsabYfu47I59/5NMAA3Kt2rWHFvp5a045HNksnV+LhiO5jeZnz7VLybEwasuQ9vTG5L/ljY7/9okzXF3fID9CM2QMaZ/Be1hsuUkPxecSLImFAPAWZ0NjDGrI/OHhCS4BiYoge7wbMB65wJ+usGf9OOZd8zDjzNABoAq/pb+rfju9R/05IP/kv899qcb/L3+/1b+Vfulvxnz7j/1H1sk7tX6PpXpZYlrmW4W7IA8/eJ+hosSAO+gppq/jmcv2nwi6++4Auh5y/mL70sJQDZYV+bdrlvHfsEvJzx/wrdHTJmnj/Xl9pEL59/LL6P4Jf8=:BC3E" SKIP.

        /*Imagem Quantidade */
        PUT UNFORMATTED "^FO52,960^GFA,03840,03840,00024,:Z64:eJzt07FKw0AcBvDEo55ISB0UMqQm4AuIi0HEpG/gILgoTfAFElQEEXMacFHqK7j7EhcL1kF0EhfBC8Vdtw6aM1eTOpj/IOgg5hs/fny5O1pJqlLlV1KTnIlJWZ5aaS5LEzVnysl7+4yZ04icph6XrHrfYHkfPrv+Po4f04DTvfprq+h3GTOXELtg3jnpq4sLxb6fZR69xDSI6YPe0IqezTJzDjFCPUKuFLXoZWfL9XdwIHx8rdT1Wn4gZjFzJjKFZzeqqiHy4amW+Uh4Gt8ouNHMh6gmvDXwbWXEOCj8mutvd9eFTy4V3IrzfZrt9yKNMo8kR+qITaVi3w/uOo3B/r2Oh+cXnkdjYr+XKuPD89MtN+Ddmjh/lytY/7yva/LOqPARbw/vK94n2//wqycNTc57i1kJ6aDMHx+i9qImk+L9w4Tu4MxnX7l9bT3l57eZHZMNRJiXjsqnfbuXe8M3mtImyvwblh+fjaT4sPX1tzCIDvRjQF+lSpUfyxLQh0DPSWkt83KOAI8BXwe8AXgb8CHgQ8gD9923y/0e4E3AO9B7Ah58/8pX/g/6kKflHOhDXv4HhnYg/919yFf5T3kH7TDd7w==:60D4" SKIP.

        /* Retangulo */
        PUT UNFORMATTED "^FO244,960^GFA,01920,01920,00012,:Z64:eJztk01OwzAQhceNwLuEXVkgcoPSZXfJEVgQsewVegHknIcFa1a03MQSByCVihSVNMP430UJYlcJ8SxZ9tfpePw8ATiVSjt+KXZfqWE2qNRr/KrXyNVaGp7Smh8+KpIQdABDqUJv1B+YaNQ67/Ssea7JdKdmsVFzsteH1PoAdBNpTSjpTT3YlLC0/L0FKF4M33b0W264xDpprw1vxIbvHM9kIVPLeSdKx6HvwcWD6MDzQsLMcSrY83Xr488O6Dlvi9rlz9WwvKiTZxu/xZLhstSbN1X/k7sXWWLvpYzL3H0plBtuLDCcd8G3TAZXY59j/w/NBSkXat1+Io2+gON3hNq848ScqwUDGuwfVmnZ+n2fHOeJue6TpfOT5P1X9Ufc+89uA6etj+e7wJMGUs9XgafzEH8V8ct5yL+I+GIR4lcRl3Ofn20CT+qQn0f8HEL+afXgeYZY+3hE34eTyT7UD9G5ENX/jc8G+bif6Qh38SXJvsv+kWS/r7F3HO+TQZk+ufs5zz//2/z0+gI+vfP+:B74E" SKIP.

        /* Redes Sociais */
        PUT UNFORMATTED "^FO61,1153^A0N,28,28^FD" "Siga a Intelbras nas redes sociais:" "^FS" SKIP.

        PUT UNFORMATTED "^FO692,1120^GFA,01152,01152,00012,:Z64:eJztkjFuwzAMRRUYSEajCDLrGp2sU/QszZKwQAaPvVK2zr2BegN1qgeFrCiKkhIU6JYu5eKHB0GiP2nMn9VAqbywZY7CjhmFgZmEM9IL40r4rB4LD50vnB/YEH09Fx4oGDOqT58tC+ZTOqF+JFrUW6QIxXNzIB4f08NOPO6Td+JjZvHxsNjqwQ/Vw9tH8esIc6BJvb208zZCPe8Q1B+Zfce/eJjqPZd0f/OvS+tn/vy5z7BpHl3z9X/XeEw5TF0+TnOjllvipeRGM1HQnN93uwfN2fNwio+8EzIvzAP2tzPtZ327D7onhTNe7VW/byNzEF49pTL/dbf6BhiiJkA=:A9D6^FS". /* Instagram */
        PUT UNFORMATTED "^FO628,1120^GFA,00768,00768,00012,:Z64:eJy90rEKwyAQBuCTGzL2ATqkj9C9BR8tzZsFfBG3ro6CoTb6w3lJKO0Qei4fR/wNekR/LZOX8nBXHOG++AXb4gxX5mlrA9cgTrksGP2AeKc8ymG/+SnmGp+i/LJ8o+3mO0tOvFLzhQYxKfNk4TTGzlvpn0Jzf4B58TncDs1cOem+m20cvtzVzmH7dqze1+D+/Yd5eOxmRs+SnjFqW1u9AeKNMLo=:3289^FS". /* Linkedin */
        PUT UNFORMATTED "^FO596,1120^GFA,00512,00512,00008,:Z64:eJy90bENwjAQBdBvpXCZETwIiIxF6YzmUSwxAC5dAMf/5wSJCikFbp5iJ3ffF+A/azauB5DkC1ikHfKZhz0Nm+/frfrzzWqU1cokWypB9nl127TCDZsMd9W5QlJmQ6LMiri572f1o953/Ri+rFDfkxUox9l0d+CisjrHqLEUlvOc/Mzz8fVRJx+ci891n2+U/fd/eQPWpK42:A777^FS". /* Twitter */
        PUT UNFORMATTED "^FO532,1120^GFA,00512,00512,00008,:Z64:eJy9kbERgCAQBGEMCI2MtROasB9wLMTcJrQUSzA0cMRXlkASjbyAmx0enj+U+l3T2MjqguhQOtzyRfTZRF/wtXz6Vr/7hF9HdhtCf7mwhr2Lrmq4hAtYw/LGm6UwsoXZp84bmHu8henT0d/Qf4Dtl3my+dcsnyXllnJMuYqq9sNnnGQWFxQ=:715B^FS". /* Youtube */
        PUT UNFORMATTED "^FO468,1120^GFA,00512,00512,00008,:Z64:eJzF0L0RgCAMBeDnWVgygqOwkSuE0TIKI1BScGACNLHwPC18zdfk5+4BP2dpkgxsagWc2oDdGOCNbAR1yzRP0zRe5Kt+3GG6NWHMv7Xy8ejPF4P2ZXTd3i+T9LuqRYqXJYo4AXYE4X4=:C66B^FS" SKIP. /* Facebook */

        PUT UNFORMATTED "^PQ1,0,1,Y^XZ" SKIP.

    END.
END. /* modelo 640 */


IF p-cod-modelo = 644 THEN DO:

    {esapi/esapi016inic.i} /*inicializa parmetros impressora*/

    RUN piCargaImagem("local-anatel5").
    
    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    FOR EACH tt-lista-ns:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        /*
        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.*/
        
        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = p-it-codigo NO-ERROR.
        
        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99"). 

        PUT "^XA" SKIP.

        PUT UNFORMATTED "^FT567,85^A0B,25,22^FH\^FD" item-ean.it-codigo "^FS" SKIP.
        PUT UNFORMATTED "^FT56,85^A0B,20,19^FH\^FD" STRING(TODAY,"99/99/99") "^FS" SKIP.
        /*PUT UNFORMATTED "^BY4,3,40^FT76,49^BCN,,Y,N" SKIP.
        PUT UNFORMATTED "^FD>;" STRING(item-mat.cod-ean, "9(13)") "^FS" SKIP.*/

        PUT UNFORMATTED "^FO120,15^BY4^BEN,40,Y,N^FD" STRING(item-mat.cod-ean, "9(13)") "^FS" SKIP.

        PUT UNFORMATTED "^FO170,100^A0N,28,28^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^FO170,130^A0N,28,28^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO34,89^GB540,0,77^FS^LRN" SKIP.

        PUT UNFORMATTED "^FO110,170^BY2^BCN,45,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FT190,234^A0N,20,22^FH\^FDNS:" num-serie.n-serie "^FS"   SKIP.  /* Valor do Codigo de Barras EAN128 */

        PUT UNFORMATTED "^FO500,175^A0N,50,45^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */

        PUT UNFORMATTED "^FO460,230^XGlocal-anatel5.GRF^FS" SKIP. /* Impressao da Imagem ANATEL */ 
        PUT UNFORMATTED "^FO424,290^A0N,20,19^FD" item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO36,240^A0N,17,16^FDProduzido por: " item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO310,240^A0N,17,16^FD" "Ind£stria Brasileira^FS" SKIP.
        PUT UNFORMATTED "^FO35,260^A0N,17,16^FDInd£stria de Telecomunicaá∆o Eletrìnica Brasileira^FS" SKIP.
        PUT UNFORMATTED "^FO35,280^A0N,17,16^FD" estabelec.endereco + " - " + estabelec.bairro "^FS" SKIP.
        PUT UNFORMATTED "^FO35,300^A0N,17,16^FD" estabelec.cidade + "/" + upper(estabelec.estado) + " - " STRING(estabelec.cep) "^FS" SKIP.
        PUT UNFORMATTED "^FO260,300^A0N,17,16^FD" "www.intelbras.com.br  ^FS" SKIP.                                     
        PUT UNFORMATTED "^FO34,320^A0N,17,16^FDCNPJ:" string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
        PUT UNFORMATTED "^FO260,320^A0N,17,16^FD" item-ean.fone "^FS" SKIP.

        PUT UNFORMATTED "^PQ1,0,1,Y^XZ" SKIP.

    END.
END. /* modelo 640 */


IF p-cod-modelo = 658 THEN  DO:

    IF item-ean.tp-fabric = 1 THEN DO: /*CKD*/
    
        FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.
    
        IF NOT AVAIL ord-prod THEN DO:
        
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
        END.
    END.

    PUT "^XA"         SKIP.   /* Inicio Label */
    PUT "^PW3500"     SKIP.   /* Width 832 */
    PUT "^MNY"        SKIP.   /* Papel de etiquetas n∆o continuo */
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */
    PUT "^BY2"        SKIP.   /* Magnitude EAN */ 
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */
    PUT "^JUS"        SKIP.   /* Grava Configuracao */
    PUT "^XZ"         SKIP.       
    
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = v_cod_estab_usuar NO-LOCK NO-ERROR.

    IF AVAIL estabelec THEN
       ASSIGN c-cgc = STRING(estabelec.cgc,"99.999.999/9999-99").
    
    FOR EACH tt-lista-ns:

        FOR FIRST num-serie NO-LOCK
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:
        END.

        PUT "^XA" SKIP.

        PUT UNFORMATTED "^FO90,60^A0N,50,50^FD"  item-ean.it-codigo "^FS"         SKIP.
        PUT UNFORMATTED "^FO620,60^A0N,50,50^FD"  STRING(TODAY,'99/99/9999') "^FS" SKIP.
        PUT UNFORMATTED "^FO960,60^A0N,50,40^FD"   item-ean.char-2   "^FS"         SKIP.
        
        IF p-num-po <> 0 THEN
           PUT UNFORMATTED "^FO90,175^A0N,50,50^FDOP:" STRING(p-num-po) "^FS" SKIP.

        PUT UNFORMATTED "^FO750,175^A0N,50,50^FD"   num-serie.sigla   "^FS" SKIP.
        PUT UNFORMATTED "^FO960,175^A0N,50,40^FD"   item-ean.origem   "^FS" SKIP.

        PUT UNFORMATTED "^FO1490,175^A0N,50,50^FD" STRING(TODAY,'99/99/9999') "^FS" SKIP.

        /*
        IF i-cont <= p-qtd-etiquetas THEN DO:
            PUT UNFORMATTED "^FO265,20,1^A0B,17,16^FD" item-ean.it-codigo         "^FS" SKIP.

            IF item-ean.char-3 <> "" THEN DO:
                 PUT UNFORMATTED "^FO30,20^A0N,17,16^FD" item-ean.char-2 "^FS"    SKIP.
                 PUT UNFORMATTED "^FO125,20^A0N,17,16^FD" item-ean.char-3 "^FS"    SKIP.
            END.
            ELSE
               PUT UNFORMATTED "^FO30,20^A0N,17,16^FD"    item-ean.char-2  "^FS" SKIP.


            PUT UNFORMATTED "^FO30,38^A0N,17,16^FD"    "CNPJ:" c-cgc              "^FS" SKIP.
            PUT UNFORMATTED "^FO30,56^A0N,17,16^FD"    item-ean.fone              "^FS" SKIP.
            PUT UNFORMATTED "^FO30,74^A0N,14,16^FD"    item-ean.origem            "^FS" SKIP.

            PUT UNFORMATTED "^FO30,92^A0N,17,16^FD"  STRING(TODAY,'99/99/9999') "^FS" SKIP.

            PUT UNFORMATTED "^FO30,120^A0N,17,16^FD"   item-ean.info-tec[1]       "^FS" SKIP.
            PUT UNFORMATTED "^FO30,140^A0N,17,16^FD"   item-ean.info-tec[2]       "^FS" SKIP.
            
          
            ASSIGN i-cont = i-cont + 1.
        END.

        IF i-cont <= p-qtd-etiquetas THEN DO:
           PUT UNFORMATTED "^FO545,20,1^A0B,17,16^FD" item-ean.it-codigo         "^FS" SKIP.  

           IF item-ean.char-3 <> "" THEN DO:
                PUT UNFORMATTED "^FO310,20^A0N,17,16^FD" item-ean.char-2 "^FS"    SKIP.
                PUT UNFORMATTED "^FO405,20^A0N,17,16^FD" item-ean.char-3 "^FS"    SKIP.
           END.
           ELSE
              PUT UNFORMATTED "^FO310,20^A0N,17,16^FD"   item-ean.char-2         "^FS" SKIP.   

           PUT UNFORMATTED "^FO310,38^A0N,17,16^FD"   "CNPJ:" c-cgc              "^FS" SKIP.   
           PUT UNFORMATTED "^FO310,56^A0N,17,16^FD"   item-ean.fone              "^FS" SKIP.   
           PUT UNFORMATTED "^FO310,74^A0N,14,16^FD"   item-ean.origem            "^FS" SKIP.   

           PUT UNFORMATTED "^FO310,92^A0N,17,16^FD"  STRING(TODAY,'99/99/9999') "^FS" SKIP. 

           PUT UNFORMATTED "^FO310,120^A0N,17,16^FD"  item-ean.info-tec[1]       "^FS" SKIP.   
           PUT UNFORMATTED "^FO310,140^A0N,17,16^FD"  item-ean.info-tec[2]       "^FS" SKIP.  

           ASSIGN i-cont = i-cont + 1.
        END.
      
        IF i-cont <= p-qtd-etiquetas THEN DO:
           PUT UNFORMATTED "^FO830,20,1^A0B,17,16^FD" item-ean.it-codigo         "^FS" SKIP.   

           IF item-ean.char-3 <> "" THEN DO:
                PUT UNFORMATTED "^FO590,20^A0N,17,16^FD" item-ean.char-2 "^FS"    SKIP.
                PUT UNFORMATTED "^FO685,20^A0N,17,16^FD" item-ean.char-3 "^FS"    SKIP.
           END.
           ELSE
              PUT UNFORMATTED "^FO590,20^A0N,17,16^FD"   item-ean.char-2          "^FS" SKIP.   

           PUT UNFORMATTED "^FO590,38^A0N,17,16^FD"   "CNPJ:" c-cgc              "^FS" SKIP.   
           PUT UNFORMATTED "^FO590,56^A0N,17,16^FD"   item-ean.fone              "^FS" SKIP.   
           PUT UNFORMATTED "^FO590,74^A0N,14,16^FD"   item-ean.origem            "^FS" SKIP.   

           PUT UNFORMATTED "^FO590,92^A0N,17,16^FD"  STRING(TODAY,'99/99/9999') "^FS" SKIP. 

           PUT UNFORMATTED "^FO590,120^A0N,17,16^FD"  item-ean.info-tec[1]       "^FS" SKIP.   
           PUT UNFORMATTED "^FO590,140^A0N,17,16^FD"  item-ean.info-tec[2]       "^FS" SKIP.   
        END.
        */
    
        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.
END.

IF p-cod-modelo = 626 THEN DO:

   {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/

   FIND FIRST param-global NO-LOCK NO-ERROR.

    DO i-cont = 1 TO p-qtd-etiquetas:

        FIND FIRST item-dun
             WHERE item-dun.it-codigo = p-it-codigo
             AND   item-dun.qtd-emb   = p-qtd-embalagem
                   NO-LOCK NO-ERROR.

        FIND FIRST item-mat NO-LOCK
             WHERE item-mat.it-codigo = p-it-codigo NO-ERROR.

        IF lastec THEN DO:
            FOR FIRST item FIELDS(cod-estabel)
                WHERE item.it-codigo = item-ean.it-codigo NO-LOCK:
                    FOR FIRST estabelec
                        WHERE estabelec.cod-estabel = item.cod-estabel NO-LOCK:
                    END.
            END.
        END.
        ELSE DO:
            FIND FIRST estabelec 
                WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
        END.
        
        ASSIGN c-cgc  = STRING(estabelec.cgc,"99.999.999/9999-99").    

        PUT "^XA" SKIP.

        //LOGO iNTELBRAS
        PUT UNFORMATTED "^FO40,10^GFA,3450,3450,46,,::::::::::::I01F8,I07FET01FFX03FE00FF8,I0IFT0IFW01FFE07FF8,I0IFS01IFW01FFE07FF8,001IF8R01IFW01FFE07FF8,::I0IFS01IFW01FFE07FF8,:I07FES01IFW01FFE07FF8,I01F8S01IFW01FFE07FF8,Y01IFW01FFE07FF8,:K0FL07EK01KFEL01F8K01FFE07FF801FCQ0FCK01FCO07KF,I03FFK0JFJ01KFEK03IFCJ01FFE07FF83IFCN01IFCI03IFEM07LF8,I0IFJ03JFCI01KFEJ01KF8I01FFE07FF9KF8M0KF801KFCK01MF,I0IFJ0LF8001KFEJ07KFEI01FFE07NFEL03KF807LFK03MF,I0IFI03LFC001KFEI01MF8001FFE07OF8K07KF01MFCJ0NF,I0IFI07MF001KFEI07MFC001FFE07OFEJ01KFE03MFEI01NF,I0IF001NF801KFCI0OF001FFE07PFJ03KFC07NFI01NF,I0IF003NFC01KFC001OF801FFE07PF8I07KF80OF8003NF,I0IF003NFE01KFC003OFC01FFE07PFCI0LF81OFC007MFE,I0IF007NFE01KFC007OFE01FFE07PFE001LF03OFE007MFE,I0IF00PF01KF800PFE01FFE07QF001KFE07PF007MFE,I0IF01JF00JF81IFK0JF801JF01FFE07JF801JF003IFCI0JFC01JF80IFC,I0IF01IFC003IF81IFJ01IFE001JF81FFE07IFEI07IF803IFJ0IFEI03IF80IF8,I0IF01IF8I0IF81IFJ03IF8003IFE01FFE07IF8I01IFC07FFEI01IFCI01IFC0IF8,I0IF03IFJ0IFC1IFJ03IFI0JFC01FFE07IFK0IFC07FFCI01IF8J0IFC0IF8,I0IF03FFEJ07FFC1IFJ03FFE001JF001FFE07FFEK07FFC07FFCI03IFK07FFE0IF8,I0IF03FFCJ03FFC1IFJ07FFC007IFE001FFE07FFEK03FFE0IF8I03FFEK03FFE07FFC,I0IF03FFCJ03FFC1IFJ07FFC00JF8001FFE07FFCK03FFE0IF8I03FFCK03FFE07KFE,I0IF03FFCJ03FFC1IFJ07FF803JFI01FFE07FFCK01FFE0IFJ07FFCK01IF03LFE,I0IF03FFCJ03FFC1IFJ07FF807IFCI01FFE07FF8K01FFE0IFJ07FFCK01IF03MFC,I0IF03FFCJ03FFC1IFJ07FF81JF8I01FFE07FF8K01FFE0IFJ07FFCK01IF01MFE,I0IF03FFCJ03FFC1IFJ07FF83IFEJ01FFE07FF8K01FFE0IFJ07FF8K01IF00NF,I0IF03FFCJ03FFC1IFJ07FF8JFCJ01FFE07FF8K01FFE0IFJ07FF8K01IF007MF8,I0IF03FFCJ03FFC1IFJ07FFBJFK01FFE07FF8K01FFE0IFJ07FFCK01IF003MFC,I0IF03FFCJ03FFC1IFJ07LFCK01FFE07FF8K01FFE0IFJ07FFCK01IFI0MFE,I0IF03FFCJ03FFC1IFJ07LF803F801FFE07FFCK03FFE0IFJ03FFCK01IFI03LFE,I0IF03FFCJ03FFC0IFJ07KFE003FF01FFE07FFCK03FFE0IFJ03FFEK03IFM07IF,I0IF03FFCJ03FFC0IFJ07KFC007FFC1FFE03FFEK07FFE0IFJ03FFEK03IFM01IF,I0IF03FFCJ03FFC0IF8I03KFI0IFC1FFE03IFK0IFC0IFJ03IFK07IFN0IF,I0IF03FFCJ03FFC0IFCI03JFE001IF81FFE03IF8I01IFC0IFJ01IF8J0JFN0IF,I0IF03FFCJ03FFC07FFEI01JF8003IF81FFE01IFCI03IF80IFJ01IFEI03JFN0IF,I0IF03FFCJ03FFC07IFI01JF800JF01FFE01JFI0JF80IFK0JFI07JFM01IF,I0IF03FFCJ03FFC03IFE040JFE07JF01FFE00JFE07JF00IFK0JFE03KFM03IF,I0IF03FFCJ03FFC03KFE07OFE01FFE007OFE00IFK07QF01OF,I0IF03FFCJ03FFC01LF07OFC01FFE003OFE00IFK03QF01NFE,I0IF03FFCJ03FFC00LF03OF801FFE001OFC00IFK01QF01NFE,I0IF03FFCJ03FFC007KF81OF001FFEI0OF800IFL0QF03NFC,I0IF03FFCJ03FFC003KFC07MFE001FFEI07MFEI0IFL07PF03NFC,I0IF03FFCJ03FFC001KFE03MF8001FFEI03MFCI0IFL01PF03NF8,I0IF03FFCJ03FFCI0LF00MFI01FFEJ0MFJ0IFM0PF03NF,I0IF03FFCJ03FFCI03KF803KFCI01FFEJ03KFEJ0IFM03OF03MFC,I0IF03FFCJ03FFCJ0JFEI0KFJ01FFEK0KFK0IFN0KF1IF03MF8,I0IF03FFCJ03FFCK0IFK0IFK01FFEL0IFL0IFO0IF81IF03LFC,,:::::^FS" SKIP.

        PUT UNFORMATTED "^FO50,87^A0N,22,22^FDConteudo:^FS" SKIP.

        PUT UNFORMATTED "^FO50,115^A0N,18,18^FD" ENTRY(1,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO50,132^A0N,18,18^FD" ENTRY(2,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO50,149^A0N,18,18^FD" ENTRY(3,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO50,166^A0N,18,18^FD" ENTRY(4,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO50,183^A0N,18,18^FD" ENTRY(5,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO50,200^A0N,18,18^FD" ENTRY(6,item-ean.desc-kit,';') "^FS" SKIP.

        IF  (item-ean.char-2 = "Fabricado por:" OR
            item-ean.char-2 = "Importado por:") THEN DO:
            PUT UNFORMATTED "^FO50,230^A0N,22,18^FDDistribuido por: Intelbras S/A     ^FS"  SKIP.

            PUT UNFORMATTED "^FO50,350^A0N,22,18^FD " item-ean.char-2 " " item-ean.char-3 "^FS" SKIP.
        END.
        ELSE DO:

            PUT UNFORMATTED "^FO50,230^A0N,22,18^FD" item-ean.char-2 " " item-ean.char-3 "^FS"  SKIP.

            /*
            IF item-ean.char-2 = "INTELBRAS S/A" THEN 
               PUT UNFORMATTED "^FO50,230^A0N,22,21^FDFabricado por: Intelbras S/A     ^FS"  SKIP.
            ELSE 
               PUT UNFORMATTED "^FO50,230^A0N,22,21^FDImportado por: Intelbras S/A     ^FS"  SKIP.*/
        END.   

        
        PUT UNFORMATTED "^FO50,250^A0N,22,18^FDIndustria de Telecomunicacao Eletronica Brasileira^FS" SKIP.
        PUT UNFORMATTED "^FO50,270^A0N,22,18^FD" estabelec.endereco "^FS" SKIP.
        PUT UNFORMATTED "^FO50,290^A0N,22,18^FD" estabelec.bairro + " " + estabelec.cidade + "/" + estabelec.estado + " - " STRING(estabelec.cep) "^FS" SKIP.
        PUT UNFORMATTED "^FO50,310^A0N,22,18^FD" "CNPJ: " string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.
        PUT UNFORMATTED "^FO50,330^A0N,22,18^FD" item-ean.origem "^FS" SKIP.
        
        
        PUT UNFORMATTED "^FO515,42^A0N,22,21^FD" item-ean.fone "^FS" SKIP.
        //PUT UNFORMATTED "^FO515,65^A0N,22,21^FDSAC:0800 7042767^FS" SKIP.
        PUT UNFORMATTED "^FO515,65^A0N,22,21^FDF¢rum:forum.intelbras.com.br^FS" SKIP.
        PUT UNFORMATTED "^FO515,88^A0N,22,21^FDSuporte via chat: ^FS" SKIP.
        PUT UNFORMATTED "^FO515,111^A0N,22,21^FDchat.apps.intelbras.com.br ^FS" SKIP.
        PUT UNFORMATTED "^FO515,134^A0N,22,21^FDSuporte via e-mail: ^FS" SKIP.
        PUT UNFORMATTED "^FO515,157^A0N,22,21^FDsuporte@intelbras.com.br^FS" SKIP.
        PUT UNFORMATTED "^FO515,180^A0N,22,21^FDwww.intelbras.com.br ^FS" SKIP.
        PUT UNFORMATTED "^FO515,203^A0N,22,21^FDOnde comprar? Quem instala?^FS" SKIP.
        PUT UNFORMATTED "^FO515,226^A0N,22,21^FDSAC:0800 7042767^FS" SKIP.
        
        PUT UNFORMATTED "^FO515,282^A0N,18,18^FD" "Prazo de Validade: " CAPS(item-ean.texto[12]) "^FS" SKIP.
        PUT UNFORMATTED "^FO515,299^A0N,18,18^FD" "Composiá∆o: " CAPS(item-ean.texto[14]) "^FS" SKIP.
        PUT UNFORMATTED "^FO515,316^A0N,18,18^FD" CAPS(item-ean.texto[15]) "^FS" SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.

        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
            
               //PUT UNFORMATTED "^FO105,492^A0N,12,12^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.

                PUT UNFORMATTED "^FO515,333^A0N,18,18^FDEste produto e beneficiado ^FS" SKIP.
                PUT UNFORMATTED "^FO515,350^A0N,18,18^FDpela legislacao da informatica^FS" SKIP.
            END.
        END.   

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.
    END.

END.


IF  p-cod-modelo = 627 THEN DO:    
    
    ASSIGN i-cont = 0.                                                                                                                                                           
                                                                                                                                                                                 
    /* Carrega a imagem para a impressora */                                                                                                                                     
    //RUN piCargaImagem("local-logoma2").    

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST item-mat 
         WHERE item-mat.it-codigo = item-ean.it-codigo   NO-LOCK NO-ERROR.
                                                                                                                                                                                 
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "~~DG" + imagem-etiq.nome-tec.                                                                                                                           
    END.  
    
 //   RUN piCargaImagem("local-suframa").                                                                                                                                          
                                                                                                                                                                                 
    IF NOT AVAIL imagem-etiq THEN DO:                                                                                                                                            
        RUN piGeraErro (INPUT 17006,                                                                                                                                             
                        INPUT "N∆o existe imagem cadastrada para o item " + item-ean.it-codigo + " e modelo " + STRING(p-cod-modelo) + ", solicitar a Engenharia industrial.").  
        RETURN "NOK".                                                                                                                                                            
    END.       

    
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/                                                                                                                  
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:                                                                                                                                                        
        FOR FIRST num-serie NO-LOCK                                                                                                                                              
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:                                                                                                                     
        END.                                                                                                                                                                     
                                                                                                                                                                                 
        //{esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/                                                                                                   

        FIND FIRST estabelec 
              WHERE estabelec.cod-estabel =IF v_cod_estab_usuar <> "" AND v_cod_estab_usuar <> ? THEN v_cod_estab_usuar ELSE "101" NO-LOCK NO-ERROR.
      
        PUT "^XA" SKIP.   

        PUT UNFORMATTED "^FO35,35,1^A0B,18,18^FD" STRING(num-serie.data, "99/99/9999") "^FS" SKIP. /* Imprime Data Vertical */                                                   
        PUT UNFORMATTED "^FO125,35^BY3^BEN,70,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */                                               
        PUT UNFORMATTED "^FO520,35,1^A0B,26,26^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */                                                                                    
        PUT UNFORMATTED "^FO20,145^A0N,26,26^FB500,1,0,C^FD"    caps(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */                                           
        PUT UNFORMATTED "^FO20,170^A0N,26,26^FB500,1,0,C^FD"  caps(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */    

        IF item-ean.destaque = "" THEN DO:
           PUT UNFORMATTED "^LRY^FO20,135^GB500,0,60^FS^LRN" SKIP.  /* Quadro preto */        
        END.
        ELSE DO:
           IF item-ean.destaque = '127V' THEN DO:
              PUT UNFORMATTED "^LRY^FO20,135^GB440,0,60^FS^LRN" SKIP.  /* Quadro preto */  
              PUT UNFORMATTED "^FO477,145,^A0B,35,22^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */

              /* Quadrado branco destaque */
              PUT UNFORMATTED "^FO465,136^GB45,0,4^FS" SKIP. /* Linha superior */
              PUT UNFORMATTED "^FO465,193^GB45,0,4^FS" SKIP. /* Linha inferior */
              PUT UNFORMATTED "^FO465,136^GB0,62,4^FS" SKIP. /* Linha lateral esquerda */
              PUT UNFORMATTED "^FO510,136^GB0,62,4^FS" SKIP. /* Linha lateral direita  */
           END.
           ELSE DO:

               PUT UNFORMATTED "^LRY^FO20,135^GB440,0,60^FS^LRN" SKIP.  /* Quadro preto */        
               PUT UNFORMATTED "^FO477,143,^A0B,35,22^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */

               PUT UNFORMATTED "^LRY^FO465,136^GB50,60,40^FS^LRN" SKIP. /* Quadro preto destaque */
           END.
        END.

        PUT UNFORMATTED "^FO90,200^BY2^BCN,32,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */                                                          
        PUT UNFORMATTED "^FO20,238^ADN,18,10^FB500,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */                                             
        PUT UNFORMATTED "^FO465,240^A0N,26,26^FB50,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */                                                                             
                                                                                                                                                                                 
        ASSIGN i-cont = 0.                                                                                                                                                       
                                                                                                                                                                                 
        FOR EACH it-mod-img-etiq                                                                                                                                                 
            WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                
            AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                             
            FIRST imagem-etiq                                                                                                                                                    
            WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK BY it-mod-img-etiq.sequencia:                                                                      
                                                                                                                                                                                 
            IF i-cont = 0 THEN                                                                                                                                                   
                ASSIGN i-cont = 40.                                                                                                                                              
            ELSE                                                                                                                                                                 
                ASSIGN i-cont = i-cont + 160.                                                                                                                                    
                                                                                                                                                                                 
            PUT UNFORMATTED "^FO" + STRING(i-cont) + ",260^XG" + ENTRY(1,imagem-etiq.nome-tec) + "^FS".                                                                          
        END.                                                                                                                                                                                                                                                                                                                                                          
        
        
        PUT UNFORMATTED "^FO38,388^A0N,14,14^FDCONTEÈDO:^FS" SKIP.
        PUT UNFORMATTED "^FO47,405^A0N,12,12^FD" ENTRY(1,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO47,420^A0N,12,12^FD" ENTRY(2,item-ean.desc-kit,';') "^FS" SKIP.
        PUT UNFORMATTED "^FO47,435^A0N,12,12^FD" ENTRY(3,item-ean.desc-kit,';') "^FS" SKIP.

        PUT UNFORMATTED "^FO280,388^A0N,14,14^FDTENSAO DE ENTRADA:^FS" SKIP.  
        PUT UNFORMATTED "^FO280,405^A0N,12,12^FD" item-ean.texto[1] "^FS" SKIP.

        PUT UNFORMATTED "^FO105,453^A0N,12,12^FDPRAZO DE VALIDADE:" CAPS(item-ean.texto[12]) "^FS" SKIP.  
        PUT UNFORMATTED "^FO105,468^A0N,12,12^FDCOMPOSICAO: " CAPS(item-ean.texto[14]) " " CAPS(item-ean.texto[15])"^FS" SKIP.            

        //PUT UNFORMATTED "^FO105,492^A0N,12,12^FDESTE PRODUTO E BENEFICIADO PELA LEGISLACAO DE INFORMATICA^FS" SKIP.

        FIND ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
        IF  AVAIL ITEM THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF AVAIL int-portaria-movto THEN DO:
            
                PUT UNFORMATTED "^FO105,482^A0N,12,12^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
            END.
        END.   
     
        /*pra baixo alterar */
        
        PUT UNFORMATTED "^FO765,315^A0B,18,18^FB215,1,0,C^FD"  item-ean.nome-abrev "^FS" SKIP.    /* Imprime descricao Equipto */                                                
        PUT UNFORMATTED "^FO785,315^A0B,18,18^FB215,1,0,C^FDNS:" num-serie.n-serie "^FS" SKIP.  /* Numero de s?rie - Etiqueta Secundòria*/ 

        //LOGO iNTELBRAS
        PUT UNFORMATTED "~~DGIntelbras.GRF,01280,020,,:::::::::::H0380Q020,H07C0I07C0J03E780,H07C0I07C0J03EF80,H07C0I07C0J03E780,H03C0I07C0J03EF80,H0380I07C0J03E780,N07C0J03EF80,H03C07C07FC07E03E79F0H07E07C007FE0,H07C0FE07FC0FF83EFBFC00FF9FF00FFE0,H07C3FF87FC1FFC3E7FFE01FF3FF80FFE0,H07C7FFC7F83FFE3EFIF03FE7FFC3FFE0,H07C7FFC7F87FHF3E7FHF83FE7FFE3FFC0,H07CFHFE7F87FHF3EFIFC7FCFHFE3FFC0,H07CF83E7C0FC3FBE7F0FC7C1F83F3E0,H07CF83E7C0F83F3EFE07C781F81F3E0,H07CF01F7C1F0FC3E7C07C781E01F3E0,H07CF01F7C1F1FC3EFC03EF81E00FBFF,H07CF01F7C1F3F83E7803EF81E00F9FFC0,H07CF01F7C1F7E03EF803EF83E00F8FFE0,H07CF01F7C1FFE03E7803EF81E00F8FFE0,H07CF01F7C1FFC63E7C03EF81E00F87FF0,H07CF01F7C1FF0FBE7C07CF81F01F801F0,H07CF01F7C1FF0FBE7C07CF81F01F800F0,H07CF01F7E0FE1F3E3F0FCF81F83F801F0,H07CF01F3FE7FHF3E3FHF8F80FIF9FHF0,H07CF01F1FE7FHF3E1FHF8F807FHF9FHF0,H07CF01F1FE3FFE3E1FHF0F807FHFBFFE0,H07CF01F0FF9FFC3E07FE0F803FHFBFFE0,H07CF01F07F8FF83E07FE0F801FHFBFFC0,H07CF01F01E01C03E00F00F80078FBFF,,:::::::::::::::::::::" SKIP.

        PUT UNFORMATTED "^FT610,84^XGIntelbras.GRF,1,1^FS"  SKIP. /* Intelbras */

        PUT UNFORMATTED "^FO560,75^A0N,14,12^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO560,90^A0N,14,12^FDSAC:0800 7042767^FS" SKIP.
        PUT UNFORMATTED "^FO560,105^A0N,14,12^FDOnde comprar? Quem instala? 0800 7245115^FS" SKIP.
        PUT UNFORMATTED "^FO560,120^A0N,14,12^FDF¢rum:forum.intelbras.com.br^FS" SKIP.
        PUT UNFORMATTED "^FO560,135^A0N,14,12^FDSuporte via chat: intelbras.com.br/suporte-tecnico^FS" SKIP.
        PUT UNFORMATTED "^FO560,150^A0N,14,12^FDSuporte via e-mail: suporte@intelbras.com.br^FS" SKIP.

        IF  (item-ean.char-2 = "Fabricado por:" OR
             item-ean.char-2 = "Importado por:") THEN DO:
            PUT UNFORMATTED "^FO560,165^A0N,14,12^FD" "Distribuido por:" "^FS" SKIP.
        END.
        ELSE DO:
            IF item-ean.char-2 = "INTELBRAS S/A" THEN 
               PUT UNFORMATTED "^FO560,165^A0N,14,12^FD" "Fabricado por:" "^FS" SKIP. 
            ELSE 
               PUT UNFORMATTED "^FO560,165^A0N,14,12^FD" "Importado por:" "^FS" SKIP. 
        END.                                                                          


        PUT UNFORMATTED "^FO560,180^A0N,14,12^FDIntelbras S/A - Industria de Telecomunicacao"  "^FS" SKIP.
        PUT UNFORMATTED "^FO560,195^A0N,14,12^FDEletronica Brasileira^FS" SKIP.
        PUT UNFORMATTED "^FO560,210^A0N,14,12^FD" estabelec.endereco + " - " + estabelec.bairro "^FS" SKIP.
        PUT UNFORMATTED "^FO560,225^A0N,14,12^FD" estabelec.cidade + "/" + estabelec.estado + " - " STRING(estabelec.cep) "^FS" SKIP.
         
        PUT UNFORMATTED "^FO560,240^A0N,14,12^FDCNPJ:" string(estabelec.cgc, param-global.formato-id-federal) "^FS" SKIP.

        PUT UNFORMATTED "^FO560,255^A0N,14,12^FD" item-ean.origem "^FS"   SKIP.
       
        IF item-ean.char-2 = "INTELBRAS S/A" THEN 
           PUT UNFORMATTED "^FO560,270^A0N,14,12^FDwww.intelbras.com.br ^FS" SKIP.

        //Logo Inmetro
        //PUT UNFORMATTED "^FO560,345^GFA,2772,2772,21,,::::::::::::P0FE,O01FF,O03CF,O03C10300CK020C0A601807,O03E00FC3FF79E7F3F8FF8FE1FC,O01FE1CE3DE78E7F738F78EF3CE,P0FF18E78E78E7C038E39E700E,Q0FBFF78E78E783F8E39C01FE,O0387BFF78E78E707B8E39C03CE,O03C7B8078E79E78F38E39E738E,O03FF1CE3FE3DE78F38E39EF39E,O01FF1FE1FE3FE787FCE38FE3FE,P07807800E1CC303986183C1CA,U038EQ03,U03FCR0C,V0F8Q07C,,::::::::::::::J01TFCN03MFC,J01TFCN0EM07,J01TFCM018M018,J01TFCM03K0EI0C,J01TFCM04K0EI02,J01TFCM0CK0EI03,J01TFCL018K0EI018,J01TFCL01L0EJ08,:J01TFCL03L0EJ0C,N01LF8P02L0EJ04,O0LF8P02L0EJ04,O0BKF8P02L0EJ04,O08KF8P02L0EJ04,O087JF8P0207J0EJ04,O081JF8P0207J0EJ04,O080JF8P0207J0EJ04,O0803IF8P02078I0FFI04,O0801IF8P02078I0FFE004,O08007FF8P0207C001IF004,O08003FF8P0207C003E03804,O08001FF8P0207C007E01004,O08I07F8P0207E00FEJ04,O08I03F8P0206600EE1F804,O08J0F8P0206700EE3FE04,O08J078P0206700EE78E04,O08J018P0207380CEFI04,O08K08P0207381CEEI04,O08K08P0206381CECI04,O08K08P02061C1CECI04,:O08K08P02060E1CECI04,O0EK08P02060E1CECI04,O0FK08P0206061CECI04,O0FCJ08P0207071CECI04,O0FEJ08P0207071CECI04,O0FF8I08P0206039CECI04,O0FFCI08P0206039CECI04,O0IFI08P020601CCEEI04,O0IF8008P020601CCE6I04,O0IFE008P020600CCE78604,O0JF808P020600IE3FE04,O0JFC08P020600IE1FC04,O0JFE08P02060077EJ04,O0KF88P02060077E01004,O0KFC8P02060033E03804,O0LF8P02060039IF804,N01LFCP02060038IF004,J01TFCL0206001CFF8004,J01TFCL0206001CEJ04,J01TFCL0206I0CEJ04,J01TFCL0206I0EEJ04,J01TFCL0206I0FEJ04,J01TFCL0206I07EJ04,:J01TFCL0306I03EJ04,J01TFCL0306I03EJ0C,J01TFCL0107I01EJ08,gL0187I01EJ08,gM087I01EI01,gM0C7J0CI03,gM06O06,gM03O0C,gM01CM038,gN078K01E,07F381CE039FE7FF9FE00CM0MF,07F3C1CF079FE7FF9FF07F8,07F3E1CF8F9FE7FF9FF8FFC,01C3F1CF8F9800381C39E1E,01C3F9CFDF9800381C3BC0F,01C3F9CIF9FE0381C73807,01C3BDCEFB9FE0381CE3807,01C39FCE739800381CF3807I0F8F9F079F3C3,01C38FCE739800381C73C0FI0IC9B86DB2C7,01C387CE239800381C79C0EI08D81B84DB1CD,01C387CE039FE0381C39FFEI08D81F04DB0C9,07F383CE039FF0381C3C7FCI0ICD804DB05F8,07F381CE039FE0381C3C3FJ0FCF9807DF7C38,gL0303100306181,,::::::::^FS" SKIP.
      
        PUT UNFORMATTED "~~DGinmetro.GRF,03840,024,,::::M0gWF80,L03FgVFE0,L0F0gV078,K01C0gV01C,K0180gW0C,K030gX06,K070gX07,K060gX03,:K0E0gX0180K0C0gX0180:::::K0C0O0F80gL0180K0C0N03FE0gL0180K0C0N07DE0gL0180K0C0N078E0gL0180K0C0N03E03F8FFBCE7E7F1FE1F87E0L0180K0C0N03FC738E7BCE7E739EF3BCE70L0180K0C0O0FE71DC7BCE7C039C779C070L0180K0C0O01F7FDC7BCE787F9C7780FF0L0180K0C0N078F7FDC7BCE78F39C7780E70L0180K0C0N078E71DE7BCE78E39C779DC70L0180K0C0N03FE7B8FF9FE78F79C73FDEF0L0180K0C0N01FC3F0779FE787B9C71F8F70L0180K0C0T0E780O040O0180K0C0T0HFQ0F0O0180K0C0T07E0O01F0O0180K0C0gX0180::::::::::::::K0C0J0MFC0gK0180K0C0I0380K070L03FRFK0180K0C0I040L0180K07FRF80I0180K0C0I080I0E0H0C0K07FRF80I0180K0C0H010J0E0H060K07FRF80I0180K0C0H030J0E0H020K07FRF80I0180K0C0H020J0E0H010K07FRF80I0180K0C0H040J0E0H0180J07FRF80I0180K0C0H040J0E0I080J07FRF80I0180K0C0H0C0J0E0I080J07FRF80I0180K0C0H080J0E0I080J07FRFK0180K0C0H080J0E0I080N07FJF80M0180K0C0H080J0E0I080N05FJF80M0180K0C0H08180H0E0I080N04FJF80M0180K0C0H081C0H0E0I080N043FIF80M0180K0C0H081C0H0E0I080N040FIF80M0180K0C0H081E0H0HF80080N0407FHF80M0180K0C0H081E0H0HFE0080N0403FHF80M0180K0C0H081E001F9F0080N0400FHF80M0180K0C0H081F003E030080N04007FF80M0180K0C0H081B003E0I080N04003FF80M0180K0C0H081B807E070080N040H0HF80M0180K0C0H081B807E1FC080N040H07F80M0180K0C0H0819C06E78E080N040H01F80M0180K0C0H0819C0EE702080N040I0F80M0180K0C0H0818C0EHEI080N040I0380M0180K0C0H0818E0EHEI080N040I0180M0180K0C0H081860EHEI080N040J080M0180K0C0H081860EEC0H080N040J080M0180K0C0H081870EEC0H080N040J080M0180K0C0H081830EEC0H080N040J080M0180K0C0H081838EEC0H080N070J080M0180K0C0H081838EEC0H080N07C0I080M0180K0C0H08181CEEC0H080N07E0I080M0180K0C0H08181CEHEI080N07F80H080M0180K0C0H08180EIEI080N07FC0H080M0180K0C0H08180E6E60H080N07FE0H080M0180K0C0H0818066E706080N07FF80080M0180K0C0H0818076E3FE080N07FFE0080M0180K0C0H0818076E0FC080N07FHFH080M0180K0C0H081803B60I080N07FHFC080M0180K0C0H081803BE010080N07FHFE080M0180K0C0H081801DE0F8080N07FIFH8N0180K0C0H081801CFHF8080N07FIFC80M0180K0C0H081800CFFE0080N07FJF80M0180K0C0H081800EHEI080N0LF80M0180K0C0H081800EE0I080J07FRF80I0180K0C0H0818006E0I080J07FRF80I0180K0C0H0818007E0I080J07FRF80I0180K0C0H0818003E0I080J07FRF80I0180K0C0H0C18003E0I080J07FRF80I0180K0C0H0C18001E0I080J07FRF80I0180K0C0H0418001E0I080J07FRF80I0180K0C0H0418001E0H010K07FRF80I0180K0C0H02180H0E0H010K07FRFK0180K0C0H02180H0E0H020gJ0180K0C0H01880H040H040gJ0180K0C0I0C0M0C0gJ0180K0C0I060L010gK0180K0C0I0380K0E0gK0180K0C0J07FKF80gK0180K0C0gX0180K0C0V0FE707781CFF7FF3FC0FC00180K0C0V0FE7877C3CFF7FFBFE1FF00180K0C0V0387C77E7CC007038E78700180K0C0V0387E77EFCC007038670380180K0C0H0E1C701863830H0387F77FFCFE07038E60180180K0C003F3EFC3CF6C70H0386F7H7DCFE07039C60180180K0C003320CC2590CF0H03867F739CC007039C60180180K0C0031E0F825918A0H03863F719CC007038E70380180K0C003320F02590DF0H03861F701CC007038E78780180K0C003B36C02C96DF0H0FE60F701CFF07038F3FF00180K0C001E3CC03CF3C30H0FE607701CFF0703871FE00180K0C0V0FE0Y0180K0C0gX0180K060gX0380K060gX03,:K030gX07,K030gX06,K0180gW0C,L0E0gV038,L0780gU0F0,L03FgVFE0,M0gWF80,,:::::::::::::::::::::::^FS" SKIP.
           
        PUT UNFORMATTED "^FT543,490^XGinmetro.GRF,1,1^FS" SKIP.
        PUT UNFORMATTED "^FO585,470^A0N,18,16^FB365,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP.
        PUT UNFORMATTED "^FO585,490^A0N,18,16^FB365,1,0,L^FDData: " STRING(TODAY,'99/99/9999') "^FS" SKIP.

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */                                                                                             
        PUT "^XZ" SKIP.                                                                                                                                                          
                                                                                                                                                                                 
        IF l-reimp THEN                                                                                                                                                          
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).                                                                                                                       
    END.                                                                                                                                                                         
                                                                                                                                                                                 
    /* Limpa a imagem da impressora */                                                                                                                                           
    FOR EACH it-mod-img-etiq                                                                                                                                                     
        WHERE it-mod-img-etiq.it-codigo  = item-ean.it-codigo                                                                                                                    
        AND   it-mod-img-etiq.cod-modelo = p-cod-modelo NO-LOCK,                                                                                                                 
        FIRST imagem-etiq                                                                                                                                                        
        WHERE imagem-etiq.cod-imagem = it-mod-img-etiq.cod-imagem NO-LOCK:                                                                                                       
                                                                                                                                                                                 
        PUT UNFORMATTED "^XA^ID" + ENTRY(1,imagem-etiq.nome-tec) + "^FS^XZ".                                                                                                     
    END.                                                                                                                                                                         
  //  PUT UNFORMATTED "^XA^IDlocal-suframa.GRF^FS^XZ". 

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDinmetro.GRF^FS^XZ".
                                                                                                                                                                                     
END.  /* FIM 627 */


IF p-cod-modelo = 647 THEN DO:

   {esapi/esapi016inic-600dpi.i} /*inicializa par≥metros impressora*/

   FOR EACH tt-lista-ns:
       {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

       FIND FIRST mac-address NO-LOCK 
            WHERE mac-address.n-serie = tt-lista-ns.num-serie NO-ERROR.

       FIND FIRST num-serie NO-LOCK                                                                                                                                              
            WHERE num-serie.n-serie = tt-lista-ns.num-serie NO-ERROR.

       PUT "^XA" SKIP.        

       PUT UNFORMATTED "^FO120,90,1^A0B,40,50^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
       PUT UNFORMATTED "^BY9,2,185^FT201,277^BEN,,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
       PUT UNFORMATTED "^FO1190,90,1^A0B,60,50^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */  

       IF item-ean.destaque = "" THEN DO:
           PUT UNFORMATTED "^FO80,390^A0N,60,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
           PUT UNFORMATTED "^FO80,480^A0N,60,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
           PUT UNFORMATTED "^LRY^FO80,360^GB1090,0,190^FS^LRN" SKIP.  /* Quadro preto */

        END.
        ELSE DO:
            PUT UNFORMATTED "^FO18,390^A0N,60,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
            PUT UNFORMATTED "^FO18,480^A0N,60,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
            PUT UNFORMATTED "^LRY^FO80,360^GB950,0,190^FS^LRN" SKIP.  /* Quadro preto */
        
            IF item-ean.destaque = "CHA" THEN DO:
                RUN piCargaImagem("local-chave").
                PUT UNFORMATTED "^FO1075,407^XGlocal-chave.GRF^FS" SKIP.
            END.
            ELSE
                PUT UNFORMATTED "^FO1085,380,^A0B,80,70^FD" CAPS(item-ean.destaque) "^FS" SKIP.    /* Imprime descricao Equipto */ 
        
            PUT UNFORMATTED "^LRY^FO1050,360^GB40,190,130^FS^LRN" SKIP.  /* Quadro preto destaque */
        END.

       PUT UNFORMATTED "^FO90,580^BY3^BCN,180,N,N,N,N^FD" num-serie.n-serie  "^FS" SKIP.  /* Codigo de Barras EAN 128 */
       PUT UNFORMATTED "^FO120,770^ADN,40,20^FB978^FB700,1,0,C^FDNS:" num-serie.n-serie  "^FS" SKIP. 

       PUT UNFORMATTED "^FO885,570^BQR,2,8^FDQA," num-serie.n-serie "^FS" SKIP.
       
       IF num-serie.sigla <> '' THEN
          PUT UNFORMATTED "^FO160,820^A0N,80,80^FB1000,1,0,R^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
       ELSE 
          PUT UNFORMATTED "^FO160,820^A0N,80,80^FB1000,1,0,R^FD" p-sigla "^FS" SKIP. /* Sigla */

       IF p-num-po <> 0 THEN
          PUT UNFORMATTED "^FO80,820^A0N,80,80^FB720,1,0,L^FDOP:" STRING(p-num-po) "^FS" skip.

       PUT UNFORMATTED
            "^FO2080,272^GFA,06144,06144,00032,:Z64:eJztmLFu4zgQhikpsA4SIF23wDUErowBPYAbucg77Fv4Fchyq3sGlYbcXBmoUrEPcG9wKoVFQGg7F4Z5Q0mkhhapAIstDtiM7UTB4Mtwhv8MmRDyYR/2YT/VPkt53HCHQoje7w6kssHrTxplr9u4lFvRlXGPn8586/FfZqvc7k8zLm9ufyG0ba4ezL3AxpjTHy985wzfmwq4/MFYNuZNIDqrr+lYgLMr/BEtwuH/bfrmLcDv0ze2UQBlib8Ao+WbO0hI5i3AZPE7Eoy2FED0LnoUoGyMv9ED7/GHzRaYC7jBF34FjlZuthAhe5V//eP8j8VPzJYfXAIImEm5dAkgXEIWrhFAF4S6+P2y52P+lwce1dzFhyjnwiHAHImeOjoYi37Kv1otX4u2dAi4QKJzxZ+a7urjg2ns1Sh/K76ePD5ez11ffM1zH4/H3pT/3+v056KxNZ8JNPZO6/jlzA8efo/nvuMIYIgP5Jo/zfHHDXBM4BkfFeTi9dh/XWpR+fjYweNzx3ECmIPn7uYDfe4pAaTr/JeDi2gpW/oNcfxsI77iqYM35x7RrWDlHzv41hd/PoSxP8I8W/ORzv9CjBa4L758J77jCoLj61pgv5W/4waA41ut6IhvteJswTs83v8UjwIHTx081l+xFf9uWtE+v5D+D0snLKb5m9k+m9fhe9OKb07+apZi87r/z6YU9gVoDgpNEzl5nXRnym+f/9TwsVkJtlnzIPqkceWfG9EtvwnbzojOmoTGlvnr5iMjf2sSrvilEvbvJyZpvROt7WcP5X88fg9z0qYTuO2nD+V75LM5qOmEBz5+UO/q/mmrf3X8jwks6ltfX4qp5loIq+sPndbs5UOr+cdn2z4p3JRv4/r361mt3iF07JnUdZ3UNX/myA1/98A7v5LoruoHvdSyFvkj2OwLSSsS1dAHNUiA7zEfy1bxA3QhdP99xYcgNsGzDkQYPovn7Nuf5LTiW+CpJNGNUGg9hv3q5tvwpIImIOErSeDmY8mfyjaSLWCl4S35FqINRQfxC8HDnsADseTPZBvLgbbwwDWPy7e/8OhSpVAEeDirQpAL9rN/gb9SSIK1MfDdA3/6q9uJvmiJOKn4hYpvlZ8Cfyvb+A78lZTt/Jeotiapwub1wMPxQw6wdiz/+E474FVs+AyEfX2y+FBk3a6H2FlfdDtVhd6KH9/oEH+XjOfXcuTlLbgjf3pOq6iq9zyt9vAA5TgH+PTLr/mQDzAxaFd2ueKvAW6/rFOvk+BFV6hdOMEUwqcPHdSLScL+oR0UH7QTYf4PuOsm1aHhMAMrUAHsfYinfwlzD0JLNTs6KD7wMebhwFMrEGr0qvjiIT4beSqV9oEHKdr8BRKHVw1Jqwf4ef5PgN4+ng9lF0PvwNY7eCX9ogtFKIh6UNrbvWEeWqdso/soHaUimw8bkowbr6RfweY3X74kTc2X7SPxwNrgliseHuAYydH8h1yzHvrtTTVgp1Qo+gydP4q/Mh6ACgxPEZ+C4s+QM6gA8t9zuACcUzT/n47wfiHkOD0cycvL8Qk+5MP+7/Yf/vT8kA==:1C55" SKIP. 

       PUT UNFORMATTED "^FO2070,460^A0N,37,37^FD" item-ean.homolog "^FS" SKIP.

       /* Modelo */
       PUT UNFORMATTED "^FO1470,90^A0N,62,62^FB870,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
       PUT UNFORMATTED "^LRY^FO1240,50^GB1250,100,100^FS^LRN" SKIP.  /* Quadro preto */

       /* Informaá‰es Item */
       PUT UNFORMATTED "^FO1350,170^A0N,50,40^FD" item-ean.char-2 "^FS" SKIP.

       PUT UNFORMATTED "^FO1970,170^A0N,50,40^FD" item-ean.origem "^FS" SKIP.

       PUT UNFORMATTED "^FO1970,240^A0N,50,40^FD" STRING(TODAY,'99/99/9999') "^FS" SKIP.

       PUT UNFORMATTED "^FO1350,240^A0N,50,40^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.

       PUT UNFORMATTED "^FO1350,310^A0N,50,40^FB760,1,0,L^FD" /*'Suporte:'*/ item-ean.fone "^FS" SKIP.

       PUT UNFORMATTED "^FO1350,380^A0N,50,40^FB760,1,0,L^FD" item-ean.info-tec[1]  "^FS" SKIP.

       PUT UNFORMATTED "^FO1350,450^A0N,50,40^FB760,1,0,L^FD" item-ean.info-tec[2] "^FS" SKIP.  

       PUT UNFORMATTED "^FO1350,520^A0N,50,40^FB760,1,0,L^FD" item-ean.info-tec[3] "^FS" SKIP.  
      
       IF AVAIL mac-address THEN DO:
          PUT UNFORMATTED "^FO1350,590^BY4^BCN,100,N,N,N,N^FD" mac-address.mac  "^FS" SKIP.  /* Codigo de Barras EAN 128 */
          PUT UNFORMATTED "^FO1350,700^A0N,40,40^FB760,1,0,L^FD" 'MAC:' mac-address.mac  "^FS" SKIP.
       END.

       PUT UNFORMATTED "^FO1350,750^BY3^BCN,100,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
       PUT UNFORMATTED "^FO1350,860^A0N,40,40^FB760,1,0,L^FD" 'NS:' num-serie.n-serie  "^FS" SKIP.

       PUT UNFORMATTED "^FO2160,650^BQR,2,8^FDQA," num-serie.n-serie "^FS" SKIP.

       PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
       PUT "^XZ" SKIP.  
   END.                 

END.


IF  p-cod-modelo = 667 THEN DO:    
    
    ASSIGN i-cont = 0. 

    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/                                                                                                                  
                                                                                                                                                                                 
    FOR EACH tt-lista-ns:                                                                                                                                                        
        FOR FIRST num-serie NO-LOCK                                                                                                                                              
            WHERE num-serie.n-serie = tt-lista-ns.num-serie:                                                                                                                     
        END.           

        ASSIGN i-cont = i-cont + 1.

        IF i-cont = 1 THEN DO:

            PUT "^XA" SKIP. 

            PUT UNFORMATTED "^FT47,72^A0N,11,12^FD" item-ean.char-2  "^FS" SKIP.
            PUT UNFORMATTED "^FH^FT144,72^A0N,11,12^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP.
            PUT UNFORMATTED "^FT47,51^A0N,11,12^FD" item-ean.linha[1] "^FS" SKIP.
            PUT UNFORMATTED "^FT47,61^A0N,11,12^FDANATEL:" item-ean.homolog "^FS" SKIP.
            PUT UNFORMATTED "^BY1,3,22^FT49,24^BCN,,Y,N" SKIP.
            PUT UNFORMATTED "^FD>:"  num-serie.n-serie "^FS" SKIP.
            PUT UNFORMATTED "^FT258,47^A0B,11,12^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.

            IF p-num-po <> 0 THEN
               PUT UNFORMATTED "^FT27,70^A0B,11,12^FDOP:" STRING(p-num-po) "^FS" SKIP.

            PUT UNFORMATTED "^FT38,70^A0B,11,12^FD" UPPER(p-sigla) "^FS" SKIP.
        END.
        ELSE DO:
            PUT UNFORMATTED "^FT346,72^A0N,11,12^FD" item-ean.char-2 "^FS" SKIP.
            PUT UNFORMATTED "^FH^FT442,72^A0N,11,12^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP.
            PUT UNFORMATTED "^FT346,51^A0N,11,12^FD" item-ean.linha[1] "^FS" SKIP.
            PUT UNFORMATTED "^FT346,61^A0N,11,12^FDANATEL:" item-ean.homolog "^FS" SKIP.
            PUT UNFORMATTED "^BY1,3,22^FT348,24^BCN,,Y,N" SKIP.
            PUT UNFORMATTED "^FD>:"  num-serie.n-serie "^FS" SKIP.
            PUT UNFORMATTED "^FT556,47^A0B,11,12^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP.

            IF p-num-po <> 0 THEN
               PUT UNFORMATTED "^FT325,70^A0B,11,12^FH\^FDOP:" STRING(p-num-po) "^FS" SKIP.

            PUT UNFORMATTED "^FT336,70^A0B,11,12^FH\^FD" UPPER(p-sigla)"^FS" SKIP.
            PUT UNFORMATTED "^PQ1,0,1,Y" SKIP. 
            PUT UNFORMATTED "^XZ" SKIP.  

            ASSIGN i-cont = 0.
        END.
    END.

    IF i-cont = 1 THEN DO:
       PUT UNFORMATTED "^PQ1,0,1,Y" SKIP. 
       PUT UNFORMATTED "^XZ" SKIP.  
    END.

END.



IF  p-cod-modelo = 751 THEN DO:

    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    /*
    RUN piCargaImagem("local-suframa").                                             
    */

    PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".
   // PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

   // RUN piCargaImagem("local-suframa"). 

   // {esapi/esapi016inic.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.

        /* Embalagem */
       // PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */ ------- trocado por today abaixo a pedido da Tatiani
        PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO165,92^BY5^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO690,100^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime cÆdigo do item */


        PUT UNFORMATTED "^FO170,270^A0N,70,60^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO110,335^A0N,60,30^FB500,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO50,260^GB680,0,150^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO120,460^BY3^BCN,120,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO168,620^ADN,50,22^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO680,620^A0N,50,50^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
  
        /* Fim Embalagem */

        /* Etiqueta de Produto (34x21mm) */
        /* Número S≤rie */

        PUT UNFORMATTED "^FO980,70^A0N,60,50^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO840,60^GB790,60,40^FS^LRN" SKIP.

        /* Suframa */
        PUT UNFORMATTED "^FO900,250^XGSuframa600dpi.GRF^FS" SKIP.
        
        
        /* etiqueta 24x8mm */
        PUT UNFORMATTED "^FO895,140^A0N,25,25^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO895,165^A0N,25,25^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO895,190^A0N,24,24^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO895,215^A0N,25,25^FD" item-ean.origem "^FS" SKIP.

        PUT UNFORMATTED "^FO1270,190^A0R,25,25^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.
        PUT UNFORMATTED "^FO1300,210^A0R,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.

       // PUT UNFORMATTED "^FO880,395^A0N,25,25^FDEste produto contem o modulo " item-ean.MODULO "^FS" SKIP.
       // PUT UNFORMATTED "^FO880,420^A0N,25,25^FDcodigo de homologacao Anatel " item-ean.homolog "^FS" SKIP.
        PUT UNFORMATTED "^FO880,395^A0N,25,25^FDIncorpora produto homologado pela Anatel sob numero^FS" SKIP.
        PUT UNFORMATTED "^FO1050,420^A0N,25,25^FD" item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO880,455^A0N,30,30^FDNS:" num-serie.n-serie  "^FS" SKIP. 
        PUT UNFORMATTED "^FO1150,455^A0N,30,30^FDCHAVE ACESSO: " num-serie.ch-acesso  "^FS" SKIP. 

        //QR CODE
        ASSIGN c-qr-code  = ""
               i-mac-cont = 0
               c-macs     = "".
              // c-qr-code = "SN:5H07566PAJDC5,DT:iM4,SC:L2F9BAA5,NC:015,MAC1:XXXXXXXXXX,MAC2:XXXXXXXXXY".

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = num-serie.n-serie
                 NO-LOCK.

            ASSIGN i-mac-cont = i-mac-cont + 1.

            ASSIGN c-macs = c-macs 
                          + "MAC"
                          + STRING(i-mac-cont)
                          + ":"
                          + mac-address.mac 
                          + IF i-mac-cont = 1 AND
                               item-ean.qtd-mac > 1
                               THEN "," ELSE "".
        END.

        //comentar a linha abaixo ≤ teste
       // ASSIGN c-macs = "MAC1:ABCDEF123456,MAC2:ABCDEF654321,".

        FIND FIRST num-serie-uuid WHERE
                   num-serie-uuid.n-serie = num-serie.n-serie
                   NO-LOCK NO-ERROR.

        IF AVAIL num-serie-uuid AND 
                 num-serie-uuid.uuid <> "" 
        THEN DO:
           ASSIGN c-qr-code = "~{"
                            + "SN:" 
                            + STRING(num-serie.n-serie) + ","
                            + "DT:"
                            + "" + ","
                            + "NC:"
                            + string(item-ean.nc) + ","
                            + c-macs
                            + ",UUID:" + num-serie-uuid.uuid + ",AUTHKEY:" + num-serie-uuid.authkey
                            + "~}".

           IF LENGTH(item-ean.nc) > 3 THEN DO:

               ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                + "SC:"
                                + string(num-serie.ch-acesso) + ","
                                + "PID:"
                                + string(item-ean.nc) + ","
                                + c-macs
                                + "~}". 
           END.

           PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
        END.
        ELSE DO:
           ASSIGN c-qr-code = "~{"
                            + "SN:" 
                            + STRING(num-serie.n-serie) + ","
                            + "DT:"
                            + string(item-ean.nome-abrev) + ","
                            + "SC:"
                            + string(num-serie.ch-acesso) + ","
                            + "NC:"
                            + string(item-ean.nc) + ","
                            + c-macs
                            + "~}".

            IF LENGTH(item-ean.nc) > 3 THEN DO:

                ASSIGN c-qr-code = "~{"
                                 + "SN:" 
                                 + STRING(num-serie.n-serie) + ","
                                 + "SC:"
                                 + string(num-serie.ch-acesso) + ","
                                 + "PID:"
                                 + string(item-ean.nc) + ","
                                 + c-macs
                                 + "~}". 
            END.

           PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
        END.

        IF LENGTH(item-ean.nc) > 3 THEN DO:

            ASSIGN c-qr-code = "~{"
                             + "SN:" 
                             + STRING(num-serie.n-serie) + ","
                             + "SC:"
                             + string(num-serie.ch-acesso) + ","
                             + "PID:"
                             + string(item-ean.nc) + ","
                             + c-macs
                             + "~}". 
        END.

        
        PUT UNFORMATTED "^FT1720,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT2200,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
         
        CASE item-ean.etiq-1-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1030,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1030,580^A0N,40,40^FD" item-ean.etiq-1-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1030,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP.
            END.
        END CASE.
        


        CASE item-ean.etiq-2-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1900,590^A0N,50,50^FB700,1,0,L^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1900,590^A0N,50,50^FB700,1,0,L^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
            END.
            WHEN 5 THEN DO:
                PUT UNFORMATTED "^FO1940,450^A0N,58,55^FD" STRING(TODAY,"99/99/9999") "^FS"  SKIP. 
                PUT UNFORMATTED "^FO1940,500^A0N,50,50^FB700,1,0,L^FDCHAVE DE ACESSO: ^FS"  SKIP. 
                PUT UNFORMATTED "^FO1940,545^A0N,50,50^FB700,1,0,L^FD" string(num-serie.ch-acesso) "^FS"  SKIP.
                PUT UNFORMATTED "^FT1720,660^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
                PUT UNFORMATTED "^FO1940,590^A0N,50,50^FB700,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP.
            END.                            
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1900,590^A0N,50,50^FB700,1,0,L^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE. 

        /*
        CASE item-ean.etiq-3-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1730,580^A0N,40,40^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1730,620^A0N,40,40^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
            END.
            WHEN 5 THEN DO:
                IF p-cod-modelo = 751 THEN DO:
                   PUT UNFORMATTED "^FO1910,460^A0N,50,50^FB700,1,0,L^FD" STRING(TODAY,"99/99/9999") "^FS"  SKIP. 
                   PUT UNFORMATTED "^FO1910,520^A0N,50,50^FB700,1,0,L^FDSC:" string(num-serie.ch-acesso) "^FS"  SKIP.
                   PUT UNFORMATTED "^FT1720,640^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
                   PUT UNFORMATTED "^FO1910,580^A0N,50,50^FB700,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP.
                END.
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE. 
        */

        // Fim QR Code

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDSuframa600dpi.GRF^FS^XZ".

END. /* modelo 528 */



IF  p-cod-modelo = 752 OR /** Iziplay **/
    p-cod-modelo = 753    /** Mibo **/
    THEN DO:


    /*inicializa par≥metros impressora*/                                                                                                                                         
    PUT "^XA"         SKIP.   /* Inicio Label */                                                                                                                                 
    PUT "^PW2500"      SKIP.   /* Width 832 */                                                                                                                                   
    PUT "^MNY"        SKIP.   /* Papel de etiquetas nío continuo */                                                                                                              
    PUT "^MTT"        SKIP.   /* Papel Comum - usa ribon */                                                                                                                      
    PUT "^BY2"        SKIP.   /* Magnitude EAN */                                                                                                                                
    PUT "^PRA"        SKIP.   /* Velocidade 50mm/seg */                                                                                                                          
    PUT "^JUS"        SKIP.   /* Grava Configuracao */                                                                                                                           
    PUT "^XZ"         SKIP.                                                                                                                                                      

    /*
    RUN piCargaImagem("local-suframa").                                             
    */

    PUT UNFORMATTED "~~DGSuframa600dpi.GRF,04096,032,,Y0F80FE0N03E7F8007E0L07F8,P07FF9FHF07FE0FHF1F87CFHFBE7FF01FF803F0F8FFC,P07FFDFHF8FHF0FHF9F87CFHFBE7FFC3FFC03F0F9FFE,P07FFDFHF9FHF8FHF9F87CFHFBE7FFE7FFE03F8FBFHF,P07CFDF0F9F8FCF8FDF87C03F3E7C7E7C3E03F8FBE1F,P07C7FF079F07CF87DF87C07F3E7C3E7C1F03FCFFC0F80,P07C7FF0FBF07CF87DF87C0FE3E7C3EF81F03FEFFC0F80,P07FFDFHFBF07CF87DF87C1FC3E7C3EF81F03FEFFC0F80,P07FFDFFE3F07CF87DF87C3F83E7C3EF81F03FIFC0F80,P07FF9FHFBF07CF87DF87C3F03E7C3EF81F03EFHFC0F80,P07FF1F1F9F07CF87DF87C7E03E7C3E7C1F03EFHFE1F80,P07C01F0F9F8FCF9FDF8FCFHFBE7CFE7E7E03E7FBF3F,P07C01F079FHF8FHF8FHF8FHFBE7FFC7FFE03E3FBFHF,P07C01F078FHF0FHF8FHF8FHFBE7FF83FFC03E3F9FFE,P07C01F07C7FE0FFE07FF0FHFBE7FF01FF803E1F8FFC,P07C01F07C0F80FE0H0F80K07F0H03C0M0E0,,:::L03FE007F07C007F001F3C1F3FF07C3F1FF1FHFBFF83E07E07C0,L03FFC1FFC7C01FFC01F3E1F3FFC7C3F3FF9FHFBFFE3E07E07C0,L03FFE3FFC7C03FFE01F3F1F3FFE7C3F7FFDFHFBFHF3E07F07C0,L03FFE7FFE7C03FHF01F3F1F3FFE7C3F7CFDFHFBFHF3E0FF07C0,L03E3F7C3F7C07E1F01F3F9F3C3F7C3F7C7C1F03E1F3E0FF07C0,L03E1F7C3F7C07C1F01F3FDF3C1F7C3F7FC01F03E1F3E0FF87C0,L03E3FF81F7C07C0F81F3FDF3C1F7C3F3FF81F03FFE3E1F787C0,L03FFEF81F7C07C0F81F3FHF3C1F7C3F3FFC1F03FFC3E1E7C7C0,L03FFEF81F7C07C0F81F3DFF3C1F7C3F0FFC1F03FFE3E3E7C7C0,L03FFCF81F7C07C1F81F3DFF3C1F7C3F03FE1F03FFE3E3E7C7C0,L03FF87C3F7C0FE1F01F3CFF3C3F7C3F7E7E1F03E1F3E3FFC7C0,L03E007E7E7FFBF3F01F3C7F3FFE7F7F7E7E1F03E1F3E7FFE7FF,L03E007FFE7FFBFFE01F3C7F3FFE3FFE7FFC1F03E1F3E7FHF7FF,L03E003FFC7FF9FFE01F3C3F3FFC3FFC3FFC1F03E1F3E7C1F7FF,L03E0H0HF87FF8FF801F3C1F3FF00FF81FF01F03E1FBEFC1F7FF,Q03C0J01C,,::hK0FC0,U07FE0FHF81F83F03F07E1F03E0FC3E3FE0,U07FF8FHF81FC3F03F07E1F07F0FC3E7FF8,U07FFCFHF81FC7F07F87F1F07F0FC3EFHF8,U07FFEFHF81FC7F07F87F9F0FF0FC3EF8F8,U07C7EF8001FC7F0FF87F9F0FF8FC3EFC,U07C3EFHF01FEFF0FFC7FDF0FF8FC3EFFC0,U07C3EFHF01FEFF0FFC7FHF1F7CFC3E7FF0,U07C3EFHF01FEFF1F3C7FHF1F7CFC3E3FF8,U07C3EFHF01FIF1F3E7DFF1E7CFC3E0FFC,U07C3EF8001FIF1FFE7CFF3FFEFC3E00FC,U07C7EF8001FIF3FFE7CFF3FFEFC7CF87C,U07FFCFHF81F7DF3FHF7C7F3FFE7FFCFHFC,U07FFCFHF81F7DF3FHF7C3F7FHF7FFCFHF8,U07FF8FHF81F7DF7C1F7C3F7C1F3FF87FF8,U07FE0FHF81F3DF7C0FFC1F7C1F1FE01FE0,,:::::K03FhPF0,:::K03FQFI01FXF01FSF0,K03FOFE0K0VFE0H03FRF0,K03FOFN07FRFE0J03FQF0,K03FNF80N0SF80K07FPF0,K03FMFC0O01FPFC0M0OFCF0,K03FMFR07FOF80M01FMF0F0,K03FLF80R0OFC0O01FKFC1F0,K03FKFE0S03FMF80P03FIFE03F0,K03FKF80T0MFE0S07FC007F0,K03FJFE0U07FKF80X07F0,K03FJF80U01FKFg0HF0,K03FIFE0W0KFE0X01FF0,K03FIFY01FIF80X03FF0,K03FFE0g0IFE0I01FHFE0P07FF0,K0380T03FHFJ03FFC0H01FJFE0O0IF0,K03E0S03FJFI01FF0H01FLFC0M03FHF0,K03F0R03FIFC0J0780H07FMFN07FHF0,K03FC0P03FJFC0N01FNFE0K03FIF0,K03FE0P0NFN07C3FMFL0KF0,K03FF80N0OFE0L0F80FNF80H0LF0,K03FFE0M03FOFL01E007FWF0,K03FHF80L0QF80J03E003FWF0,K03FIFL07FPFC0J0380H0XF0,K03FIFE0I07FRFK070I07FVF0,K03FKFH07FSFK060I03FVF0,K03FgHFC0L0800FVF0,K03FgHFC0K07F803FUF0,K03FgIFL0IF803FTF0,K03FgIF80I01FgF0,K03FgIFC0I03FgF0,K03FgIFE0I07FgF0,K03FgJF80H0gHF0,:K03FgJFE003FgGF0,K03FgKFC1FgHF0,K03FhPF0,:::,hM03,hM0780,hM0FC0,hL01FC0,L03E01F07831838FFC1F00E0H070H01C1E070383FF07C1C1C707,L0HF87FC7831838FFC7FC0E0H078003C1E0F0783FF1FE1E1C70F,K01FF8FFE7C31838FFCFFC1F0H078003E1E0F0783FF3FF1F1C70F80,K01C3CF0E7E31838E00E1E1F0H0F8003E1F0F0FC01E7879F1C70F80,K03C1DE0F7E31838E01E0E3F800FC007F1F1F0FC01E7039F9C71F80,K03801C077F31FF8FF9C003B801FC007F1F1F1FC03CF039F9C71DC0,K03801C077FB1FF8FF9C003B801DC00771F9F1CE078E01DHDC73DC0,K03801C077BB1FF8FF9C007FC03FE00FF9FBF1FE0F0E01DDFC73FE0,K0381DC077BF1838E01C0E7FC03FE00FF9FBF3FE1E0F039CFC73FE0,K03C1DE0F79F1838E01E0E7FC03FF01FF9DF73FF3C07039C7C77FE0,K01C3CF0E78F1838E00E1EE1E078701C3DDF73873C07879C7C770F0,K01FF8FFE78F1838FFCFFCE1E070701C1DDF77077FF7FF1C3C77070,L0HF87FC7871838FFC7FCE0E070703C1DCF7703FHF3FF1C3C7E070,L07E03F87871838FFC3F1C070F038381FCE7703FHF0FC1C1C7E070,gH01E,:gH03E,,".
   // PUT UNFORMATTED "~~DGselo-suframa.GRF,07680,040,iL07C,M07FF003FHFJ0HF801FFE003F80FE3FIF8FE3FFC0H01FF80H07F01FC03FF,M07FHF83FIFH03FFE01FHFE03F80FE3FIF8FE3FHFC007FFE0H07F01FC0FHFC0,M07FHFC3FIFC0FIF01FIF03F80FE3FIF8FE3FIFH0JFI07F81FC1FHFE0,M07FHFE3FIFC1FIF81FIF83F80FE3FIF8FE3FIF81FIF8007FC1FC3FIF0,M07FIF3FIFE1FIFC1FIFC3F80FE3FIF8FE3FIF83FIFC007FC1FC7FIF8,M07F1FF3F83FE3FC3FE1FC7FE3F80FE0H0HF8FE3F8FFC3FC3FE007FE1FC7F87FC,M07F07F3F80FE3F80FE1FC1FE3F80FE001FF0FE3F83FC7F81FE007FF0FCFF03FC,M07F03F3F80FE7F80FF1FC0FE3F80FE003FE0FE3F81FE7F00FE007FF8FCFE01FC,M07F07F3F80FC7F007F1FC0FF3F80FE007FC0FE3F80FE7F00FF007FF8FCFE01FE,M07F07F3FIFC7F007F1FC07F3F80FE00FF80FE3F80FE7F00FF007FFCFCFE00FE,M07FIF3FIFC7F007F1FC07F3F80FE00FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FIF3FIF07F007F1FC07F3F80FE01FF00FE3F80FE7F00FF007FFEFCFE00FE,M07FHFE3FIF87F007F1FC07F3F80FE03FE00FE3F80FE7F00FF007F7FFCFE00FE,M07FHFC3FIFC7F007F1FC0FF3F80FE07FC00FE3F80FE7F00FF007F3FFCFE01FE,M07FHF83F83FE7F80FF1FC0FE3F80FE0FF800FE3F81FE7F00FE007F1FFCFE01FC,M07F0H03F81FE3F80FE1FC1FE3F80FE1FF0H0FE3F83FC7F81FE007F1FFCFF03FC,M07F0H03F80FE3FC1FE1FIFE3FC1FE3FIFCFE3FIFC3FC3FE007F0FFC7F87FC,M07F0H03F80FE3FIFE1FIFC3FIFE3FIFCFE3FIF83FIFC007F07FC7FIF8,M07F0H03F80FE1FIFC1FIFC1FIFC3FIFCFE3FIF81FIF8007F03FC3FIF0,M07F0H03F80FE0FIF81FIF80FIF83FIFCFE3FIFH0JFI07F03FC1FHFE0,M07F0H03F80FE07FHF01FIFH07FHF03FIFCFE3FHFC007FFE0H07F01FC0FHFC0,M07F0H03F80FF01FFC01FHFC001FFC0L0FE3FHFI01FF80O03FF,,::::::03FFC0H01FF007F0I07FE0H01FC7F00FC7FFC00FE03F80FFC0FJF9FHFE01FC00FF00FF0,03FHFC007FFC07F0I0IF8001FC7F80FC7FHFC0FE03F81FHF0FJF9FIF81FC00FF00FF0,03FIF01FHFE07F0H03FHFC001FC7F80FC7FHFE0FE03F83FHF8FJF9FIFC1FC00FF00FF0,03FIF83FIF07F0H07FHFE001FC7FC0FC7FIF0FE03F87FHFCFJF9FIFE1FC01FF80FF0,03FIFC3FIF87F0H0KFH01FC7FE0FC7FIF8FE03F8FF3FEFJF9FIFE1FC01FF80FF0,03FIFC7F87FC7F0H0HF0FF001FC7FE0FC7F1FF8FE03F8FE0FE01FC01FC0FE1FC03FFC0FF0,03F81FC7F01FC7F0H0FE07F801FC7FF0FC7F03FCFE03F8FE0I01FC01FC07E1FC03FFC0FF0,03F81FC7F01FC7F001FC03F801FC7FF8FC7F01FCFE03F8FF0I01FC01FC07E1FC03FFC0FF0,03F81FCFE01FE7F001FC03F801FC7FF8FC7F01FCFE03F87FF8001FC01FC0FE1FC07E7E0FF0,03F81FCFE00FE7F001FC01F801FC7FFCFC7F01FCFE03F87FHFH01FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7FFEFC7F01FCFE03F83FHF801FC01FIFC1FC07E7E0FF0,03FIFCFE00FE7F001FC01FC01FC7F7EFC7F01FCFE03F81FHFC01FC01FIF01FC0FC3F0FF0,03FIF8FE00FE7F001FC01FC01FC7F7FFC7F01FCFE03F807FFE01FC01FIF81FC0FC3F0FF0,03FIF0FE01FE7F001FC03F801FC7F3FFC7F01FCFE03F8007FE01FC01FIFE1FC1FC3F0FF0,03FHFE0FF01FE7F001FC03F801FC7F1FFC7F03FCFE03F80H0HF01FC01FC0FE1FC1FIF8FF0,03FC0H07F01FC7F001FE07F801FC7F1FFC7F03F8FF03F8FE07F01FC01FC0FE1FC1FIF8FF0,03FC0H07F83FC7FHFCFF07F801FC7F0FFC7FIF87F87F8FE07F01FC01FC07E1FC3FIFCFIFC,03FC0H03FIFC7FHFCFJFH01FC7F07FC7FIF07FIF0FIFE01FC01FC07F1FC3FIFCFIFC,03FC0H03FIF87FHFC7FHFE001FC7F07FC7FIF03FIF07FHFE01FC01FC07F1FC3FIFCFIFC,03FC0H01FIF07FHFC3FHFE001FC7F03FC7FHFE01FHFE07FHFC01FC01FC07F1FC7F00FEFIFC,03FC0I0IFE07FHFC1FHF8001FC7F01FC7FHFC00FHFC01FHF801FC01FC07F1FC7F00FEFIFC,03FC0I03FF807FHFC07FF0K07F01FC7FHFI03FF0H0HFE001FC01FC07F0H07F00FEFIFC,,:::::hY01,T03FFE003FHFE007FC03FE00FF007F01FC01FC03FC0FF03FF8,T03FHFC03FHFE007FC03FE00FF007F01FC01FE03FC0FF07FFE,T03FIF03FHFE007FE03FE01FF007F81FC03FE03FC0FF0FIF,T03FIF83FHFE007FE07FE01FF807FC1FC03FE03FC0FF1FIF80,T03FIFC3FHFE007FE07FE01FF807FC1FC03FF03FC0FF1FE7F80,T03FC7FC3F0J07FF07FE03FF807FE1FC07FF03FC0FF1FC3F80,T03FC1FE3F0J07FF0FFE03FFC07FF1FC07FF83FC0FF1FC,T03FC0FE3F0J07FF0FFE03FFC07FF1FC07DF83FC0FF1FF80,T03FC0FE3FHFC007FF0FFE07EFE07FF9FC0FDF83FC0FF1FHF0,T03FC0FE3FHFC007FF9FFE07E7E07FFDFC0FCFC3FC0FF0FHFE,T03FC07F3FHFC007FF9FFE0FE7E07FFDFC1FCFC3FC0FF0FIF,T03FC07F3FHFC007F79FFE0FC7F07FIFC1F8FC3FC0FF03FHF80,T03FC0FE3FHFC007F7DEFE0FC3F07F7FFC1F87E3FC0FF01FHF80,T03FC0FE3F0J07F7FEFE1FC3F07F3FFC3F87E3FC0FF0H0HFC0,T03FC0FE3F0J07F7FEFE1F83F87F3FFC3F07F3FC0FF0H03FC0,T03FC1FE3F0J07F3FEFE1FIF87F1FFC3FIF1FC0FF3F81FC0,T03FIFC3F0J07F3FCFE3FIF87F0FFC7FIF1FE1FF3FC1FC0,T03FIFC3FIFH07F3FCFE3FIFC7F07FC7FIF9FIFE3FIFC0,T03FIF83FIFH07F1FCFE3FIFC7F07FCFJF8FIFC1FIF80,T03FIF83FIFH07F1F8FE7F00FE7F03FCFE03F87FHF80FIF80,T03FHFE03FIFH07F1F8FE7F00FE7F01FCFE01FC3FHFH07FHF,T03FHF803FIFH07F1F8FEFE00FE7F01FDFC01FC0FFC003FF8,,::::::::iVFE0,:::::YF8007FhRFE0,XFL01FgKFE0H01FYFE0,WFO07FgIFK01FXFE0,VF80O07FgGF80K01FWFE0,UFC0Q07FYFC0M03FVFE0,TFE0S0YFE0O07FUFE0,TFU01FWF80P0TFE7E0,SFC0U07FUFE0Q01FRF87E0,RFE0W0VF80R01FPFE0FE0,RF80W03FSFE0T01FOF81FE0,QFC0Y07FRF80U03FMFE01FE0,QFgG01FRFX03FLFH03FE0,PFC0gG07FPFC0X07FJF8007FE0,PFgI01FPFgO07FE0,OF80gI07FNFC0gN0HFE0,NFE0gJ03FNF80gM01FFE0,NF80gK0NFE0gN03FFE0,MFC0gL03FLF80gN07FFE0,LFE0gN0LFE0gO0IFE0,LFgP07FJFC0L0KFE0U01FHFE0,JFE0gG07F80K01FJFL01FLFC0T03FHFE0,FC0gH03FJFL07FHFC0J01FNF80S07FHFE0,FE0gG07FKFE0J03FHF80J07FNFE0R01FIFE0,HF80Y07FKF0180J0HFE0J03FPFC0Q03FIFE0,HFC0X0NFN03F80J0SFR0KFE0,IFX03FMFU07FRFC0O07FJFE0,IF80U01FNFU0UF80M01FKFE0,IFE0U0RFC0P03FF7FQFE0M07FKFE0,JF80S07FRFQ07F80FRFC0K03FLFE0,JFE0R03FSFC0N01FE003FRFC0I07FMFE0,KF80Q0UFE0N03F80H0gMFE0,KFE0P07FUFO07F0I07FgKFE0,LF80N03FVFC0M07E0I01FgKFE0,MF80L03FWFE0M07C0J0gLFE0,NFL01FYFN0F80J07FgJFE0,OFJ01FgF80L0F0K01FgJFE0,gUFC0L0E0L0gKFE0,gUFE0T03FgIFE0,gVFO01FF8001FgIFE0,gVF80M03FHF8003FgHFE0,gVFC0M07FIFC001FgGFE0,gVFE0M07FJFC1FgHFE0,gWFN0gQFE0,gWF80K01FgPFE0,gWFC0K01FgPFE0,gWFE0K03FgPFE0,gXF80J07FgPFE0,gXFC0J0gRFE0,gYFJ01FgQFE0,gYFC0H0gSFE0,hF803FgRFE0,iVFE0,:::::,::iH01C,iH03E,iH07E,iH07F,iH0E780,01E0H01F0W0F0gT03E,07FE007FE03C038780787FFE03FE001E0J0780I01E01F007C03E01FHFC1FF80F807878078,0FHF01FHF03E038780787FFE0FHF803E0J0F80I03E01F007C03E01FHFC3FFE0FC07878078,1FHF83FHF83F038780787FFE1FHFC03F0J0F80I03F01F80FC07E01FHFC7FHF0FC078780FC,3F0783E0FC3F0387807870H01F07C03F0I01FC0I03F01F80FC07F0I0F8FC1F0FE078780FC,3C03C7C07C3F8387807870H03E03E07F0I01FC0I07F01FC0FC07F0H01F0F80F8FE078781FC,7C03C7803C3FC387807870H03C01E07F80H01FC0I07F81FC1FC0F78003E1F0078FF078781FE,780H0F801E3FC387807870H03C0I0H780H03DE0I0H781FC1FC0F78007E1E007CF7878781DE,780H0F801E3DE387FHF87FFC3C0I0F780H03DE0I0F781FE1FC0F78007C1E003CF7878783CF,780H0F001E3DF387FHF87FFC3C0I0F3C0H038F0I0F3C1FE3FC1E7C00F81E003CF3C78783CF,780H0F001E3CF387FHF87FFC780H01E3C0H078F0H01E3C1FE3BC1E3C01F01E003CF3E787878F,780H0F001E3C7B87FHF87FFC3C0H01FFE0H07FF0H01FFC1EF3BC1FFC03E01E003CF1E78787FF80,7801CF801E3C7B87807870H03C01E1FFE0H0IF8001FFE1EF7BC3FFE07C01E003CF0F78787FF80,7803CF801E3C3F87807870H03C01E3FFE0H0IF8003FFE1EFF3C3FFE0FC01E007CF0FF878FHF80,3C03C7803C3C3F87807870H03E03C3FHFI0IF8003FHF1E7F3C7FFE0F801F0078F07F878FHFC0,3C07C7C07C3C1F87807870H03E03C780F001E03C00780F1E7F3C780F1F0H0F80F8F03F878E03C0,3F0F83F1FC3C0F8780787FFE1F878780F001E03C00780F1E7E3C780F3FHFCFE3F0F03F879E03C0,1FHF03FHF83C0F8780787FFE0FHF87807803C03C0078079E3E3CF00FBFHFC7FHF0F01F879E01E0,0FFE00FHF03C078780787FFE07FF0F007803C01E00F0079E3E3CF007BFHFC3FFC0F01F87BC01E0,03FC007FC03C078780787FFE03FE0F007803C01E00F0079E1E3CF007BFHFC0FF80F00F87BC00F0,H060I0E0W0F0gT01C,gK01F8,gL0B8,gK03F8,gK03F0,gL040,,::::" SKIP.

   // RUN piCargaImagem("local-suframa"). 

   // {esapi/esapi016inic.i} /*inicializa par≥metros impressora*/

    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na variˇvel c-cgc*/

        PUT "^XA" SKIP.

        /* Embalagem */
       // PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(num-serie.data,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */ ------- trocado por today abaixo a pedido da Tatiani
        PUT UNFORMATTED "^FO60,100^A0B,40,40^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
        PUT UNFORMATTED "^FO165,92^BY5^BEN,90,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
        PUT UNFORMATTED "^FO690,100^A0B,40,40^FD" item-ean.it-codigo "^FS" SKIP. /* Imprime cÆdigo do item */


        PUT UNFORMATTED "^FO170,270^A0N,70,60^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^FO110,335^A0N,60,30^FB500,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.    /* Imprime descricao Equipto */
        PUT UNFORMATTED "^LRY^FO50,260^GB680,0,150^FS^LRN" SKIP.  /* Quadro preto */

        PUT UNFORMATTED "^FO120,460^BY3^BCN,120,N,N,N,N^FD" num-serie.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */
        PUT UNFORMATTED "^FO168,620^ADN,50,22^FDNS:" num-serie.n-serie "^FS" SKIP. /* Valor do Codigo de Barras EAN128 */
        PUT UNFORMATTED "^FO680,620^A0N,50,50^FD" num-serie.sigla "^FS" SKIP. /* Sigla */
  
        /* Fim Embalagem */

        /* Etiqueta de Produto (34x21mm) */
        /* Número S≤rie */

        PUT UNFORMATTED "^FO980,70^A0N,60,50^FB500,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
        PUT UNFORMATTED "^LRY^FO840,60^GB790,60,40^FS^LRN" SKIP.

        
        PUT UNFORMATTED "^FO860,250^XGSuframa600dpi.GRF^FS" SKIP.
                              

        /* etiqueta 24x8mm */
        PUT UNFORMATTED "^FO895,140^A0N,25,25^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO895,165^A0N,25,25^FDCNPJ: " c-cgc "^FS" SKIP.
        PUT UNFORMATTED "^FO895,190^A0N,24,24^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO895,215^A0N,25,25^FD" item-ean.origem "^FS" SKIP.

        //PUT UNFORMATTED "^FO1270,150^A0R,25,25^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.
        //PUT UNFORMATTED "^FO1300,210^A0R,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.

       // PUT UNFORMATTED "^FO880,395^A0N,25,25^FDEste produto contem o modulo " item-ean.MODULO "^FS" SKIP.
       // PUT UNFORMATTED "^FO880,420^A0N,25,25^FDcodigo de homologacao Anatel " item-ean.homolog "^FS" SKIP.

       PUT UNFORMATTED "~~DGlocal-anatel.GRF,02560,020,,:::::::W0JFC,V0LF80,U01FKFE0,T01FMFC,T07FNF,S01FOF,S07FOFC0,R01FPFE0,R03FQF0,R0SF8,Q01FRFC,Q07FRFE,Q0TFE,P01FFC03FOF,P07FC0H0PF80,P0FE0I01FNFC0,O03F80J07FMFE0,O0F0L01FMFE0,N01E0M0OF0,N0380M07FMF0,N060N03FMF8,N040N03FMF8,X01FMF8,Y0NFC,:Y07FLFC,Y07FLFE,::Y07FMF,Y03FMF,N01FHF80K03FMF,N07FHFE0K03FMF,N0KF80J03FMF,M03FJFE0J03FMF,M07FKFK03FMF,M0MF80I03FMF,L01FLFC0I03FMF,L03FLFE0I03FMF,L07FMFJ07FMF,L0OF80H07FMF,K01FNF80H07FMF,K01FNFC0H07FMF,K01FNFE0H07FMF,K03FNFE0H07FMF,K07FNFE0H0OF,K07FOFI0OF,K0QFH01FNF,:K0QF803FNF,::K0QF803FMFE,K0QF807FMFE,:K0QF80FNFE,K0QFH0OFE,K0QF01FNFC,K07FOF03FNFC,:K07FNFE07FNF8,K03FNFE07FNF8,K03FNFE0FOF8,K01FNFC3FOF8,L0OF83FOF0,L0OF07FOF0,L03FMF0FOFE0,L03FLFE0FOFE0,M0MF80FOFE0,M0MF01FOFC0,M07FJFE03FOFC0,M01FJF807FOFC0,N07FIFH0QF80,N03FHFC01FPF80,O03FC003FPF,,::L01F01F0FC0F87FLF8,L03F83F0F80F87FFDFFDF8,L07F83F8F81F807C1F01F8,L07F83F8F83FC0FC3F01F0,L0HF83F8F03FC0FC3F01F0,K01FF87FCF07FC0FC3F01F0,K01FF87FEF0FBC0F83FF1E0,K03EFC7FHF1FBC0F83FF1E0,K07EFC7FFE1F3C1F87FF1E0,K0FCFCFDFE3F3E1F07C03C0,K0IFCF9FE3FFE1F07C03C0,J01FHFCF8FE7FFE3F0FC03C0,J01FHFDF8FC7FFE3E0F807C0,J03F07DF0FCF83E3E0F807C0,J03E07DF07DF83E3E0F80780,J07E07DF079F83E7E0FFEFFE,J07C0FDF03BF03E7E0FFEFFE,,::::::::::::::::::::::::".

       PUT UNFORMATTED "^FO1145,285^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP. 

        //Cometado Isac - PUT UNFORMATTED "^FO880,395^A0N,25,25^FDIncorpora produto homologado pela Anatel sob numero^FS" SKIP.


        PUT UNFORMATTED "^FO1100,400^A0N,30,25^FD" item-ean.homolog "^FS" SKIP.

        PUT UNFORMATTED "^FO880,455^A0N,30,30^FDNS:" num-serie.n-serie  "^FS" SKIP. 

        IF p-cod-modelo = 753 THEN
           PUT UNFORMATTED "^FO1150,455^A0N,30,30^FDCHAVE ACESSO: " num-serie.ch-acesso  "^FS" SKIP. 

        //QR CODE
        ASSIGN c-qr-code  = ""
               i-mac-cont = 0
               c-macs     = "".
              // c-qr-code = "SN:5H07566PAJDC5,DT:iM4,SC:L2F9BAA5,NC:015,MAC1:XXXXXXXXXX,MAC2:XXXXXXXXXY".

        FOR EACH mac-address USE-INDEX num-serie WHERE
                 mac-address.n-serie = num-serie.n-serie
                 NO-LOCK.

            ASSIGN i-mac-cont = i-mac-cont + 1.

            ASSIGN c-macs = c-macs 
                          + "MAC"
                          + STRING(i-mac-cont)
                          + ":"
                          + mac-address.mac 
                          + IF i-mac-cont = 1 AND
                               item-ean.qtd-mac > 1
                               THEN "," ELSE "".
        END.

        //comentar a linha abaixo ≤ teste
       // ASSIGN c-macs = "MAC1:ABCDEF123456,MAC2:ABCDEF654321,".
        
        
        IF p-cod-modelo = 753 
        THEN DO:
        
            FIND FIRST num-serie-uuid WHERE
                       num-serie-uuid.n-serie = num-serie.n-serie
                       NO-LOCK NO-ERROR.
    
            IF AVAIL num-serie-uuid AND 
                     num-serie-uuid.uuid <> "" 
            THEN DO:
               ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                + "DT:"
                                + "" + ","
                                + "NC:"
                                + string(item-ean.nc) + ","
                                + c-macs
                                + ",UUID:" + num-serie-uuid.uuid + ",AUTHKEY:" + num-serie-uuid.authkey
                                + "~}".


               IF p-cod-modelo = 753 THEN DO:
                   IF LENGTH(item-ean.nc) > 3 THEN DO:

                       ASSIGN c-qr-code = "~{"
                                        + "SN:" 
                                        + STRING(num-serie.n-serie) + ","
                                        + "SC:"
                                        + string(num-serie.ch-acesso) + ","
                                        + "PID:"
                                        + string(item-ean.nc) + ","
                                        + c-macs
                                        + "~}". 
                   END.
               END.
    
               PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
            END.
            ELSE DO:
               ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                + "DT:"
                                + string(item-ean.nome-abrev) + ","
                                + "SC:"
                                + string(num-serie.ch-acesso) + ","
                                + "NC:"
                                + string(item-ean.nc) + ","
                                + c-macs
                                + "~}".


               IF p-cod-modelo = 753 THEN DO:
                   IF LENGTH(item-ean.nc) > 3 THEN DO:

                       ASSIGN c-qr-code = "~{"
                                        + "SN:" 
                                        + STRING(num-serie.n-serie) + ","
                                        + "SC:"
                                        + string(num-serie.ch-acesso) + ","
                                        + "PID:"
                                        + string(item-ean.nc) + ","
                                        + c-macs
                                        + "~}". 
                   END.
               END.
    
               PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
            END.
        END.
        /** Iziplay **/
        ELSE DO:
            ASSIGN c-qr-code = "~{"
                                + "SN:" 
                                + STRING(num-serie.n-serie) + ","
                                /*+ "DT:"
                                + string(item-ean.nome-abrev) + ","
                                + "SC:"
                                + string(num-serie.ch-acesso) + ","
                                + "NC:"
                                + string(item-ean.nc) + ","*/
                                + c-macs
                                + "~}".

            IF p-cod-modelo = 753 THEN DO:
                IF LENGTH(item-ean.nc) > 3 THEN DO:

                    ASSIGN c-qr-code = "~{"
                                     + "SN:" 
                                     + STRING(num-serie.n-serie) + ","
                                     + "SC:"
                                     + string(num-serie.ch-acesso) + ","
                                     + "PID:"
                                     + string(item-ean.nc) + ","
                                     + c-macs
                                     + "~}". 
                END.
            END.
    
            PUT UNFORMATTED "^FT1350,395^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
        END.

        IF p-cod-modelo = 753 THEN DO:
            IF LENGTH(item-ean.nc) > 3 THEN DO:

                ASSIGN c-qr-code = "~{"
                                 + "SN:" 
                                 + STRING(num-serie.n-serie) + ","
                                 + "SC:"
                                 + string(num-serie.ch-acesso) + ","
                                 + "PID:"
                                 + string(item-ean.nc) + ","
                                 + c-macs
                                 + "~}". 
            END.
        END.


        PUT UNFORMATTED "^FT1720,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.

        PUT UNFORMATTED "^FT2200,310^BY5,2.0,65^BQN,2,5^FH\^FDLA," c-qr-code "^FS" SKIP.
         
        
        PUT UNFORMATTED "^FO1380,390^A0N,25,25^FD" STRING(TODAY,"99/99/9999") "^FS"   SKIP.
        PUT UNFORMATTED "^FO1380,420^A0N,25,25^FD" STRING(item-ean.info-tec[1]) "^FS" SKIP.
        
        CASE item-ean.etiq-1-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1030,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1030,580^A0N,40,40^FD" item-ean.etiq-1-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FD" item-ean.etiq-1-info[2] "^FS" SKIP. 
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1030,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1030,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP.
            END.
        END CASE.
        
        
        CASE item-ean.etiq-2-tipo: 
           WHEN 1 THEN DO: /* Núm S≤rie */
               PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FD" item-ean.nome-abrev "^FS" SKIP. 
               PUT UNFORMATTED "^FO1900,590^A0N,50,50^FB700,1,0,L^FDNS:" num-serie.n-serie  "^FS" SKIP. 
           END.
           WHEN 2 THEN /*CΩd. Item.*/
               PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FD" item-ean.it-codigo "^FS" SKIP. 
           WHEN 3 THEN DO: /* Outros */
               PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
               PUT UNFORMATTED "^FO1900,590^A0N,50,50^FB700,1,0,L^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
           END.
           WHEN 5 THEN DO:
               PUT UNFORMATTED "^FO1940,450^A0N,58,55^FD" STRING(TODAY,"99/99/9999") "^FS"  SKIP. 
               PUT UNFORMATTED "^FO1940,500^A0N,50,50^FB700,1,0,L^FDCHAVE DE ACESSO: ^FS"  SKIP. 
               PUT UNFORMATTED "^FO1940,545^A0N,50,50^FB700,1,0,L^FD" string(num-serie.ch-acesso) "^FS"  SKIP.
               PUT UNFORMATTED "^FT1720,660^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
               PUT UNFORMATTED "^FO1940,590^A0N,50,50^FB700,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP.
           END.                            
           WHEN 6 THEN DO:
               PUT UNFORMATTED "^FO1900,545^A0N,50,50^FB700,1,0,L^FDANATEL: " item-ean.homolog "^FS" SKIP. 
               PUT UNFORMATTED "^FO1900,590^A0N,50,50^FB700,1,0,L^FD" item-ean.origem "^FS" SKIP. 
           END.
        END CASE. 

        
     
        /*
        CASE item-ean.etiq-3-tipo: 
            WHEN 1 THEN DO: /* Núm S≤rie */
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FD" item-ean.nome-abrev "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FDNS:" num-serie.n-serie  "^FS" SKIP. 
            END.
            WHEN 2 THEN /*CΩd. Item.*/
                PUT UNFORMATTED "^FO1950,580^A0N,50,50^FD" item-ean.it-codigo "^FS" SKIP. 
            WHEN 3 THEN DO: /* Outros */
                PUT UNFORMATTED "^FO1730,580^A0N,40,40^FD" item-ean.etiq-2-info[1] "^FS" SKIP. 
                PUT UNFORMATTED "^FO1730,620^A0N,40,40^FD" item-ean.etiq-2-info[2]  "^FS" SKIP. 
            END.
             WHEN 5 THEN DO:
                IF p-cod-modelo = 752 OR p-cod-modelo = 753 THEN DO:
                   PUT UNFORMATTED "^FO1910,460^A0N,50,50^FB700,1,0,L^FD" STRING(TODAY,"99/99/9999") "^FS"  SKIP. 
                   PUT UNFORMATTED "^FO1910,520^A0N,50,50^FB700,1,0,L^FDSC:" string(num-serie.ch-acesso) "^FS"  SKIP.
                   PUT UNFORMATTED "^FT1720,640^BY4,2.0,65^BQN,2,6^FH\^FDLA," c-qr-code "^FS" SKIP.
                   PUT UNFORMATTED "^FO1910,580^A0N,50,50^FB700,1,0,L^FDNS:" num-serie.n-serie "^FS" SKIP.
                END.
            END.
            WHEN 6 THEN DO:
                PUT UNFORMATTED "^FO1850,580^A0N,40,40^FDANATEL: " item-ean.homolog "^FS" SKIP. 
                PUT UNFORMATTED "^FO1850,620^A0N,40,40^FD" item-ean.origem "^FS" SKIP. 
            END.
        END CASE. 
         */ 



        // Fim QR Code

        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatel.GRF^FS"
        "^XA^IDSuframa600dpi.GRF^FS^XZ".

END. /* modelo 528 */


IF  p-cod-modelo = 668 THEN DO:

    IF item-ean.tp-fabric = 1 THEN DO: /*CKD*/
    
        FIND ord-prod WHERE ord-prod.nr-ord-prod = p-num-po NO-LOCK NO-ERROR.
    
        IF NOT AVAIL ord-prod THEN DO:
        
           ASSIGN p-num-po = 0.
    
           MESSAGE 'OP informada nao encontrada no sistema'
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.         
    
           RETURN 'nok'.
        END.
    END.

    RUN piCargaImagem("local-anatelpp").
    {esapi/esapi016inic.i} /*inicializa parÉmetros impressora*/
    
    FOR EACH tt-lista-ns:
        {esapi/esapi016cgc.i} /*rotina busca cnpj e guarda na vari†vel c-cgc*/

        PUT "^XA" SKIP.
        
        IF p-num-po = 0 THEN DO:
           {esapi/esapi016a5034.i}         /* Embalagem */
        END.
        ELSE DO:                
           {esapi/esapi016a5034c.i}        /* Embalagem */
        END.



        {esapi/esapi016a11.i 2}         /* Etiqueta de Produto (34x21mm) */
        //{esapi/esapi016a12.i 2}         /* etiqueta 24x8mm */

        PUT UNFORMATTED "^FO440,200^A0N,17,16^FB200,1,0,L^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP.
        PUT UNFORMATTED "^FH^FO525,200^A0N,14,14^FB170,1,0,R^FD" REPLACE(item-ean.origem,'È','_e9')  "^FS" SKIP.
        PUT UNFORMATTED "^FO440,220^A0N,14,14^FB200,1,0,L^FD" item-ean.char-2 "^FS" SKIP.
        PUT UNFORMATTED "^FO495,220^A0N,14,14^FB200,1,0,R^FD"  STRING(TODAY,"99/99/99") "^FS" SKIP.
        PUT UNFORMATTED "^FO440,235^A0N,14,14^FB170,1,0,L^FD" item-ean.fone "^FS" SKIP.
        PUT UNFORMATTED "^FO440,250^A0N,14,14^FB170,1,0,L^FDCNPJ:" c-cgc "^FS" SKIP.
        
        PUT UNFORMATTED "^FO735,30^A0B,17,16^FB200,1,0,C^FDANATEL:" item-ean.homolog "^FS" SKIP.
        
        PUT UNFORMATTED "^FO755,15^ABB^FB200,1,0,L^FDNS:" tt-lista-ns.num-serie "^FS" SKIP.
        PUT UNFORMATTED "^FO770,45^BY1^BCB,24,N,N,N,N^FD" tt-lista-ns.num-serie "^FS" SKIP.

       
        IF l-reimp = NO AND
           l-registra-dup = YES
        THEN DO:
            FIND FIRST tt-ns-dup WHERE
                       tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-ns-dup 
            THEN DO:
                CREATE tt-ns-dup.
                ASSIGN tt-ns-dup.n-serie-tmp = tt-lista-ns.num-serie
                       tt-ns-dup.n-serie-bd  = num-serie.n-serie
                       tt-ns-dup.modelo      = p-cod-modelo
                       tt-ns-dup.it-codigo   = item-ean.it-codigo
                       tt-ns-dup.duplicado   = NO.
            END.
            ELSE DO:
                ASSIGN tt-ns-dup.duplicado   = YES.
            END.
        END.

        PUT "^PQ" STRING(1, "99999") SKIP.  /* Quantidade de etiquetas a imprimir */
        PUT "^XZ" SKIP.

        IF l-reimp THEN
            RUN piAtualizaNumSerie (INPUT i-motivo-reimp).
    END.

    /* Limpa a imagem da impressora */
    PUT UNFORMATTED
        "^XA^IDlocal-anatelpp.GRF^FS^XZ".
END. /* modelo 130 */
