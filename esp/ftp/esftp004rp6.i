IF FIRST-OF(volume-nf.cod-estabel) OR
   FIRST-OF(volume-nf.nr-nota-fis) OR
   FIRST-OF(volume-nf.serie)       THEN DO:
   FIND LAST b-volume-nf NO-LOCK WHERE
             b-volume-nf.cod-estabel = volume-nf.cod-estabel AND
             b-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis AND
             b-volume-nf.serie       = volume-nf.serie       NO-ERROR.
    ASSIGN i-ult-volume = b-volume-nf.nr-volume.
END.

FIND FIRST emitente NO-LOCK WHERE
           emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
FIND transporte no-lock
    where transporte.nome-abrev = nota-fiscal.nome-transp no-error.
/****Busca deposito para imprimir na etiqueta*****/
ASSIGN c-deposito = "".    
FOR EACH fat-ser-lote
    WHERE fat-ser-lote.cod-estabel = volume-nf.cod-estabel AND      
          fat-ser-lote.nr-nota-fis = volume-nf.nr-nota-fis AND      
          fat-ser-lote.serie       = volume-nf.serie       AND 
          fat-ser-lote.it-codigo   = volume-nf.it-codigo   NO-LOCK:
    
        IF lookup(fat-ser-lote.cod-depos, c-deposito) = 0 THEN
            IF c-deposito = "" THEN
                ASSIGN c-deposito = fat-ser-lote.cod-depos.
            ELSE
                ASSIGN c-deposito = c-deposito + "," + fat-ser-lote.cod-depos.

        IF fat-ser-lote.cod-depos = "asr" OR fat-ser-lote.cod-depos = "pdo" THEN
            ASSIGN c-nf-bar = "".

END.

