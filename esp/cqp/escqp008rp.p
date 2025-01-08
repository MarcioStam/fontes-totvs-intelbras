
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** TOdos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou TOtal por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCQP008RP 2.00.00.000}  /*** 010000 ***/

/*******************************************************************************
**
**   Programa: ESCQP008RP.P
**
**   Autor...: Gustavo Eduardo Tamanini - SQL WORKS.
**
**   Objetivo: Relat¢rio de Inspe‡Æo Customizado
**
**   Data....: 10/06/2010
**
*********************************************************************************/
{esp/es0018.i}
{utp/ut-glob.i}

DEFINE TEMP-TABLE tt-param
    FIELD destino        AS   INTEGER
    FIELD arquivo        AS   CHARACTER
    FIELD arquivo-csv    AS   CHARACTER
    FIELD usuario        AS   CHARACTER
    FIELD data-exec      AS   DATE
    FIELD hora-exec      AS   INTEGER
    FIELD classifica     AS   INTEGER
    FIELD c-est-ini      LIKE ficha-cq.cod-estabel
    FIELD c-est-fim      LIKE ficha-cq.cod-estabel
    FIELD c-ite-ini      LIKE ficha-cq.it-codigo
    FIELD c-ite-fim      LIKE ficha-cq.it-codigo
    FIELD i-for-ini      LIKE ficha-cq.cod-emitente
    FIELD i-for-fim      LIKE ficha-cq.cod-emitente
    FIELD c-dat-ini      LIKE docum-est.dt-emiss
    FIELD c-dat-fim      LIKE docum-est.dt-emiss
    FIELD i-fic-ini      LIKE ficha-cq.nr-ficha 
    FIELD i-fic-fim      LIKE ficha-cq.nr-ficha
    FIELD c-dtl-ini      LIKE ficha-cq.dt-inspecao
    FIELD c-dtl-fim      LIKE ficha-cq.dt-inspecao   
    FIELD c-dep-ini      AS   CHARACTER 
    FIELD c-dep-fim      AS   CHARACTER
    FIELD c-resp-ini     AS   CHARACTER
    FIELD c-resp-fim     AS   CHARACTER 
    FIELD l-todos        AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-so-insp      AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-so-nao       AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-tudo         AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD c-classe       AS   CHARACTER
    FIELD c-destino      AS   CHARACTER
    FIELD l-analise      AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-pendente     AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-pendente-ret AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-cancelado    AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-terminado    AS   LOGICAL FORMAT "Sim/NÆo"
    FIELD l-nacional     AS LOGICAL FORMAT "Sim/NÆo"
    FIELD l-estrangeiro  AS LOGICAL FORMAT "Sim/NÆo".

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/************* Vari veis para ImpressÆo do parƒmetro ******************/

DEFINE VARIABLE c-selecao     AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-classif     AS CHARACTER FORMAT "x(18)" NO-UNDO.
DEFINE VARIABLE c-param       AS CHARACTER FORMAT "x(16)" NO-UNDO. 
DEFINE VARIABLE c-impressao   AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE c-classifica  AS CHARACTER FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE c-parametro   AS CHARACTER FORMAT "x(35)" NO-UNDO.
DEFINE VARIABLE c-lb-depos    AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-lb-resp     AS CHARACTER FORMAT "x(12)" NO-UNDO.
DEFINE VARIABLE c-arquivo-csv AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-dir-saida   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-arq-excel   AS CHARACTER                NO-UNDO.

/************* Literais para ImpressÆo do parƒmetro ******************/

{utp/ut-liter.i SELE€ÇO: mcq l}.       ASSIGN c-selecao   = RETURN-VALUE.
{utp/ut-liter.i CLASSIFICA€ÇO: mcq l}. ASSIGN c-classif   = RETURN-VALUE.
{utp/ut-liter.i PAR¶METROS: mcq l}.    ASSIGN c-param     = RETURN-VALUE.
{utp/ut-liter.i IMPRESSÇO: mcq l}.     ASSIGN c-impressao = RETURN-VALUE.
{utp/ut-liter.i Dep¢sito: mcq l}.      ASSIGN c-lb-depos  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Respons vel: mcq l}.   ASSIGN c-lb-resp   = TRIM(RETURN-VALUE).

/*********** Forms para impressÆo de parƒmetros do Relat¢rio **********/

  FORM
      c-selecao               NO-LABELS  SKIP (1)
      tt-param.c-est-ini      COLON  21
      tt-param.c-est-fim      COLON  50  NO-LABELS
      tt-param.c-ite-ini      COLON  21
      tt-param.c-ite-fim      COLON  50  NO-LABELS
      tt-param.i-for-ini      COLON  21
      tt-param.i-for-fim      COLON  50  NO-LABELS
      tt-param.c-dat-ini      COLON  21
      tt-param.c-dat-fim      COLON  50  NO-LABELS 
      tt-param.i-fic-ini      COLON  21  
      tt-param.i-fic-fim      COLON  50  NO-LABELS 
      tt-param.c-dtl-ini      COLON  21
      tt-param.c-dtl-fim      COLON  50  NO-LABELS       
      c-lb-depos              COLON  11  NO-LABELS
      tt-param.c-dep-ini      COLON  21  NO-LABELS
      tt-param.c-dep-fim      COLON  50  NO-LABELS
      c-lb-resp               COLON  08  NO-LABELS
      tt-param.c-resp-ini     COLON  21  NO-LABELS
      tt-param.c-resp-fim     COLON  50  NO-LABELS 
      SKIP(1)
    WITH NO-BOX SIDE-LABELS WIDTH 132 NO-ATTR-SPACE FRAME f-selecao STREAM-IO.

   FORM
       c-classif               NO-LABELS SKIP(1)
       c-classifica            COLON 21
       WITH NO-BOX SIDE-LABELS WIDTH 132 NO-ATTR-SPACE FRAME f-classif STREAM-IO.     

   FORM
       c-param                 NO-LABELS SKIP(1)
       tt-param.l-so-insp      COLON  31
       tt-param.l-so-nao       COLON  31 
       tt-param.l-tudo         COLON  31
       tt-param.l-analise      COLON  31
       tt-param.l-pendente     COLON  31
       tt-param.l-pendente-ret COLON  31
       tt-param.l-cancelado    COLON  31
       tt-param.l-terminado    COLON  31
       WITH NO-BOX SIDE-LABELS WIDTH 132 NO-ATTR-SPACE FRAME f-param STREAM-IO.

   FORM
       c-impressao              NO-LABELS SKIP(1)
       tt-param.destino         COLON  21
       tt-param.arquivo         COLON  21
       tt-param.arquivo-csv     COLON  21
       tt-param.usuario         COLON  21      
       WITH NO-BOX SIDE-LABELS WIDTH 132 NO-ATTR-SPACE FRAME f-impressao STREAM-IO.       

  {utp/ut-liter.i Destino * R}                      ASSIGN tt-param.destino:LABEL        IN FRAME f-impressao = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Arquivo * R}                      ASSIGN tt-param.arquivo:LABEL        IN FRAME f-impressao = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Arquivo_CSV * R}                  ASSIGN tt-param.arquivo-csv:LABEL    IN FRAME f-impressao = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Usu rio * R}                      ASSIGN tt-param.usuario:LABEL        IN FRAME f-impressao = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Inspecionados * R}                ASSIGN tt-param.l-so-insp:LABEL      IN FRAME f-param     = TRIM(RETURN-VALUE).
  {utp/ut-liter.i NÆo_Inspecionados * R}            ASSIGN tt-param.l-so-nao:LABEL       IN FRAME f-param     = TRIM(RETURN-VALUE).
  {utp/ut-liter.i Sem_Documento_no_Recebimento * R} ASSIGN tt-param.l-tudo:LABEL         IN FRAME f-param     = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i Em_An lise * R}                   ASSIGN tt-param.l-analise:LABEL      IN FRAME f-param     = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i Pendente * R}                     ASSIGN tt-param.l-pendente:LABEL     IN FRAME f-param     = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i Pentente_Retorno * R}             ASSIGN tt-param.l-pendente-ret:LABEL IN FRAME f-param     = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i Cancelado * R}                    ASSIGN tt-param.l-cancelado:LABEL    IN FRAME f-param     = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i Terminado * R}                    ASSIGN tt-param.l-terminado:LABEL    IN FRAME f-param     = TRIM(RETURN-VALUE). 
  {utp/ut-liter.i Classifica * R}                   ASSIGN c-classifica:LABEL            IN FRAME f-classif   = TRIM(RETURN-VALUE).

