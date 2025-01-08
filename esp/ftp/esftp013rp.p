{include/i-prgvrs.i ESFTP013 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP013RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: DEZEMBRO/2004 - Desenvolvimento
**  Descricao.: Impressao Boleto BRADESCO - ES0658
**  VersÆo....: 001 27/12/2004 - Chaves
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp013rtt.i "new shared"}
{esp/ftp/esftp013tt.i}
{include/i-rpvar.i}
{cdp/cd0666.i}

/****************************  Temp-Tables  ****************************/
def temp-table tt-boleto
    field c-codesp        as char format "x(02)"
    field c-codserie      as char
    field c-documento     as char format "x(10)"
    field c-tipo          as char format "X(40)"
    field c-cpf           as char format "999999999999999"
    field c-sacado        as char format "x(30)"
    field c-end           as char
    field c-bairro        as char
    field c-cidade        as char
    field c-compl         as char
    field c-uf            as char
    field c-cep           as char
    field nat-operacao    like titulo.nat-operacao
    field i-carteira      as i  format "99"                       
    field d-valor         as de format ">>,>>>,>>9.99" decimals 3  
    field d-valor-doc     as de format ">,>>>,>>9.99"              
    field c-cod-esp       as c  format "xx"
    field c-emissao       as c  format "99/99/9999"
    field c-vencimento    as c  format "99/99/9999"
    field d-juros         as de format ">>>,>>9.99"
    field d-desconto      as dec                     
    field c-process       as char format "99/99/9999"  
    field c-ficha         as char
  INDEX ch-documento c-documento.

/****************************  Variaveis    ****************************/
def var tc-linha               as char format "x(69)" extent 9.
def var ti-linha               as int.
def var tc-nossonumero         as c    format "99999999999". 
def var tc-ficha               as c.
def var ti-linha-1             as i no-undo.
def var ti-coluna              as i no-undo.
def var tc-ntitulo             as c format "x(16)" no-undo.
def var tc-posicao             as c no-undo.
def var ti-ixtab1              as i no-undo.
def var tc-dig-bin             as c format "x(5)" extent 10 init ["00110","10001","01001","11000","00101","10100","01100","00011","10010","01010"] no-undo.
def var tc-linha-bin           as c format "x(10)" no-undo.
def var tc-linha-bar           as c format "x(10)" no-undo.
def var tc-par-binar           as c forma "xx"     no-undo.
def var tc-barra-solida-fina   as c init "~033*c3A~033*c150B~033*c0P" no-undo.
def var tc-barra-solida-larga  as c init "~033*c9A~033*c150B~033*c0P" no-undo.
def var tc-barra-branca-fina   as c init "~033*c5H~033*c365V~033*c1P" no-undo.
def var tc-barra-branca-larga  as c init "~033*c15H~033*c365V~033*c1P"
    no-undo.
def var tl-imprimiu-fina       as l no-undo.

def var tc-linha-s80           as c format "x(20)" 
    init "~033*c5550H~033*c10V~033*c0P" no-undo.
def var tc-linha-f80           as c format "x(20)" 
    init "~033*c5550H~033*c5V~033*c0P"  no-undo.
def var tc-traco-fino          as c format "x(50)" 
    init "~033*c5H~033*c200V~033*c0P"   no-undo.
def var tc-traco-fino1         as c format "x(50)" 
    init "~033*c5H~033*c250V~033*c0P"   no-undo.
def var tc-fonte-10            as c format "x(50)" 
    init "~033(19U~033(s16901t0b0s10.0v1P" no-undo.    
def var tc-fonte-6             as c format "x(50)" 
    init "~033(19U~033(s1p6.0v0s0b16602T"  no-undo.    
def var tc-fonte-10exp         as c format "x(50)" 
    init "~033(19U~033(s0p12.0h0s0b4099T"  no-undo.

def var i-digito          as int.
def var i-mo-cod          like titulo.mo-codigo init 0.

/****************************  Frames       ****************************/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mguni.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.



assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Impressao Boleto BRADESCO"
       c-empresa      = if avail empresa then mguni.empresa.razao-social else ''
       c-programa     = "ESFTP013"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
/*run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Imprimindo...").*/