IF FIRST-OF(volume-nf.cod-estabel) OR
   FIRST-OF(volume-nf.nr-nota-fis) OR
   FIRST-OF(volume-nf.serie)       OR
   FIRST-OF(volume-nf.nr-volume)   THEN DO:

    {esp/ftp/esftp004rp13.i} /* desc-separa wms */

    ASSIGN de-volume-itens = 0
           c-sigla-usada = ""
           c-nf-bar = volume-nf.cod-estabel + STRING(int(volume-nf.serie),"999") + STRING(volume-nf.nr-nota-fis,"9999999") + STRING(volume-nf.nr-volume,"9999" ) + STRING(i-ult-volume, "9999" ).

    ASSIGN i-volume = 1
           i-item   = 0.

    FOR each b-volume-nf NO-LOCK WHERE
             b-volume-nf.cod-estabel = volume-nf.cod-estabel AND
             b-volume-nf.nr-nota-fis = volume-nf.nr-nota-fis AND
             b-volume-nf.serie       = volume-nf.serie       AND
             b-volume-nf.nr-volume   = volume-nf.nr-volume,
        FIRST b-item NO-LOCK WHERE
              b-item.it-codigo = volume-nf.it-codigo:
        assign de-volume-itens = de-volume-itens + (b-item.comprim / 1000) * (b-item.largura / 1000) *
                                                   (b-item.altura / 1000)  * b-volume-nf.qtde.
    END.

    FOR EACH embalag NO-LOCK
       WHERE embalag.volume >= de-volume-itens
         AND embalag.emite-roman = YES
          BY embalag.volume:
        ASSIGN c-sigla-usada = embalag.sigla-emb.
        LEAVE.
    END.
           
    IF tt-param.ImprimeEtiqueta = 2 THEN
        ASSIGN i-x = 35
               i-y = 140.
    ELSE
        ASSIGN i-x = 35
               i-y = 150.

    ASSIGN c-cod-transp     = ""
           c-sigla-transp   = "".

    /* Busca Pedido */
    IF nota-fiscal.nr-pedcli <> "" THEN DO:
        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli:

            /* Retorna Transportadora Ecommerce */
            IF ped-venda.nome-transp = "DEUTSCHE MAT" THEN
                ASSIGN l-transp-ecommerce = YES.

            FOR FIRST int-ped-venda EXCLUSIVE-LOCK
                WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido:

                /* Retorna Transportadora : Incidente - 26357 */
                RUN esp/crm/escrm107.p (INPUT ped-venda.cod-estabel,
                                        INPUT STRING(ped-venda.cod-emitente),
                                        INPUT ped-venda.cidade,
                                        INPUT ped-venda.estado,
                                        INPUT INT(SUBSTRING(int-ped-venda.char-1,16,3)),
                                        INPUT ped-venda.cep,
                                        OUTPUT c-cod-transp,
                                        OUTPUT c-sigla-transp).

                /* Retorna Transportadora Ecommerce */
                IF l-transp-ecommerce THEN
                    RUN esp/api/busca-transportadora.p (INPUT ped-venda.cod-estabel,
                                                        INPUT STRING(ped-venda.cod-emitente),
                                                        INPUT ped-venda.cidade,
                                                        INPUT ped-venda.estado,
                                                        INPUT INT(SUBSTRING(int-ped-venda.char-1,16,3)),
                                                        INPUT ped-venda.cep,
                                                        OUTPUT c-cod-transp,
                                                        OUTPUT c-sigla-transp). 

                ASSIGN OVERLAY(int-ped-venda.char-1,20,5) = c-sigla-transp.  
                
            END.
        END.

        RELEASE ped-venda.
        RELEASE int-ped-venda.
    END.

    FIND FIRST embalag NO-LOCK
        WHERE  embalag.sigla-emb = volume-nf.sigla-emb NO-ERROR.
    IF  AVAIL  embalag THEN

        ASSIGN c-embalagem = embalag.sigla-emb + "-" + embalag.embalagem.
    ELSE
        ASSIGN c-embalagem = "".

    IF tt-param.ImprimeEtiqueta = 1 THEN DO:
        
        put "^XA" skip
            "^PW832^FS"      SKIP.   /* Novo comando para zebra 600 */
                   
        IF c-nf-bar <> "" THEN DO:
            PUT    "^FO35,20^BY2^BCN,50,N,N,N,N^SN" c-nf-bar ",1,Y" "^FS".
        END.     
        
        IF tt-param.reimpressao
        AND volume-nf.impresso THEN DO:
            PUT SKIP
                "^FT600,050^A0N,28,28^FH\^FD*R^FS" SKIP
                "^LRY^FO592,016^GB53,0,53^FS^LRN" SKIP.
        END.

        IF nota-fiscal.cod-estabel = "999" OR
           nota-fiscal.cod-estabel = "301" THEN DO:
            PUT "^FO35,40^A0N,40,25^FD" + emitente.nome-emit + "  " + c-embalagem + "^FS" format "x(200)" skip
                "^FO35,187^GB750,0,2^FS" skip
                "^FO35,240^GB750,0,2^FS" SKIP
                "^FO35,95^CF0^A0N,18,18^FD" + emitente.endereco + "^FS" format "x(80)" skip
                "^FO35,128^CF0^A0N,18,18^FD"  + emitente.bairro + "^FS" format "x(40)" skip
                "^FO35,155^CF0^A0N,18,18^FD" + string(emitente.cep) + "-" + emitente.cidade + "-" + emitente.estado + "^FS" format "x(80)" SKIP
                "^FO480,194^CF0^AAN,40,25^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + "^FS" format "X(40)" skip
                "^FO35,194^CF0^AAN,40,25^FDVOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "^FS" format "x(70)" skip.

             if nota-fiscal.cod-estabel = "999" or
               nota-fiscal.cod-estabel = "301" then do:
                if  nota-fiscal.cidade-cif <> ""    THEN
                    put "^FO35,275^CF0^AAN,30,15^FD " + transporte.nome + "-CIF" format "x(80)" skip.
                else                        
                    put "^FO35,275^CF0^AAN,30,15^FD " + transporte.nome + "-FOB" format "x(80)" skip.
            end.  
        end.
        else do:
            PUT "^FO35,75^A0N,18,16^FD" + emitente.nome-emit + "  UF:" + emitente.estado + (IF c-sigla-usada <> "" THEN "   Cx.:" + c-sigla-usada ELSE "") + "  " + c-embalagem + "^FS" format "x(200)" skip.
                
            FIND FIRST param-b2c NO-LOCK NO-ERROR.
                        
            IF AVAIL PARAM-b2c THEN DO:
                FIND transporte WHERE transporte.cod-transp = param-b2c.cod-transp-sedex NO-LOCK NO-ERROR.
            END.

            FIND FIRST loc-entr WHERE loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                                  AND loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
            IF AVAIL loc-entr THEN DO:
                FIND int-loc-entr WHERE int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                                    AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
                PUT "^FO35,95^CF0^A0N,18,14^FD" + (IF AVAIL int-loc-entr AND int-loc-entr.endereco-completo <> "" THEN int-loc-entr.endereco-completo ELSE loc-entr.endereco) + "^FS" FORMAT "x(150)" skip
                    "^FO35,115^CF0^A0N,18,14^FD" + loc-entr.bairro + "^FS" format "x(80)" skip
                    "^FO35,135^CF0^A0N,18,14^FD" + string(loc-entr.cep,"99999-999") + "-" + loc-entr.cidade + "-" + loc-entr.estado + "^FS" format "x(80)" SKIP
                   /* "^FO530,070^BY2^BCN,30,N,N,N,N^SN"  STRING(loc-entr.cep)   ",1,Y" "^FS" SKIP */ .  /* Codigo de Barras CEP */

                PUT UNFORMAT "^FO390,115^CF0^A0N,40,35^FD" + c-sigla-transp + "^FS"  SKIP. /* SIGLA DA TRANSPORTADORA */

            END.
            ELSE DO:
                PUT "^FO35,95^CF0^A0N,18,14^FD" + emitente.endereco + "^FS" FORMAT "x(80)" skip
                    "^FO35,115^CF0^A0N,18,14^FD" + emitente.bairro + "^FS" format "x(80)" skip
                    "^FO35,135^CF0^AON,18,14^FD" + string(emitente.cep,"99999-999") + "-" + emitente.cidade + "-" + emitente.estado + "^FS" format "x(80)" SKIP
                   /* "^FO530,070^BY2^BCN,30,N,N,N,N^SN"  STRING(emitente.cep)   ",1,Y" "^FS" SKIP */ .  /* Codigo de Barras CEP */

                PUT UNFORMAT "^FO390,115^CF0^A0N,40,35^FD" + c-sigla-transp + "^FS"  SKIP. /* SIGLA DA TRANSPORTADORA */

            END. 

            PUT  "^FO35,150^GB350,0,2^FS"
                 "^FO35,160^CF0^AON,25,25^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + " VOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "  " + c-desc-separa + "^FS" format "X(100)" SKIP.

            IF l-transp-ecommerce THEN DO:
    
                IF FIRST-OF(volume-nf.cod-estabel) OR
                   FIRST-OF(volume-nf.nr-nota-fis) OR
                   FIRST-OF(volume-nf.serie)       OR
                   FIRST-OF(volume-nf.nr-volume)   THEN DO:
    
                    PUT UNFORMAT "^FO35,182^BY1^BCN,40,N,N,N,N^SN".
                    IF emitente.natureza = 1 THEN 
                        PUT UNFORMAT "000".
                    PUT UNFORMAT
                        STRING(emitente.cgc) + "00" +
                        STRING(nota-fiscal.nr-nota-fis) + "00" +
                        STRING(nota-fiscal.serie) + string(volume-nf.nr-volume,"9999") + string(i-ult-volume,"9999") + ",1,Y^FS" SKIP.
       
                    IF tt-param.ImprimeEtiqueta = 2 THEN
                        ASSIGN i-y = i-y + 35.
                    ELSE
                        ASSIGN i-y = i-y + 25.
    
    
                END.
            END.

        end.                       
    END.
    ELSE DO:            /* Sem endere‡o */
        put "^XA" skip
            "^PW832^FS"      SKIP.   /* Novo comando para zebra 600 */
                   
        IF c-nf-bar <> "" THEN DO:
            PUT    "^FO35,20^BY2^BCN,70,N,N,N,N^SN" c-nf-bar ",1,Y" "^FS".
        END.     
        
        IF tt-param.reimpressao
        AND volume-nf.impresso THEN DO:
            PUT SKIP
                "^FT600,050^A0N,28,28^FH\^FD*R^FS" SKIP
                "^LRY^FO592,016^GB53,0,53^FS^LRN" SKIP.
        END.

        IF nota-fiscal.cod-estabel = "999" OR
           nota-fiscal.cod-estabel = "301" THEN DO:
            PUT "^FO35,40^A0N,40,25^FD" + emitente.nome-emit + "  " + c-embalagem + "^FS" format "x(200)" skip
                "^FO35,187^GB750,0,2^FS" skip
                "^FO35,240^GB750,0,2^FS" SKIP
                "^FO35,95^CF0^A0N,18,18^FD" + emitente.endereco + "^FS" format "x(80)" skip
                "^FO35,128^CF0^A0N,18,18^FD"  + emitente.bairro + "^FS" format "x(40)" skip 
                "^FO35,155^CF0^A0N,18,18^FD" + string(emitente.cep) + "-" + emitente.cidade + "-" + emitente.estado + "^FS" format "x(80)" SKIP
                "^FO480,194^CF0^AAN,40,25^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + "^FS" format "X(40)" skip
                "^FO35,194^CF0^AAN,40,25^FDVOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "^FS" format "x(70)" skip.

            if nota-fiscal.cod-estabel = "999" or
               nota-fiscal.cod-estabel = "301" then do:
                if  nota-fiscal.cidade-cif <> ""    THEN
                    put "^FO35,275^CF0^AAN,30,15^FD " + transporte.nome + "-CIF" format "x(80)" skip.
                else                        
                    put "^FO35,275^CF0^AAN,30,15^FD " + transporte.nome + "-FOB" format "x(80)" skip.
            end.  
        end.
        else do:
            PUT "^FO35,93^A0N,18,16^FD" + emitente.nome-emit /* + "  UF:" + emitente.estado + (IF c-sigla-usada <> "" THEN "   Cx.:" + c-sigla-usada ELSE "") + "  " + c-embalagem */ + "^FS" format "x(200)"  skip.
                
            FIND FIRST param-b2c NO-LOCK NO-ERROR.
                        
            IF AVAIL PARAM-b2c THEN DO:
                FIND transporte WHERE transporte.cod-transp = param-b2c.cod-transp-sedex NO-LOCK NO-ERROR.
            END.

            FIND FIRST loc-entr WHERE loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                                  AND loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
            IF AVAIL loc-entr THEN DO:
                FIND int-loc-entr WHERE int-loc-entr.nome-abrev = nota-fiscal.nome-ab-cli
                                    AND int-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-LOCK NO-ERROR.
                PUT 
                   /* "^FO35,95^CF0^A0N,18,14^FD" + (IF AVAIL int-loc-entr AND int-loc-entr.endereco-completo <> "" THEN int-loc-entr.endereco-completo ELSE loc-entr.endereco) + "^FS" FORMAT "x(150)" skip
                    "^FO35,115^CF0^A0N,18,14^FD" + loc-entr.bairro + "^FS" format "x(80)" skip */
                    "^FO35,110^CF0^A0N,35,25^FD" + /* string(loc-entr.cep,"99999-999") + "-" + */ loc-entr.cidade + "-" + loc-entr.estado + "^FS" format "x(80)" SKIP
                    "^FO400,110^CF0^A0N,35,35^FD" +  c-desc-separa + "^FS" FORMAT "x(50)" SKIP
                   /* "^FO530,070^BY2^BCN,30,N,N,N,N^SN"  STRING(loc-entr.cep)   ",1,Y" "^FS" SKIP */ .  /* Codigo de Barras CEP */

                PUT UNFORMAT "^FO390,150^CF0^A0N,40,35^FD" + c-sigla-transp + "^FS"  SKIP. /* SIGLA DA TRANSPORTADORA */

            END.
            ELSE DO:
                PUT 
                   /* "^FO35,95^CF0^A0N,18,14^FD" + emitente.endereco + "^FS" FORMAT "x(80)" skip
                    "^FO35,115^CF0^A0N,18,14^FD" + emitente.bairro + "^FS" format "x(80)" skip */
                    "^FO35,135^CF0^AON,18,14^FD" + /* string(emitente.cep,"99999-999") + "-" + */ emitente.cidade + "-" + emitente.estado + "^FS" format "x(80)" SKIP
                    "^FO400,135^CF0^A0N,35,35^FD" +  c-desc-separa + "^FS" FORMAT "x(50)" SKIP
                   /* "^FO530,070^BY2^BCN,30,N,N,N,N^SN"  STRING(emitente.cep)   ",1,Y" "^FS" SKIP */ .  /* Codigo de Barras CEP */

                PUT UNFORMAT "^FO390,115^CF0^A0N,40,35^FD" + c-sigla-transp + "^FS"  SKIP. /* SIGLA DA TRANSPORTADORA */

            END. 
                        
        end.      

        PUT  "^FO35,140^GB350,0,2^FS"
             "^FO35,153^CF0^AON,35,35^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + " VOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "^FS" format "X(80)" SKIP.

        IF l-transp-ecommerce THEN DO:

            IF FIRST-OF(volume-nf.cod-estabel) OR
               FIRST-OF(volume-nf.nr-nota-fis) OR
               FIRST-OF(volume-nf.serie)       OR
               FIRST-OF(volume-nf.nr-volume)   THEN DO:

                PUT UNFORMAT "^FO35,182^BY1^BCN,40,N,N,N,N^SN".
                   IF emitente.natureza = 1 THEN 
                       PUT UNFORMAT "000".
                   PUT UNFORMAT
                       STRING(emitente.cgc) + "00" +
                       STRING(nota-fiscal.nr-nota-fis) + "00" +
                       STRING(nota-fiscal.serie) + string(volume-nf.nr-volume,"9999") + string(i-ult-volume,"9999") + ",1,Y^FS" SKIP.
                          
                IF tt-param.ImprimeEtiqueta = 2 THEN
                    ASSIGN i-y = i-y + 45.
                ELSE
                    ASSIGN i-y = i-y + 35.

            END.
        END.
        
