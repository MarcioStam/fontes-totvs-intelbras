{esp/es0018.i}
{utp/ut-glob.i}  

{esp/cdp/escdp123tt.i}

DEF VAR h-acomp         AS HANDLE NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.
    
DEFINE VARIABLE c-destaq AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-impressao NO-UNDO
    FIELD class-fiscal         LIKE classif-fisc.class-fiscal
    FIELD descricao            LIKE classif-fisc.descricao
    FIELD unidade              LIKE classif-fisc.unidade
    FIELD unid-trib            AS CHAR
    FIELD perc-ii              AS CHAR
    FIELD clog-suspensao-ii    AS CHAR
    FIELD aliquota-ipi         LIKE classif-fisc.aliquota-ipi
    FIELD clog-suspensao-ipi   AS CHAR
    FIELD val-aliq-ext-pis     LIKE classif-fisc.val-aliq-ext-pis
    FIELD aliq-pis-majorada    AS CHAR
    FIELD val-aliq-ext-cofins  LIKE classif-fisc.val-aliq-ext-cofins
    FIELD aliq-cofins-majorada AS CHAR
    FIELD aliq-pis-nac         AS DEC
    FIELD perc-red-pis-nac     AS CHAR
    FIELD aliq-cofins-nac      AS DEC
    FIELD perc-red-cofins-nac  AS CHAR
    FIELD clog-ex-tarifario    AS CHAR
    FIELD cod-un-ibge          LIKE classif-fisc.cod-un-ibge
    FIELD un-abr-ibge          LIKE classif-fisc.un-abr-ibge
    FIELD cod-naladi           LIKE classif-fisc.cod-naladi
    FIELD cod-naladi-sh        LIKE classif-fisc.cod-naladi-sh
    FIELD cod-mercosul         LIKE classif-fisc.cod-mercosul
    FIELD cod-ncm              LIKE classif-fisc.cod-ncm
    /* destaques */
    FIELD cod-destaq           LIKE classif-destaq.cod-destaq
    FIELD dsl-destaq           LIKE classif-destaq.dsl-destaq
    /* atributos */
    FIELD cod-atributo         LIKE classif-atrib.cod-atributo     
    FIELD des-atributo         LIKE classif-atrib.des-atributo 
    FIELD cod-domin            LIKE classif-atrib.cod-domin 
    FIELD des-domin            LIKE classif-atrib.des-domin 
    FIELD c-ind-modal          AS CHAR.

DEFINE BUFFER b-tt-impressao FOR tt-impressao.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "escdp123_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END. /* IF  OPSYS = "unix" THEN DO: */
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. /* FOR FIRST tt-prog-ponto: */

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
    END.
END.

EMPTY TEMP-TABLE tt-impressao.