run piMontaRelat.
IF CAN-FIND(FIRST tt-boleto) THEN DO:

    {include/i-rpout.i}
    do on stop undo, leave:

       /*run pi-acompanhar in h-acomp (input "Montando Relat¢rio...").*/
       /*run pi-acompanhar in h-acomp (input "Imprimindo...").*/
        run piImprimeRelat.

    end.
    {include/i-rpclo.i}
END.
ELSE IF NOT SESSION:BATCH-MODE THEN
    /*IF i-num-ped-exec-rpw <> 0 AND NOT SESSION:BATCH-MODE THEN*/
MESSAGE 'NÆo encontradas faturas para a sele‡Æo informada.'
         VIEW-AS ALERT-BOX INFO BUTTONS OK.


/*run pi-finalizar in h-acomp.*/

RETURN "OK".

/* **********************  Internal Procedures  *********************** */

PROCEDURE piMontaRelat:
    RUN esp/ftp/esftp013r1.p(INPUT  TABLE tt-param,
                             OUTPUT TABLE tt-boleto).
    /*
    do da-data = tt-param.da-emis-ini to tt-param.da-emis-fim:
    RUN pi-acompanhar IN h-acomp (INPUT "Data.: " + string(da-data,"99/99/9999")).
    */
END PROCEDURE.


PROCEDURE piImprimeRelat:
    put UNFORMATTED "~033&f761Y" /*format "X(10)"*/ .
    put UNFORMATTED "~033&f0X" /*SKIP*/ .
    
    run imprime_lay-out.

    put UNFORMATTED "~033&f1X".
    put UNFORMATTED "~033&f10X" /*format "X(9)"*/ .

    FIND estabelec no-lock
        WHERE estabelec.cod-estabel = tt-param.cod-estabel NO-ERROR.

    FOR EACH tt-boleto 
        BY tt-boleto.c-documento:

        /*RUN pi-acompanhar IN h-acomp (INPUT "Boleto...: " + string(tt-boleto.c-documento)).*/

        assign td-valor       = tt-boleto.d-valor-doc
               tc-nossonumero = STRING(INT(SUBSTRING(tt-param.cod-estabel, 3, 1)), "9")                 +
                                STRING(INT(tt-boleto.c-codserie), "99")                                 +
                                STRING(INT(SUBSTR(REPLACE(tt-boleto.c-documento,"/",""),2,6)),"999999") +
                                STRING(INT(SUBSTR(REPLACE(tt-boleto.c-documento,"/",""),8,2)),"99").

        RUN esp/ftp/esftp013r4.p(INPUT tt-param.cod-estabel,
                                 INPUT tt-param.c-esp,
                                 INPUT estabelec.serie,
                                 INPUT SUBSTR(tt-boleto.c-documento,1,7),
                                 INPUT SUBSTR(tt-boleto.c-documento,9,2),
                                 INPUT-OUTPUT  tc-nossonumero).

        find natur-oper where 
             natur-oper.nat-operacao = tt-boleto.nat-operacao
             no-lock no-error.

        assign tc-linha[1] = "NAO DISPENSAR JUROS"
               tc-linha[2] = "Valor do juro de mora diario:"
               tc-linha[3] = "R$ " +
                           trim(string(tt-boleto.d-juros,">>>,>>>,>>9.99"))
               tc-linha[4] = "PROTESTAR APOS 5 DIAS DO VENCIMENTO"
               tc-linha[5] = string(tt-boleto.nat-operacao,"9.99-xxx").
        if avail natur-oper then
            assign tc-linha[5] = tc-linha[5] + " - " + natur-oper.denominacao.
        ASSIGN td-vencimento = date(int(substr(tt-boleto.c-vencimento,4,2)), int(substr(tt-boleto.c-vencimento,1,2)), int(substr(tt-boleto.c-vencimento,7  ))).
        
        run calcula-dig.     /***** CALCULA DIGITO NOSSO NUMERO ***/     
        

        assign ti-nnumero = DEC(substr(tc-nossonumero,1,11)).

        

        run esp/ftp/esftp013r2.p. /*esp/es0658a.p.*/

        

        /***** TT-PARAM.L-IMP-REIMP = IMPRESSÇO ********/
        IF tt-param.l-imp-reimp THEN
           RUN esp/ftp/esftp013r3.p(INPUT  tt-param.cod-estabel,
                                    INPUT  tt-param.c-esp,
                                    INPUT  tt-boleto.c-documento,
                                    INPUT  tc-nossonumero,
                                    OUTPUT TABLE tt-erro).

        IF  CAN-FIND(FIRST tt-erro) THEN DO:
            FOR EACH tt-erro:
                MESSAGE 'Seq: ' tt-erro.i-sequen SKIP 
                        'Erro: ' tt-erro.cd-erro SKIP 
                        'Mensagem: ' tt-erro.mensagem SKIP
                        'Nota Fis: ' tt-boleto.c-documento SKIP
                    VIEW-AS ALERT-BOX ERROR TITLE "Erro na gera‡Æo do boleto".
            END.
          


        END.
        ELSE DO:
           run runs.
        END.
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
            /*RUN cdp\cd0666.w (INPUT TABLE tt-erro).*/
        /*PAGE.*/
        PUT SKIP(1).

    end.

