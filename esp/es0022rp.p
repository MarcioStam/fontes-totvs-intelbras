

{esp/es0022.i}

  


 DEF input parameter raw-param as raw no-undo.
 def input parameter table for tt-raw-digita.
 
raw-transfer raw-param TO tt-param.


DEF VAR i-ano AS INT.
DEF VAR i-mes AS INT.


FIND FIRST tt-param NO-ERROR.
IF AVAIL tt-param THEN
    ASSIGN i-ano = tt-param.ano
           i-mes = tt-param.mes .

DEF TEMP-TABLE tt-uni
    FIELD unidade AS CHAR
    FIELD divisao AS CHAR
    FIELD cod_ccusto LIKE sdo_orcto_ctbl_bgc.cod_ccusto
    INDEX codigo IS PRIMARY unidade divisao cod_ccusto.


DEF TEMP-TABLE tt-conta
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY cod_cta_ctbl
    INDEX esp ind_espec_cta_ctbl
    INDEX tp-codigo ind_espec_cta_ctbl cod_cta_ctbl.


DEF TEMP-TABLE tt-conta-div
    FIELD unidade LIKE tt-uni.unidade
    FIELD divisao LIKE tt-uni.divisao
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY unidade divisao cod_cta_ctbl .

DEF TEMP-TABLE tt-conta-uni
    FIELD unidade LIKE tt-uni.unidade
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY unidade cod_cta_ctbl.


DEF TEMP-TABLE tt-conta-emp
    FIELD cod_cta_ctbl LIKE cta_ctbl.cod_cta_ctbl
    FIELD ind_espec_cta_ctbl LIKE cta_ctbl.ind_espec_cta_ctbl
    FIELD orcado AS DEC FORMAT "->>>,>>>,>>9.99"
    FIELD realizado AS DEC FORMAT "->>>,>>>,>>9.99"
    INDEX codigo IS PRIMARY cod_cta_ctbl.


DEF BUFFER btt-conta FOR tt-conta.
DEF VAR c-arquivo AS CHAR.


DEF VAR c-linha AS CHAR.

IF OPSYS = "UNIX" THEN
    ASSIGN c-arquivo = "/usr8/progems/emscar/orcamento/cc-unidade.csv".
ELSE ASSIGN c-arquivo = "\\intel200\erp\emscar\orcamento\cc-unidade.csv".

INPUT FROM VALUE(c-arquivo).

REPEAT:
    IMPORT UNFORMATTED c-linha.
    CREATE tt-uni.
    ASSIGN tt-uni.unidade = ENTRY(1,c-linha,";")
           tt-uni.divisao = ENTRY(2,c-linha,";")
           tt-uni.cod_ccusto = SUBSTRING(ENTRY(3,c-linha,";"),4,5).
END.
INPUT CLOSE.


/* BUSCA TODOS OS CENTROS DE CUSTOS - O ARQUIVO SERA GERADO POR CENTRO DE CUSTOS */

FOR EACH cta_ctbl FIELDS (cod_cta_ctbl ind_espec_cta_ctbl) NO-LOCK
        WHERE cta_ctbl.cod_cta_ctbl >= "40000000"
          AND cta_ctbl.cod_cta_ctbl <  "41699999": 

         CREATE tt-conta.
         ASSIGN tt-conta.cod_cta_ctbl = cta_ctbl.cod_cta_ctbl
                tt-conta.ind_espec_cta_ctbl = cta_ctbl.ind_espec_cta_ctbl.
    
END.

DEF TEMP-TABLE tt-cc
    FIELD cc-codigo AS CHAR FORMAT "x(5)"
    FIELD centro-custo LIKE centro-custo.cc-codigo
    INDEX codigo IS PRIMARY cc-codigo.

FOR EACH centro-custo FIELDS (cc-codigo)  NO-LOCK:
    FIND tt-cc
         WHERE tt-cc.cc-codigo = SUBSTRING(centro-custo.cc-codigo,4,5) NO-ERROR.
    IF NOT AVAIL tt-cc THEN DO:
        CREATE tt-cc.
        ASSIGN tt-cc.cc-codigo = SUBSTRING(centro-custo.cc-codigo,4,5)
               tt-cc.centro-custo = centro-custo.cc-codigo.
    END.
END.






