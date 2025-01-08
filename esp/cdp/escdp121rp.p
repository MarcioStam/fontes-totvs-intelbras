{esp/es0018.i}
{utp/ut-glob.i}  

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD estab-ini        AS CHAR
    FIELD estab-fim        AS CHAR
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD op-ini           AS INT
    FIELD op-fim           AS INT
    FIELD tipo             AS INT
    FIELD reporte-ggf      AS INT
    FIELD dt-emis-ini      AS DATE
    FIELD dt-emis-fim      AS DATE
    FIELD dt-movto-ini     AS DATE
    FIELD dt-movto-fim     AS DATE.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-estado
    FIELD estado AS CHAR.

DEF VAR h-acomp         AS HANDLE NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-estado-op   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-reporte-ggf AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-usuario     AS CHARACTER   NO-UNDO.

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

    ASSIGN c-arquivo-csv = "escdp121_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM:SS'),':','') + ".csv":U.

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

OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.

IF tt-param.tipo = 1 THEN DO:

   PUT STREAM str-excel UNFORMATTED "Estab;Item;Descricao;Familia;Reporte GGF" SKIP.

   FOR EACH item-uni-estab NO-LOCK 
       WHERE item-uni-estab.cod-estabel >= tt-param.estab-ini
         AND item-uni-estab.cod-estabel <= tt-param.estab-fim 
         AND item-uni-estab.it-codigo >= tt-param.item-ini  
         AND item-uni-estab.it-codigo <= tt-param.item-fim  
         AND item-uni-estab.reporte-ggf = tt-param.reporte-ggf,
       FIRST ITEM NO-LOCK 
       WHERE ITEM.it-codigo = item-uni-estab.it-codigo:

       RUN pi-acompanhar IN h-acomp(INPUT 'Produto: ' + ITEM.it-codigo ).

       ASSIGN c-reporte-ggf = IF item-uni-estab.reporte-ggf = 1 THEN 'Real' ELSE 'Padrao'.

       PUT STREAM str-excel UNFORMATTED item-uni-estab.cod-estabel     ";"
                                        ITEM.it-codigo                 ";"                     
                                        ITEM.desc-item  FORMAT 'x(60)' ";"
                                        ITEM.fm-codigo                 ";"
                                        c-reporte-ggf                  SKIP.
   END.                                                      
END.
ELSE DO: 

   PUT STREAM str-excel UNFORMATTED "Estab;Item;Descricao;Familia;Ordem Prod.;Estado OP;Reporte GGF;Dt Emissao;Dt Movto" SKIP.

   FOR EACH ord-prod NO-LOCK 
       WHERE ord-prod.nr-ord-produ >= tt-param.op-ini 
         AND ord-prod.nr-ord-produ <= tt-param.op-fim 
         AND ord-prod.it-codigo >= tt-param.item-ini
         AND ord-prod.it-codigo <= tt-param.item-fim
         AND ord-prod.cod-estabel >= tt-param.estab-ini
         AND ord-prod.cod-estabel <= tt-param.estab-fim
         AND ord-prod.dt-emissao >= tt-param.dt-emis-ini   
         AND ord-prod.dt-emissao <= tt-param.dt-emis-fim   
         AND ord-prod.reporte-ggf = tt-param.reporte-ggf,
       FIRST movto-estoq NO-LOCK 
       WHERE movto-estoq.nr-ord-prod = ord-prod.nr-ord-produ
         AND movto-estoq.dt-trans >= tt-param.dt-movto-ini   
         AND movto-estoq.dt-trans <= tt-param.dt-movto-fim,
       FIRST ITEM NO-LOCK 
       WHERE ITEM.it-codigo = ord-prod.it-codigo:

       RUN pi-acompanhar IN h-acomp(INPUT 'Ordem Prod: ' + STRING(ord-prod.nr-ord-produ) ).

       ASSIGN c-reporte-ggf = IF ord-prod.reporte-ggf = 1 THEN 'Real' ELSE 'Padrao'.

       CASE ord-prod.estado:
           WHEN 1 THEN
              ASSIGN c-estado-op = 'Nao Iniciada'.
           WHEN 2 THEN
              ASSIGN c-estado-op = 'Liberada'.
           WHEN 3 THEN
              ASSIGN c-estado-op = 'Reservada'.
           WHEN 4 THEN
              ASSIGN c-estado-op = 'Separada'.
           WHEN 5 THEN
              ASSIGN c-estado-op = 'Requisitada'.
           WHEN 6 THEN
              ASSIGN c-estado-op = 'Iniciada'.
           WHEN 7 THEN
              ASSIGN c-estado-op = 'Finalizada'.
           WHEN 8 THEN
              ASSIGN c-estado-op = 'Terminada'.
       END CASE.

       PUT STREAM str-excel UNFORMATTED ord-prod.cod-estabel           ";"
                                        ITEM.it-codigo                 ";"                     
                                        ITEM.desc-item  FORMAT 'x(60)' ";"
                                        ITEM.fm-codigo                 ";"
                                        ord-prod.nr-ord-produ          ";"
                                        c-estado-op                    ";" 
                                        c-reporte-ggf                  ";" 
                                        ord-prod.dt-emissao            ";"
                                        movto-estoq.dt-trans           SKIP.           
   END.                                                      
END.


OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp.                                    

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.