/*        put "^XA" skip
            "^PW832^FS"      SKIP.   /* Novo comando para zebra 600 */
        
        IF c-nf-bar <> "" THEN DO:
            PUT    "^FO35,20^BY2^BCN,50,N,N,N,N^SN" c-nf-bar ",1,Y" "^FS".
        END.     

        if nota-fiscal.cod-estabel = "301" or
           nota-fiscal.cod-estabel = "999" then
            put "^FO35,40^AON,45,25^FD" + emitente.nome-emit + "^FS" format "x(200)" skip
                "^FO35,187^GB750,0,2^FS" skip
                "^FO480,68^CF0^AAN,40,25^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + "^FS" format "X(40)" skip
                "^FO35,68^CF0^AAN,40,25^FDVOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "^FS" format "x(70)" SKIP
                "^FO35,240^GB750,0,2^FS" SKIP.
                        
        else
           PUT "^FO35,25^A0N,18,18^FD" + emitente.nome-emit + "        UF:" + emitente.estado + "^FS" format "x(200)" skip
               "^FO35,45^GB750,0,2^FS" skip
               "^FO35,53^CF0^AAN,37,22^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + "^FS" format "X(40)" skip
               "^FO35,85^CF0^AAN,30,15^FDVOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "^FS" format "x(70)" SKIP.
               
        if nota-fiscal.cod-estabel = "301" OR
           nota-fiscal.cod-estabel = "999" then do:
            put "^FO35,215^CF0^AAN,25,10^FD TRANSP.: " + transporte.nome     format "x(80)".
                        
            if  nota-fiscal.cidade-cif <> ""    THEN
                put " CIF" skip   .    
            ELSE
                put " FOB" skip   .             
        end. */          
    END.