FOR EACH tt-cc  NO-LOCK:
     

    IF OPSYS = "unix" THEN
        ASSIGN c-arquivo = "/usr8/progems/emscar/orcamento/orc" + STRING(i-ano,"9999") 
                                     + STRING(i-mes,"99") 
                                     + SUBSTRING(tt-cc.centro-custo,4,5).


    ELSE
        ASSIGN c-arquivo = "\\intel200\erp$\emscar\orcamento\orc" + STRING(i-ano,"9999") 
                                     + STRING(i-mes,"99") 
                                     + SUBSTRING(tt-cc.centro-custo,4,5).



    /* BUSCA TODAS AS CONTAS CONTABEIS - O ARQUIVO TERA UMA LINHA PARA CADA CONTA */

     FOR EACH tt-conta:

        ASSIGN tt-conta.realizado = 0
                tt-conta.orcado    = 0.

         /* BUSCA OS VALORES REALIZADOS PARA CADA CONTA / CENTRO DE CUSTOS */
 
        FOR EACH  sdo_ctbl NO-LOCK
         WHERE sdo_ctbl.cod_cenar_ctbl        = "Fiscal"                  
            AND sdo_ctbl.cod_plano_cta_ctbl   = "padrao"      
            AND sdo_ctbl.cod_cta_ctbl         = tt-conta.cod_cta_ctbl                            
            AND sdo_ctbl.cod_plano_ccusto     = "padrao"      
            AND sdo_ctbl.cod_ccusto           =  tt-cc.cc-codigo
            AND sdo_ctbl.cod_estab            = "101"         
            AND sdo_ctbl.cod_empresa          =  "1"           
            AND MONTH(dat_sdo_ctbl)           = i-mes
            AND YEAR(dat_sdo_ctbl)            = i-ano:

            ASSIGN tt-conta.realizado = tt-conta.realizado + sdo_ctbl.val_sdo_ctbl_db - sdo_ctbl.val_sdo_ctbl_cr.

        END.

         /* BUSCA OS VALORES ORCADOS PARA CADA CONTA / CENTRO DE CUSTOS */


 
           FOR EACH sdo_orcto_ctbl_bgc NO-LOCK
               WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario = "oficial"
                 AND sdo_orcto_ctbl_bgc.cod_unid_orctaria = "desp1"
                 AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl = "FISCAL"
                 AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl = "padrao"
                 AND sdo_orcto_ctbl_bgc.cod_plano_ccusto = "padrao"
                 AND sdo_orcto_ctbl_bgc.cod_estab = "101"
                 AND sdo_orcto_ctbl_bgc.cod_empresa = "1"
                 AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl = STRING(i-ano,"9999")
                 AND sdo_orcto_ctbl_bgc.num_period_ctbl = i-mes
                 AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl = "2.00"
                 AND sdo_orcto_ctbl.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                 AND sdo_orcto_ctbl.cod_ccusto = tt-cc.cc-codigo:


               ASSIGN tt-conta.orcado = tt-conta.orcado + sdo_orcto_ctbl_bgc.val_orcado.
           END.
     
     END.

           
     

     /* TOTALIZA CONTAS SINTETICAS */


     /*

     FOR EACH tt-conta 
       WHERE tt-conta.ind_espec_cta_ctbl = "analitica":

        FIND LAST btt-conta
             WHERE btt-conta.cod_cta_ctbl < tt-conta.cod_cta_ctbl
               AND btt-conta.ind_espec_cta_ctbl = "sintetica" 
               USE-INDEX esp NO-ERROR.
    
        IF AVAIL btt-conta THEN DO:
            ASSIGN btt-conta.orcado = btt-conta.orcado + tt-conta.orcado
                   btt-conta.realizado = btt-conta.realizado + tt-conta.realizado.
    
    
        END.
     END.


     FOR EACH tt-conta
       WHERE tt-conta.ind_espec_cta_ctbl = "sintetica":

        FOR EACH btt-conta
           WHERE btt-conta.ind_espec_cta_ctbl = "sintetica"
             AND btt-conta.cod_cta_ctbl > tt-conta.cod_cta_ctbl
             AND btt-conta.cod_cta_ctbl BEGINS ENTRY(1,tt-conta.cod_cta_ctbl,"0").

            ASSIGN tt-conta.orcado = tt-conta.orcado +  btt-conta.orcado
                   tt-conta.realizado = tt-conta.realizado + btt-conta.realizado.

        END.
     END.
       
     */  
            
     /* totaliza contas */