/*************************************************************************************/

DEFINE VARIABLE de-apr-cond  LIKE rej-ficha.qt-apr-cond  FORMAT "->>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-rejeitada LIKE rej-ficha.qt-rejeitada FORMAT "->>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE de-tipo      AS   INTEGER FORMAT "z " EXTENT 4 NO-UNDO.
DEFINE VARIABLE l-cab        AS   LOGICAL INIT NO              NO-UNDO.
DEFINE VARIABLE i-cont       AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE h-acomp      AS   HANDLE                       NO-UNDO.

DEFINE STREAM s-txt.

/* Variaveis p/ Cabe‡alho */

DEFINE VARIABLE c-rec-desp   AS CHARACTER NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE c-cod-estab  AS CHARACTER NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE c-resp       AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE c-trans      AS CHARACTER NO-UNDO FORMAT "x(10)".
DEFINE VARIABLE c-serie      AS CHARACTER NO-UNDO FORMAT "x(05)".
DEFINE VARIABLE c-docto      AS CHARACTER NO-UNDO FORMAT "x(09)".
DEFINE VARIABLE c-forn       AS CHARACTER NO-UNDO FORMAT "x(06)".
DEFINE VARIABLE c-nome-abrev AS CHARACTER NO-UNDO FORMAT "x(04)".
DEFINE VARIABLE c-item       AS CHARACTER NO-UNDO FORMAT "x(04)".
DEFINE VARIABLE c-qtd-orig   AS CHARACTER NO-UNDO FORMAT "x(13)".
DEFINE VARIABLE c-qtd-aprov  AS CHARACTER NO-UNDO FORMAT "x(13)".
DEFINE VARIABLE c-qtd-apr-c  AS CHARACTER NO-UNDO FORMAT "x(13)".
DEFINE VARIABLE c-qtd-rej    AS CHARACTER NO-UNDO FORMAT "x(14)".
DEFINE VARIABLE c-qtd-perda  AS CHARACTER NO-UNDO FORMAT "x(10)".
DEFINE VARIABLE c-insp       AS CHARACTER NO-UNDO FORMAT "x(09)".
DEFINE VARIABLE c-roteiro    AS CHARACTER NO-UNDO FORMAT "x(07)".
DEFINE VARIABLE c-ins        AS CHARACTER NO-UNDO FORMAT "x(03)".
DEFINE VARIABLE c-descr      AS CHARACTER NO-UNDO FORMAT "x(09)".
DEFINE VARIABLE c-cod-rej    AS CHARACTER NO-UNDO FORMAT "x(07)".
DEFINE VARIABLE c-lote       AS CHARACTER NO-UNDO FORMAT "x(04)".

DEFINE VARIABLE c-qtd-apr-2 AS CHARACTER NO-UNDO FORMAT "x(13)".
DEFINE VARIABLE c-qtd-rej-2 AS CHARACTER NO-UNDO FORMAT "x(14)".
DEFINE VARIABLE c-sit       AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE c-desc-sit  AS CHARACTER NO-UNDO FORMAT "x(12)".

DEFINE VARIABLE c-desc-item   LIKE ITEM.desc-item NO-UNDO.

DEFINE VARIABLE ddt-trans-aux-01 LIKE movto-estoq.dt-trans NO-UNDO.
DEFINE VARIABLE ddt-trans-aux-02 LIKE movto-estoq.dt-trans NO-UNDO.
DEFINE VARIABLE l-entrou         AS LOGICAL     INIT NO NO-UNDO.


DEFINE VARIABLE c-ord-serie     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ord-docto     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ord-emitente  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-ord-nat-oper  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-ord-seq       AS INTEGER     NO-UNDO.

DEF BUFFER b-ficha-cq FOR ficha-cq.

{include/i-rpvar.i}

{utp/ut-liter.i Origem_Fornec * R}   ASSIGN c-rec-desp   = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento * R} ASSIGN c-cod-estab  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Responsavel * R}     ASSIGN c-resp       = TRIM(RETURN-VALUE).
{utp/ut-liter.i Lote * R}            ASSIGN c-lote       = TRIM(RETURN-VALUE).
{utp/ut-liter.i Data_Trans * R}      ASSIGN c-trans      = TRIM(RETURN-VALUE).
{utp/ut-liter.i Serie * R}           ASSIGN c-serie      = TRIM(RETURN-VALUE).
{utp/ut-liter.i Documento * R}       ASSIGN c-docto      = TRIM(RETURN-VALUE).
{utp/ut-liter.i Fornec * R}          ASSIGN c-forn       = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Nome * R}            ASSIGN c-nome-abrev = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item * R}            ASSIGN c-item       = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Qtde_Original * R}   ASSIGN c-qtd-orig   = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Qtde_Aprovada * R}   ASSIGN c-qtd-aprov  = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Qtde_Apr_Cond * R}   ASSIGN c-qtd-apr-c  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Qtde_Rejeitada * R}  ASSIGN c-qtd-rej    = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Qtde_Perda * R}      ASSIGN c-qtd-perda  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Data_Insp * R}       ASSIGN c-insp       = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Roteiro * R}         ASSIGN c-roteiro    = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Ins * R}             ASSIGN c-ins        = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Descricao * R}       ASSIGN c-descr      = TRIM(RETURN-VALUE). 
{utp/ut-liter.i Cod_Rej * R}         ASSIGN c-cod-rej    = TRIM(RETURN-VALUE).
{utp/ut-liter.i Situacao * R}        ASSIGN c-sit        = TRIM(RETURN-VALUE).
{utp/ut-liter.i Apr_Cond_Rej * R}    ASSIGN c-qtd-apr-2  = TRIM(RETURN-VALUE).
{utp/ut-liter.i Rejeit_Cod_Rej * R}  ASSIGN c-qtd-rej-2  = TRIM(RETURN-VALUE). 

FORM HEADER
     c-cod-estab ";"
     c-rec-desp  ";"
     c-resp      ";"
     c-trans     ";"
     c-serie     ";"
     c-docto     ";"
     c-forn      ";"
     c-qtd-orig  ";"
     c-qtd-aprov ";"
     c-qtd-apr-c ";"
     c-qtd-rej   ";"
     c-qtd-perda ";"
     c-insp      ";" 
     c-roteiro   ";"
     c-ins       ";"
     c-sit       ";"
     c-item      ";"
     c-descr     ";"
     c-cod-rej   ";"
     c-qtd-apr-2 ";"
     c-qtd-rej-2 ";"     
     c-lote      ";"
    WITH STREAM-IO NO-BOX NO-LABEL SCROLLABLE PAGE-TOP FRAME f-data.

FORM HEADER
     c-cod-estab  ";"
     c-rec-desp   ";"
     c-resp       ";"
     c-forn       ";"
     c-nome-abrev ";"
     c-trans      ";"
     c-serie      ";"
     c-docto      ";"
     c-qtd-orig   ";"
     c-qtd-aprov  ";"
     c-qtd-apr-c  ";"
     c-qtd-rej    ";"
     c-qtd-perda  ";"
     c-insp       ";"
     c-roteiro    ";"
     c-ins        ";"
     c-sit        ";"
     c-item       ";"
     c-descr      ";"
     c-cod-rej    ";"
     c-qtd-apr-2  ";"
     c-qtd-rej-2  ";"
     c-lote       ";"
    WITH STREAM-IO NO-BOX NO-LABEL SCROLLABLE PAGE-TOP FRAME f-fornec.

