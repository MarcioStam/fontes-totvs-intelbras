{esp/es0018.i}
{utp/ut-glob.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field uf-origem-ini    as char 
    field uf-origem-fim    as char 
    field uf-destino-ini   as char 
    field uf-destino-fim   as char 
    FIELD it-codigo-ini    AS CHAR
    FIELD it-codigo-fim    AS CHAR
    FIELD item-fat         AS INT
    FIELD estabelecimentos AS CHAR. 

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD desc-item LIKE ITEM.desc-item
    INDEX idx-it it-codigo.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-estado
    FIELD estado AS CHAR.

DEF BUFFER b01-tt-estado FOR tt-estado.

DEF TEMP-TABLE tt-lista-estado
    FIELD cod-estabel  AS CHAR
    FIELD uf-origem    AS CHAR
    FIELD uf-destino   AS CHAR
    INDEX idx uf-origem uf-destino cod-estabel.

DEF TEMP-TABLE tt-item-icms 
    FIELD cod-estabel  AS CHAR
    FIELD uf-origem    AS CHAR
    FIELD uf-destino   AS CHAR
    FIELD it-codigo    AS CHAR
    FIELD ind-item-fat AS LOG
    INDEX idx uf-origem uf-destino cod-estabel it-codigo .
    
DEF VAR de-perc-icms    AS DEC    NO-UNDO.
DEF VAR h-acomp         AS HANDLE NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nat-oper    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-listar-item AS LOGICAL     NO-UNDO.

DEFINE VARIABLE h-boes505      AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bodi317im1br AS HANDLE    NO-UNDO.

DEFINE VARIABLE i-cont   AS INTEGER NO-UNDO.
DEFINE VARIABLE c-erro   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-return AS LOGICAL   NO-UNDO.

DEFINE VARIABLE  de-perc-icms-old AS DECIMAL     NO-UNDO.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Acompanhamento").

DO ON STOP UNDO, LEAVE:

    ASSIGN c-arquivo-csv = "esftp212_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.

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

// Carrega Estados
RUN pi-carrega-estados.

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

PUT STREAM str-excel UNFORMATTED "Origem;Destino;Cod.Estabel;Item;Descricao;%ICMS;Item Faturavel" SKIP.

DEFINE VARIABLE ii AS INT  NO-UNDO.

RUN esbo/boes505.p      PERSISTENT SET h-boes505. 
RUN dibo/bodi317im1br.p PERSISTENT SET h-bodi317im1br.

DO i-cont = 1 TO NUM-ENTRIES(tt-param.estabelecimentos):

   FIND FIRST estabelec WHERE estabelec.cod-estabel = ENTRY(i-cont,tt-param.estabelecimentos) NO-LOCK NO-ERROR.
 
   IF NOT AVAIL estabelec THEN NEXT.
   
   ii = 0.

   IF CAN-FIND(FIRST tt-digita) THEN DO:
      FOR EACH tt-digita:
          FOR EACH ITEM NO-LOCK 
              WHERE ITEM.it-codigo   = tt-digita.it-codigo
                /*AND ITEM.cod-estabel = estabelec.cod-estabel*/,
              FIRST item-uni-estab NO-LOCK 
              WHERE item-uni-estab.cod-estabel = ITEM.cod-estabel
                AND item-uni-estab.it-codigo   = ITEM.it-codigo:

              IF tt-param.item-fat = 1 /* ITEM FATUR */ AND NOT item-uni-estab.ind-item-fat THEN NEXT.
              IF tt-param.item-fat = 2 /* ITEM NAO FATUR */ AND item-uni-estab.ind-item-fat THEN NEXT.

              RUN pi-carrega-itens (INPUT item-uni-estab.cod-estabel).
          END.
      END.
   END.
   ELSE
   DO:
      FOR EACH ITEM NO-LOCK 
          WHERE ITEM.it-codigo  >= tt-param.it-codigo-ini
            AND ITEM.it-codigo  <= tt-param.it-codigo-fim
            /*AND ITEM.cod-estabel = estabelec.cod-estabel*/,
          FIRST item-uni-estab NO-LOCK 
          WHERE item-uni-estab.cod-estabel = estabelec.cod-estabel
            AND item-uni-estab.it-codigo   = ITEM.it-codigo:

          IF tt-param.item-fat = 1 /* ITEM FATUR */ AND NOT item-uni-estab.ind-item-fat THEN NEXT.
          IF tt-param.item-fat = 2 /* ITEM NAO FATUR */ AND item-uni-estab.ind-item-fat THEN NEXT.

          ASSIGN l-listar-item = NO.

          CASE ITEM.ge-codigo:
              WHEN 0 THEN //DEBITO DIRETO
              DO:
                 IF SUBSTRING(ITEM.it-codigo,1,2) = '99' THEN
                    ASSIGN l-listar-item = YES. 
              END.
              WHEN 20 THEN //SEMI-ACABADOS - INTELBRAS
                ASSIGN l-listar-item = YES.
              WHEN 40 THEN //PRODUTOS ACABADOS - INTELBRAS     
                ASSIGN l-listar-item = YES.
              WHEN 42 THEN //PRODUTOS ACABADOS - SKD/CKD
                ASSIGN l-listar-item = YES.
              WHEN 45 THEN //PRODUTOS ACABADOS - OEM
                ASSIGN l-listar-item = YES.         
          END CASE.

          IF NOT l-listar-item THEN NEXT.

          RUN pi-carrega-itens (INPUT item-uni-estab.cod-estabel).

          ASSIGN ii = ii + 1.
          //IF ii = 500 THEN LEAVE.
      END.
   END.
    
END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp. 

DELETE PROCEDURE h-boes505.
DELETE PROCEDURE h-bodi317im1br.

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

/* FIM */
/*********************************************************/

PROCEDURE pi-carrega-estados:
   FOR EACH tt-estado.       DELETE tt-estado.       END.
   FOR EACH tt-lista-estado. DELETE tt-lista-estado. END.

   FOR EACH unid-feder NO-LOCK
       WHERE unid-feder.pais = "BRASIL":

       IF unid-feder.estado = "EX" THEN NEXT.    

       IF unid-feder.estado = "" THEN NEXT.    

       CREATE tt-estado.
       ASSIGN tt-estado.estado = unid-feder.estado.
   END.
END PROCEDURE.


PROCEDURE pi-carrega-itens:

    DEF BUFFER b01-estabelec FOR estabelec.

    DEF INPUT PARAM p-estab      AS CHAR NO-UNDO.

    DEFINE VARIABLE ii             AS INTEGER NO-UNDO.
    DEFINE VARIABLE l-lista-estado AS LOGICAL NO-UNDO.

    FIND b01-estabelec  WHERE b01-estabelec.cod-estabel = p-estab NO-LOCK NO-ERROR.
    
    IF AVAIL b01-estabelec AND AVAIL ITEM THEN DO:
       
       loop_estado:
       FOR EACH tt-estado
           BREAK BY tt-estado.estado:

           ASSIGN l-lista-estado = NO.
             
           /* Incluir Parametro Estados Nordeste */
           IF b01-estabelec.cod-estabel = '110' THEN DO:
              RUN esp/es0018p.p (INPUT  'esftp212',
                                 INPUT  1,
                                 INPUT  0,
                                 INPUT  "":U,
                                 OUTPUT TABLE tt-prog-ponto).
    
              FOR EACH tt-prog-ponto:
                  DO ii = 1 TO NUM-ENTRIES(tt-prog-ponto.conteudo,';'):
                     IF ENTRY(ii,tt-prog-ponto.conteudo,';') = tt-estado.estado THEN 
                        ASSIGN l-lista-estado = YES.
                  END.
              END.  

              IF NOT l-lista-estado  THEN NEXT loop_estado.
           END.
           
           RUN pi-acompanhar IN h-acomp (INPUT 'Carregando: ' + item-uni-estab.cod-estabel + ' - ' + item-uni-estab.it-codigo + ' => ' + b01-estabelec.estado + ' / ' + tt-estado.estado).
           
           FIND FIRST tt-item-icms
                WHERE tt-item-icms.uf-origem    = b01-estabelec.estado
                  AND tt-item-icms.uf-destino   = tt-estado.estado
                  AND tt-item-icms.cod-estabel  = b01-estabelec.cod-estabel
                  AND tt-item-icms.it-codigo    = ITEM.it-codigo 
           NO-ERROR.
            
           IF NOT AVAIL tt-item-icms THEN
           DO:
              CREATE tt-item-icms.
              ASSIGN tt-item-icms.uf-origem    = b01-estabelec.estado
                     tt-item-icms.uf-destino   = tt-estado.estado
                     tt-item-icms.cod-estabel  = b01-estabelec.cod-estabel
                     tt-item-icms.it-codigo    = ITEM.it-codigo     
                     tt-item-icms.ind-item-fat = item-uni-estab.ind-item-fat.
    
              RUN pi-carrega-icms (INPUT b01-estabelec.cod-estabel ,INPUT tt-item-icms.uf-destino).
           END. 

           IF LAST(tt-estado.estado) THEN DO:
              IF p-estab = '101' OR p-estab = '103' OR p-estab = '104' THEN DO:
                 RUN pi-carrega-itens (INPUT '110').
              END.
           END.
       END.                   
    END.
END PROCEDURE.


PROCEDURE pi-carrega-icms:

   DEF BUFFER b02-estabelec FOR estabelec.

   DEF INPUT PARAM p-estab        AS CHAR NO-UNDO.
   DEF INPUT PARAM p-uf-dest      AS CHAR NO-UNDO.
   
   ASSIGN de-perc-icms = 0
          c-erro       = ''.              

   FIND b02-estabelec  WHERE b02-estabelec.cod-estabel = p-estab NO-LOCK NO-ERROR.

     
   RUN defineNatOperacaoSemEmitente IN h-boes505 (INPUT  b02-estabelec.cod-estabel,
                                                  INPUT  p-uf-dest ,
                                                  INPUT  ITEM.it-codigo,
                                                  INPUT  NO,
                                                  OUTPUT c-nat-oper,
                                                  OUTPUT l-return). 
   
   IF c-nat-oper <> "" THEN DO:
      RUN calculaAliquotaICMS IN h-bodi317im1br(INPUT  YES, //CONTRIB ICMS
                                                INPUT  2, 
                                                INPUT  b02-estabelec.estado,
                                                INPUT  b02-estabelec.pais,
                                                INPUT  p-uf-dest  ,
                                                INPUT  ITEM.it-codigo,
                                                INPUT  c-nat-oper,
                                               OUTPUT de-perc-icms,
                                               OUTPUT l-return). 
   END.
   ELSE 
     ASSIGN c-erro = 'Nenhuma natureza relacionada ao Item/UF Orig/UF Dest - Verifique com o departamento tributario'.


   IF ((b02-estabelec.estado = "AM" AND p-uf-dest = "AM") OR 
       (b02-estabelec.estado = "MG" AND p-uf-dest = "MG")) AND  
      (ITEM.cd-trib-icm = 4  /*ICMS Reduzido*/ OR ITEM.cd-trib-icm = 1) THEN DO: /*Tributado*/ 
      
       /*ASSIGN c-erro = ''.*/

      IF ITEM.cd-trib-icm = 4 THEN
         ASSIGN de-perc-icms =  7.
      ELSE 
         ASSIGN de-perc-icms = 18.

      IF b02-estabelec.estado = "MG" THEN DO:
         IF ITEM.class-fiscal = "8525.80.19" OR
            ITEM.class-fiscal = "8525.80.29" OR
            ITEM.class-fiscal = "8525.80.21" OR
            ITEM.class-fiscal = "8517.12.31" OR
            ITEM.class-fiscal = "8517.12.39" THEN  /*fundo pobreza + 2%*/
            ASSIGN de-perc-icms = de-perc-icms + 2.
      END.
   END.
   

   IF ITEM.cd-trib-icm = 2 THEN //ICMS ISENTO 
      ASSIGN de-perc-icms = 0.  

   ASSIGN de-perc-icms-old = de-perc-icms. 

   IF b02-estabelec.cod-estabel = '110' AND p-uf-dest = 'PE' THEN
      RUN pi-calc-icms-PE(INPUT-OUTPUT de-perc-icms).

   //RUN pi-acompanhar IN h-acomp (INPUT 'Imprime Itens: ' + tt-item-icms.uf-origem + ' / ' + tt-item-icms.uf-destino + ' - ' + ITEM.it-codigo ).

   PUT STREAM str-excel UNFORMATTED b02-estabelec.estado                         ";"
                                    p-uf-dest                                    ";"
                                    b02-estabelec.cod-estabel                    ";"
                                    ITEM.it-codigo  FORMAT 'x(16)'               ";"
                                    ITEM.desc-item  FORMAT 'x(60)'               ";"
                                    de-perc-icms    FORMAT '>>9.99'              ";"
                                    item-uni-estab.ind-item-fat FORMAT 'Sim/Nao' ";"
                                    c-erro                      FORMAT 'x(100)'  
                                    //IF de-perc-icms-old <> de-perc-icms THEN string(de-perc-icms-old) + '*' ELSE '' 
                                    SKIP.
END PROCEDURE.



PROCEDURE pi-calc-icms-PE:

  DEF INPUT-OUTPUT PARAM p-percIcms AS DEC NO-UNDO.

  //ASSIGN d-percIcms = 18.
  
  FIND FIRST ponto-programa
       WHERE ponto-programa.nome-programa = "msg0138":U
         AND ponto-programa.ponto         = 1 
  NO-LOCK NO-ERROR.

  IF AVAIL ponto-programa THEN DO:
     FIND FIRST conteudo-programa 
          WHERE conteudo-programa.cod-programa      = ponto-programa.cod-programa
            AND ENTRY(1,conteudo-programa.conteudo) = "110" 
            AND ENTRY(2,conteudo-programa.conteudo) = "PE" 
     NO-LOCK NO-ERROR.

     IF AVAIL conteudo-programa THEN DO:
        FIND FIRST ct-clas-item WHERE ct-clas-item.cod-item = ITEM.it-codigo  
                                  AND ct-clas-item.cod-clas-fis BEGINS "PE -" 
        NO-LOCK NO-ERROR.

        IF AVAIL ct-clas-item THEN DO:
           FIND FIRST ct-clas-fis
                WHERE ct-clas-fis.cod-clas-fis = ct-clas-item.cod-clas-fis
                  AND ct-clas-fis.idi-tip-clas = 1 
           NO-LOCK NO-ERROR.
           IF AVAIL ct-clas-fis THEN 
              FIND FIRST ct-trib-clas-fisc WHERE ct-trib-clas-fisc.cod-clas-fis = ct-clas-fis.cod-clas-fis NO-LOCK NO-ERROR.

           IF AVAIL ct-trib-clas-fisc THEN 
              FIND FIRST ct-configur-trib WHERE ct-configur-trib.cod-configur-trib = ct-trib-clas-fisc.cod-configur-trib NO-LOCK NO-ERROR.

           IF AVAIL ct-configur-trib THEN 
              FIND FIRST ct-formul WHERE ct-formul.cod-formul = ct-configur-trib.cod-formul-base-calc NO-LOCK NO-ERROR.
  
           //IF OPSYS = "UNIX" THEN LOG-MANAGER:WRITE-MESSAGE("config-tributos msg0138 -> ponto2").
       
           if AVAIL ct-configur-trib AND ct-configur-trib.cod-tip-trib = 'ICMS' AND AVAIL ct-formul AND ct-formul.val-perc-reduc > 0 THEN DO:
              ASSIGN p-percIcms = (1 * ((p-percIcms / 100) *  (1 - (ct-formul.val-perc-reduc / 100)))) * 100 
                     p-percIcms = ROUND(p-percIcms,2).
           END.
        END.
     END.
  END.  

END PROCEDURE.