END.    
ELSE DO:
    IF i-volume > 1 AND
       i-item   = 0 THEN DO:
        PUT "^XA":U                                                                                                                                             SKIP
            "^PW832":U                                                                                                               + "^FS":U                  SKIP
            "^FO35,25^A0N,18,18^FDContinuacao":U                                                                                     + "^FS":U FORMAT "x(50)":U SKIP
            "^FO35,45^CF0^A0N,18,18^FDVOL:":U + STRING(volume-nf.nr-volume, ">>>9":U) + "/":U + TRIM(STRING(i-ult-volume, ">>>9":U)) + "^FS":U FORMAT "x(70)":U SKIP
            "^FO180,45^CF0^A0N,18,18^FDNF:":U + STRING(nota-fiscal.nr-nota-fis, "9999999":U)                                         + "^FS":U FORMAT "x(40)":U SKIP
            "^FO35,65^GB350,0,2":U                                                                                                   + "^FS":U                  SKIP.

        IF tt-param.reimpressao
        AND volume-nf.impresso THEN DO:
            PUT SKIP
                "^FT600,050^A0N,28,28^FH\^FD*R^FS" SKIP
                "^LRY^FO592,016^GB53,0,53^FS^LRN" SKIP.
        END.

        IF tt-param.ImprimeEtiqueta = 1 
        THEN ASSIGN i-y = 42.
        ELSE ASSIGN i-y = 32.
    END.