FORM HEADER
     c-cod-estab ";"
     c-rec-desp  ";"
     c-resp      ";"
     c-trans     ";"
     c-serie     ";"
     c-docto     ";"
     c-forn      ";"
     c-qtd-orig  ";"
     c-qtd-aprov ";"
     c-qtd-apr-c ";"
     c-qtd-rej   ";"
     c-qtd-perda ";"    
     c-item      ";"
     c-descr     ";"    
     c-insp      ";"
     c-roteiro   ";"
     c-ins       ";"
     c-sit       ";"
     c-cod-rej   ";"
     c-qtd-apr-2 ";"
     c-qtd-rej-2 ";"
     c-lote      ";"
    WITH STREAM-IO NO-BOX NO-LABEL SCROLLABLE PAGE-TOP FRAME f-item.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Relat¢rio_de_Inspe‡Æo").

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST param-cq     NO-LOCK NO-ERROR.

ASSIGN c-empresa  = (IF AVAIL param-global THEN grupo ELSE "")
       c-programa = "ESCQP008"
       c-versao   = "1.00"
       c-revisao  = "000".
                                                           
{utp/ut-liter.i Relat¢rio_de_Inspe‡Æo * r} ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
{utp/ut-liter.i QUALIDADE * r}             ASSIGN c-sistema      = TRIM(RETURN-VALUE).

ASSIGN c-arquivo-csv = "escpq008_" + STRING(TIME) + ".csv":U.

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
    ASSIGN tt-param.c-dtl-ini = TODAY - 1
           tt-param.c-dtl-fim = TODAY - 1.

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

    ASSIGN c-dir-saida =  c-dir-saida + "\":U + c-seg-usuario + "\":U.
    OS-CREATE-DIR VALUE(c-dir-saida).
    ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arquivo-csv).
END.

ASSIGN tt-param.arquivo-csv = c-arq-excel
       tt-param.arquivo     = c-dir-saida + "escqp008.tmp".

/* {include/i-rpcab.i}  */
/* {include/i-rpout.i}  */
/*                      */
/* VIEW FRAME f-cabec.  */
/* VIEW FRAME f-rodape. */

IF  tt-param.classifica = 1 THEN DO:
    {utp/ut-liter.i Por_data_de_Transa‡Æo * R} ASSIGN c-classifica = TRIM(RETURN-VALUE).
END.

IF  tt-param.classifica = 2 THEN DO:
    {utp/ut-liter.i Por_Fornecedor * R} ASSIGN c-classifica = TRIM(RETURN-VALUE).
END.

IF  tt-param.classifica = 3 THEN DO:
    {utp/ut-liter.i Por_Item * R} ASSIGN c-classifica = TRIM(RETURN-VALUE).
END.

OUTPUT STREAM s-txt TO VALUE(c-arq-excel) CONVERT TARGET SESSION:CHARSET.

IF  tt-param.classifica = 1 THEN DO:
    bl-ficha-1:
    FOR EACH  ficha-cq USE-INDEX ch-ficha NO-LOCK
        WHERE ficha-cq.nr-ficha     >= tt-param.i-fic-ini     
          AND ficha-cq.nr-ficha     <= tt-param.i-fic-fim    
          AND ficha-cq.cod-estabel  >= tt-param.c-est-ini  
          AND ficha-cq.cod-estabel  <= tt-param.c-est-fim  
          AND ficha-cq.it-codigo    >= tt-param.c-ite-ini    
          AND ficha-cq.it-codigo    <= tt-param.c-ite-fim    
          AND ficha-cq.cod-emitente >= tt-param.i-for-ini 
          AND ficha-cq.cod-emitente <= tt-param.i-for-fim        
          AND ficha-cq.cod-resp     >= tt-param.c-resp-ini 
          AND ficha-cq.cod-resp     <= tt-param.c-resp-fim
          AND ficha-cq.cod-depos    >= tt-param.c-dep-ini
          AND ficha-cq.cod-depos    <= tt-param.c-dep-fim:

        IF  (tt-param.l-so-insp                         AND 
             ficha-cq.inspecionado                      AND 
             ficha-cq.dt-inspecao >= tt-param.c-dtl-ini AND 
             ficha-cq.dt-inspecao <= tt-param.c-dtl-fim)
          OR
            (tt-param.l-so-nao          AND
            NOT ficha-cq.inspecionado)
          OR
            (tt-param.l-so-nao      AND
             ficha-cq.inspecionado  AND 
             ficha-cq.dt-inspecao > tt-param.c-dtl-fim)
          THEN DO:
                 
            RUN pi-acompanhar IN h-acomp (INPUT STRING(ficha-cq.nr-ficha)).

            FIND FIRST docum-est USE-INDEX documento
                 WHERE docum-est.serie-docto  = ficha-cq.serie-docto
                   AND docum-est.nro-docto    = ficha-cq.nro-docto
                   AND docum-est.cod-emitente = ficha-cq.cod-emitente
                   AND docum-est.nat-operacao = ficha-cq.nat-operacao NO-LOCK NO-ERROR.

            IF  NOT(ficha-cq.situacao = 1 AND tt-param.l-pendente)
            AND NOT(ficha-cq.situacao = 2 AND tt-param.l-analise)
            AND NOT(ficha-cq.situacao = 3 AND tt-param.l-pendente-ret)
            AND NOT(ficha-cq.situacao = 4 AND tt-param.l-terminado)
            AND NOT(ficha-cq.situacao = 5 AND tt-param.l-cancelado) 
                THEN NEXT bl-ficha-1.

            IF NOT AVAIL docum-est AND NOT tt-param.l-tudo THEN NEXT bl-ficha-1.

            ASSIGN ddt-trans-aux-01 = 01/01/1900
                   ddt-trans-aux-02 = 01/01/1900
                   l-entrou = NO.

            /*---[ Existe OP relacionada - IR88323 ]------------------------------------*/
            IF  CAN-FIND(FIRST ord-prod 
                         WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ) THEN DO:
                
                FOR FIRST ord-prod NO-LOCK 
                    WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ,
                    EACH  movto-estoq USE-INDEX operacao
                    WHERE movto-estoq.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK:
                    
                    IF   movto-estoq.esp-docto <> 1
                    OR  (movto-estoq.esp-docto  = 1 /* Acabados */
                    AND (movto-estoq.dt-trans   < tt-param.c-dat-ini
                    OR   movto-estoq.dt-trans   > tt-param.c-dat-fim)) THEN 
                        NEXT.

                    IF NUM-ENTRIES(movto-estoq.descricao-db, ";") = 5 THEN DO:

                        ASSIGN c-ord-serie    = ENTRY(1, movto-estoq.descricao-db, ";")
                               c-ord-docto    = ENTRY(2, movto-estoq.descricao-db, ";")
                               i-ord-emitente = int(ENTRY(3, movto-estoq.descricao-db, ";"))
                               c-ord-nat-oper = ENTRY(4, movto-estoq.descricao-db, ";")
                               i-ord-seq      = int(ENTRY(5, movto-estoq.descricao-db, ";")).
    
                        IF c-ord-serie    = ficha-cq.serie AND
                           c-ord-docto    = ficha-cq.nro-docto AND
                           i-ord-emitente = ficha-cq.cod-emitente AND
                           c-ord-nat-oper = ficha-cq.nat-operacao AND
                           i-ord-seq      = ficha-cq.nr-ord-cq THEN DO:
    
                            IF movto-estoq.dt-trans > ddt-trans-aux-01 THEN
                                ASSIGN ddt-trans-aux-01 = movto-estoq.dt-trans
                                       l-entrou = TRUE.
    
                        END.

                    END.
                    ELSE DO:

                        IF movto-estoq.dt-trans > ddt-trans-aux-02 THEN
                                ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.

                    END.

                END. /* FOR FIRST ord-prod */

                IF NOT l-entrou THEN
                    ASSIGN ddt-trans-aux-01 = ddt-trans-aux-02.

                ASSIGN ddt-trans-aux-02 = ficha-cq.dt-inspecao.

            END. /* IF  CAN-FIND(FIRST ord-prod */
            ELSE DO:
                IF (ficha-cq.dt-ficha < tt-param.c-dat-ini
                OR  ficha-cq.dt-ficha > tt-param.c-dat-fim) THEN NEXT bl-ficha-1.
                
                ASSIGN ddt-trans-aux-01 = ficha-cq.dt-ficha
                       ddt-trans-aux-02 = ficha-cq.dt-inspecao.
                
                IF ddt-trans-aux-02 <> ? THEN DO:
                   FIND FIRST b-ficha-cq NO-LOCK
                        WHERE b-ficha-cq.nro-docto    = ficha-cq.nro-docto  
                          AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                          AND b-ficha-cq.cod-estabel  = ficha-cq.cod-estabel
                          AND b-ficha-cq.it-codigo    = ficha-cq.it-codigo  
                          AND b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                          AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao 
                          AND b-ficha-cq.qt-rejeitada > 0
                          AND rowid(b-ficha-cq)      <> rowid(ficha-cq) NO-ERROR.
                   IF AVAIL b-ficha-cq THEN DO:
                      FIND LAST movto-estoq NO-LOCK
                          WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                            AND movto-estoq.serie-docto   = ficha-cq.serie-docto
                            AND movto-estoq.cod-estabel   = ficha-cq.cod-estabel
                            AND movto-estoq.it-codigo     = ficha-cq.it-codigo
                            AND movto-estoq.esp-docto     = 33
                            AND movto-estoq.tipo-trans    = 1
                            AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente 
                            AND movto-estoq.cod-depos     = ficha-cq.cod-depos NO-ERROR.
                      IF AVAIL movto-estoq THEN
                         ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.
                   END.
                   ELSE DO:
                      IF ficha-cq.qt-rejeitada > 0 THEN DO:
                         /* Busca sempre o 1o movimento */
                         FOR EACH movto-estoq NO-LOCK
                             WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                               AND movto-estoq.serie-docto   = ficha-cq.serie-docto
                               AND movto-estoq.cod-estabel   = ficha-cq.cod-estabel
                               AND movto-estoq.it-codigo     = ficha-cq.it-codigo
                               AND movto-estoq.esp-docto     = 33
                               AND movto-estoq.tipo-trans    = 2
                               AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente 
                               AND movto-estoq.cod-depos     = ficha-cq.cod-depos
                               BY movto-estoq.dt-trans DESC:
                             ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.
                         END.
                      END.
                   END.
                END.
            END. /* ELSE DO: */

            
            IF ddt-trans-aux-01 = 01/01/1900 THEN NEXT.

            IF ddt-trans-aux-02 < tt-param.c-dtl-ini OR
               ddt-trans-aux-02 > tt-param.c-dtl-fim THEN NEXT.

            /*--------------------------------------------------------------------------*/

            FIND FIRST ITEM
                 WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN
                ASSIGN c-desc-item = ITEM.desc-item.
            ELSE
                ASSIGN c-desc-item = "".

            IF NOT l-cab THEN DO:
                IF NOT AVAIL ITEM OR (AVAIL ITEM AND tipo-con-est <> 3) THEN
                    ASSIGN c-lote = "".

                DISP STREAM s-txt
                    WITH FRAME f-data.

                ASSIGN l-cab = YES.
            END.

            DO  i-cont = 1 TO 4:
                ASSIGN de-tipo[i-cont] = 0.
            END.

            ASSIGN i-cont = 4.

            IF  ficha-cq.qt-apr-cond <> 0 THEN
                ASSIGN de-tipo[i-cont] = 4
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-consumida <> 0 THEN
                ASSIGN de-tipo[i-cont] = 3
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-rejeitada <> 0 THEN
                ASSIGN de-tipo[i-cont] = 2
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-aprovada <> 0 THEN
                ASSIGN de-tipo[i-cont] = 1.
    
            ASSIGN c-desc-sit = SUBSTR({ininc/i03in124.i 4 ficha-cq.situacao},1,12).

            FOR FIRST usuar_mestre
                WHERE usuar_mestre.cod_usuario = ficha-cq.cod-resp NO-LOCK:                
            END.

            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ficha-cq.cod-emitente:
            END.
    
            IF NOT AVAIL emitente OR 
               (AVAIL emitente AND
                 ((emitente.natureza  = 3 AND NOT tt-param.l-estrangeiro) OR
                  (emitente.natureza <> 3 AND NOT tt-param.l-nacional)))
                THEN
                NEXT.

