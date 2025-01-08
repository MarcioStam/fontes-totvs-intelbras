/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: Relat¢rio de Itens Produtos com ST.
**  Objetivo.: Relat¢rio.
**  Cria‡Æo..: 01/04/2011
**  VersÆo...: Silvio Ferrari (SQL Works).
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
DEFINE BUFFER b-item-uf  FOR ITEM-uf.

{include/i-prgvrs.i ESCDP043RP 2.00.00.000}

{utp/ut-glob.i}
{include/i-rpvar.i}

{esp/es0018.i}

/* Includes Definitions ---                                             */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as INTEGER
    FIELD excel            AS LOGICAL
    FIELD item-ini         LIKE ITEM.it-codigo
    FIELD item-fim         LIKE ITEM.it-codigo
    FIELD uf-orig-ini      LIKE unid-feder.estado
    FIELD uf-orig-fim      LIKE unid-feder.estado
    FIELD uf-dest-ini      LIKE unid-feder.estado
    FIELD uf-dest-fim      LIKE unid-feder.estado
    FIELD opcao            AS INTEGER
    FIELD faturavel        AS LOG
    FIELD ativo            AS LOG.

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo          LIKE ITEM.it-codigo
    FIELD descricao          AS CHAR FORMAT "x(60)"
    FIELD estado-orig        AS CHAR FORMAT "x(02)"
    FIELD estado-dest        AS CHAR FORMAT "x(02)"
    FIELD ncm                LIKE ITEM.class-fiscal
    FIELD perc-subs-trib     LIKE item-uf.per-sub-tri
    FIELD perc-red-subs-trib LIKE item-uf.perc-red-sub
    FIELD icms-est-subs-trib LIKE item-uf.dec-1
    FIELD perc-cred-inter    LIKE int-item-uf.perc-credito-interno
    FIELD fam-material       LIKE ITEM.fm-codigo
    FIELD aliq-ipi           LIKE ITEM.aliquota-ipi
    FIELD protocolo          LIKE int-item-uf.protocolo
    FIELD ind-item-fat       LIKE ITEM.ind-item-fat
    FIELD codigo-orig        LIKE item.codigo-orig
    FIELD cod-mensagem       LIKE mensagem.cod-mensagem
    FIELD cest               AS INT FORMAT "9999999"
    FIELD perc-FCP           AS DEC FORMAT ">>9.99"
    FIELD destaque-nf        AS CHAR
    FIELD desc-mensagem      AS CHAR FORMAT "x(50)"
    FIELD cod-unid-negoc     AS CHAR
    FIELD situacao           AS CHAR FORMAT "x(30)".
  

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita  AS RAW.

/* Local Variables Definitions ---                                      */
DEFINE VARIABLE h-acomp         AS HANDLE             NO-UNDO.
DEFINE VARIABLE c-arquivo-csv   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-opcao AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-esmsspapi001     AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-cest AS INTEGER  NO-UNDO.
DEFINE STREAM s-imp.
DEFINE VARIABLE c-cest AS CHAR NO-UNDO.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio Tributa‡Æo Item/UF"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCDP043"
       c-versao       = "2.04"
       c-revisao      = "001".

IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo-csv = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.
END.
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR FIRST tt-prog-ponto:
        ASSIGN c-arquivo-csv = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.
END.



IF SUBSTRING(c-arquivo-csv, LENGTH(c-arquivo-csv), 1) <> "/":U THEN
    ASSIGN c-arquivo-csv = c-arquivo-csv + "/":U + TRIM(tt-param.usuario) + "/":U.

/* IF OPSYS = "UNIX":U THEN                               */
/*     ASSIGN c-arquivo-csv = c-arquivo-csv + "spool/":U. */

ASSIGN c-arquivo-csv = c-arquivo-csv + "ESCDP043.csv":U.


FORM SKIP(1)
     "SELE€ÇO":U AT 13 SKIP(1)
     tt-param.item-ini      FORMAT "x(16)":U      LABEL "Item":U COLON 40 
     " |< >| ":U AT 59                                                    
     tt-param.item-fim      FORMAT "x(16)":U      NO-LABEL SKIP           
     tt-param.uf-orig-ini FORMAT "x(12)":U      LABEL "Estado Origem":U COLON 40
     " |< >| ":U AT 59
     tt-param.uf-orig-fim FORMAT "x(12)":U      NO-LABEL SKIP
     tt-param.uf-dest-ini FORMAT "x(12)":U      LABEL "Estado Destino":U COLON 40
     " |< >| ":U AT 59
     tt-param.uf-dest-fim FORMAT "x(12)":U      NO-LABEL SKIP
     SKIP(1)
     c-opcao               FORMAT "x(30)"                     LABEL "Opcao Listagem" SKIP(1)

     "IMPRESSÇO":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu rio":U           COLON 40 SKIP
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