END PROCEDURE.

procedure calcula-dig:

   assign i-digito = int(substr(tc-nossonumero,11,1)) * 2.
   assign i-digito = i-digito + (int(substr(tc-nossonumero,10,1)) * 3).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,9,1)) * 4).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,8,1)) * 5).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,7,1)) * 6).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,6,1)) * 7).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,5,1)) * 2).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,4,1)) * 3).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,3,1)) * 4).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,2,1)) * 5).
   assign i-digito = i-digito + (int(substr(tc-nossonumero,1,1)) * 6).
   assign i-digito = i-digito + (int(substr(string(int(tt-param.i-carteira),"99"),2,1))) * 7.
   assign i-digito = i-digito + (int(substr(string(int(tt-param.i-carteira),"99"),1,1))) * 2.
   assign i-digito = i-digito mod 11.
   if i-digito = 1 then
      assign tc-nossonumero = tc-nossonumero + "-P".
   else
   if i-digito <> 0 then
      assign tc-nossonumero = tc-nossonumero + "-" + string(11 - i-digito,"9").
   else
      assign tc-nossonumero = tc-nossonumero + "-" + string(i-digito,"9").
end.

procedure runs.
   put UNFORMATTED "~033&f761Y" /*format "X(10)"*/ .
   put UNFORMATTED "~033&f2X" /*skip*/ . 
   run imprime_dados.
   run imprime_barras.
end.

