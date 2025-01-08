/* Include para criacao do AE-ITEM e impressao de etiqueta de reporte */
IF c-seg-usuario = "ADM" THEN
   MESSAGE "Dep¢sito Entrada.: " ttRepApi.depos-ent SKIP
           "se <> INJ-TAM-REP --> Gera AE"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.

IF ttRepApi.depos-ent <> "INJ" AND 
   ttRepApi.depos-ent <> "TAM" AND 
   ttRepApi.depos-ent <> "REP" THEN DO:
   FIND FIRST aviso-entrada EXCLUSIVE-LOCK
       WHERE aviso-entrada.cod-estabel = pCodEstabel NO-ERROR.
   IF AVAIL aviso-entrada THEN
       ASSIGN i-nr-ae                 = aviso-entrada.ultimo-ae + 1
              aviso-entrada.ultimo-ae = i-nr-ae.
   ELSE DO:
       CREATE aviso-entrada.
       ASSIGN aviso-entrada.cod-estabel = pCodEstabel
              aviso-entrada.ultimo-ae   = 1.
   END.
   FIND CURRENT aviso-entrada NO-LOCK NO-ERROR.
    /*
    if (ttRepApi.depos-ent = "smd" or ttRepApi.depos-ent = "tam")
       and c-enche = "devolucao" then do: /*on endkey undo, retry:*/
        assign da-data = today - if weekday(today) = 1 then 6 
                         else weekday(today) - 2.
        RUN piPedeDataAe.
                     /*
        update da-data label "Data da AE"
               with frame f-data row 8 overlay centered.
        hide frame f-data no-pause.*/
    end.  */
   IF ttRepApi.depos-ent = "tam" AND
      (c-enche = "total"         OR
       c-enche = "parcial")      THEN DO: /*on endkey undo, retry: */
       ASSIGN da-data = TODAY.
       RUN piPedeDataAe.
        /*
        update da-data label "Data da AE"
               with frame f-data row 8 overlay centered.
        */
    end.
    IF c-seg-usuario = "ADM" THEN
        MESSAGE "CRIANDO AE" i-nr-ae
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    DO  TRANSACTION:
        create ae-item.
        assign ae-item.cod-estabel = pCodEstabel
               ae-item.it-codigo  = ord-prod.it-codigo
               ae-item.quantidade = i-qtd-cont
               ae-item.nr-ae      = i-nr-ae
               ae-item.sequencia  = 1
               ae-item.nf         = 0
               ae-item.data       = if (ttRepApi.depos-ent = "smd" or 
                                        ttRepApi.depos-ent = "iao" or 
                                        ttRepApi.depos-ent = "iac" or
                                        ttRepApi.depos-ent = "ias" or
                                        ttRepApi.depos-ent = "iat" or
                                        ttRepApi.depos-ent = "cob" or
                                        ttRepApi.depos-ent = "tam")
                                       and c-enche = "devolucao" or 
                                       (ttRepApi.depos-ent = "tam" and (c-enche = "total"
                                       or c-enche = "parcial")) then da-data 
                                    else today
               ae-item.localizacao = if ttRepApi.depos-ent = "inj" or ttRepApi.depos-ent = "tam" then 
                                        c-localizacao 
                                     else 
                                        item.cod-localiz
               ae-item.cod-depos = ttRepApi.depos-ent.

        /*
        RUN piAtualizaArquivo(INPUT "etq" + 
                                    substring(string(time,"HH:MM:SS"),1,2) + 
                                    substring(string(time,"HH:MM:SS"),4,2) +
                                    substring(string(time,"HH:MM:SS"),7,2) + 
                                    string(random(1,1000))).
      
        assign vArquivo = "spool/etq" + 
               substring(string(time,"HH:MM:SS"),1,2) + 
               substring(string(time,"HH:MM:SS"),4,2) +
               substring(string(time,"HH:MM:SS"),7,2) + 
               string(random(1,1000)).
    */            
        assign c-linha = substring(ae-item.it-codigo,1,7)   +
                         string(ae-item.quantidade,"99999") +
                         string(i-nr-ae,"9999999")          +
                         string(ae-item.sequencia,"999").
     
        /*Calcula digito verificador*/
                                                                 
        run esp/es0135(input c-linha,output i-it-digito).
                                                                   
        assign c-linha = c-linha + string(i-it-digito,"9").
     
        assign ae-item.impresso = yes.
    
        if  ttRepApi.depos-ent <> "smd" and
            ttRepApi.depos-ent <> "iao" and
            ttRepApi.depos-ent <> "iac" and
            ttRepApi.depos-ent <> "ias" and
            ttRepApi.depos-ent <> "iat" and
            ttRepApi.depos-ent <> "cob" and            
            ttRepApi.depos-ent <> "inj" and 
            ttRepApi.depos-ent <> "tam" then assign ae-item.situacao = yes.
        IF c-seg-usuario = "ADM" THEN
            MESSAGE "Imprimindo AE" i-nr-ae
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        IF (ttRepApi.depos-ent <> "cnt" and ttRepApi.depos-ent <> "sec") or
          ((ttRepApi.depos-ent = "cnt" or ttRepApi.depos-ent = "sec") and  not ord-prod.it-codigo begins "201") then do:

           IF ttRepApi.c-nome-imp = "godex" then do:

               OUTPUT STREAM sGodoex TO PRINTER VALUE("LPT1") PAGED PAGE-SIZE VALUE(99) CONVERT TARGET 'iso8859-1' .
    
               /*output to value(vArquivo).*/
               disp STREAM sGodoex
                    "^Q40,2" skip
                    "^S7" skip
                    "^H3" skip
                    "^E12" skip
                    "^L"   skip
                    "AE,5,10,1,1,1,0,"  
                    substring(ord-prod.it-codigo,1,6) + "-" +
                    substring(ord-prod.it-codigo,7,1) no-label skip
                    "AE,250,10,1,1,1,0," 
                    if ttRepApi.depos-ent = "inj" or ttRepApi.depos-ent = "tam" then 
                       c-localizacao 
                    else 
                       if ttRepApi.depos-ent = "tam" then 
                          item.cod-localiz 
                       else 
                          ""
                          skip 
                   "AD,5,65,1,1,1,0, AE" string(ae-item.nr-ae,">999999") no-label
                       skip
                   "AD,200,65,1,1,1,0, " string(ae-item.sequencia,"999") no-label skip
                   "AD,20,115,1,1,1,0," +  string(ae-item.data,"99/99/9999")
                       format "x(70)" no-label skip 
                   "AA,15,50,1,1,1,0," 
                       string(time,"HH:MM:SS")  c-seg-usuario skip
                   "AD,210,115,1,1,1,0, QTD" format "x(70)" skip
                   "AD,280,115,1,1,1,0," i-qtd-cont format ">>,>>9" skip
                   "AB,18,170,1,1,1,0," +
                       item.desc-item format "X(76)" no-label skip
                   "BU,35,207,2,5,50,0,1," + c-linha format "X(60)" no-label skip
                   "E".
        
               OUTPUT STREAM sGodoex CLOSE.
               /******* O MESSAGE ABAIXO FAZ COM QUE A TELA NAO ROLE NO
                        FINAL DA IMPRESSAO DA ETIQUETA        *************/
               /* unix silent impesc value(vArquivo).*/
           END.
           ELSE
              IF TRIM(ttRepApi.c-nome-imp) = "Zebra" THEN DO:

                   OUTPUT STREAM sZebra TO VALUE(ttRepApi.cNomeLayout).
                   /*OUTPUT STREAM sZebra TO PRINTER. */
                   DISP STREAM sZebra
                        "^XA"                 
                        SKIP

                        "^PW832"      SKIP   /* Novo comando para zebra 600 */
                        "^JUS"        SKIP   /* Novo comando para zebra 600 */


                        "^FO30,36^A0N,40,40^FD"  + substring(ord-prod.it-codigo,1,6) + "-" + substring(ord-prod.it-codigo,7,1) + "^FS"  format "x(70)" 
                        SKIP

                        "^FO270,36^A0N,40,40^FD"
                        IF ttRepApi.depos-ent = "inj" OR
                           ttRepApi.depos-ent = "tam" THEN 
                           c-localizacao 
                        ELSE 
                           IF ttRepApi.depos-ent = "tam" THEN 
                              item.cod-localiz 
                           ELSE 
                              "" + "^FS" FORMAT "x(70)" 
                        SKIP

                        "^FO70,85^A0N,25,25^FDAE^FS"  
                        SKIP

                        "^FO95,85^A0N,25,25^FD" + string(ae-item.nr-ae,"9999999") + "^FS" format "x(70)"            
                        SKIP

                        "^FO255,85^A0N,25,25^FDSEQ^FS"       
                        SKIP

                        "^FO290,85^A0N,25,25^FD" string(ae-item.sequencia,"999") "^FS" 
                        SKIP
    
                        "^FO367,85^A0N,25,25^FD" ae-item.data format "99/99/9999" "^FS" 
                        SKIP

                        "^FO60,115^A0N,25,25^FDROT^FS"              
                        SKIP

                        "^FO105,115^A0N,25,25^FD" + STRING(ae-item.roteiro,">>>>>9") + "^FS" format "x(70)"
                        SKIP
    
                        "^FO255,115^A0N,25,25^FD" + c-seg-usuario + "^FS" format "x(70)" 
                        SKIP
                               

                        
                        "^FO387,115^A0N,25,25^FD" STRING(TIME,"hh:mm") FORMAT "X(30)" "^FS" /* Imprime a hora */
                        



                        "^FO30,150^A0N,25,25^FD" item.desc-item format "x(36)" "^FS"
                        SKIP

                        "^FO280,195^A0N,60,40^FD" + string(ae-item.quantidade,">>>,>>9") + "^FS" format "x(70)"         
                        SKIP
    
                        "^FO500,10" 
                        SKIP
    
                        "^FO50,250^BAN,50,Y,N,N^BY2^FD" + c-linha + "^FS" format "x(70)" 
                        SKIP

                        "^XZ" with no-labels.                     

                   OUTPUT STREAM sZebra CLOSE. 
               END.
               /*output to value(vArquivo).*/
               ELSE DO:
                   IF  ttRepApi.c-nome-imp <> "arquivo" THEN DO:
                       {esapi/esapi008.i}               
                   END.
                   ELSE DO:
                       RUN piAtualizaArquivo(INPUT "etq" + 
                                                  substring(string(time,"HH:MM:SS"),1,2) + 
                                                  substring(string(time,"HH:MM:SS"),4,2) +
                                                  substring(string(time,"HH:MM:SS"),7,2) + 
                                                  string(random(1,1000))).
                       OUTPUT TO VALUE(vArquivo).
                   END.

                   disp  "******* INTELBRAS S/A  -  REPORTE DE PRODUTO ACABADO   Nr.: " ae-item.nr-ae "*******" at 74 
                         SKIP
                         "*" 
                         "*" at 80 
                         SKIP
                         "*       Data: " today format "99/99/9999" "     Hora: " string(time,"HH:MM:SS") "     Usuario: " c-seg-usuario "*" at 80
                         SKIP
                         "*"
                         "*" at 80 
                         SKIP
                         "*       Item: " ord-prod.it-codigo format "x(7)" "-" item.desc-item format "x(36)" "*" at 80
                         SKIP
                         "*"
                         "*" at 80 
                         SKIP
                         "*       QUANTIDADE: " ae-item.quantidade "*" at 80 
                         SKIP
                         "*"
                         "*" at 80 
                         SKIP
                         "******************************************************************************~~**"
                         SKIP(16)
                         WITH no-labels width 100 frame f-comanda.
               END.
               OUTPUT CLOSE.

        END.
        RELEASE ae-item.
        FOR FIRST ae-item NO-LOCK
            WHERE ae-item.nr-ae = i-nr-ae:
        END.
    END. /* do transaction */