form tt-item.it-codigo                           column-label "Item"            
     tt-item.descricao                           column-label "Descri‡Æo"       
     tt-item.estado-orig                         column-label "UF Origem"
                            
     tt-item.estado-dest                         column-label "UF Destino"   
     tt-item.ncm                                 column-label "NCM"       
     tt-item.perc-subs-trib                      column-label "% Subst. Trib."             
     tt-item.perc-red-subs-trib                  column-label "% Redu‡Æo Subst. Trib."
     tt-item.icms-est-subs-trib                  column-label "ICMS Subs. Trib."
     tt-item.perc-cred-inter                     column-label "% C‚dito Interno"
     tt-item.fam-material                        column-label "Fam¡lia Material"
     tt-item.aliq-ipi                            column-label "Al¡quota IPI"
     tt-item.protocolo                           COLUMN-LABEL "Protocolo"
     tt-item.ind-item-fat                        COLUMN-LABEL "Faturavel"
     tt-item.codigo-orig                         COLUMN-LABEL "Cod.Origem"
     tt-item.cod-mensagem                        COLUMN-LABEL "Cod Mensagem"
     tt-item.cest                                COLUMN-LABEL "CEST"
     tt-item.perc-FCP                            COLUMN-LABEL "Aliq FCP ST"
     tt-item.destaque-nf                         COLUMN-LABEL "Destaque NF"
     tt-item.desc-mensagem                       COLUMN-LABEL "Desc Msg"
     tt-item.cod-unid-negoc                      COLUMN-LABEL "Unid Negoc"
     tt-item.situacao                            COLUMN-LABEL "Situacao"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 160 FRAME f-item.

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    RUN pi-executar.
    RUN pi-imprimir.


    IF tt-param.excel THEN
        RUN pi-imprimir-excel.

    RUN pi-finalizar in h-acomp.

    PAGE.
    IF tt-param.opcao = 1 THEN
        ASSIGN c-opcao = "Base OF".
    ELSE
        IF tt-param.opcao = 2 THEN
            ASSIGN c-opcao = "Base Sem Protocolo".
        ELSE
            ASSIGN c-opcao = "Ambos - Base OF e Base sem Protocolo".


    DISP tt-param.item-ini    
         tt-param.item-fim    
         tt-param.uf-orig-ini 
         tt-param.uf-orig-fim 
         tt-param.uf-dest-ini 
         tt-param.uf-dest-fim 
         tt-param.arquivo
         tt-param.usuario
         c-opcao
         WITH FRAME f-impressao.

   {include/i-rpclo.i}
END.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK".