/*
     MESSAGE "chegou aqui"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
  */
     FOR EACH tt-conta USE-INDEX tp-codigo
        WHERE tt-conta.ind_espec_cta_ctbl = "analitica"
           BY tt-conta.cod_cta_ctbl DESCENDING:

        FIND LAST btt-conta
             WHERE btt-conta.cod_cta_ctbl < tt-conta.cod_cta_ctbl
               AND btt-conta.ind_espec_cta_ctbl = "sintetica" 
               USE-INDEX codigo NO-ERROR.
    
        IF AVAIL btt-conta THEN DO:
            IF tt-conta.cod_cta_ctbl = btt-conta.cod_cta_ctbl THEN NEXT.

            ASSIGN btt-conta.orcado = btt-conta.orcado + tt-conta.orcado
                   btt-conta.realizado = btt-conta.realizado + tt-conta.realizado.
    
        END.
     END.
    /*
     MESSAGE "ta aqui"
         VIEW-AS ALERT-BOX INFO BUTTONS OK.
      */
     FOR EACH tt-conta  USE-INDEX tp-codigo
          WHERE tt-conta.ind_espec_cta_ctbl = "sintetica"
             BY tt-conta.cod_cta_ctbl DESCENDING:
      /*  

           MESSAGE tt-conta.cod_cta_ctbl
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */
           FIND LAST btt-conta
              WHERE btt-conta.ind_espec_cta_ctbl = "sintetica"
                AND btt-conta.cod_cta_ctbl < tt-conta.cod_cta_ctbl
                AND btt-conta.cod_cta_ctbl BEGINS 
                 substring(ENTRY(1,tt-conta.cod_cta_ctbl,"0"),1,LENGTH(ENTRY(1,tt-conta.cod_cta_ctbl,"0")) - 1) 
                   + FILL("0", 8 - LENGTH(substring(ENTRY(1,tt-conta.cod_cta_ctbl,"0"),1,LENGTH(ENTRY(1,tt-conta.cod_cta_ctbl,"0")) - 1) )) 
               NO-ERROR.
        
            /*   MESSAGE tt-conta.cod_cta_ctbl btt-conta.cod_cta_ctbl

                  substring(ENTRY(1,tt-conta.cod_cta_ctbl,"0"),1,LENGTH(ENTRY(1,tt-conta.cod_cta_ctbl,"0")) - 1) 
                   + FILL("0", 8 - LENGTH(substring(ENTRY(1,tt-conta.cod_cta_ctbl,"0"),1,LENGTH(ENTRY(1,tt-conta.cod_cta_ctbl,"0")) - 1) )) 
                        
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
              */
               IF AVAIL btt-conta THEN
               ASSIGN btt-conta.orcado = btt-conta.orcado +  tt-conta.orcado
                      btt-conta.realizado = btt-conta.realizado + tt-conta.realizado.
        
     END.


     /* GERA O ARQUIVO */
     
     OUTPUT TO VALUE(c-arquivo).
     
     FOR EACH tt-conta:
          PUT tt-conta.cod_cta_ctbl ";"
              tt-conta.orcado ";"
              tt-conta.realizado SKIP.

     END.

     OUTPUT CLOSE.


     FOR EACH tt-conta:
           /* totaliza empresa */
            

            FIND tt-conta-emp 
                 WHERE tt-conta-emp.cod_cta_ctbl = tt-conta.cod_cta_ctbl NO-ERROR.
            IF NOT AVAIL tt-conta-emp THEN
                CREATE tt-conta-emp.

            ASSIGN tt-conta-emp.cod_cta_ctbl       = tt-conta.cod_cta_ctbl
                   tt-conta-emp.ind_espec_cta_ctbl = tt-conta.ind_espec_cta_ctbl
                   tt-conta-emp.orcado       = tt-conta-emp.orcado +  tt-conta.orcado
                   tt-conta-emp.realizado    = tt-conta-emp.realizado + tt-conta.realizado.

     END.


     FOR EACH tt-uni
        WHERE tt-uni.cod_ccusto = tt-cc.cc-codigo:

          FOR EACH tt-conta:
                
                          /* totaliza unidade */

                FIND tt-conta-uni 
                     WHERE tt-conta-uni.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                       AND tt-conta-uni.unidade      = tt-uni.unidade NO-ERROR.
                IF NOT AVAIL tt-conta-uni THEN
                    CREATE tt-conta-uni.

                ASSIGN tt-conta-uni.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                       tt-conta-uni.unidade      = tt-uni.unidade
                       tt-conta-uni.ind_espec_cta_ctbl        = tt-conta.ind_espec_cta_ctbl
                       tt-conta-uni.orcado       = tt-conta-uni.orcado +  tt-conta.orcado
                       tt-conta-uni.realizado    = tt-conta-uni.realizado + tt-conta.realizado.


                /* totaliza divisao */

                FIND tt-conta-div
                     WHERE tt-conta-div.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                       AND tt-conta-div.unidade = tt-uni.unidade
                       AND tt-conta-div.divisao = tt-uni.divisao NO-ERROR.
                IF NOT AVAIL tt-conta-div THEN
                    CREATE tt-conta-div.

                ASSIGN tt-conta-div.cod_cta_ctbl = tt-conta.cod_cta_ctbl
                       tt-conta-div.unidade      = tt-uni.unidade
                       tt-conta-div.divisao      = tt-uni.divisao
                       tt-conta-div.ind_espec_cta_ctbl        = tt-conta.ind_espec_cta_ctbl
                       tt-conta-div.orcado       = tt-conta-div.orcado +  tt-conta.orcado
                       tt-conta-div.realizado    = tt-conta-div.realizado + tt-conta.realizado.
            
          END.
     END.