END.

ASSIGN c-descricao = "".
    
IF emitente.natureza = 3 THEN DO:
   FOR FIRST emitente-cex NO-LOCK
       WHERE emitente-cex.cod-emitente = emitente.cod-emitente,
       FIRST traduc-item NO-LOCK
       WHERE traduc-item.it-codigo  = ITEM.it-codigo
       AND   traduc-item.cod-idioma = emitente-cex.cod-idioma:
       ASSIGN c-descricao = traduc-item.tr-desc-item.
   END.
END.

IF c-descricao = "" THEN
    ASSIGN c-descricao = item.desc-item.

IF tt-param.ImprimeEtiqueta = 2 THEN
    ASSIGN i-y = i-y + 45.
ELSE
    ASSIGN i-y = i-y + 35.

IF i-item >= 1   THEN
    ASSIGN i-y = i-y - 10.


/** Identificador: 2010/00017725 **/
    IF NOTA-FISCAL.COD-ESTABEL = "102" THEN
        ASSIGN c-descricao = "".
/**/

IF NOTA-FISCAL.COD-ESTABEL <> "301" and
   NOTA-FISCAL.COD-ESTABEL <> "999" THEN
    IF volume-nf.it-codigo <> "" THEN DO: 
       IF tt-param.i-impressora = 1 THEN DO:
           IF tt-param.ImprimeEtiqueta = 1 THEN DO:

               put "^FO" + string(i-x,"99") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(volume-nf.it-codigo,"x(7)") + " " + string(c-descricao,"x(33)") + "^FS" format "x(120)".
                   /*"^FO" + string(i-x + 90,"999") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(c-descricao,"x(36)") + "^FS" format "x(95)" skip.*/
               put "^FO" + string(i-x + 375,"999") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(volume-nf.qtde,">>>>9") + "  " + caps(c-deposito) + "^FS" format "x(120)" skip.
                 /*** 395 ***/
              /* se sao varios itens nao imprime codigo de barras */
                 
              RUN Imprime_codigo_basico_central.
           END.
           ELSE DO:

              put "^FO" + string(i-x,"99") + "," + string(i-y,"999") + "^CF0^ABN,28,10^FD" + string(volume-nf.it-codigo,"x(7)") + " " + string(c-descricao,"x(33)") + "^FS" format "x(120)".
                  /*"^FO" + string(i-x + 90,"999") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(c-descricao,"x(36)") + "^FS" format "x(95)" skip.*/
              put "^FO" + string(i-x + 375,"999") + "," + string(i-y,"999") + "^CF0^ABN,28,10^FD" + string(volume-nf.qtde,">>>>9") + "  " + caps(c-deposito) + "^FS" format "x(120)" skip.
                /*** 395 ***/
              /* se sao varios itens nao imprime codigo de barras */
                
              RUN Imprime_codigo_basico_central.
           END.
       END.
       ELSE DO:
           
          put "^FO" + string(i-x,"99") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(volume-nf.it-codigo,"x(7)") + " " + string(c-descricao,"x(33)") + "^FS" format "x(120)".
              /*"^FO" + string(i-x + 90,"999") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(c-descricao,"x(36)") + "^FS" format "x(95)" skip.*/
          put "^FO" + string(i-x + 375,"999") + "," + string(i-y,"999") + "^CF0^ABN,25,10^FD" + string(volume-nf.qtde,">>>>9") + "  " + caps(c-deposito) + "^FS" format "x(120)" skip.
            /*** 395 ***/
          RUN Imprime_codigo_basico_central.
          
       END.

       ASSIGN i-item = i-item + 1.

   END.


