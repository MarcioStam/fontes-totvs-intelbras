/*-----------------------------------------------------------------------
**  Programa..: esp/ftp/esftp136rp.p
-----------------------------------------------------------------------*/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp136 2.00.00.000}

/*---------------------------  Variaveis    ---------------------------*/

{include/i-rpvar.i}
{utp/ut-glob.i}

DEFINE VARIABLE h-acomp             AS HANDLE       NO-UNDO.
DEFINE VARIABLE l-it-dep-fat        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE i                   AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-nr-notas          AS INTEGER      NO-UNDO.
DEFINE VARIABLE de-vl-tot-ger-nfs   AS DECIMAL      NO-UNDO.
DEFINE VARIABLE i-tot-volumes       AS INTEGER      NO-UNDO.
DEFINE VARIABLE i-nr-volumes-tmp    AS INTEGER      NO-UNDO.
DEFINE VARIABLE c-embarques         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lSepara-mg          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE l-volta             AS LOGICAL      NO-UNDO.


/*---------------------------  Temp-Tables  ---------------------------*/
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino           AS INTEGER
    FIELD arquivo           AS CHARACTER FORMAT "x(35)":U
    FIELD usuario           AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec         AS DATE
    FIELD hora-exec         AS INTEGER
    FIELD nr-embarque       LIKE pre-fatur.cdd-embarq
    FIELD nr-nota-fis-ini   LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fis-fim   LIKE nota-fiscal.nr-nota-fis
    FIELD nr-copias         AS INTEGER
    FIELD atu-nf            AS LOGICAL
    FIELD imp-etiq          AS LOGICAL
    FIELD imp-zebra         AS CHAR
    FIELD dt-atu-nf         AS DATE.

define temp-table tt-digita no-undo
    FIELD selecionado      AS LOGICAL LABEL 'Selecionado'
    FIELD cod-estab        LIKE nota-fiscal.cod-estabel
    FIELD serie            LIKE nota-fiscal.serie
    FIELD nr-nota-fis      LIKE nota-fiscal.nr-nota-fis
    FIELD nome-ab-cli      LIKE nota-fiscal.nome-ab-cli
    FIELD nome-transp      LIKE nota-fiscal.nome-transp
    FIELD vl-total-nota    LIKE nota-fiscal.vl-tot-nota
    FIELD nr-volume        LIKE nota-fiscal.nr-volume  
    FIELD nr-pedcli        LIKE nota-fiscal.nr-pedcli
    FIELD dt-emissao         AS DATE
    FIELD cd-atendente       AS CHAR
    FIELD cod-depos          AS CHAR
    FIELD estado             AS CHAR
    index id cod-estab serie nr-nota-fis.

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
   FIELD raw-digita         AS RAW.

DEFINE TEMP-TABLE tt-digita-sem-etiqueta LIKE tt-digita.

DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD separa-mg         AS LOGICAL
    FIELD nome-transp       LIKE pre-fatur.nome-transp
    FIELD estado            LIKE pre-fatur.estado
    FIELD cod-estabel       LIKE nota-fiscal.cod-estabel
    FIELD serie             LIKE nota-fiscal.serie
    FIELD nr-nota-fis       LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-nota      LIKE nota-fiscal.dt-emis-nota
    FIELD cod-emitente      LIKE nota-fiscal.cod-emitente
    FIELD nr-volumes        LIKE nota-fiscal.nr-volumes
    FIELD cep               LIKE nota-fiscal.cep
    FIELD vl-tot-nota       LIKE nota-fiscal.vl-tot-nota
    INDEX idx-nf nome-transp estado separa-mg cod-estabel serie nr-nota-fis.

DEFINE TEMP-TABLE tt-embarque NO-UNDO
    FIELD nome-transp       LIKE pre-fatur.nome-transp
    FIELD estado            LIKE pre-fatur.estado
    FIELD nr-embarque       LIKE embarque.cdd-embarq
    INDEX id-embarque IS PRIMARY UNIQUE nome-transp estado nr-embarque.