procedure imprime_lay-out:

    do ti-linha = 0 to 2230 by 1115.
    
       if ti-linha = 0 
       then assign tc-ntitulo = "Recibo do Sacado".        
       
       else if ti-linha = 1115 
            then assign tc-ntitulo = "  Ficha de Caixa".
                 
       else assign tc-ntitulo = "".
            
       if ti-linha = 2230
       then assign tc-ficha = "-Ficha de Compensacao".      
       else assign tc-ficha = ''.
       put UNFORMATTED "~033*p0X~033*p" /*+*/ string (ti-linha + 12,"9999") /*+*/ "Y" /*+*/
           tc-linha-s80  /*format "x(50)"*/ .
       
       do ti-ixtab = 105 to 345 by 80.       
       
          assign tc-posicao = "~033*p0X~033*p" + 
                              string (ti-ixtab + ti-linha,"9999") +
                              "Y" + tc-linha-f80.
                                                          
          put UNFORMATTED tc-posicao /*format "x(80)"*/ .
          
          /*** Imprime linhas Verticais do layout do boleto  ***/ 
          put UNFORMATTED "~033*p1600X~033*p"  /*+*/ string (12 + ti-linha,"9999")  /*+*/ "Y" /*+*/ 
              tc-traco-fino1 /*format "x(80)"*/
              "~033*p1600X~033*p"  /*+*/ string (105 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*format "x(80)"*/
              "~033*p408X~033*p"   /*+*/ string (185 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p751X~033*p"   /*+*/ string (185 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p997X~033*p"   /*+*/ string (185 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p1211X~033*p"  /*+*/ string (185 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p1600X~033*p"  /*+*/ string (185 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*format "x(200)"*/
              
              "~033*p408X~033*p"   /*+*/ string (265 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p578X~033*p"   /*+*/ string (265 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p728X~033*p"   /*+*/ string (265 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p1211X~033*p"  /*+*/ string (265 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino /*+*/
              "~033*p1600X~033*p"  /*+*/ string (265 + ti-linha,"9999") /*+*/ "Y" /*+*/ 
              tc-traco-fino  /*format "x(200)"*/ .
       end. /*ti-ixtab*/
       
       do ti-ixtab = 425 to 665 by 80.
          assign tc-posicao = "~033*p1600X~033*p" + 
                             string ((ti-ixtab + ti-linha) - 80,"9999") + "Y" +
                             tc-traco-fino + "~033*p1600X~033*p" +    /*linha v~ertical lateral esquerda*/
                             string ((ti-ixtab + ti-linha),"9999") + "Y" + 
                             "~033*c1730H~033*c5V~033*c0P".   /*linhas horizont~ais */
                             
          put UNFORMATTED tc-posicao /*format "x(180)"*/ .      /** Linha Vertical**/
       end.

       
       /******** Boleto   ************/
       put UNFORMATTED 
           "~033*p1600X~033*p" /*+*/ string ((ti-ixtab + ti-linha) - 80,"9999") /*+*/
           "Y" /*+*/ tc-traco-fino /*+*/
           "~033*p0X~033*p"    /*+*/ string (745 + ti-linha,"9999")          /*+*/ "Y" 
           /*+*/ tc-linha-s80 /*+*/
           "~033*p0X~033*p"    /*+*/ string (905 + ti-linha,"9999")          /*+*/ "Y" 
           /*+*/ tc-linha-s80 /*format "x(255)"                     */
          /**Posicao do nome do banco c/ log - 120**/ /** Linhas do Sacado **/            "~033(19U~033(s0p10.0hs3b34099T~033*p1790X~033*p" /*+*/
           string (ti-linha + 0,"9999") /*+*/ "Y" /*+*/ tc-ntitulo  /*format "x(200)"*/    ~                                                       /** 1a. Linha **/                  tc-fonte-6
           "~033*p0X~033*p"    /*+*/ string (ti-linha + 35,"9999") /*+*/ 
           "YLocal de Pagamento" /*+*/ 
           "~033*p1622X~033*p" + string (ti-linha + 35,"9999") /*+*/ 
           "YVencimento" /*format "x(200)"            */
           
           tc-fonte-10exp 
     /** 2a. Linha **/
           
           tc-fonte-6 /*+*/
           "~033*p0X~033*p"    /*+*/ string (ti-linha + 125,"9999") /*+*/ "YCedente" /*+*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 125,"9999") /*+*/ 
           "YAgencia/Codigo Cedente" /*format "x(200)"*/
    /** 3a. Linha **/
           
           tc-fonte-6 /*+*/
           "~033*p0X~033*p"    /*+*/ string (ti-linha + 205,"9999") /*+*/
           "YData do Documento"     /*+*/
           "~033*p413X~033*p"  /*+*/ string (ti-linha + 205,"9999") /*+*/
           "YNum. do Documento"     /*+*/
           "~033*p756X~033*p"  /*+*/ string (ti-linha + 205,"9999") /*+*/
           "YEspecie Doc"           /*+*/
           "~033*p1002X~033*p" /*+*/ string (ti-linha + 205,"9999") /*+*/
           "YAceite"                /*+*/
           "~033*p1216X~033*p" /*+*/ string (ti-linha + 205,"9999") /*+*/
           "YData do Processamento" /*+*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 205,"9999") /*+*/
           "YNosso Numero" /*format "x(200)"*/                                     ~                     /** 4a. Linha Layout**/ 
           
           tc-fonte-6 /*+*/
           "~033*p0X~033*p"    /*+*/ string (ti-linha + 285,"9999") /*+*/
           "YUso do Banco"  /*+*/
           "~033*p413X~033*p"  /*+*/ string (ti-linha + 285,"9999") /*+*/
           "YCarteira"      /*+*/
           "~033*p583X~033*p"  /*+*/ string (ti-linha + 285,"9999") /*+*/
           "YEspecie"       /*+*/
           "~033*p733X~033*p"  /*+*/ string (ti-linha + 285,"9999") /*+*/
           "YQuantidade"    /*+*/
           "~033*p1216X~033*p" /*+*/ string (ti-linha + 285,"9999") /*+*/
           "YValor"         /*+*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 285,"9999") /*+*/
           "Y(=) Valor do Documento" /*format "x(200)"*/
                                 /** 5a. Linha Layout **/
           
           tc-fonte-6 /*+*/
           "~033*p0X~033*p" /*+*/ string (ti-linha + 365,"9999") /*+*/
           "YInstrucoes"     /*+*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 365,"9999") /*+*/
           "Y(-) Desconto/Abatimento" /*format "x(200)"*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 445,"9999") /*+*/
           "Y(-) Outras Deducoes" /*format "x(200)"*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 525,"9999") /*+*/
           "Y(+) Mora/Multa" /*format "x(200)"*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 605,"9999") /*+*/
           "Y(+) Outros Acrescimos" /*format "x(200)"*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 685,"9999") /*+*/
           "Y(=) Valor Cobrado" /*format "x(200)" */
                      /**  6a. a 10a. Linha  Layout - Canto Esquedo**/  
           
           "~033*p0X~033*p" /*+*/ string (ti-linha + 765,"9999") /*+*/
           "YSacado" /*format "x(200)"*/
           "~033*p0X~033*p" /*+*/ string (ti-linha + 895,"9999") /*+*/
           "YSacador/Avalista" /*+*/
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 895,"9999") /*+*/
           "YCodigo de Baixa  " /*format "x(200)"           */
           "~033*p1622X~033*p" /*+*/ string (ti-linha + 935,"9999") /*+*/
           "YAutenticacao Mecanica" /*+*/ tc-ficha  /*format "x(200)"*/ .
                             /** Inf. Sacado - Antes da Barra **/
       
       if ti-linha < 1115 then 
          put UNFORMATTED tc-fonte-6 /*+*/
              "~033*p0X~033*p" /*+*/ string (ti-linha + 935,"9999")  /*+*/
              "YRecebimento atraves do cheque num.                          do banco"
           /*format 'x(300)'*/
           "~033*p0X~033*p" /*+*/ string (ti-linha + 965,"9999")  /*+*/
           "YEsta quita‡Æo s¢ ter  validade ap¢s pagamento do cheque pelo"
           /*format 'x(300)'*/
           "~033*p0X~033*p" /*+*/ string (ti-linha + 995,"9999") /*+*/
           "Ybanco sacado." /*format 'x(300)'*/ .


       assign ti-linha-1 = ti-linha-1 + 45.       
       
       if ti-linha <= 1115 then
          put UNFORMATTED "~033(s16901t0b0s12.5v1p"
              "~033*p0X~033*p" /*+*/ string (ti-linha + 1050,"9999") /*+*/ "Y" /*+*/
              fill ("-",134) /*format "x(200)"*/
              tc-fonte-10. /**Linha Tracejada **/                              
              
  end. /*1o. do*/        
end procedure.

procedure imprime_dados:

    do ti-linha = 0 to 2230 by 1115.
        
       /******** Boleto   ************/
       put UNFORMATTED
           "~033(19U~033(s1p12.0v0s3b4168T~033*p0X~033*p" /*+*/ 
           string (ti-linha + 0,"9999")   /*+*/ "Y" /*+*/ tc-nome-banco  /*+*/
           "~033(19U~033(s1p15.0v0s4b4362T~033*p550X~033*p"         /*+*/ 
           string (ti-linha + 0,"9999") /*+*/ "Y|" /*+*/ tc-bco-compens 
           /*+*/ "|" /*format "x(200)"*/
   /** 1a. Linha **/           

           tc-fonte-10exp /*+*/
           "~033*p0X~033*p"     /*+*/ string (ti-linha + 80,"9999") /*+*/ "Y" /*+*/ 
           "Pague preferencialmente nas agencias do BRADESCO" /*format "X(200)"*/
           "~033*p1642X~033*p"  /*+*/ string (ti-linha + 80,"9999") /*+*/ "Y" /*+*/ 
           tt-boleto.c-vencimento  /*format "x(80)" */
   /** 2a. Linha **/
           
           tc-fonte-10exp /*+*/
           "~033*p0X~033*p"    /*+*/ string (ti-linha + 170,"9999") /*+*/ "Y" /*+*/ 
           tc-nome-est  /*+*/
           "~033*p1642X~033*p"  /*+*/ string (ti-linha + 170,"9999") /*+*/ "Y" /*+*/
           string (ti-ag-cedente,"9999") /*+*/ "-" /*+*/ string(i-dig-cart,"9") /*+*/ "/" /*+*/
           string (ti-ccorrente,"99999") /*+*/ "-" /*+*/ string(ti-dac-agcc,"9") 
           /*format "x(200)"*/

    /** 3a. Linha **/
           
           tc-fonte-10exp /*+*/
           "~033*p0X~033*p"    /*+*/ string (ti-linha + 250,"9999") /*+*/ "Y" /*+*/
           tt-boleto.c-emissao /*+*/
           "~033*p420X~033*p"  /*+*/ string (ti-linha + 250,"9999") /*+*/ "Y" /*+*/
           tt-boleto.c-documento /*+*/ 
           "~033*p880X~033*p"  /*+*/ string (ti-linha + 250,"9999") /*+*/ "Y" /*+*/ 
           tt-boleto.c-cod-esp /*+*/
         "~033*p1090X~033*p" /*+*/ string (ti-linha + 250,"9999") /*+*/ "YN"  /*+*/ 
           "~033*p1225X~033*p" /*+*/ string (ti-linha + 250,"9999") /*+*/ "Y" /*+*/ 
           tt-boleto.c-process /*+*/
           "~033*p1642X~033*p" /*+*/ string (ti-linha + 250,"9999") /*+*/ "Y" /*+*/
           string (ti-carteira,"99") /*+*/ "/" /*+*/ tc-nossonumero /*format "x(200)"*/
            
     /** 4a. Linha Informa**/
           
           tc-fonte-10exp /*+*/
           "~033*p423X~033*p"  /*+*/ string (ti-linha + 330,"9999") /*+*/ "Y"   /*+*/
           string (i-carteira,"99") /*+*/
           "~033*p593X~033*p"  /*+*/ string (ti-linha + 330,"9999") /*+*/ "YR$" /*+*/
           "~033*p1662X~033*p" /*+*/ string (ti-linha + 330,"9999") /*+*/ "Y"   /*+*/
           string (tt-boleto.d-valor-doc,">>>>,>>9.99")
           /*format "x(200)"*/ .
    /** 5a. Linha Informa **/ 
           
       assign ti-linha-1 = 415.
                      
       /****** Instrucoes de pagamento do Boleto ********/
              
       put UNFORMATTED
           "~033(11U~033(s0p16.67h8.5v0s0b0T~033*p0X~033*p" /*+*/        
           string (ti-linha + ti-linha-1,"9999") /*+*/ 
           "Y" /*+*/ tc-linha[1] /*format "x(250)"*/
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 35,"9999") /*+*/
           "Y" /*+*/ tc-linha[2] /*format "x(250)"            */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 75,"9999") /*+*/
           "Y" /*+*/ tc-linha[3] /*format "x(250)" */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 115,"9999") /*+*/
           "Y" /*+*/ tc-linha[4] /*format "x(250)" */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 155,"9999") /*+*/
           "Y" /*+*/ tc-linha[5] /*format "x(250)" */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 195,"9999") /*+*/ 
           "Y" /*+*/ tc-linha[6] /*format "x(250)" */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 235,"9999") /*+*/
           "Y" /*+*/ tc-linha[7] /*format "x(250)" */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 275,"9999") /*+*/
           "Y" /*+*/ tc-linha[8] /*format "x(250)" */
           "~033*p0X~033*p" /*+*/ string (ti-linha + ti-linha-1 + 315,"9999") /*+*/
           "Y" /*+*/ tc-linha[9] /*format "x(250)"*/ .
 
        assign ti-linha-1 = ti-linha-1 + 45.       
       
       /********* Sacado ************/
       put UNFORMATTED 
           tc-fonte-10exp /*+*/
           "~033*p150X~033*p" /*+*/ string (ti-linha + 805,"9999") /*+*/ "Y" /*+*/
           tt-boleto.c-sacado format "x(100)"
           "~033*p1680X~033*p" /*+*/ string (ti-linha + 805,"9999") /*+*/ "Y" /*+*/ 
           tt-boleto.c-tipo /*+*/ " - " /*+*/ string(tt-boleto.c-cpf)
           format "x(180)"
           "~033*p150X~033*p" /*+*/ string (ti-linha + 835,"9999") /*+*/ "Y" /*+*/
           tt-boleto.c-end format "x(80)" 
           "~033*p900X~033*p" /*+*/ string (ti-linha + 835,"9999") /*+*/ "Y" /*+*/ 
           tt-boleto.c-compl format "x(25)"
           "~033*p150X~033*p"  /*+*/ string (ti-linha + 865,"9999") /*+*/ "Y"   /*+*/
           TRIM(tt-boleto.c-cep)
           /*substr(tt-boleto.c-cep,1,5)  /*+*/ " " /*+*/ substr(tt-boleto.c-cep,6,3)*/
           /*+*/ "   " /*+*/ 
           tt-boleto.c-bairro format 'x(40)'
           "~033*p1000X~033*p" /*+*/ string (ti-linha + 865,"9999") /*+*/ "Y"   /*+*/
           tt-boleto.c-cidade format 'x(60)'           
           "~033*p1700X~033*p" /*+*/ string (ti-linha + 865,"9999") /*+*/ "Y"   /*+*/
           ' - ' /*+*/ tt-boleto.c-uf /*format 'x(70)'*/ .
                                 
  end. /*1o. do*/        