/*             IF AVAIL docum-est OR AVAIL movto-estoq THEN DO: */
                PUT STREAM s-txt
                    ficha-cq.cod-estabel ";"
                    IF emitente.natureza = 3 THEN "Estrangeiro" ELSE "Nacional" FORMAT "X(20)" ";"
                    TRIM(ficha-cq.cod-resp) " - " IF AVAIL usuar_mestre THEN TRIM(usuar_mestre.nom_usuario) ELSE "" FORMAT "x(32)" ";"
                  /*docum-est.dt-trans          ";"*/
                    ddt-trans-aux-01            ";"
                    ficha-cq.serie-docto        ";"
                    ficha-cq.nro-docto          ";"
                    ficha-cq.cod-emitente       ";"                                  
                    ficha-cq.qt-original        ";"
                    ficha-cq.qt-aprovada        ";"
                    ficha-cq.qt-apr-cond        ";"
                    ficha-cq.qt-rejeitada       ";"
                    ficha-cq.qt-consumida       ";"
                    ddt-trans-aux-02 /*ficha-cq.dt-inspecao*/        ";"
                    ficha-cq.nr-ficha           ";"
                    ficha-cq.inspecionado       ";"
                    c-desc-sit                  ";"
                    ficha-cq.it-codigo          ";"
                    c-desc-item FORMAT "x(20)"  ";".

                ASSIGN de-apr-cond  = 0
                       de-rejeitada = 0.

                FOR LAST  rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                    BREAK BY rej-ficha.codigo-rejei:

                    ASSIGN de-apr-cond  = de-apr-cond  + rej-ficha.qt-apr-cond
                           de-rejeitada = de-rejeitada + rej-ficha.qt-rejeitada.

                    PUT STREAM s-txt 
                        rej-ficha.codigo-rejei ";"
                        de-apr-cond            ";"
                        de-rejeitada           ";".
                END.

/*                 /* Se existir tipo-con-est = 3 LOTE */ */
/*                 IF AVAIL ITEM AND                      */
/*                          ITEM.tipo-con-est = 3 THEN    */
/*                     PUT STREAM s-txt                   */
/*                         ficha-cq.lote ";".             */

                PUT STREAM s-txt SKIP.
            /*END.
            ELSE DO:
                PUT STREAM s-txt 
                    ficha-cq.cod-estabel ";"
                    IF emitente.natureza = 3 THEN "Estrangeiro" ELSE "Nacional" FORMAT "X(20)" ";"
                    TRIM(ficha-cq.cod-resp) " - " IF AVAIL usuar_mestre THEN TRIM(usuar_mestre.nom_usuario) ELSE "" FORMAT "x(32)" ";"
                    "          "               ";"
                    ficha-cq.serie-docto       ";"
                    ficha-cq.nro-docto         ";"
                    "      "                   ";"
                    ficha-cq.qt-original       ";"
                    ficha-cq.qt-aprovada       ";"
                    ficha-cq.qt-apr-cond       ";"
                    ficha-cq.qt-rejeitada      ";"
                    ficha-cq.qt-consumida      ";"
                    ficha-cq.dt-inspecao       ";"
                    ficha-cq.nr-ficha          ";"
                    ficha-cq.inspecionado      ";"
                    c-desc-sit                 ";"
                    ficha-cq.it-codigo         ";"
                    c-desc-item FORMAT "x(20)" ";".

                ASSIGN de-apr-cond  = 0
                       de-rejeitada = 0.

                FOR LAST  rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                    BREAK BY rej-ficha.codigo-rejei:

                    ASSIGN de-apr-cond  = de-apr-cond  + rej-ficha.qt-apr-cond
                           de-rejeitada = de-rejeitada + rej-ficha.qt-rejeitada.

                    PUT STREAM s-txt 
                        rej-ficha.codigo-rejei ";"
                        de-apr-cond            ";"
                        de-rejeitada           ";".                    
                END.

                /* Se existir tipo-con-est = 3 LOTE */