/*---------------------------  Parƒmetros   ---------------------------*/
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.


/*---------------------------  Frames       ---------------------------*/
FIND FIRST param-global NO-LOCK.
FIND FIRST empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio de Embarque"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "esftp136"
       c-versao       = "2.00"
       c-revisao      = "000".

{include/i-rpcab.i}


/*---------------------------  Main Block   ---------------------------*/
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

/* Coloquei estas linhas no programa - Clayton Antunes */
DEF VAR i-nome-programa AS CHAR.
DEF VAR i-ponto AS INT.
DEF VAR i-sequencia AS INT.
DEF VAR i-conteudo AS CHAR.

{esp/es0018.i}

FOR EACH tt-digita
   WHERE tt-digita.selecionado:
    IF NOT CAN-FIND(FIRST int-etiqueta-ecommerce NO-LOCK
                    WHERE int-etiqueta-ecommerce.cod-estabel = tt-digita.cod-estab
                      AND int-etiqueta-ecommerce.serie       = tt-digita.serie
                      AND int-etiqueta-ecommerce.nr-nota-fis = tt-digita.nr-nota-fis) THEN DO:
        CREATE tt-digita-sem-etiqueta.
        BUFFER-COPY tt-digita TO tt-digita-sem-etiqueta.
    END.
END.