end procedure.

procedure imprime_barras:

    put UNFORMATTED "~033(19U~033(s1p11.0v0s0b16602T~033*p850X~033*p2230Y" /*+*/
        tc-linha-dig  /*format "x(100)"      */
   
   /*codigo do boleto - ficha do banco **/
   
        "~033*p0X~033*p3175Y" tc-barra-solida-fina /*format "x(30)"*/
        "~033*p6X~033*p3175Y" tc-barra-solida-fina /*format "x(30)"*/ .

    assign ti-coluna         = 9
           tl-imprimiu-fina  = yes.
    
    do ti-ixtab = 1 to 44 by 2.
       assign tc-par-binar = substr(tc-nrbarr,ti-ixtab,2)
              tc-linha-bin = tc-dig-bin[integer(substr(tc-par-binar,1,1)) + 1] +
                            tc-dig-bin [integer (substr (tc-par-binar,2,1)) + 1]
              tc-linha-bar = "".
       do ti-ixtab1 = 1 to 5.
          assign tc-linha-bar = tc-linha-bar +
                               substr (tc-linha-bin,ti-ixtab1,1) +
                               substr (tc-linha-bin,ti-ixtab1 + 5,1).
      end.
      do ti-ixtab1 = 1 to 10.
         if tl-imprimiu-fina then 
              assign ti-coluna = ti-coluna + 3.
         else assign ti-coluna = ti-coluna + 9.
         
         if substr (tc-linha-bar,ti-ixtab1,1) eq "0" then 
              assign tl-imprimiu-fina = yes.
         else assign tl-imprimiu-fina = no.
         if ti-ixtab1 mod 2 ne 0 then do:
            if tl-imprimiu-fina then
                  put UNFORMATTED "~033*p" /*+*/ string (ti-coluna,"9999") /*+*/ "X~033*p3175Y" /*+*/
                      tc-barra-solida-fina /*format "x(50)"*/.
             else put UNFORMATTED "~033*p" /*+*/ string (ti-coluna,"9999") /*+*/ "X~033*p3175Y" /*+*/
                      tc-barra-solida-larga /*format "x(50)"*/ .
         end.
      end. 
    end.
    if tl-imprimiu-fina then 
         assign ti-coluna = ti-coluna + 3.
    else assign ti-coluna = ti-coluna + 9.
    put UNFORMATTED "~033*p" /*+*/ string (ti-coluna,"9999") /*+*/ "X~033*p3175Y"
        tc-barra-solida-larga    /*format "x(30)"*/
        "~033*p" /*+*/ string (ti-coluna + 12,"9999") /*+*/ "X~033*p3175Y"
        tc-barra-solida-fina     /*format "x(30)" */
        tc-fonte-10.

end procedure.