/*                 IF AVAIL ITEM AND                   */
/*                          ITEM.tipo-con-est = 3 THEN */
/*                     PUT STREAM s-txt                */
/*                         ficha-cq.lote ";".          */

                PUT STREAM s-txt SKIP.
            END.
            */
        END.
    END.
END.
IF  tt-param.classifica = 2 THEN DO:
    bl-ficha-2:
    FOR EACH  ficha-cq NO-LOCK
        WHERE ficha-cq.nr-ficha     >= tt-param.i-fic-ini
          AND ficha-cq.nr-ficha     <= tt-param.i-fic-fim
          AND ficha-cq.cod-estabel  >= tt-param.c-est-ini
          AND ficha-cq.cod-estabel  <= tt-param.c-est-fim
          AND ficha-cq.it-codigo    >= tt-param.c-ite-ini
          AND ficha-cq.it-codigo    <= tt-param.c-ite-fim
          AND ficha-cq.cod-emitente >= tt-param.i-for-ini
          AND ficha-cq.cod-emitente <= tt-param.i-for-fim       
          AND ficha-cq.cod-resp     >= tt-param.c-resp-ini 
          AND ficha-cq.cod-resp     <= tt-param.c-resp-fim
          AND ficha-cq.cod-depos    >= tt-param.c-dep-ini
          AND ficha-cq.cod-depos    <= tt-param.c-dep-fim        
        BREAK BY ficha-cq.cod-emitente
              BY ficha-cq.nr-ficha:

         IF (tt-param.l-so-insp                         AND 
             ficha-cq.inspecionado                      AND 
             ficha-cq.dt-inspecao >= tt-param.c-dtl-ini AND 
             ficha-cq.dt-inspecao <= tt-param.c-dtl-fim)
           OR 
             (tt-param.l-so-nao AND
              NOT ficha-cq.inspecionado) 
           OR
            (tt-param.l-so-nao      AND
             ficha-cq.inspecionado  AND 
             ficha-cq.dt-inspecao > tt-param.c-dtl-fim)
             THEN DO:

            RUN pi-acompanhar IN h-acomp (INPUT STRING(ficha-cq.nr-ficha)).

            FIND FIRST docum-est USE-INDEX documento
                 WHERE docum-est.serie-docto  = ficha-cq.serie-docto
                   AND docum-est.nro-docto    = ficha-cq.nro-docto
                   AND docum-est.cod-emitente = ficha-cq.cod-emitente
                   AND docum-est.nat-operacao = ficha-cq.nat-operacao NO-LOCK NO-ERROR.

            IF  NOT(ficha-cq.situacao = 1 AND tt-param.l-pendente)
            AND NOT(ficha-cq.situacao = 2 AND tt-param.l-analise)
            AND NOT(ficha-cq.situacao = 3 AND tt-param.l-pendente-ret)
            AND NOT(ficha-cq.situacao = 4 AND tt-param.l-terminado)
            AND NOT(ficha-cq.situacao = 5 AND tt-param.l-cancelado)
                THEN NEXT bl-ficha-2.

            IF  NOT AVAIL docum-est AND NOT tt-param.l-tudo THEN NEXT bl-ficha-2.

            ASSIGN ddt-trans-aux-01 = 01/01/1900
                   ddt-trans-aux-02 = 01/01/1900
                   l-entrou = FALSE.

            /*---[ Existe OP relacionada - IR88323 ]------------------------------------*/
            IF  CAN-FIND(FIRST ord-prod
                         WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ) THEN DO:

                FOR FIRST ord-prod NO-LOCK 
                    WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ,
                    EACH  movto-estoq USE-INDEX operacao
                    WHERE movto-estoq.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK:

                    IF   movto-estoq.esp-docto <> 1
                    OR  (movto-estoq.esp-docto  = 1 /* Acabados */
                    AND (movto-estoq.dt-trans   < tt-param.c-dat-ini
                    OR   movto-estoq.dt-trans   > tt-param.c-dat-fim)) THEN 
                        NEXT.

                    IF NUM-ENTRIES(movto-estoq.descricao-db, ";") = 5 THEN DO:

                        ASSIGN c-ord-serie    = ENTRY(1, movto-estoq.descricao-db, ";")
                               c-ord-docto    = ENTRY(2, movto-estoq.descricao-db, ";")
                               i-ord-emitente = int(ENTRY(3, movto-estoq.descricao-db, ";"))
                               c-ord-nat-oper = ENTRY(4, movto-estoq.descricao-db, ";")
                               i-ord-seq      = int(ENTRY(5, movto-estoq.descricao-db, ";")).
                        
                        IF c-ord-serie    = ficha-cq.serie AND
                           c-ord-docto    = ficha-cq.nro-docto AND
                           i-ord-emitente = ficha-cq.cod-emitente AND
                           c-ord-nat-oper = ficha-cq.nat-operacao AND
                           i-ord-seq      = ficha-cq.nr-ord-cq THEN DO:
    
                            IF movto-estoq.dt-trans > ddt-trans-aux-01 THEN
                                ASSIGN ddt-trans-aux-01 = movto-estoq.dt-trans
                                       l-entrou = TRUE.
    
                        END.

                    END.
                    ELSE DO:

                        IF movto-estoq.dt-trans > ddt-trans-aux-02 THEN
                            ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.

                    END.

                END. /* FOR FIRST ord-prod */

                IF NOT l-entrou THEN
                    ASSIGN ddt-trans-aux-01 = ddt-trans-aux-02.

                ASSIGN ddt-trans-aux-02 = ficha-cq.dt-inspecao.

            END. /* IF  CAN-FIND(FIRST ord-prod */
            ELSE DO:
                IF (ficha-cq.dt-ficha < tt-param.c-dat-ini
                OR  ficha-cq.dt-ficha > tt-param.c-dat-fim) THEN NEXT bl-ficha-2.

                ASSIGN ddt-trans-aux-01 = ficha-cq.dt-ficha
                       ddt-trans-aux-02 = ficha-cq.dt-inspecao.

                IF ddt-trans-aux-02 <> ? THEN DO:
                   FIND FIRST b-ficha-cq NO-LOCK
                        WHERE b-ficha-cq.nro-docto    = ficha-cq.nro-docto  
                          AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                          AND b-ficha-cq.cod-estabel  = ficha-cq.cod-estabel
                          AND b-ficha-cq.it-codigo    = ficha-cq.it-codigo  
                          AND b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                          AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao 
                          AND b-ficha-cq.qt-rejeitada > 0
                          AND rowid(b-ficha-cq)      <> rowid(ficha-cq) NO-ERROR.
                   IF AVAIL b-ficha-cq THEN DO:
                      FIND LAST movto-estoq NO-LOCK
                          WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                            AND movto-estoq.serie-docto   = ficha-cq.serie-docto
                            AND movto-estoq.cod-estabel   = ficha-cq.cod-estabel
                            AND movto-estoq.it-codigo     = ficha-cq.it-codigo
                            AND movto-estoq.esp-docto     = 33
                            AND movto-estoq.tipo-trans    = 1
                            AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente 
                            AND movto-estoq.cod-depos     = ficha-cq.cod-depos NO-ERROR.
                      IF AVAIL movto-estoq THEN
                         ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.
                   END.
                   ELSE DO:
                      IF ficha-cq.qt-rejeitada > 0 THEN DO:
                         /* Busca sempre o 1o movimento */
                         FOR EACH movto-estoq NO-LOCK
                             WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                               AND movto-estoq.serie-docto   = ficha-cq.serie-docto
                               AND movto-estoq.cod-estabel   = ficha-cq.cod-estabel
                               AND movto-estoq.it-codigo     = ficha-cq.it-codigo
                               AND movto-estoq.esp-docto     = 33
                               AND movto-estoq.tipo-trans    = 2
                               AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente 
                               AND movto-estoq.cod-depos     = ficha-cq.cod-depos
                               BY movto-estoq.dt-trans DESC:
                             ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.
                         END.
                      END.
                   END.
                END.
            END. /* ELSE DO: */

            IF ddt-trans-aux-01 = 01/01/1900 THEN NEXT.

            IF ddt-trans-aux-02 < tt-param.c-dtl-ini OR
               ddt-trans-aux-02 > tt-param.c-dtl-fim THEN NEXT.
            /*--------------------------------------------------------------------------*/

            FIND FIRST ITEM
                 WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN
                ASSIGN c-desc-item = ITEM.desc-item.
            ELSE
                ASSIGN c-desc-item = "".

            DO  i-cont = 1 TO 4:
                ASSIGN de-tipo[i-cont] = 0.
            END.
            ASSIGN i-cont = 4.

            IF  ficha-cq.qt-apr-cond <> 0 THEN
                ASSIGN de-tipo[i-cont] = 4
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-consumida <> 0 THEN
                ASSIGN de-tipo[i-cont] = 3
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-rejeitada <> 0 THEN
                ASSIGN de-tipo[i-cont] = 2
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-aprovada <> 0 THEN
                ASSIGN de-tipo[i-cont] = 1.

            ASSIGN c-desc-sit = SUBSTR({ininc/i03in124.i 4 ficha-cq.situacao},1,12).

            IF NOT l-cab THEN DO:
                IF NOT AVAIL ITEM OR (AVAIL ITEM AND tipo-con-est <> 3) THEN
                    ASSIGN c-lote = "".

                DISP STREAM s-txt
                     WITH FRAME f-fornec.

                ASSIGN l-cab = YES.
            END.

            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ficha-cq.cod-emitente:
            END.
    
            IF NOT AVAIL emitente OR 
               (AVAIL emitente AND
                 ((emitente.natureza  = 3 AND NOT tt-param.l-estrangeiro) OR
                  (emitente.natureza <> 3 AND NOT tt-param.l-nacional)))
                THEN
                NEXT.

            FOR FIRST usuar_mestre
                WHERE usuar_mestre.cod_usuario = ficha-cq.cod-resp NO-LOCK:                
            END.