FOR EACH tt-digita
   WHERE tt-digita.selecionado,
   FIRST int-etiqueta-ecommerce NO-LOCK
   WHERE int-etiqueta-ecommerce.cod-estabel = tt-digita.cod-estab
     AND int-etiqueta-ecommerce.serie       = tt-digita.serie
     AND int-etiqueta-ecommerce.nr-nota-fis = tt-digita.nr-nota-fis:

    FIND FIRST nota-fiscal NO-LOCK
         WHERE nota-fiscal.cod-estabel = int-etiqueta-ecommerce.cod-estabel
           AND nota-fiscal.serie       = int-etiqueta-ecommerce.serie      
           AND nota-fiscal.nr-nota-fis = int-etiqueta-ecommerce.nr-nota-fis NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        IF tt-param.imp-etiq THEN
            RUN pi-imprime-etiqueta.

        IF tt-param.Atu-NF THEN DO:
            FIND FIRST int-nota-fiscal EXCLUSIVE-LOCK 
                 WHERE int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel 
                   AND int-nota-fiscal.serie       = nota-fiscal.serie       
                   AND int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
            IF NOT AVAILABLE int-nota-fiscal THEN DO:
                CREATE int-nota-fiscal.
                ASSIGN int-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                       int-nota-fiscal.serie       = nota-fiscal.serie
                       int-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis.
            END.
            ASSIGN int-nota-fiscal.log-lib-despacho = YES
                   int-nota-fiscal.data-despacho    = tt-param.dt-atu-nf.

            IF NOT CAN-FIND(tt-nota-fiscal WHERE
               tt-nota-fiscal.cod-estab   = nota-fiscal.cod-estabel  AND
               tt-nota-fiscal.serie       = nota-fiscal.serie        AND 
               tt-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN DO:
               CREATE tt-nota-fiscal.
               ASSIGN tt-nota-fiscal.separa-mg     = lSepara-mg
                      tt-nota-fiscal.nome-transp   = nota-fiscal.nome-transp
                      tt-nota-fiscal.estado        = nota-fiscal.estado
                      tt-nota-fiscal.cod-estabel   = nota-fiscal.cod-estabel
                      tt-nota-fiscal.serie         = nota-fiscal.serie
                      tt-nota-fiscal.nr-nota-fis   = nota-fiscal.nr-nota-fis
                      tt-nota-fiscal.dt-emis-nota  = nota-fiscal.dt-emis-nota
                      tt-nota-fiscal.cod-emitente  = nota-fiscal.cod-emitente
                      tt-nota-fiscal.nr-volumes    = nota-fiscal.nr-volumes
                      tt-nota-fiscal.cep           = nota-fiscal.cep
                      tt-nota-fiscal.vl-tot-nota   = nota-fiscal.vl-tot-nota.
            END.

            FIND FIRST embarque 
                 WHERE embarque.cdd-embarq = nota-fiscal.cdd-embarq NO-LOCK NO-ERROR.
            IF NOT AVAIL embarque THEN NEXT.
        
            FIND FIRST tt-embarque NO-LOCK
                 WHERE tt-embarque.nr-embarque   = embarque.cdd-embarq    
                   AND tt-embarque.nome-transp   = nota-fiscal.nome-transp 
                   AND tt-embarque.estado        = nota-fiscal.estado NO-ERROR.
            IF NOT AVAILABLE tt-embarque THEN DO:
               CREATE tt-embarque.
               ASSIGN tt-embarque.nr-embarque  = embarque.cdd-embarq
                      tt-embarque.nome-transp  = nota-fiscal.nome-transp
                      tt-embarque.estado       = nota-fiscal.estado.
            END.

            FIND CURRENT nota-fiscal EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN nota-fiscal.dt-saida = tt-param.dt-atu-nf.
            FIND CURRENT nota-fiscal NO-LOCK NO-ERROR.
            RELEASE nota-fiscal.
        END.
    END.
END.
 
{include/i-rpout.i}

IF tt-param.Atu-NF THEN DO:
    DO i = 1 TO tt-param.nr-copias:
                  
       VIEW FRAME f-cabec.
       VIEW FRAME f-rodape.
    
       FIND FIRST tt-nota-fiscal NO-ERROR.
       IF NOT AVAIL tt-nota-fiscal THEN DO:
          PUT "NÆo encontrada nota v lida conforme a sele‡Æo" SKIP.
       END.
       ELSE DO:
          RUN pi-acompanhar in h-acomp (input "Imprimindo c¢pia " + STRING(i)).
       
          ASSIGN i-nr-notas           = 0
                 de-vl-tot-ger-nfs    = 0
                 i-tot-volumes        = 0.
        
          DISPLAY tt-nota-fiscal.nome-transp AT 20 SKIP
                  /*tt-nota-fiscal.estado       AT 34 SKIP*/
                  //tt-param.dt-embarque-ini FORMAT '99/99/9999' LABEL 'Per¡odo' AT 29 'at‚'
                  //tt-param.dt-embarque-end FORMAT '99/99/9999' NO-LABEL 
              WITH FRAME f2 STREAM-IO SIDE-LABELS.
        
          /*IF tt-param.rs-romaneio = 2
          OR tt-param.rs-romaneio = 3 THEN DO:*/
    
            PUT SKIP(1)
                  'Nota Fis         Ser   EmissÆo    Nome                   Volumes    CEP          UF         Vl Tot Nota Dt Roman   Hora  Usu rio ' SKIP
                  '---------------- ----- ---------- ---------------------- ---------- ------------ ---- ----------------- ---------- ----- -----------' SKIP.
          /*END.
          ELSE DO:
              PUT SKIP(1)
                  'Nota Fis         Ser   EmissÆo    Nome                                     Volumes    CEP          UF         Vl Tot Nota' SKIP
                  '---------------- ----- ---------- ---------------------------------------- ---------- ------------ ---- -----------------' SKIP.
          END.*/
        
          FOR EACH tt-nota-fiscal NO-LOCK,
              FIRST emitente NO-LOCK OF tt-nota-fiscal
              BREAK BY tt-nota-fiscal.nr-nota-fis WITH STREAM-IO WIDTH 132 NO-BOX NO-LABELS:
    
              FIND FIRST int-romaneio-emb NO-LOCK
                   WHERE int-romaneio-emb.cod-estabel = tt-nota-fiscal.cod-estabel
                     AND int-romaneio-emb.serie       = tt-nota-fiscal.serie      
                     AND int-romaneio-emb.nr-nota-fis = tt-nota-fiscal.nr-nota-fis NO-ERROR.
              
              PUT UNFORMATTED tt-nota-fiscal.nr-nota-fis AT 1.
              PUT UNFORMATTED tt-nota-fiscal.serie AT 18.
              PUT UNFORMATTED tt-nota-fiscal.dt-emis-nota AT 24.
    
              /*
              IF tt-param.rs-romaneio = 2
              OR tt-param.rs-romaneio = 3 THEN DO:*/

                  PUT UNFORMATTED emitente.nome-emit FORMAT "x(21)" AT 35.
                  PUT UNFORMATTED tt-nota-fiscal.nr-volumes FORMAT "x(06)" AT 58.
                  PUT UNFORMATTED tt-nota-fiscal.cep AT 69.
                  PUT UNFORMATTED tt-nota-fiscal.estado AT 82.
                  PUT UNFORMATTED tt-nota-fiscal.vl-tot-nota TO 103.
    
                  IF AVAIL int-romaneio-emb THEN DO:
                      PUT UNFORMATTED int-romaneio-emb.dt-romaneio AT 105.
                      PUT UNFORMATTED trim(STRING(int-romaneio-emb.hr-romaneio,"hh:mm")) AT 116.
                      PUT UNFORMATTED int-romaneio-emb.cod-usuario FORMAT "x(08)" AT 122.
                  END.

              /*END.
              ELSE DO:
                  PUT UNFORMATTED emitente.nome-emit FORMAT "x(40)" AT 35.
                  PUT UNFORMATTED tt-nota-fiscal.nr-volumes FORMAT "x(06)" AT 76.
                  PUT UNFORMATTED tt-nota-fiscal.cep AT 87.
                  PUT UNFORMATTED tt-nota-fiscal.estado AT 100.
                  PUT UNFORMATTED tt-nota-fiscal.vl-tot-nota TO 121.
              END.*/
    
              PUT SKIP.
    
              IF NOT CAN-FIND (FIRST int-romaneio-emb
                               WHERE int-romaneio-emb.cod-estabel = tt-nota-fiscal.cod-estabel
                                 AND int-romaneio-emb.serie       = tt-nota-fiscal.serie      
                                 AND int-romaneio-emb.nr-nota-fis = tt-nota-fiscal.nr-nota-fis) THEN DO:
    
                  CREATE int-romaneio-emb.
                  ASSIGN int-romaneio-emb.dt-romaneio = today
                         int-romaneio-emb.cod-estabel = tt-nota-fiscal.cod-estabel
                         int-romaneio-emb.serie = tt-nota-fiscal.serie
                         int-romaneio-emb.nr-nota-fis = tt-nota-fiscal.nr-nota-fis
                         int-romaneio-emb.dt-emis-nota = tt-nota-fiscal.dt-emis-nota
                         int-romaneio-emb.cod-usuario  = c-seg-usuario
                         int-romaneio-emb.hr-romaneio = time
                         int-romaneio-emb.nr-volumes = int(tt-nota-fiscal.nr-volumes)
                         int-romaneio-emb.cep = tt-nota-fiscal.cep
                         int-romaneio-emb.estado = tt-nota-fiscal.estado
                         int-romaneio-emb.vl-tot-nota = tt-nota-fiscal.vl-tot-nota
                         int-romaneio-emb.nome-transp = tt-nota-fiscal.nome-transp.
              END.
        
              ASSIGN i-nr-notas           = i-nr-notas + 1
                     de-vl-tot-ger-nfs    = de-vl-tot-ger-nfs + tt-nota-fiscal.vl-tot-nota.
        
              ASSIGN i-nr-volumes-tmp     = INTEGER(tt-nota-fiscal.nr-volumes) NO-ERROR.
              IF ERROR-STATUS:ERROR THEN
                 ASSIGN i-nr-volumes-tmp     = 0 ERROR-STATUS:ERROR   = NO.    
    
              ASSIGN i-tot-volumes        = i-tot-volumes + i-nr-volumes-tmp.    
          END.
        
           ASSIGN c-embarques = ''.
           FOR EACH tt-embarque NO-LOCK:
               ASSIGN c-embarques = c-embarques + (IF c-embarques = '' THEN '' ELSE ',') + 
                                    STRING(tt-embarque.nr-embarque) + "__________".
           END.
        
           DISPLAY
                c-embarques         LABEL 'Embarque(s)'             FORMAT 'x(97)'          AT 21 SKIP
                i-nr-notas          LABEL 'Total de notas fiscais'  FORMAT ">>>,>>9"        AT 10 SKIP
                de-vl-tot-ger-nfs   LABEL 'Valor Total da Notas'    FORMAT ">>>,>>>,>>9.99" AT 12 SKIP
                i-tot-volumes       LABEL 'Total de Volumes'        FORMAT ">>>,>>9"        AT 16 SKIP
                '   Data de Sa¡da: ____/____/________'                                         AT 16 SKIP (3)
                '_______________________________'       AT 30 SKIP
                'Recebi a(s) nota(s) acima'             AT 33 SKIP(2)
                'RG: _______________________________'   AT 26
               WITH FRAME f3 SIDE-LABELS STREAM-IO WIDTH 132.
    
           IF i MOD 2 = 0
           OR i = tt-param.nr-copias THEN
               PAGE.
           ELSE 
               PUT SKIP(2).
        
           //IF tt-param.parametros THEN
             // RUN piImprimeParam.
        END.
    END.
END.

IF CAN-FIND(FIRST tt-digita-sem-etiqueta) THEN DO:
        
    IF i MOD 2 = 0
    OR i = tt-param.nr-copias THEN
        PAGE.
    ELSE 
        PUT SKIP(2).
    
    PUT SKIP(1)
        'Notas sem etiqueta'
        SKIP(1)
        '---------------- ----- ' SKIP
        'Nota Fis         Ser   ' SKIP
        '---------------- ----- ' SKIP.
    
    FOR EACH tt-digita-sem-etiqueta NO-LOCK
        WITH STREAM-IO WIDTH 132 NO-BOX NO-LABELS:
    
        PUT UNFORMATTED tt-digita-sem-etiqueta.nr-nota-fis AT 1.
        PUT UNFORMATTED tt-digita-sem-etiqueta.serie AT 18.
    
    END.

END.

{include/i-rpclo.i}

RUN pi-finalizar in h-acomp.
RETURN "OK".

PROCEDURE pi-imprime-etiqueta:

    DEFINE VARIABLE c-arquivo    AS CHAR NO-UNDO.
    DEFINE VARIABLE c-file       AS CHAR NO-UNDO.
    DEFINE VARIABLE c-etiqueta   AS LONGCHAR NO-UNDO.

    FOR LAST imprsor_usuar FIELDS (nom_impressora nom_disposit_so) no-lock
       WHERE imprsor_usuar.nom_impressora = tt-param.imp-zebra
       //AND imprsor_usuar.cod_usuario    = c-seg-usuario
        use-index imprsrsr_id,
       FIRST impressora FIELDS () NO-LOCK OF imprsor_usuar,
       FIRST tip_imprsor FIELDS (cod_pag_carac_conver) NO-LOCK of impressora:

        OUTPUT TO VALUE(imprsor_usuar.nom_disposit_so)
            PAGE-SIZE 0
            CONVERT TARGET tip_imprsor.cod_pag_carac_conver. 
        
        PUT UNFORMATTED STRING(int-etiqueta-ecommerce.conteudo-etiqueta).

        OUTPUT CLOSE.

    END.

END PROCEDURE.

