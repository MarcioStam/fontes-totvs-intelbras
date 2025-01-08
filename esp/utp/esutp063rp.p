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
    field estab-ini        as char
    field estab-fim        as char
    field ccusto-ini       as char
    field ccusto-fim       as char
    field unid-neg-ini     as char
    field unid-neg-fim     as char.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9"
    field exemplo          as character format "x(30)"
    index id ordem.

DEFINE TEMP-TABLE tt-imprime LIKE int-centro-custo
       FIELD descricao        AS CHAR
       FIELD nr-unidade-negoc AS INT
       FIELD projeto          AS CHAR
       FIELD situacao         AS CHAR
       FIELD data-inicio      AS DATE
       FIELD data-fim         AS DATE
       FIELD aprovador-nf     AS CHAR
       FIELD aprovador-desp   AS CHAR.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF VAR h-acomp         AS HANDLE NO-UNDO.

DEFINE VARIABLE c-arquivo-csv AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER   NO-UNDO.

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

    ASSIGN c-arquivo-csv = "esutp003_" + STRING(TIME) + ".csv":U.

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

// Carrega 
RUN pi-carrega.
// Imprime
RUN pi-imprime.

RUN pi-finalizar IN h-acomp. 

IF NOT OPSYS = "unix" THEN DO:
    DOS SILENT START /*excel*/ VALUE(c-arq-excel).
END.                         

IF VALID-HANDLE(h-acomp) THEN
   DELETE OBJECT h-acomp.

/* FIM */

/**************************** Procedures ****************************/

PROCEDURE pi-carrega:

    FOR EACH int-centro-custo NO-LOCK
        WHERE int-centro-custo.cod-estabel >= tt-param.estab-ini
          AND int-centro-custo.cod-estabel <= tt-param.estab-fim
          AND int-centro-custo.cc-codigo   >= tt-param.ccusto-ini
          AND int-centro-custo.cc-codigo   <= tt-param.ccusto-fim 
          AND int-centro-custo.cod-unid-negoc >= tt-param.unid-neg-ini
          AND int-centro-custo.cod-unid-negoc <= tt-param.unid-neg-fim:

        CREATE tt-imprime.
        BUFFER-COPY int-centro-custo TO tt-imprime.

        FIND usuar_mestre WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-LOCK NO-ERROR.

        IF AVAIL usuar_mestre THEN
           ASSIGN tt-imprime.aprovador-nf = usuar_mestre.nom_usuario.   

        FIND usuar_mestre WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario_aprov NO-LOCK NO-ERROR.

        IF AVAIL usuar_mestre THEN
           ASSIGN tt-imprime.aprovador-desp = usuar_mestre.nom_usuario.   


        /*
        RUN esp/es0018p.p (INPUT "esutp003":U,
                           INPUT 2, //PONTO
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR EACH tt-prog-ponto
            WHERE entry(2,tt-prog-ponto.conteudo,';') = int-centro-custo.cod-unid-negoc:  
            ASSIGN tt-imprime.nr-unidade-negoc =  entry(1,tt-prog-ponto.conteudo,';').
        END.*/

        FIND FIRST unid_negoc 
             WHERE unid_negoc.cod_unid_negoc = int-centro-custo.cod-unid-negoc 
        NO-LOCK NO-ERROR. 

        IF AVAIL unid_negoc THEN
           ASSIGN tt-imprime.nr-unidade-negoc = unid_negoc.cdn_unid_negoc.

        
        FIND FIRST centro-custo 
             WHERE centro-custo.cc-codigo = int-centro-custo.cc-codigo
        NO-LOCK NO-ERROR.
             
        IF AVAIL centro-custo THEN 
        DO: 
           RUN pi-acompanhar IN h-acomp(INPUT 'Centro Custo: ' + int-centro-custo.cc-codigo + ' - ' + centro-custo.descricao).

           ASSIGN tt-imprime.descricao = centro-custo.descricao.

           IF centro-custo.nr-up-report = 0 THEN
              ASSIGN tt-imprime.situacao = "Nao".
           ELSE
              ASSIGN tt-imprime.situacao = "Sim".
    
           IF centro-custo.val-unit-up[1] = 0 THEN
              ASSIGN tt-imprime.projeto = "Nao".
           ELSE
              ASSIGN tt-imprime.projeto = "Sim".
        END.

        FIND estabelecimento WHERE estabelecimento.cod_estab = int-centro-custo.cod-estabel NO-LOCK NO-ERROR.

        IF AVAIL estabelecimento THEN
        DO:
            FIND FIRST emscad.ccusto 
                 WHERE ccusto.cod_empresa = estabelecimento.cod_empresa  
                   AND ccusto.cod_ccusto  = int-centro-custo.cc-codigo 
            NO-LOCK NO-ERROR.
    
            IF AVAIL ccusto THEN
               ASSIGN tt-imprime.data-inicio = ccusto.dat_inic_valid 
                      tt-imprime.data-fim    = ccusto.dat_fim_valid.
        END.
            
    END.

END PROCEDURE. 



PROCEDURE pi-imprime:

    OUTPUT STREAM str-excel TO value(c-arq-excel) NO-CONVERT.
    
    PUT STREAM str-excel UNFORMATTED "Centro Custo;Descricao;Estab;Nr Unidade;Unid Negoc;Aprovador NF;Nome Aprov.NF;Aprovador Despesa;Nome Aprov.Desp;GP;Situacao/Ativo;Data Inicio;Data Fim;Segmento" SKIP.

    FOR EACH tt-imprime
          by tt-imprime.cc-codigo
          by tt-imprime.cod-estabel 
          by tt-imprime.cod-unid-negoc:

        RUN pi-acompanhar IN h-acomp(INPUT 'Imprimindo:' + tt-imprime.cc-codigo + ' - ' + tt-imprime.descricao).

        PUT STREAM str-excel UNFORMATTED tt-imprime.cc-codigo                ';'
                                         tt-imprime.descricao FORMAT 'x(60)' ';'
                                         tt-imprime.cod-estabel              ';'
                                         tt-imprime.nr-unidade-negoc         ';'
                                         tt-imprime.cod-unid-negoc           ';'
                                         tt-imprime.cod_usuario              ';'
                                         tt-imprime.aprovador-nf             ';'
                                         tt-imprime.cod_usuario_aprov        ';'
                                         tt-imprime.aprovador-desp           ';'  
                                         tt-imprime.projeto                  ';'
                                         tt-imprime.situacao                 ';'.

        if tt-imprime.data-ini <> ? then PUT STREAM str-excel tt-imprime.data-ini format '99/99/9999'  ';'. ELSE PUT STREAM str-excel ';'.
        if tt-imprime.data-fim <> ? then PUT STREAM str-excel tt-imprime.data-fim format '99/99/9999'  ';'. ELSE PUT STREAM str-excel ';'. 
                                                 
        PUT STREAM str-excel UNFORMATTED tt-imprime.segmento SKIP.
    END.  

    OUTPUT STREAM str-excel CLOSE.

END PROCEDURE.