FOR EACH  classif-fisc NO-LOCK
    WHERE classif-fisc.class-fiscal >= tt-param.c-ncm-ini
      AND classif-fisc.class-fiscal <= tt-param.c-ncm-fim.
    
    CREATE tt-impressao.
    ASSIGN tt-impressao.class-fiscal         = classif-fisc.class-fiscal
           tt-impressao.descricao            = classif-fisc.descricao
           tt-impressao.unidade              = classif-fisc.unidade
           tt-impressao.unid-trib            = SUBSTRING(classif-fisc.char-2,2,2)                                 /* Unid.Tributavel */
           tt-impressao.perc-ii              = substring(classif-fisc.char-1,1,5)                                 /* II */
           tt-impressao.clog-suspensao-ii    = IF SUBSTRING(classif-fisc.char-1,43,1) = "1" THEN "Sim" ELSE "Nao" /* Suspensao II */
           tt-impressao.aliquota-ipi         = classif-fisc.aliquota-ipi
           tt-impressao.clog-suspensao-ipi   = IF classif-fisc.log-1 THEN "Sim" ELSE "Nao"                        /* Suspensao IPI */
           tt-impressao.val-aliq-ext-pis     = classif-fisc.val-aliq-ext-pis
           tt-impressao.aliq-pis-majorada    = SUBSTRING(classif-fisc.char-1,65,9)                                /* Pis Majorada */
           tt-impressao.val-aliq-ext-cofins  = classif-fisc.val-aliq-ext-cofins
           tt-impressao.aliq-cofins-majorada = SUBSTRING(classif-fisc.char-1,56,9)                                /* Cofins Majorada*/
           tt-impressao.aliq-pis-nac         = classif-fisc.dec-1                                                 /* % PIS Nac. */
           tt-impressao.perc-red-pis-nac     = STRING(classif-fisc.int-1 / 100, ">9.99":U)                        /* % Redu‡Æo PIS Nac. */
           tt-impressao.aliq-cofins-nac      = classif-fisc.dec-2                                                 /* % Cofins Nac. */
           tt-impressao.perc-red-cofins-nac  = STRING(classif-fisc.int-2 / 100, ">9.99":U)                        /* % Reducao COFINS Nac. */
           tt-impressao.clog-ex-tarifario    = IF SUBSTRING(classif-fisc.char-2,4,1) = "1" THEN "Sim" ELSE "Nao"  /* Ex-tarifario */
           tt-impressao.cod-un-ibge          = classif-fisc.cod-un-IBGE
           tt-impressao.un-abr-ibge          = classif-fisc.un-abr-IBGE
           tt-impressao.cod-naladi           = classif-fisc.cod-naladi
           tt-impressao.cod-naladi-sh        = classif-fisc.cod-naladi-sh
           tt-impressao.cod-mercosul         = classif-fisc.cod-mercosul
           tt-impressao.cod-ncm              = classif-fisc.cod-ncm.

    IF tt-param.rs-tipo = 2 THEN DO: /* Destaques */
        
        FOR EACH  classif-destaq NO-LOCK
            WHERE classif-destaq.class-fiscal = classif-fisc.class-fiscal.

            CREATE b-tt-impressao.                       
            ASSIGN b-tt-impressao.class-fiscal         = tt-impressao.class-fiscal        
                   b-tt-impressao.descricao            = tt-impressao.descricao           
                   b-tt-impressao.unidade              = tt-impressao.unidade             
                   b-tt-impressao.unid-trib            = tt-impressao.unid-trib           
                   b-tt-impressao.perc-ii              = tt-impressao.perc-ii             
                   b-tt-impressao.clog-suspensao-ii    = tt-impressao.clog-suspensao-ii   
                   b-tt-impressao.aliquota-ipi         = tt-impressao.aliquota-ipi        
                   b-tt-impressao.clog-suspensao-ipi   = tt-impressao.clog-suspensao-ipi  
                   b-tt-impressao.val-aliq-ext-pis     = tt-impressao.val-aliq-ext-pis    
                   b-tt-impressao.aliq-pis-majorada    = tt-impressao.aliq-pis-majorada   
                   b-tt-impressao.val-aliq-ext-cofins  = tt-impressao.val-aliq-ext-cofins 
                   b-tt-impressao.aliq-cofins-majorada = tt-impressao.aliq-cofins-majorada
                   b-tt-impressao.aliq-pis-nac         = tt-impressao.aliq-pis-nac        
                   b-tt-impressao.perc-red-pis-nac     = tt-impressao.perc-red-pis-nac    
                   b-tt-impressao.aliq-cofins-nac      = tt-impressao.aliq-cofins-nac     
                   b-tt-impressao.perc-red-cofins-nac  = tt-impressao.perc-red-cofins-nac 
                   b-tt-impressao.clog-ex-tarifario    = tt-impressao.clog-ex-tarifario   
                   b-tt-impressao.cod-un-ibge          = tt-impressao.cod-un-ibge         
                   b-tt-impressao.un-abr-ibge          = tt-impressao.un-abr-ibge         
                   b-tt-impressao.cod-naladi           = tt-impressao.cod-naladi          
                   b-tt-impressao.cod-naladi-sh        = tt-impressao.cod-naladi-sh       
                   b-tt-impressao.cod-mercosul         = tt-impressao.cod-mercosul        
                   b-tt-impressao.cod-ncm              = tt-impressao.cod-ncm
                   b-tt-impressao.cod-destaq           = classif-destaq.cod-destaq
                   b-tt-impressao.dsl-destaq           = classif-destaq.dsl-destaq.
        END.
        
        IF CAN-FIND(FIRST classif-destaq
                    WHERE classif-destaq.class-fiscal = classif-fisc.class-fiscal) THEN
            DELETE tt-impressao.

    END.
    ELSE IF tt-param.rs-tipo = 3 THEN DO: /* Atributos */
        FOR EACH classif-atrib NO-LOCK
            WHERE classif-atrib.cod-class-fisc = classif-fisc.class-fiscal.

            CREATE b-tt-impressao.                       
            ASSIGN b-tt-impressao.class-fiscal         = tt-impressao.class-fiscal        
                   b-tt-impressao.descricao            = tt-impressao.descricao           
                   b-tt-impressao.unidade              = tt-impressao.unidade             
                   b-tt-impressao.unid-trib            = tt-impressao.unid-trib           
                   b-tt-impressao.perc-ii              = tt-impressao.perc-ii             
                   b-tt-impressao.clog-suspensao-ii    = tt-impressao.clog-suspensao-ii   
                   b-tt-impressao.aliquota-ipi         = tt-impressao.aliquota-ipi        
                   b-tt-impressao.clog-suspensao-ipi   = tt-impressao.clog-suspensao-ipi  
                   b-tt-impressao.val-aliq-ext-pis     = tt-impressao.val-aliq-ext-pis    
                   b-tt-impressao.aliq-pis-majorada    = tt-impressao.aliq-pis-majorada   
                   b-tt-impressao.val-aliq-ext-cofins  = tt-impressao.val-aliq-ext-cofins 
                   b-tt-impressao.aliq-cofins-majorada = tt-impressao.aliq-cofins-majorada
                   b-tt-impressao.aliq-pis-nac         = tt-impressao.aliq-pis-nac        
                   b-tt-impressao.perc-red-pis-nac     = tt-impressao.perc-red-pis-nac    
                   b-tt-impressao.aliq-cofins-nac      = tt-impressao.aliq-cofins-nac     
                   b-tt-impressao.perc-red-cofins-nac  = tt-impressao.perc-red-cofins-nac 
                   b-tt-impressao.clog-ex-tarifario    = tt-impressao.clog-ex-tarifario   
                   b-tt-impressao.cod-un-ibge          = tt-impressao.cod-un-ibge         
                   b-tt-impressao.un-abr-ibge          = tt-impressao.un-abr-ibge         
                   b-tt-impressao.cod-naladi           = tt-impressao.cod-naladi          
                   b-tt-impressao.cod-naladi-sh        = tt-impressao.cod-naladi-sh       
                   b-tt-impressao.cod-mercosul         = tt-impressao.cod-mercosul        
                   b-tt-impressao.cod-ncm              = tt-impressao.cod-ncm
                   b-tt-impressao.cod-atributo         = classif-atrib.cod-atributo 
                   b-tt-impressao.cod-domin            = classif-atrib.cod-domin 
                   b-tt-impressao.des-atributo         = classif-atrib.des-atributo 
                   b-tt-impressao.des-domin            = classif-atrib.des-domin 
                   b-tt-impressao.c-ind-modal          = {ininc/i01in01092.i 4 classif-atrib.ind-modal}.
                   

        END.
                                
        IF CAN-FIND(FIRST classif-atrib
                    WHERE classif-atrib.cod-class-fisc = classif-fisc.class-fiscal) THEN
            DELETE tt-impressao.

    END.