/*             IF AVAIL docum-est OR AVAIL movto-estoq THEN DO: */
                PUT STREAM s-txt
                    ficha-cq.cod-estabel ";"
                    IF emitente.natureza = 3 THEN "Estrangeiro" ELSE "Nacional" FORMAT "X(20)" ";"
                    TRIM(ficha-cq.cod-resp) " - " IF AVAIL usuar_mestre THEN TRIM(usuar_mestre.nom_usuario) ELSE "" FORMAT "x(32)" ";"
                    ficha-cq.cod-emitente      ";"
                    IF AVAIL emitente THEN emitente.nome-abrev ELSE "" ";"
                    /*docum-est.dt-trans         ";"*/
                    ddt-trans-aux-01           ";"
                    ficha-cq.serie-docto       ";"
                    ficha-cq.nro-docto         ";"
                    ficha-cq.qt-original       ";"
                    ficha-cq.qt-aprovada       ";"
                    ficha-cq.qt-apr-cond       ";"
                    ficha-cq.qt-rejeitada      ";"
                    ficha-cq.qt-consumida      ";"
                    ddt-trans-aux-02 /*ficha-cq.dt-inspecao*/       ";"
                    ficha-cq.nr-ficha          ";"
                    ficha-cq.inspecionado      ";"
                    c-desc-sit                 ";"
                    ficha-cq.it-codigo         ";"
                    c-desc-item FORMAT "x(20)" ";".

                ASSIGN de-apr-cond  = 0
                       de-rejeitada = 0.

                FOR LAST  rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                    BREAK BY rej-ficha.codigo-rejei:

                    ASSIGN de-apr-cond  = de-apr-cond  + rej-ficha.qt-apr-cond
                           de-rejeitada = de-rejeitada + rej-ficha.qt-rejeitada.

                    PUT STREAM s-txt 
                        rej-ficha.codigo-rejei ";"
                        de-apr-cond            ";"
                        de-rejeitada           ";".
                END.

                /* Se existir tipo-con-est = 3 LOTE */
/*                 IF AVAIL ITEM AND                   */
/*                          ITEM.tipo-con-est = 3 THEN */
/*                     PUT STREAM s-txt                */
/*                         ficha-cq.lote ";".          */

                PUT STREAM s-txt SKIP.
            /*END.
            ELSE DO:
                PUT STREAM s-txt 
                    ficha-cq.cod-estabel ";"
                    IF emitente.natureza = 3 THEN "Estrangeiro" ELSE "Nacional" FORMAT "X(20)" ";"
                    TRIM(ficha-cq.cod-resp) " - " IF AVAIL usuar_mestre THEN TRIM(usuar_mestre.nom_usuario) ELSE "" FORMAT "x(32)" ";"
                    "          "               ";"
                    "          "               ";"
                    "          "               ";"
                    ficha-cq.serie-docto       ";"
                    ficha-cq.nro-docto         ";"                    
                    ficha-cq.qt-original       ";"
                    ficha-cq.qt-aprovada       ";"
                    ficha-cq.qt-apr-cond       ";"
                    ficha-cq.qt-rejeitada      ";"
                    ficha-cq.qt-consumida      ";"
                    ficha-cq.dt-inspecao       ";"
                    ficha-cq.nr-ficha          ";"
                    ficha-cq.inspecionado      ";"
                    c-desc-sit                 ";"
                    ficha-cq.it-codigo         ";"
                    c-desc-item FORMAT "x(20)" ";".
                
                ASSIGN de-apr-cond  = 0
                       de-rejeitada = 0.

                FOR LAST  rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                    BREAK BY rej-ficha.codigo-rejei:

                    ASSIGN de-apr-cond  = de-apr-cond  + rej-ficha.qt-apr-cond
                           de-rejeitada = de-rejeitada + rej-ficha.qt-rejeitada.

                    PUT STREAM s-txt 
                        rej-ficha.codigo-rejei ";"
                        de-apr-cond            ";"
                        de-rejeitada           ";".
                END.

                /* Se existir tipo-con-est = 3 LOTE */
/*                 IF AVAIL ITEM AND                   */
/*                          ITEM.tipo-con-est = 3 THEN */
/*                     PUT STREAM s-txt                */
/*                         ficha-cq.lote ";".          */

                PUT STREAM s-txt SKIP.
            END.
            */
        END.
    END.