PROCEDURE pi-executar:
    RUN esp/mssp/esmsspapi001.p PERSISTENT SET h-esmsspapi001.

    IF  tt-param.opcao = 1 or
        tt-param.opcao = 3 THEN
         FOR EACH item-uf-sem-prot 
            WHERE item-uf-sem-prot.it-codigo       >= tt-param.item-ini
              AND item-uf-sem-prot.it-codigo       <= tt-param.item-fim
              AND item-uf-sem-prot.cod-estado-orig >= tt-param.uf-orig-ini 
              AND item-uf-sem-prot.cod-estado-orig <= tt-param.uf-orig-fim
              AND item-uf-sem-prot.estado          >= tt-param.uf-dest-ini
              AND item-uf-sem-prot.estado          <= tt-param.uf-dest-fim NO-LOCK:
    
            RUN pi-acompanhar IN h-acomp (INPUT "Item: " + item-uf-sem-prot.it-codigo).
            
            FIND FIRST int-item-uf
                 WHERE int-item-uf.estado          = item-uf-sem-prot.estado
                   AND int-item-uf.cod-estado-orig = item-uf-sem-prot.cod-estado-orig
                   AND int-item-uf.it-codigo       = item-uf-sem-prot.it-codigo NO-LOCK NO-ERROR.
            
            FOR FIRST ITEM
                WHERE ITEM.it-codigo = item-uf-sem-prot.it-codigo:

                IF tt-param.faturavel = YES AND item.ind-item-fat = NO THEN NEXT.

                IF tt-param.ativo = YES AND item.cod-obsoleto <> 1 THEN NEXT.
                
                IF NOT item-uf-sem-prot.log-1 AND tt-param.opcao = 1 THEN NEXT.
                
                CREATE tt-item.
                ASSIGN tt-item.it-codigo           = item-uf-sem-prot.it-codigo
                       tt-item.descricao           = ITEM.desc-item
                       tt-item.estado-orig         = item-uf-sem-prot.cod-estado-orig
                       tt-item.estado-dest         = item-uf-sem-prot.estado
                       tt-item.ncm                 = ITEM.class-fiscal
                       tt-item.perc-subs-trib      = item-uf-sem-prot.per-sub-tri                
                       tt-item.perc-red-subs-trib  = item-uf-sem-prot.perc-red-sub            
                       tt-item.icms-est-subs-trib  = item-uf-sem-prot.dec-1                   
                       tt-item.perc-cred-inter     = item-uf-sem-prot.perc-credito-interno 
                       tt-item.fam-material        = ITEM.fm-codigo
                       tt-item.aliq-ipi            = ITEM.aliquota-ipi
                       tt-item.protocolo           = item-uf-sem-prot.protocolo 
                       tt-item.ind-item-fat        = ITEM.ind-item-fat
                       tt-item.codigo-orig         = item.codigo-orig
                       tt-item.cod-mensagem        = item-uf-sem-prot.int-1
                       tt-item.destaque-nf         = IF item-uf-sem-prot.log-1 THEN "S" ELSE "N" 
                       tt-item.cod-unid-negoc      = ITEM.cod-unid-negoc
                       tt-item.situacao            = TRIM({ininc/i17in172.i 04 ITEM.cod-obsoleto}).

                RUN piBuscaCEST IN h-esmsspapi001 (INPUT 1,
                                                   INPUT IF TODAY > 04/01/2016 THEN TODAY ELSE 04/01/2016,
                                                   INPUT "",
                                                   INPUT item-uf-sem-prot.estado,
                                                   INPUT "",
                                                   INPUT ITEM.class-fiscal,
                                                   INPUT ITEM.it-codigo,
                                                   INPUT 0,
                                                   OUTPUT c-mensagem,
                                                   OUTPUT i-cest).
                 ASSIGN tt-item.cest = i-cest.
                 RUN pi-retorna-aliquota-FCP (INPUT tt-item.it-codigo,
                                              INPUT tt-item.estado-orig,
                                              INPUT tt-item.estado-dest,
                                              OUTPUT tt-item.perc-FCP).

                 FIND FIRST mensagem NO-LOCK
                      WHERE mensagem.cod-mensagem = tt-item.cod-mensagem NO-ERROR.
                 IF AVAIL mensagem THEN
                     ASSIGN tt-item.desc-mensagem = mensagem.descricao.
                 ELSE
                     ASSIGN tt-item.desc-mensagem = "".

            END.
        END.
     ELSE 
         IF tt-param.opcao = 2 OR
            tt-param.opcao = 3 THEN
            FOR EACH item-uf-sem-prot 
               WHERE item-uf-sem-prot.it-codigo       >= tt-param.item-ini
                 AND item-uf-sem-prot.it-codigo       <= tt-param.item-fim
                 AND item-uf-sem-prot.cod-estado-orig >= tt-param.uf-orig-ini 
                 AND item-uf-sem-prot.cod-estado-orig <= tt-param.uf-orig-fim
                 AND item-uf-sem-prot.estado          >= tt-param.uf-dest-ini
                 AND item-uf-sem-prot.estado          <= tt-param.uf-dest-fim NO-LOCK:
               
                 IF item-uf-sem-prot.log-1 AND tt-param.opcao = 2 THEN NEXT.
        
                RUN pi-acompanhar IN h-acomp (INPUT "Item: " + item-uf-sem-prot.it-codigo).
                
                FOR FIRST ITEM
                    WHERE ITEM.it-codigo = item-uf-sem-prot.it-codigo NO-LOCK:

                    IF tt-param.faturavel = YES AND item.ind-item-fat = NO THEN NEXT.

                    IF tt-param.ativo = YES AND item.cod-obsoleto <> 1 THEN NEXT.
                    
                    CREATE tt-item.
                    ASSIGN tt-item.it-codigo           = item-uf-sem-prot.it-codigo
                           tt-item.descricao           = ITEM.desc-item
                           tt-item.estado-orig         = item-uf-sem-prot.cod-estado-orig
                           tt-item.estado-dest         = item-uf-sem-prot.estado
                           tt-item.ncm                 = ITEM.class-fiscal
                           tt-item.perc-subs-trib      = item-uf-sem-prot.per-sub-tri                
                           tt-item.perc-red-subs-trib  = item-uf-sem-prot.perc-red-sub            
                           tt-item.icms-est-subs-trib  = item-uf-sem-prot.dec-1                   
                           tt-item.perc-cred-inter     = item-uf-sem-prot.perc-credito-interno 
                           tt-item.fam-material        = ITEM.fm-codigo
                           tt-item.aliq-ipi            = ITEM.aliquota-ipi
                           tt-item.protocolo           = item-uf-sem-prot.protocolo
                           tt-item.ind-item-fat        = ITEM.ind-item-fat
                           tt-item.codigo-orig         = item.codigo-orig
                           tt-item.cod-mensagem        = item-uf-sem-prot.int-1
                           tt-item.destaque-nf         = IF item-uf-sem-prot.log-1 THEN "S" ELSE "N"
                           tt-item.cod-unid-negoc      = ITEM.cod-unid-negoc
                           tt-item.situacao            = TRIM({ininc/i17in172.i 04 ITEM.cod-obsoleto}).
                    RUN piBuscaCEST IN h-esmsspapi001 (INPUT 1,
                                                       INPUT TODAY,
                                                       INPUT "",
                                                       INPUT item-uf-sem-prot.estado,
                                                       INPUT "",
                                                       INPUT ITEM.class-fiscal,
                                                       INPUT ITEM.it-codigo,
                                                       INPUT 0,
                                                       OUTPUT c-mensagem,
                                                       OUTPUT i-cest).
                     ASSIGN tt-item.cest = i-cest.
                     RUN pi-retorna-aliquota-FCP (INPUT tt-item.it-codigo,
                                                  INPUT tt-item.estado-orig,
                                                  INPUT tt-item.estado-dest,
                                                  OUTPUT tt-item.perc-FCP).

                     FIND FIRST mensagem NO-LOCK
                          WHERE mensagem.cod-mensagem = tt-item.cod-mensagem NO-ERROR.
                     IF AVAIL mensagem THEN
                         ASSIGN tt-item.desc-mensagem = mensagem.descricao.
                     ELSE
                         ASSIGN tt-item.desc-mensagem = "".
                    END.
            END.
    DELETE PROCEDURE h-esmsspapi001.
    RETURN "OK":U.