END.

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

PUT STREAM str-excel UNFORMATTED 
    "Class Fisc (NCM);Descricao;UnMed;UnTrib;II;Suspensao II;IPI;Suspensao IPI;PIS Imp.;PIS Majorada;COFINS Imp.;"
    "COFINS Majorada;PIS Nac.;Reducao PIS Nac.;COFINS Nac.;Reducao COFINS Nac.;Ex-Tarifario;IBGE;IBGE Abrev;NALADI;NALADI SH;Mercosul;C¢d. NCM".
    
IF tt-param.rs-tipo = 1 THEN
    PUT STREAM str-excel UNFORMATTED SKIP.
ELSE IF tt-param.rs-tipo = 2 THEN 
    PUT STREAM str-excel UNFORMATTED ";Cod.Destaque;Descricao Destaque" SKIP.
ELSE IF tt-param.rs-tipo = 3 THEN
    PUT STREAM str-excel UNFORMATTED ";Atributo;Descri‡Æo Atributo;Dominio;Descri‡Æo Dominio" SKIP.

FOR EACH  tt-impressao.

    RUN pi-acompanhar IN h-acomp(INPUT 'Classificacao Fiscal: ' + tt-impressao.class-fiscal ).

    PUT STREAM str-excel UNFORMATTED
        tt-impressao.class-fiscal            ";"
        tt-impressao.descricao               ";"
        tt-impressao.unidade                 ";"
        tt-impressao.unid-trib               ";" /* Unid.Tributavel */
        tt-impressao.perc-ii                 ";" /* II */
        tt-impressao.clog-suspensao-ii       ";" /* Suspensao II */
        tt-impressao.aliquota-ipi            ";" 
        tt-impressao.clog-suspensao-ipi      ";" /* Suspensao IPI */
        tt-impressao.val-aliq-ext-pis        ";"        
        tt-impressao.aliq-pis-majorada       ";"/* RED ext pis */
        tt-impressao.val-aliq-ext-cofins     ";"
        tt-impressao.aliq-cofins-majorada    ";" /* Cofins Majorada*/
        tt-impressao.aliq-pis-nac            ";" /* % PIS Nac. */
        tt-impressao.perc-red-pis-nac        ";" /* % Redu‡Æo PIS Nac. */
        tt-impressao.aliq-cofins-nac         ";" /* % Cofins Nac. */
        tt-impressao.perc-red-cofins-nac     ";" /* % Reducao COFINS Nac. */
        tt-impressao.clog-ex-tarifario       ";" /* Ex-tarifario */
        tt-impressao.cod-un-ibge             ";"
        tt-impressao.un-abr-ibge             ";"
        tt-impressao.cod-naladi              ";"
        tt-impressao.cod-naladi-sh           ";"    
        tt-impressao.cod-mercosul            ";"
        tt-impressao.cod-ncm.
        
    IF tt-param.rs-tipo = 1 THEN /* 1- Sem Destaque/Atributos */
        PUT STREAM str-excel UNFORMATTED SKIP.
    ELSE IF tt-param.rs-tipo = 2 THEN DO: /* 2- Somente Destaques */
        PUT STREAM str-excel UNFORMATTED 
            ";"
            tt-impressao.cod-destaq              ";"
            tt-impressao.dsl-destaq              SKIP.
    END.
    ELSE IF tt-param.rs-tipo = 3 THEN DO: /* - Somente Atributos */
        PUT STREAM str-excel UNFORMATTED 
            ";"
            tt-impressao.cod-atributo    ";"
            tt-impressao.des-atributo    ";"
            tt-impressao.cod-domin       ";"
            tt-impressao.des-domin       SKIP.
    END.
END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp.                                    

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.