IF LAST-OF(volume-nf.cod-estabel) OR
   LAST-OF(volume-nf.nr-nota-fis) OR
   LAST-OF(volume-nf.serie)       OR
   LAST-OF(volume-nf.nr-volume)   THEN DO:
   put "^PQ1^FS" skip   
       " ^XZ" SKIP.

   ASSIGN i-volume = 1
          i-item   = 0.
END.
ELSE DO:

    IF l-transp-ecommerce THEN DO:

        IF i-volume = 1 AND
           i-item   = (IF tt-param.ImprimeEtiqueta = 1 THEN 3 ELSE 2) THEN DO:
            PUT "^PQ1^FS":U SKIP
                " ^XZ":U    SKIP.
    
            ASSIGN i-volume = 2
                   i-item   = 0.
        END.
        ELSE
    
            IF i-volume > 1  AND
               i-item   = (IF tt-param.ImprimeEtiqueta = 1 THEN 8 ELSE 6)  THEN DO:
                PUT "^PQ1^FS":U SKIP
                    " ^XZ":U    SKIP.
        
                ASSIGN i-volume = i-volume + 1
                       i-item   = 0.
            END.
    END.
    ELSE DO:

        IF i-volume = 1 AND
           i-item   = (IF tt-param.ImprimeEtiqueta = 1 THEN 4 ELSE 3) THEN DO:
            PUT "^PQ1^FS":U SKIP
                " ^XZ":U    SKIP.
    
            ASSIGN i-volume = 2
                   i-item   = 0.
        END.
        ELSE
    
            IF i-volume > 1  AND
               i-item   = (IF tt-param.ImprimeEtiqueta = 1 THEN 9 ELSE 7)  THEN DO:
                PUT "^PQ1^FS":U SKIP
                    " ^XZ":U    SKIP.
        
                ASSIGN i-volume = i-volume + 1
                       i-item   = 0.
            END.
        END.


    
 
