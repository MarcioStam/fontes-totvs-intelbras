{esp/es0018.i}
{utp/ut-glob.i}  

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHAR FORMAT "x(35)"
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHAR FORMAT "x(40)"
    FIELD modelo-rtf       AS CHAR FORMAT "x(35)"
    FIELD l-habilitaRtf    AS LOG
    FIELD item-ini         AS CHAR
    FIELD item-fim         AS CHAR
    FIELD data-ini         AS DATE
    FIELD data-fim         AS DATE
    FIELD tipo             AS INT.

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

    ASSIGN c-arquivo-csv = "escdp212_" + REPLACE(STRING(DATE(TODAY),'99/99/9999'),'/','') + '_' + REPLACE(STRING(TIME,'HH:MM'),':','') + ".csv":U.

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

PUT STREAM str-excel UNFORMATTED "Item;Descricao;Data;Hora;A‡Æo Feita;Usuario;Tipo;COD.EAN Antes;COD.EAN Depois;Digito DUN Ant;Digito DUN Depois;COD.DUN Antes;COD.DUN Depois;Qtd.EMB Antes;Qtd.EMB Depois;Programas" SKIP.

FOR EACH hist-item NO-LOCK 
    WHERE hist-item.it-codigo >= tt-param.item-ini 
      AND hist-item.it-codigo <= tt-param.item-fim
      AND hist-item.data      >= tt-param.data-ini
      AND hist-item.data      <= tt-param.data-fim,
    FIRST ITEM NO-LOCK 
    WHERE ITEM.it-codigo = hist-item.it-codigo
    BREAK BY hist-item.data
          BY hist-item.hora:
            
    IF tt-param.tipo = 1 AND hist-item.tipo <> 'EAN13' THEN NEXT.
    IF tt-param.tipo = 2 AND hist-item.tipo <> 'DUN14' THEN NEXT.

    ASSIGN c-usuario = hist-item.usuario.

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = c-usuario NO-LOCK NO-ERROR.

    IF AVAIL usuar_mestre THEN
       ASSIGN c-usuario = c-usuario + ' - ' + usuar_mestre.nom_usuario.

    PUT STREAM str-excel UNFORMATTED hist-item.it-codigo                   ";"                     
                                     ITEM.desc-item        FORMAT 'x(60)'  ";"                    
                                     hist-item.data                        ";"                    
                                     hist-item.hora                        ";"                    
                                     hist-item.acao                        ";"                    
                                     c-usuario            FORMAT 'x(100)'  ";"                    
                                     hist-item.tipo                        ";"                     
                                     "'" hist-item.cod-ean-ant             ";"       
                                     "'" hist-item.cod-ean-atu             ";"
                                     hist-item.digito-ant                  ";"
                                     hist-item.digito-atu                  ";"
                                     "'" hist-item.cod-dun-ant             ";"
                                     "'" hist-item.cod-dun-atu             ";"
                                     hist-item.qtd-emb-ant                 ";"
                                     hist-item.qtd-emb-atu                 ";"
                                     hist-item.programa-alt SKIP.
END.

OUTPUT STREAM str-excel CLOSE.

RUN pi-finalizar IN h-acomp.                                    

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.