END. /* centro de custos */


/* gera arquivo da empresa */

IF OPSYS = "unix" THEN
    ASSIGN c-arquivo = "/usr8/progems/emscar/orcamento/emp" + STRING(i-ano,"9999") 
                             + STRING(i-mes,"99"). 
ELSE
    ASSIGN c-arquivo = "\\intel200\erp$\emscar\orcamento\emp" + STRING(i-ano,"9999") 
                             + STRING(i-mes,"99"). 

OUTPUT TO VALUE(c-arquivo).

    FOR EACH tt-conta-emp:

        PUT tt-conta-emp.cod_cta_ctbl ";"
            tt-conta-emp.orcado ";"
            tt-conta-emp.realizado SKIP.
    END.


OUTPUT CLOSE.


/* gera arquivos das unidades */

 FOR EACH tt-conta-uni
    BREAK BY tt-conta-uni.unidade:

     IF FIRST-OF(tt-conta-uni.unidade) THEN DO:
         
        IF OPSYS = "unix" THEN
            ASSIGN c-arquivo = "/usr8/progems/emscar/orcamento/uni" + STRING(i-ano,"9999") 
                                     + STRING(i-mes,"99") 
                                     + tt-conta-uni.unidade. 
        ELSE
            ASSIGN c-arquivo = "\\intel200\erp$\emscar\orcamento/uni" + STRING(i-ano,"9999") 
                                     + STRING(i-mes,"99") 
                                     + tt-conta-uni.unidade. 

        OUTPUT TO VALUE(c-arquivo).
     END.

    PUT tt-conta-uni.cod_cta_ctbl ";"
        tt-conta-uni.orcado ";"
        tt-conta-uni.realizado SKIP.
    
    IF LAST-OF(tt-conta-uni.unidade) THEN DO:
        OUTPUT CLOSE.
    END.
 END.


 /* gera arquivos das unidades */

 FOR EACH tt-conta-div
     BREAK BY tt-conta-div.unidade
           BY tt-conta-div.divisao:

     IF FIRST-OF(tt-conta-div.divisao) THEN DO:


         IF OPSYS = "unix" THEN
             ASSIGN c-arquivo = "/usr8/progems/emscar/orcamento/div" + STRING(i-ano,"9999") 
                                     + STRING(i-mes,"99") 
                                     + tt-conta-div.unidade 
                                     + tt-conta-div.divisao. 
         ELSE
            ASSIGN c-arquivo = "\\intel200\erp$\emscar\orcamento\div" + STRING(i-ano,"9999") 
                                     + STRING(i-mes,"99") 
                                     + tt-conta-div.unidade 
                                     + tt-conta-div.divisao. 

        OUTPUT TO VALUE(c-arquivo).
     END.
    PUT tt-conta-div.cod_cta_ctbl ";"
        tt-conta-div.orcado ";"
        tt-conta-div.realizado SKIP.
    
    IF LAST-OF(tt-conta-div.divisao) THEN DO:
        OUTPUT CLOSE.
    END.
 END.