end.
else do:

    /* os itens abaixo nao gerarao etiquetas/ AEs por solicitacao do Sr. Edno     */
    /* em caso de inclusao de algum item aqui, inclui-lo tambem no 0506.p*/

    /* Jogado para dentro da l¢gica de devolu‡Æo para teste CHAVES
    
    assign i-contenedor = i-qtd-cont.
    /*do on endkey undo, retry:*/
    RUN piPedeContenedor.*/
    /*
    update i-contenedor label "Tamanho do Contenedor" 
               with row 18 overlay side-labels frame f-tam-cont.*/
    /*end.       */
    /*hide frame f-tam-cont no-pause.*/
    
    /* geracao do ae ficou somente para devoluocoes por ter sido substituida por programa de transferencia automatica  */
    if  c-enche = "devolucao" and c-localizacao <> "" then do:
        assign i-contenedor = i-qtd-cont.

        RUN piPedeContenedor.

        assign i-qtd-lote  = trunc((i-qtd-cont / i-contenedor),0)                      
               i-qtd-resto = ((i-qtd-cont / i-contenedor) - i-qtd-lote) * i-contenedor.
        FIND FIRST aviso-entrada EXCLUSIVE-LOCK
            WHERE aviso-entrada.cod-estabel = pCodEstabel NO-ERROR.
        IF AVAIL aviso-entrada THEN
            ASSIGN i-nr-ae                 = aviso-entrada.ultimo-ae + 1
                   aviso-entrada.ultimo-ae = i-nr-ae.
        ELSE DO:
            CREATE aviso-entrada.
            ASSIGN aviso-entrada.cod-estabel = pCodEstabel
                   aviso-entrada.ultimo-ae   = 1.

        END.
        FIND CURRENT aviso-entrada NO-LOCK NO-ERROR.

        if c-enche = "total" or
           c-enche = "parcial" or 
           c-enche = "devolucao" then /*do on endkey undo, retry:*/
           RUN piPedeDataAE.
            /*
            update da-data label "Data da AE"
                   with frame f-data row 8 overlay centered.
            hide frame f-data no-pause.*/
        /*end.*/

        assign i-cont = 1.
        if  i-qtd-lote > 0 then do:

            do i-cont = 1 to i-qtd-lote TRANSACTION:
                create ae-item.
                assign ae-item.cod-estabel = pCodEstabel
                       ae-item.it-codigo  = ord-prod.it-codigo
                       ae-item.quantidade = i-contenedor
                       ae-item.nr-ae      = i-nr-ae
                       ae-item.sequencia  = i-cont
                       ae-item.nf         = 0
                       ae-item.data       = da-data
                       ae-item.localizacao = if ttRepApi.depos-ent = "inj" or ttRepApi.depos-ent = "tam" then c-localizacao else item.cod-localiz
                       ae-item.cod-depos  = ttRepApi.depos-ent.
                       
                RUN piAtualizaArquivo(INPUT "etq" + 
                                           substring(string(time,"HH:MM:SS"),1,2) + 
                                           substring(string(time,"HH:MM:SS"),4,2) +
                                           substring(string(time,"HH:MM:SS"),7,2) + 
                                           string(random(1,1000))).
    /*          assign vArquivo = "spool/etq" + 
                      substring(string(time,"HH:MM:SS"),1,2) + 
                      substring(string(time,"HH:MM:SS"),4,2) +
                      substring(string(time,"HH:MM:SS"),7,2) + 
                      string(random(1,1000)).*/
    
                assign c-linha = substring(ae-item.it-codigo,1,7)   +
                                   string(ae-item.quantidade,"99999") +
                                   string(i-nr-ae,"9999999")          +
                                   string(ae-item.sequencia,"999").
     
                 /*Calcula digito verificador*/
                                                               
                run esp/es0135(input c-linha,output i-it-digito).
                                                                 
                assign c-linha = c-linha + string(i-it-digito,"9").

                IF TRIM(ttRepApi.c-nome-imp) = "Zebra" THEN DO:

                    OUTPUT STREAM sZebra TO VALUE(ttRepApi.cNomeLayout).
                    /*OUTPUT STREAM sZebra TO PRINTER.*/
                    DISP STREAM sZebra
                        "^XA"
                        SKIP

                        "^FO30,36^A0N,40,40^FD" + substring(ae-item.it-codigo,1,6) + "-" + substring(ae-item.it-codigo,7,1) + "^FS"  format "x(70)" 
                        SKIP

                        "^FO270,36^A0N,40,40^FD"
                        IF ttRepApi.depos-ent = "inj" OR
                           ttRepApi.depos-ent = "tam" THEN 
                           c-localizacao 
                        ELSE 
                           IF ttRepApi.depos-ent = "tam" THEN 
                              item.cod-localiz 
                           ELSE 
                              "" + "^FS" format "x(70)" 
                        SKIP

                        "^FO70,85^A0N,25,25^FDAE^FS"  
                        SKIP

                        "^FO95,85^A0N,25,25^FD" + string(ae-item.nr-ae,"9999999") + "^FS" format "x(70)"             
                        SKIP

                        "^FO255,85^A0N,25,25^FDSEQ^FS"       
                        SKIP

                        "^FO290,85^A0N,25,25^FD" string(ae-item.sequencia,"999") "^FS" 
                        SKIP

                        "^FO367,85^A0N,25,25^FD" ae-item.data format "99/99/9999" "^FS" 
                        SKIP           

                        "^FO60,115^A0N,25,25^FDROT^FS"              
                        SKIP

                        "^FO105,115^A0N,25,25^FD" + STRING(ae-item.roteiro,">>>>>9") + "^FS" format "x(70)"                            
                        SKIP
    
                        "^FO255,115^A0N,25,25^FD" + c-seg-usuario + "^FS" format "x(70)" 
                        SKIP




                        "^FO387,115^A0N,25,25^FD" STRING(TIME,"hh:mm") FORMAT "X(30)" "^FS" /* Imprime a hora */



    
                        "^FO30,150^A0N,25,25^FD" item.desc-item format "x(36)" "^FS" 
                        SKIP

                        "^FO280,195^A0N,60,40^FD" + string(i-contenedor,">>>,>>9") + "^FS" format "x(70)"         
                        SKIP
    
                        "^FO500,10" 
                        SKIP
    
                        "^FO50,250^BAN,50,Y,N,N^BY2^FD" + c-linha + "^FS" format "x(70)" 
                        SKIP     

                        "^XZ" 
                        with no-labels. 

                        assign ae-item.impresso = yes.
    
                        if ttRepApi.depos-ent <> "smd" and
                           ttRepApi.depos-ent <> "iao" and
                           ttRepApi.depos-ent <> "iac" and
                           ttRepApi.depos-ent <> "ias" and
                           ttRepApi.depos-ent <> "iat" and
                           ttRepApi.depos-ent <> "cob" and
                           ttRepApi.depos-ent <> "inj" and
                           ttRepApi.depos-ent <> "tam" then
                           assign ae-item.situacao = yes.

                        OUTPUT STREAM sZebra CLOSE.
                END.
                ELSE IF ttRepApi.c-nome-imp = "Godex" THEN DO:

                    OUTPUT STREAM sGodoex TO PRINTER /*PAGED PAGE-SIZE VALUE(99) CONVERT TARGET 'iso8859-1'*/ .
                    /*output to value(vArquivo).*/

                    disp STREAM sGodoex 
                         "^Q40,2" skip
                         "^S7" skip
                         "^H3" skip
                         "^E12" skip
                         "^L"   skip
                         "AE,5,10,1,1,1,0,"  
                         substring(ae-item.it-codigo,1,6) + "-" +
                         substring(ae-item.it-codigo,7,1) no-label skip
                         "AE,250,10,1,1,1,0," 
                         if ttRepApi.depos-ent = "inj" or ttRepApi.depos-ent = "tam" then 
                            c-localizacao 
                         else 
                            if ttRepApi.depos-ent = "tam" then 
                               item.cod-localiz 
                            else 
                               ""
                                skip 

                        "AD,5,65,1,1,1,0, AE" string(ae-item.nr-ae,">999999") no-label
                            skip
                        "AD,200,65,1,1,1,0, " string(ae-item.sequencia,"999") no-label skip
                        "AD,20,115,1,1,1,0," +  string(ae-item.data,"99/99/9999")
                            format "x(70)" no-label skip 
                        "AA,15,50,1,1,1,0," 
                            string(time,"HH:MM:SS")  c-seg-usuario skip
                        "AC,210,115,1,1,1,0, QTD" format "x(70)" skip
                        "AC,280,115,1,1,1,0," i-contenedor format ">>,>>9" skip
                        "AC,20,170,1,1,1,0," +
                            item.desc-item format "X(76)" no-label skip
                        "BU,35,207,2,5,50,0,1," + c-linha format "X(60)" no-label skip
                        "E".

                        assign ae-item.impresso = yes.
 
                        if ttRepApi.depos-ent <> "smd" and 
                           ttRepApi.depos-ent <> "iao" and 
                           ttRepApi.depos-ent <> "iac" and
                           ttRepApi.depos-ent <> "ias" and
                           ttRepApi.depos-ent <> "iat" and
                           ttRepApi.depos-ent <> "cob" and
                           ttRepApi.depos-ent <> "inj" and
                           ttRepApi.depos-ent <> "tam" then
                           assign ae-item.situacao = yes.

                    OUTPUT STREAM sGodoex CLOSE.
                    /*            unix silent impesc-light value(vArquivo).*/                   
                END.
            END.
        end. 
        if  i-qtd-resto > 0 THEN DO TRANSACTION:

            create ae-item.
            assign ae-item.cod-estabel = pCodEstabel
                   ae-item.it-codigo = ord-prod.it-codigo
                   ae-item.quantidade = i-qtd-resto
                   ae-item.nr-ae      = i-nr-ae
                   ae-item.sequencia  = i-cont
                   ae-item.nf         = 0
                   ae-item.data       = da-data
                   ae-item.localizacao = if ttRepApi.depos-ent = "inj" or ttRepApi.depos-ent = "tam"  then c-localizacao else item.cod-localiz
                   ae-item.cod-depos   = ttRepApi.depos-ent.
    
            /*
            assign vArquivo = "spool/etqr" + 
                   substring(string(time,"HH:MM:SS"),1,2) + 
                   substring(string(time,"HH:MM:SS"),4,2) +
                   substring(string(time,"HH:MM:SS"),7,2) + 
                   string(random(1,2000)).
            */
    
            assign c-linha = substring(ae-item.it-codigo,1,7)   +
                             string(ae-item.quantidade,"99999") +
                             string(i-nr-ae,"9999999")          +
                             string(ae-item.sequencia,"999").
 
               /*Calcula digito verificador*/
                                                             
            run esp/es0135(input c-linha,output i-it-digito).
                                                               
            assign c-linha = c-linha + string(i-it-digito,"9").
            /*output to value(vArquivo) .*/

            IF ttRepApi.c-nome-imp = "Godex" THEN DO:

                OUTPUT TO PRINTER .
                disp "^Q40,2" skip
                     "^S7" skip
                     "^H3" skip
                     "^E12" skip
                     "^L"   skip
                     "AE,5,10,1,1,1,0,"  
                     substring(ae-item.it-codigo,1,6) + "-" +
                     substring(ae-item.it-codigo,7,1) no-label skip
                     "AE,250,10,1,1,1,0," 
                     if ttRepApi.depos-ent = "inj" or ttRepApi.depos-ent = "tam" then 
                        c-localizacao 
                     else 
                        if ttRepApi.depos-ent = "tam" then 
                           item.cod-localiz 
                        else 
                           ""
                            skip 

                    "AD,5,65,1,1,1,0, AE" string(ae-item.nr-ae,">999999") no-label
                        skip
                    "AD,200,65,1,1,1,0, " string(ae-item.sequencia,"999") no-label skip
                    "AB,320,65,1,1,1,0," +  string(ae-item.data,"99/99/9999")
                        format "x(70)" no-label skip 
                    "AB,5,95,1,1,1,0," 
                        string(time,"HH:MM:SS")  c-seg-usuario skip
                    "AD,250,105,1,1,1,0, QTD" format "x(70)" skip
                    "AD,280,105,1,1,1,0," i-qtd-resto format ">>,>>9" skip
                    "AC,18,170,1,1,1,0," +
                        item.descricao-1 + item.descricao-2 format "X(76)" no-label skip
                    "BU,35,207,2,5,50,0,1," + c-linha format "X(60)" no-label skip
                    "E"  with no-labels frame f-resto.
                    output close.          
            END.
            ELSE IF TRIM(ttRepApi.c-nome-imp) = "Zebra" THEN DO:
                    OUTPUT TO VALUE(ttRepApi.cNomeLayout).
                    DISP     
                        "^XA" 
                        SKIP

                        "^FO30,36^A0N,40,40^FD" + substring(ae-item.it-codigo,1,6) + "-" + substring(ae-item.it-codigo,7,1) + "^FS"  format "x(70)" 
                        SKIP

                        "^FO270,36^A0N,40,40^FD"
                        IF ttRepApi.depos-ent = "inj" OR
                           ttRepApi.depos-ent = "tam" THEN 
                           c-localizacao 
                        ELSE 
                           IF ttRepApi.depos-ent = "tam" THEN 
                              item.cod-localiz 
                           ELSE 
                              "" + "^FS" format "x(70)" 
                        SKIP

                        "^FO70,85^A0N,25,25^FDAE^FS"  
                        SKIP

                        "^FO95,85^A0N,25,25^FD" + string(ae-item.nr-ae,"9999999") + "^FS" format "x(70)"             
                        SKIP

                        "^FO255,85^A0N,25,25^FDSEQ^FS"       
                        SKIP

                        "^FO290,85^A0N,25,25^FD" string(ae-item.sequencia,"999") "^FS" 
                        SKIP

                        "^FO367,85^A0N,25,25^FD" ae-item.data format "99/99/9999" "^FS" 
                        SKIP           

                        "^FO60,115^A0N,25,25^FDROT^FS"              
                        SKIP

                        "^FO105,115^A0N,25,25^FD" + string(ae-item.roteiro,">>>>>9") + "^FS" format "x(70)"                            
                        SKIP
    
                        "^FO255,115^A0N,25,25^FD" + c-seg-usuario + "^FS" format "x(70)" 
                        SKIP



                        "^FO387,115^A0N,25,25^FD" STRING(TIME,"hh:mm") FORMAT "X(30)" "^FS" /* Imprime a hora */


    
                        "^FO30,150^A0N,25,25^FD" item.desc-item format "x(36)" "^FS" 
                        SKIP

                        "^FO280,195^A0N,60,40^FD" + string(i-qtd-resto,">>>,>>9") + "^FS" format "x(70)"         
                        SKIP
    
                        "^FO500,10" 
                        SKIP
    
                        "^FO50,250^BAN,50,Y,N,N^BY2^FD" + c-linha + "^FS" format "x(70)" 
                        SKIP     

                        "^XZ" 
                        with no-labels. 

                    output close.          
            END.
    
            assign ae-item.impresso = yes.
    
            if ttRepApi.depos-ent <> "smd" and 
               ttRepApi.depos-ent <> "iao" and
               ttRepApi.depos-ent <> "iac" and
               ttRepApi.depos-ent <> "ias" and
               ttRepApi.depos-ent <> "iat" and
               ttRepApi.depos-ent <> "cob" and
               ttRepApi.depos-ent <> "inj" and 
               ttRepApi.depos-ent <> "tam" then
               assign ae-item.situacao = yes.
            
            /*message " ". pause 0.      
                  unix silent impesc-light value(vArquivo).*/
            RELEASE ae-item.
        END.
        FOR FIRST ae-item NO-LOCK
            WHERE ae-item.cod-estabel = pCodEstabel
            and   ae-item.nr-ae = i-nr-ae:
        END.
    end.  
end.