END.
IF  tt-param.classifica = 3 THEN DO:
    bl-ficha-3:
    FOR EACH  ficha-cq NO-LOCK
        WHERE ficha-cq.nr-ficha     >= tt-param.i-fic-ini
          AND ficha-cq.nr-ficha     <= tt-param.i-fic-fim
          AND ficha-cq.cod-estabel  >= tt-param.c-est-ini
          AND ficha-cq.cod-estabel  <= tt-param.c-est-fim
          AND ficha-cq.it-codigo    >= tt-param.c-ite-ini
          AND ficha-cq.it-codigo    <= tt-param.c-ite-fim
          AND ficha-cq.cod-emitente >= tt-param.i-for-ini
          AND ficha-cq.cod-emitente <= tt-param.i-for-fim          
          AND ficha-cq.cod-resp     >= tt-param.c-resp-ini 
          AND ficha-cq.cod-resp     <= tt-param.c-resp-fim
          AND ficha-cq.cod-depos    >= tt-param.c-dep-ini
          AND ficha-cq.cod-depos    <= tt-param.c-dep-fim          
        BREAK BY ficha-cq.it-codigo
              BY ficha-cq.nr-ficha:

        IF  (tt-param.l-so-insp                         AND 
             ficha-cq.inspecionado                      AND 
             ficha-cq.dt-inspecao >= tt-param.c-dtl-ini AND 
             ficha-cq.dt-inspecao <= tt-param.c-dtl-fim)
          OR 
            (tt-param.l-so-nao AND
             NOT ficha-cq.inspecionado) 
          OR
            (tt-param.l-so-nao      AND
             ficha-cq.inspecionado  AND 
             ficha-cq.dt-inspecao > tt-param.c-dtl-fim) 
            THEN DO:

            RUN pi-acompanhar IN h-acomp (INPUT STRING(ficha-cq.nr-ficha)).
            ASSIGN de-tipo = 0.

            FIND FIRST docum-est USE-INDEX documento
                 WHERE docum-est.serie-docto  = ficha-cq.serie-docto
                   AND docum-est.nro-docto    = ficha-cq.nro-docto
                   AND docum-est.cod-emitente = ficha-cq.cod-emitente
                   AND docum-est.nat-operacao = ficha-cq.nat-operacao NO-LOCK NO-ERROR.

            IF  NOT(ficha-cq.situacao = 1 AND tt-param.l-pendente)
            AND NOT(ficha-cq.situacao = 2 AND tt-param.l-analise)
            AND NOT(ficha-cq.situacao = 3 AND tt-param.l-pendente-ret)
            AND NOT(ficha-cq.situacao = 4 AND tt-param.l-terminado)
            AND NOT(ficha-cq.situacao = 5 AND tt-param.l-cancelado)
                THEN NEXT bl-ficha-3.
    
            IF  NOT AVAIL docum-est AND NOT tt-param.l-tudo THEN NEXT bl-ficha-3.

            ASSIGN ddt-trans-aux-01 = 01/01/1900
                   ddt-trans-aux-02 = 01/01/1900
                   l-entrou = FALSE.

            /*---[ Existe OP relacionada - IR88323 ]------------------------------------*/
            IF  CAN-FIND(FIRST ord-prod
                         WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ) THEN DO:

                FOR FIRST ord-prod NO-LOCK 
                    WHERE ord-prod.nr-ord-produ = ficha-cq.nr-ord-produ,
                    EACH  movto-estoq USE-INDEX operacao
                    WHERE movto-estoq.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK:
                    
                    IF   movto-estoq.esp-docto <> 1
                    OR  (movto-estoq.esp-docto  = 1 /* Acabados */
                    AND (movto-estoq.dt-trans   < tt-param.c-dat-ini
                    OR   movto-estoq.dt-trans   > tt-param.c-dat-fim)) THEN 
                        NEXT.

                    IF NUM-ENTRIES(movto-estoq.descricao-db, ";") = 5 THEN DO:

                        ASSIGN c-ord-serie    = ENTRY(1, movto-estoq.descricao-db, ";")
                               c-ord-docto    = ENTRY(2, movto-estoq.descricao-db, ";")
                               i-ord-emitente = int(ENTRY(3, movto-estoq.descricao-db, ";"))
                               c-ord-nat-oper = ENTRY(4, movto-estoq.descricao-db, ";")
                               i-ord-seq      = int(ENTRY(5, movto-estoq.descricao-db, ";")).
    
                        IF c-ord-serie    = ficha-cq.serie AND
                           c-ord-docto    = ficha-cq.nro-docto AND
                           i-ord-emitente = ficha-cq.cod-emitente AND
                           c-ord-nat-oper = ficha-cq.nat-operacao AND 
                           i-ord-seq      = ficha-cq.nr-ord-cq THEN DO:
    
                            IF movto-estoq.dt-trans > ddt-trans-aux-01 THEN
                                ASSIGN ddt-trans-aux-01 = movto-estoq.dt-trans
                                       l-entrou = TRUE.
    
                        END.

                    END.
                    ELSE DO:

                        IF movto-estoq.dt-trans > ddt-trans-aux-02 THEN
                            ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.

                    END.

                END. /* FOR FIRST ord-prod */

                IF NOT l-entrou THEN
                    ASSIGN ddt-trans-aux-01 = ddt-trans-aux-02.

                ASSIGN ddt-trans-aux-02 = ficha-cq.dt-inspecao.

            END. /* IF  CAN-FIND(FIRST ord-prod */
            ELSE DO:
                IF (ficha-cq.dt-ficha < tt-param.c-dat-ini
                OR  ficha-cq.dt-ficha > tt-param.c-dat-fim) THEN NEXT bl-ficha-3.

                ASSIGN ddt-trans-aux-01 = ficha-cq.dt-ficha
                       ddt-trans-aux-02 = ficha-cq.dt-inspecao.

                IF ddt-trans-aux-02 <> ? THEN DO:
                   FIND FIRST b-ficha-cq NO-LOCK
                        WHERE b-ficha-cq.nro-docto    = ficha-cq.nro-docto  
                          AND b-ficha-cq.serie-docto  = ficha-cq.serie-docto
                          AND b-ficha-cq.cod-estabel  = ficha-cq.cod-estabel
                          AND b-ficha-cq.it-codigo    = ficha-cq.it-codigo  
                          AND b-ficha-cq.cod-emitente = ficha-cq.cod-emitente
                          AND b-ficha-cq.nat-operacao = ficha-cq.nat-operacao 
                          AND b-ficha-cq.qt-rejeitada > 0
                          AND rowid(b-ficha-cq)      <> rowid(ficha-cq) NO-ERROR.
                   IF AVAIL b-ficha-cq THEN DO:
                      FIND LAST movto-estoq NO-LOCK
                          WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                            AND movto-estoq.serie-docto   = ficha-cq.serie-docto
                            AND movto-estoq.cod-estabel   = ficha-cq.cod-estabel
                            AND movto-estoq.it-codigo     = ficha-cq.it-codigo
                            AND movto-estoq.esp-docto     = 33
                            AND movto-estoq.tipo-trans    = 1
                            AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente 
                            AND movto-estoq.cod-depos     = ficha-cq.cod-depos NO-ERROR.
                      IF AVAIL movto-estoq THEN
                         ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.
                   END.
                   ELSE DO:
                      IF ficha-cq.qt-rejeitada > 0 THEN DO:
                         /* Busca sempre o 1o movimento */
                         FOR EACH movto-estoq NO-LOCK
                             WHERE movto-estoq.nro-docto     = ficha-cq.nro-docto
                               AND movto-estoq.serie-docto   = ficha-cq.serie-docto
                               AND movto-estoq.cod-estabel   = ficha-cq.cod-estabel
                               AND movto-estoq.it-codigo     = ficha-cq.it-codigo
                               AND movto-estoq.esp-docto     = 33
                               AND movto-estoq.tipo-trans    = 2
                               AND movto-estoq.cod-emitente  = ficha-cq.cod-emitente 
                               AND movto-estoq.cod-depos     = ficha-cq.cod-depos
                               BY movto-estoq.dt-trans DESC:
                             ASSIGN ddt-trans-aux-02 = movto-estoq.dt-trans.
                         END.
                      END.
                   END.
                END.
            END. /* ELSE DO: */

            IF ddt-trans-aux-01 = 01/01/1900 THEN NEXT.

            IF ddt-trans-aux-02 < tt-param.c-dtl-ini OR
               ddt-trans-aux-02 > tt-param.c-dtl-fim THEN NEXT.

            /*--------------------------------------------------------------------------*/

            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = ficha-cq.it-codigo NO-ERROR.
            IF AVAIL ITEM THEN
                ASSIGN c-desc-item = ITEM.desc-item.
            ELSE
                ASSIGN c-desc-item = "".

            IF NOT l-cab THEN DO:
                IF NOT AVAIL ITEM OR (AVAIL ITEM AND tipo-con-est <> 3) THEN
                    ASSIGN c-lote = "".

                DISP STREAM s-txt
                    WITH FRAME f-item.

                ASSIGN l-cab = YES.
            END.

            DO  i-cont = 1 TO 4:
                ASSIGN de-tipo[i-cont] = 0.
            END.
            ASSIGN i-cont = 4.

            IF  ficha-cq.qt-apr-cond <> 0 THEN
                ASSIGN de-tipo[i-cont] = 4
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-consumida <> 0 THEN
                ASSIGN de-tipo[i-cont] = 3
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-rejeitada <> 0 THEN
                ASSIGN de-tipo[i-cont] = 2
                       i-cont = i-cont - 1.
            IF  ficha-cq.qt-aprovada <> 0 THEN
                ASSIGN de-tipo[i-cont] = 1.
    
            ASSIGN c-desc-sit = SUBSTR({ininc/i03in124.i 4 ficha-cq.situacao},1,12).

            FOR FIRST usuar_mestre
                WHERE usuar_mestre.cod_usuario = ficha-cq.cod-resp NO-LOCK:
            END.

            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = ficha-cq.cod-emitente:
            END.
    
            IF NOT AVAIL emitente OR 
               (AVAIL emitente AND
                 ((emitente.natureza  = 3 AND NOT tt-param.l-estrangeiro) OR
                  (emitente.natureza <> 3 AND NOT tt-param.l-nacional)))
                THEN
                NEXT.