END PROCEDURE.

/* Aliquota FCP */
{esp/ftp/esftp901.i}

PROCEDURE pi-imprimir-excel:
    
    OUTPUT TO VALUE(c-arquivo-csv) CONVERT TARGET SESSION:CHARSET.
        
    PUT  "Item"                    ";"
         "Descri‡Æo"               ";"
         "UF Origem"               ";"
         "UF Destino"              ";"
         "NCM"                     ";"
         "% Subst. Trib."          ";"
         "% Redu‡Æo Subst. Trib."  ";"
         "ICMS Subs. Trib."        ";"
         "% C‚dito Interno"        ";"
         "Fam¡lia Material"        ";"
         "Al¡quota IPI"            ";"
         "Protocolo"               ";"
         "Faturavel"               ";"
         "Origem"                  ";"
         "Cod Mensagem"            ";"
         "CEST"                    ";"
         "Aliq. FCP ST"            ";"
         "Destaque NF"             ";"
         "Desc Msg"                ";"
         "Unid Negoc"              ";"
         "Situacao".      
    PUT "" SKIP.

    FOR EACH tt-item:

        ASSIGN c-cest = string(tt-item.cest).
        IF LENGTH(c-cest) = 6 THEN
            ASSIGN c-cest = "0" + c-cest.

        IF LENGTH(c-cest) = 1 THEN
            ASSIGN c-cest = "000000" + c-cest.

        PUT  tt-item.it-codigo           ";"
             tt-item.descricao           ";"
             tt-item.estado-orig         ";"
             tt-item.estado-dest         ";"
             tt-item.ncm                 ";"
             tt-item.perc-subs-trib      ";"
             tt-item.perc-red-subs-trib  ";"
             tt-item.icms-est-subs-trib  ";"
             tt-item.perc-cred-inter     ";"
             tt-item.fam-material        ";"
             tt-item.aliq-ipi            ";"
             tt-item.protocolo           ";" 
             tt-item.ind-item-fat        ";"
             tt-item.codigo-orig         ";"
             tt-item.cod-mensagem        ";"
             //tt-item.cest FORMAT "99.999.99"  ";"
             c-cest  FORMAT "99.999.99"  ";"
             tt-item.perc-FCP            ";"
             tt-item.destaque-nf         ";"
             tt-item.desc-mensagem       ";"
             tt-item.cod-unid-negoc      ";"
             tt-item.situacao.            
        PUT "" SKIP.
    END.

    OUTPUT CLOSE.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-imprimir:
    
    FOR EACH tt-item:

        DISP tt-item.it-codigo         
             tt-item.descricao         
             tt-item.estado-orig       
             tt-item.estado-dest       
             tt-item.ncm               
             tt-item.perc-subs-trib    
             tt-item.perc-red-subs-trib
             tt-item.icms-est-subs-trib
             tt-item.perc-cred-inter   
             tt-item.fam-material      
             tt-item.aliq-ipi 
             tt-item.protocolo     
             tt-item.ind-item-fat 
             tt-item.codigo-orig 
             tt-item.cod-mensagem 
             tt-item.cest
             tt-item.perc-FCP
             tt-item.destaque-nf  
             tt-item.desc-mensagem
             tt-item.cod-unid-negoc 
             tt-item.situacao WITH FRAME f-item. 
            DOWN WITH FRAME f-item.
    END.

    RETURN "OK":U.

END PROCEDURE.
