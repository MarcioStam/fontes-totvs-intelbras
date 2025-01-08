{esp/es0018.i}

DEFINE VARIABLE chExcel2  AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWBook2  AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE chWSheet2 AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE c-dir-nome-arq AS CHARACTER   NO-UNDO.

DEF VAR i-cont AS INTEGER NO-UNDO.
/**/

DEFINE VARIABLE c-arquivo-excel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-csv   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto-aux NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.

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
    FIELD estab-ini        AS CHAR
    FIELD estab-fim        AS CHAR
    FIELD emiss-ini        AS DATE
    FIELD emiss-fim        AS DATE
    .

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW
    .

DEF TEMP-TABLE tt-notas
    FIELD tipo         AS CHAR /*S - sa¡da, E - entrada */
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis
    FIELD serie        LIKE nota-fiscal.serie         
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota  
    FIELD cod-estabel  LIKE nota-fiscal.cod-estabel   
    FIELD cod-emitente LIKE nota-fiscal.cod-emitente
    FIELD nome-abrev   LIKE emitente.nome-abrev
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    FIELD vl-tot-nota  LIKE nota-fiscal.vl-tot-nota
    FIELD nome-transp  LIKE nota-fiscal.nome-transp
    FIELD modal-frete  AS CHAR FORMAT "x(50)"
    FIELD uf-destino   LIKE emitente.estado          
    FIELD uf-origem    LIKE estabelec.estado
   INDEX idx tipo
             nr-nota-fis
             serie
             dt-emis-nota.       

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{utp/ut-glob.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Buscando ...").

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "ESFTP118":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

EMPTY TEMP-TABLE tt-prog-ponto-aux.

RUN esp/es0018p.p (INPUT "ESFTP118":U,
                   INPUT 2,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto-aux).
 
DEF VAR i-linha AS INTEGER NO-UNDO.

FOR EACH estabelec NO-LOCK
    WHERE estabelec.cod-estabel >= tt-param.estab-ini
      AND estabelec.cod-estabel <= tt-param.estab-fim:

      RUN pi-cria-saidas.
      RUN pi-cria-entradas.

END.

RUN pi-define-arquivo.

OUTPUT TO VALUE(c-arq-csv) CONVERT TARGET "iso8859-1".
PUT "Ent/Sai;N£mero;S‚rie;Data;Est;Emitente;Nome;Natureza;Valor;Nome Transp;Modal Frete;UF Origem;UF Destino" SKIP.

FOR EACH estabelec NO-LOCK
    WHERE estabelec.cod-estabel >= tt-param.estab-ini
      AND estabelec.cod-estabel <= tt-param.estab-fim:
    RUN pi-imprime(INPUT "S").
    RUN pi-imprime(INPUT "E").
END.

OUTPUT CLOSE.

IF  VALID-HANDLE(h-acomp) then
    RUN pi-finalizar IN h-acomp.

PROCEDURE pi-cria-saidas:

    FOR EACH nota-fiscal NO-LOCK
       WHERE nota-fiscal.cod-estabel   = estabelec.cod-estabel
         AND nota-fiscal.dt-emis-nota >= tt-param.emiss-ini
         AND nota-fiscal.dt-emis-nota <= tt-param.emiss-fim
         AND nota-fiscal.dt-cancela   = ?
         BY nota-fiscal.dt-emis-nota:

        IF  NOT nota-fiscal.nat-operacao BEGINS "5"
        AND NOT nota-fiscal.nat-operacao BEGINS "6"
        AND NOT nota-fiscal.nat-operacao BEGINS "7" THEN NEXT.
    
        FIND FIRST int-natur-oper NO-LOCK
             WHERE int-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.
    
        IF  AVAIL int-natur-oper
        AND int-natur-oper.cons-averb-seg THEN DO:
    
            IF  nota-fiscal.cidade-cif <> ""
            OR  (CAN-FIND (FIRST tt-prog-ponto
                           WHERE INT(tt-prog-ponto.conteudo) = nota-fiscal.cod-emitente)) THEN DO:
    
                IF CAN-FIND (FIRST tt-prog-ponto-aux
                             WHERE tt-prog-ponto-aux.conteudo = nota-fiscal.nome-transp) THEN
                    NEXT.
    
                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
        
                RUN pi-acompanhar IN h-acomp (INPUT "Buscando Sa¡das do Estab " + estabelec.cod-estabel + " em " + STRING(nota-fiscal.dt-emis-nota, "99/99/9999")).

                CREATE tt-notas.
                ASSIGN tt-notas.tipo   = "S"
                       tt-notas.nr-nota-fis  = nota-fiscal.nr-nota-fis         
                       tt-notas.serie        = nota-fiscal.serie               
                       tt-notas.dt-emis-nota = nota-fiscal.dt-emis-nota
                       tt-notas.cod-estabel  = nota-fiscal.cod-estabel         
                       tt-notas.cod-emitente = nota-fiscal.cod-emitente
                       tt-notas.nome-abrev   = emitente.nome-abrev             
                       tt-notas.nat-operacao = nota-fiscal.nat-operacao        
                       tt-notas.vl-tot-nota  = nota-fiscal.vl-tot-nota
                       tt-notas.nome-transp  = nota-fiscal.nome-transp  
                       tt-notas.modal-frete  = IF nota-fiscal.cidade-cif = "" THEN "Por conta do destinat rio/remetente" ELSE "Por conta do emitente"
                       tt-notas.uf-destino   = emitente.estado                 
                       tt-notas.uf-origem    = estabelec.estado.       

            END.
        END.
    END.

END.

PROCEDURE pi-cria-entradas:

    FOR EACH docum-est NO-LOCK
       WHERE docum-est.cod-estabel  = estabelec.cod-estabel
         AND docum-est.dt-trans  >= tt-param.emiss-ini
         AND docum-est.dt-trans  <= tt-param.emiss-fim
         BY docum-est.dt-trans:

        IF  NOT docum-est.nat-operacao BEGINS "1"
        AND NOT docum-est.nat-operacao BEGINS "2"
        AND NOT docum-est.nat-operacao BEGINS "3" THEN NEXT.
    
        FIND FIRST int-natur-oper NO-LOCK
             WHERE int-natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
    
        IF  AVAIL int-natur-oper
        AND int-natur-oper.cons-averb-seg THEN DO:
        
            /*Por conta do destinatrio*/

            IF  (&IF "{&bf_dis_versao_ems}" >= "2.09" &THEN 
                     docum-est.cod-modalid-frete = 1 OR docum-est.cod-modalid-frete = 4
                 &ELSE 
                     SUBSTRING(docum-est.char-2,143,8) = '1' OR SUBSTRING(docum-est.char-2,143,8) = '4' 
                 &ENDIF)
             
            OR (CAN-FIND (FIRST tt-prog-ponto
                              WHERE INT(tt-prog-ponto.conteudo) = docum-est.cod-emitente)) THEN DO:
    
                FIND FIRST emitente NO-LOCK
                     WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
        
                RUN pi-acompanhar IN h-acomp (INPUT "Buscando Entradas do Estab " + estabelec.cod-estabel + " em " + STRING(docum-est.dt-emissao, "99/99/9999")).

                CREATE tt-notas.
                ASSIGN tt-notas.tipo         = "E"
                       tt-notas.nr-nota-fis  = docum-est.nro-docto     
                       tt-notas.serie        = docum-est.serie               
                       tt-notas.dt-emis-nota = docum-est.dt-trans
                       tt-notas.cod-estabel  = docum-est.cod-estabel         
                       tt-notas.cod-emitente = docum-est.cod-emitente
                       tt-notas.nome-abrev   = emitente.nome-abrev           
                       tt-notas.nat-operacao = docum-est.nat-operacao        
                       tt-notas.vl-tot-nota  = docum-est.valor-mercad
                       tt-notas.nome-transp  = docum-est.nome-transp         
                       tt-notas.uf-destino   = emitente.estado               
                       tt-notas.uf-origem    = estabelec.estado.  


                 &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                      FIND FIRST modalid-frete NO-LOCK
                           WHERE modalid-frete.cod-modalid-frete = docum-est.cod-modalid-frete NO-ERROR.
                  &ELSE
                      FIND FIRST modalid-frete NO-LOCK
                           WHERE modalid-frete.cod-modalid-frete = SUBSTRING(docum-est.char-2,143,8) NO-ERROR.
                  &ENDIF
                    
                  IF  AVAIL modalid-frete THEN
                      ASSIGN tt-notas.modal-frete = modalid-frete.des-modalid-frete.
                  ELSE
                      ASSIGN tt-notas.modal-frete = "".


            END.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-imprime:

    DEF INPUT PARAM p-tipo AS CHAR NO-UNDO.
    FOR EACH tt-notas
        WHERE tt-notas.tipo = p-tipo
          AND tt-notas.cod-estabel = estabelec.cod-estabel
        BY tt-notas.dt-emis-nota:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Gerando arquivos. Data: " + STRING(tt-notas.dt-emis-nota, "99/99/9999")).
    
        PUT IF p-tipo = "E" THEN "Ent;" ELSE "Sai;".

        PUT tt-notas.nr-nota-fis  ";"
            tt-notas.serie        ";"
            tt-notas.dt-emis-nota ";"
            tt-notas.cod-estabel  ";"
            tt-notas.cod-emitente ";"
            tt-notas.nome-abrev   ";"
            tt-notas.nat-operacao ";"
            tt-notas.vl-tot-nota  ";"
            tt-notas.nome-transp  ";"
            tt-notas.modal-frete  ";"
            tt-notas.uf-destino   ";"
            tt-notas.uf-origem    ";"
            SKIP.

    END.
END.

PROCEDURE pi-define-arquivo:

    ASSIGN c-arquivo-excel = "ESFTP118" + "_" + STRING(TIME) + ".csv".

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.

        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-csv = c-dir-saida + TRIM(c-arquivo-excel).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.

        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).

        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "\":U + c-seg-usuario + "\":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-csv = c-dir-saida + TRIM(c-arquivo-excel).
    END.

END PROCEDURE.

RETURN "OK".