/*             IF AVAIL docum-est OR AVAIL movto-estoq THEN DO: */
                PUT STREAM s-txt
                    ficha-cq.cod-estabel ";"
                    IF emitente.natureza = 3 THEN "Estrangeiro" ELSE "Nacional" FORMAT "X(20)" ";"
                    TRIM(ficha-cq.cod-resp) " - " IF AVAIL usuar_mestre THEN TRIM(usuar_mestre.nom_usuario) ELSE "" FORMAT "x(32)" ";"
                    /*docum-est.dt-trans    ";"*/
                    ddt-trans-aux-01      ";"
                    ficha-cq.serie-docto  ";"
                    ficha-cq.nro-docto    ";"
                    ficha-cq.cod-emitente ";"
                    ficha-cq.qt-original  ";"
                    ficha-cq.qt-aprovada  ";"
                    ficha-cq.qt-apr-cond  ";"
                    ficha-cq.qt-rejeitada ";"
                    ficha-cq.qt-consumida ";"
                    ficha-cq.it-codigo    ";"
                    c-desc-item           ";"  
                    ddt-trans-aux-02 /*ficha-cq.dt-inspecao*/  ";"
                    ficha-cq.nr-ficha     ";"
                    ficha-cq.inspecionado ";"
                    c-desc-sit            ";".

                ASSIGN de-apr-cond  = 0
                       de-rejeitada = 0.
        
                FOR LAST  rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                    BREAK BY rej-ficha.codigo-rejei:

                    ASSIGN de-apr-cond  = de-apr-cond  + rej-ficha.qt-apr-cond
                           de-rejeitada = de-rejeitada + rej-ficha.qt-rejeitada.

                    PUT STREAM s-txt 
                        rej-ficha.codigo-rejei ";"
                        de-apr-cond            ";"
                        de-rejeitada           ";".
                END.

                /* Se existir tipo-con-est = 3 LOTE */
/*                 IF AVAIL ITEM AND                   */
/*                          ITEM.tipo-con-est = 3 THEN */
/*                     PUT STREAM s-txt                */
/*                         ficha-cq.lote ";".          */

                PUT STREAM s-txt SKIP.
            /*END.
            ELSE DO:
                PUT STREAM s-txt
                    ficha-cq.cod-estabel ";"
                    IF emitente.natureza = 3 THEN "Estrangeiro" ELSE "Nacional" FORMAT "X(20)" ";"
                    TRIM(ficha-cq.cod-resp) " - " IF AVAIL usuar_mestre THEN TRIM(usuar_mestre.nom_usuario) ELSE "" FORMAT "x(32)" ";"
                    "          "          ";"
                    ficha-cq.serie-docto  ";"
                    ficha-cq.nro-docto    ";"
                    "      "              ";"
                    ficha-cq.qt-original  ";"
                    ficha-cq.qt-aprovada  ";"
                    ficha-cq.qt-apr-cond  ";"
                    ficha-cq.qt-rejeitada ";"
                    ficha-cq.qt-consumida ";"
                    ficha-cq.it-codigo    ";"
                    c-desc-item           ";" 
                    ficha-cq.dt-inspecao  ";"
                    ficha-cq.nr-ficha     ";"
                    ficha-cq.inspecionado ";"
                    c-desc-sit            ";".

                ASSIGN de-apr-cond  = 0
                       de-rejeitada = 0.

                FOR LAST  rej-ficha NO-LOCK
                    WHERE rej-ficha.nr-ficha = ficha-cq.nr-ficha
                    BREAK BY rej-ficha.codigo-rejei:

                    ASSIGN de-apr-cond  = de-apr-cond  + rej-ficha.qt-apr-cond
                           de-rejeitada = de-rejeitada + rej-ficha.qt-rejeitada.

                    PUT STREAM s-txt
                        rej-ficha.codigo-rejei ";"
                        de-apr-cond            ";"
                        de-rejeitada           ";".
                END.

                /* Se existir tipo-con-est = 3 LOTE */
/*                 IF AVAIL ITEM AND                   */
/*                          ITEM.tipo-con-est = 3 THEN */
/*                     PUT STREAM s-txt                */
/*                         ficha-cq.lote ";".          */

                PUT STREAM s-txt SKIP.
            END.
            */
        END.
    END.
END.

OUTPUT STREAM s-txt CLOSE.

RUN pi-finalizar IN h-acomp.

/* PAGE.                                       */
/*                                             */
/* DISPLAY c-selecao SKIP                      */
/*         tt-param.c-est-ini                  */
/*         tt-param.c-est-fim                  */
/*         tt-param.c-ite-ini                  */
/*         tt-param.c-ite-fim                  */
/*         tt-param.i-for-ini                  */
/*         tt-param.i-for-fim                  */
/*         tt-param.c-dat-ini                  */
/*         tt-param.c-dat-fim                  */
/*         tt-param.i-fic-ini                  */
/*         tt-param.i-fic-fim                  */
/*         tt-param.c-dtl-ini                  */
/*         tt-param.c-dtl-fim                  */
/*         c-lb-depos                          */
/*         tt-param.c-dep-ini                  */
/*         tt-param.c-dep-fim                  */
/*         c-lb-resp                           */
/*         tt-param.c-resp-ini                 */
/*         tt-param.c-resp-fim                 */
/*     SKIP(2) WITH FRAME f-selecao.           */
/*                                             */
/* DISPLAY c-classif NO-LABELS                 */
/*         c-classifica                        */
/*         SKIP(2) WITH FRAME f-classif.       */
/*                                             */
/* DISPLAY c-param NO-LABELS SKIP              */
/*         tt-param.l-so-insp                  */
/*         tt-param.l-so-nao                   */
/*         tt-param.l-tudo                     */
/*         tt-param.l-analise                  */
/*         tt-param.l-pendente                 */
/*         tt-param.l-pendente-ret             */
/*         tt-param.l-cancelado                */
/*         tt-param.l-terminado                */
/*         SKIP(2) WITH FRAME f-param.         */
/*                                             */
/* DISPLAY c-impressao NO-LABELS SKIP          */
/*         tt-param.destino                    */
/*         tt-param.arquivo     FORMAT "x(70)" */
/*         tt-param.arquivo-csv FORMAT "x(70)" */
/*         tt-param.usuario                    */
/*         SKIP(2) WITH FRAME f-impressao.     */
/*                                             */
/* {include/i-rpclo.i}                         */

IF NOT OPSYS = "unix" THEN DO:
    OS-COMMAND NO-WAIT notepad VALUE(tt-param.arquivo).
    DOS SILENT START excel VALUE(tt-param.arquivo-csv).
END.


RETURN "OK".
/* fim programa */