END.

   
IF LAST-OF(volume-nf.cod-estabel) OR
   LAST-OF(volume-nf.nr-nota-fis) OR
   LAST-OF(volume-nf.serie)       OR
   LAST-OF(volume-nf.nr-volume)   THEN DO:

    FIND FIRST filial-cliente
        WHERE filial-cliente.cnpj = nota-fiscal.cgc NO-LOCK NO-ERROR.
    IF AVAIL filial-cliente THEN DO:
        IF nota-fiscal.nr-pedcli <> "" THEN DO:
            FIND FIRST ped-venda 
                WHERE ped-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
                    FIND FIRST int-ped-venda
                        WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido NO-LOCK NO-ERROR.
                    ASSIGN c-ped-cliente =  SUBSTRING(int-ped-venda.char-1,53,12).
        END.

       PUT UNFORMAT "^XA"                                                   SKIP
                        "^PW832^FS"                                         SKIP
                        "^FO235,20"                                         SKIP
                        "^ADN,28,12"                                        SKIP
                        "^FDLOJA: " + filial-cliente.nome-etiqueta + "^FS"  SKIP
                        "^FO235,70"                                         SKIP
                        "^ADN,28,12"                                        SKIP
                        "^FDPED: " + c-ped-cliente + "^FS"                  SKIP
                        "^FO235,120"                                        SKIP
                        "^ADN,28,12"                                        SKIP
                        "^FDVOL:" + string(volume-nf.nr-volume,">>>9") + "/" + trim(string(i-ult-volume,">>>9")) + "^FS" SKIP
                        "^FO235,170"                                        SKIP
                        "^ADN,28,12"                                        SKIP
                        "^FDNF:" + string(nota-fiscal.nr-nota-fis,"9999999") + "^FS" SKIP
                        "^FO175,220"                                        SKIP
                        "^ADN,80,80"                                        SKIP 
                        "^FD"  + filial-cliente.nr-filial + "^FS"           SKIP
                        "^XZ".

       RELEASE ped-venda.
       RELEASE int-ped-venda.   
       
    END.
END. 
{esp/ftp/esftp004rp12.i} 
