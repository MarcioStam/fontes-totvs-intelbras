&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESIMP015RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESIMP015RP

DEF VAR c-destino      AS CHARACTER FORMAT "x(15)":U.
DEF VAR de-desp-total  AS DEC NO-UNDO.
DEFINE VARIABLE d-preco-total like ordem-compra.preco-orig NO-UNDO.
{include/i-rpvar.i}
{esp/imp/esimp015tt.i}
{esp/es0018.i}

DEFINE TEMP-TABLE tt-excessao-nat NO-UNDO
    FIELD nat-operacao AS CHARACTER
    INDEX chave nat-operacao.

DEF TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.
 
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

DEF VAR h-acomp         AS HANDLE NO-UNDO.    

DEFINE BUFFER bf-docum-est      FOR docum-est.
DEFINE BUFFER bf-item-doc-est   FOR item-doc-est.


create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/* OVERLAY (tt-param.arquivo,LENGTH(tt-param.arquivo) - 2, 3) = "csv". */
{utp/ut-glob.i}

FIND FIRST empresa NO-LOCK 
     where empresa.ep-codigo = v_cdn_empres_usuar NO-ERROR.
find first param-global no-lock no-error.

{include/tt-edit.i}
{include/pi-edit.i}

DEFINE VARIABLE i-num-casa-dec       AS INT                           NO-UNDO.
DEFINE VARIABLE de-fator-conver      AS DEC                           NO-UNDO.
DEFINE VARIABLE c-unid-med-for       LIKE item-fornec-estab.unid-med-for.
DEFINE VARIABLE i-cont               AS INT                           NO-UNDO.
DEFINE VARIABLE de-preco-fob         AS DEC                           NO-UNDO.
DEFINE VARIABLE de-preco-fob-us      AS DEC                           NO-UNDO.
DEFINE VARIABLE de-fi                AS DEC FORMAT ">>>9.99"          NO-UNDO.
DEFINE VARIABLE de-fi-total          AS DEC FORMAT ">>>9.99999"       NO-UNDO.
DEFINE VARIABLE de-qtde              AS DEC                           NO-UNDO.
DEFINE VARIABLE c-nome-abrev         LIKE emitente.nome-abrev         NO-UNDO.
DEFINE VARIABLE i-cod-emitente       LIKE emitente.cod-emitente       NO-UNDO.
DEFINE VARIABLE c-nacional           AS CHAR                          NO-UNDO.
DEFINE VARIABLE c-descricao          AS CHAR FORMAT "X(60)"           NO-UNDO.
DEFINE VARIABLE de-val-unit          AS DEC FORMAT ">>9.9999"         NO-UNDO.
DEFINE VARIABLE de-val-nc LIKE item-doc-est.preco-unit[1]             NO-UNDO.
DEFINE VARIABLE de-fob-r$-tot-acum   AS DEC FORMAT ">9.99"            NO-UNDO.
DEFINE VARIABLE c-estab-estrutura    AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE v-seq-nivel          AS INTEGER                       NO-UNDO.
DEFINE VARIABLE v-nivel-matriz       AS INTEGER                       NO-UNDO.
DEFINE VARIABLE l-matriz             AS LOG                           NO-UNDO.

DEF TEMP-TABLE tt-est NO-UNDO
    FIELD it-codigo    LIKE estrutura.it-codigo
    FIELD nivel        AS INT
    FIELD cod-estabel  LIKE estabelec.cod-estabel
    FIELD descricao    AS CHAR FORMAT "x(60)" LABEL "Descriá∆o"
    FIELD qtde         AS DEC FORMAT ">>>9.99999"
    INDEX tt-est IS PRIMARY UNIQUE it-codigo.
    
DEF TEMP-TABLE tt-imp NO-UNDO
    FIELD nac-imp         AS CHAR
    FIELD existe-uma-imp  AS LOG
    FIELD it-codigo       AS CHAR FORMAT "X(07)"        LABEL "Item"
    FIELD cod-estabel     LIKE estabelec.cod-estabel
    FIELD descricao       AS CHAR FORMAT "X(60)"        LABEL "Descriá∆o"
    FIELD class-fiscal    LIKE ITEM.class-fiscal
    FIELD qtde            AS DEC  FORMAT ">>>>>9.99999" LABEL "Qtde"
    FIELD de-preco-fob    AS DEC  FORMAT ">>>9.99999"   LABEL "Custo FOB"
    FIELD de-preco-fob-us AS DEC  FORMAT ">>>9.99999"   LABEL "Custo FOB US"
    FIELD de-fi           AS DEC  FORMAT ">>>9.99"      LABEL "FI"
    FIELD de-fi-total     AS DEC  FORMAT ">>>9.99999"   LABEL "Èltimo FI"
    FIELD de-fob-us$-tot  AS DEC  FORMAT ">>>>9.99999"  LABEL "FOB US$"
    FIELD de-fob-r$-tot   AS DEC  FORMAT ">>>>9.99999"  LABEL "FOB US$"
    FIELD de-cif-us$-tot  AS DEC  FORMAT ">>>>9.99999"  LABEL "CIF US$"
    FIELD de-cif-r$-tot   AS DEC  FORMAT ">>>>9.99999"  LABEL "CIF R$"
    FIELD de-cif-r$       AS DEC  FORMAT ">>>>9.99999"  LABEL "CIF R$"
    FIELD val-unit-mat    AS DEC  FORMAT ">>>>9.9999"   LABEL "MÇdio"
    FIELD preco-ul-ent    AS DEC  FORMAT ">>9.9999"     LABEL "Ult Entrada"
    FIELD un              AS CHAR FORMAT "X(02)"        LABEL "Un"
    FIELD cod-emitente    LIKE emitente.cod-emitente
    FIELD nome-abrev      AS CHAR FORMAT "X(12)"        LABEL "Fornecedor"
    FIELD unid-med-for    LIKE item-fornec-estab.unid-med-for
    FIELD periodo-fixo    LIKE ITEM.periodo-fixo
    FIELD res-for-comp    LIKE ITEM.res-for-comp
    FIELD horiz-fixo      LIKE ITEM.horiz-fixo
    FIELD horiz-lib       LIKE ITEM.horiz-fixo
    FIELD tp-despesa      LIKE ITEM.tp-desp-padrao
    FIELD deposito-alm    LIKE ITEM.deposito-pad
    FIELD numero          AS INTEGER
    FIELD preco-total     AS DEC
    FIELD desp-total      AS DEC
    INDEX tt-imp IS PRIMARY nac-imp it-codigo
    INDEX chave2 it-codigo.
              
DEF BUFFER b-estrutura FOR estrutura.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11.79
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:
/*     OUTPUT TO VALUE (tt-param.arquivo) CONVERT TARGET "iso8859-1". */
    {include/i-rpout.i}

    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo":U). 

    FOR EACH tt-digita:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + tt-digita.it-codigo).
  
        FOR EACH tt-est:
            DELETE tt-est.
        END.
  
        FOR EACH tt-imp:
            DELETE tt-imp.
        END.
  
        ASSIGN v-nivel-matriz    = 0
               c-estab-estrutura =  tt-param.cod-estabel.

        FOR EACH estrutura NO-LOCK 
           WHERE estrutura.it-codigo     = tt-digita.it-codigo 
             AND estrutura.data-inicio  <= TODAY 
             AND estrutura.data-termino >= TODAY,
            FIRST ITEM NO-LOCK 
            WHERE ITEM.it-codigo = estrutura.es-codigo:
  
            ASSIGN v-seq-nivel = 1
                   l-matriz    = NO.

            FIND item-uni-estab NO-LOCK
                WHERE item-uni-estab.cod-estabel = "101"
                  AND item-uni-estab.it-codigo   = estrutura.es-codigo  NO-ERROR.

            IF  AVAIL item-uni-estab 
            AND item-uni-estab.tp-desp-padrao = 2 /*importado*/ THEN
                ASSIGN l-matriz = YES.

            /*Itens abaixo da estrutura dos 250 s∆o fabricados na matriz*/
            IF  estrutura.es-codigo BEGINS "250"  THEN DO:
                ASSIGN c-estab-estrutura = "101"
                       v-nivel-matriz    = v-seq-nivel.
            END.

            /*Se voltou a um n°vel acima dos 250, volta o estab da tt-param*/
            ELSE IF v-nivel-matriz >= v-seq-nivel THEN DO:
                 ASSIGN c-estab-estrutura = tt-param.cod-estabel
                        v-nivel-matriz    = 0.
            END.

            IF  v-nivel-matriz = 0 THEN DO:
                IF  l-matriz THEN 
                    ASSIGN c-estab-estrutura = "101".
                ELSE 
                    ASSIGN c-estab-estrutura = tt-param.cod-estabel.
            END.

            IF  NOT estrutura.fantasma 
            AND ITEM.compr-fabric = 1 THEN DO:
                
               FIND FIRST tt-est 
                   WHERE tt-est.it-codigo = estrutura.es-codigo NO-ERROR.
  
               IF NOT AVAIL tt-est THEN DO:
                  CREATE tt-est.
                  ASSIGN tt-est.it-codigo   = estrutura.es-codigo
                         tt-est.nivel       = v-seq-nivel
                         tt-est.cod-estabel = c-estab-estrutura
                         tt-est.descricao   = item.desc-item.
               END.
               ASSIGN tt-est.qtde = tt-est.qtde + estrutura.quant-usada.
            END.

            RUN pi-ler(estrutura.es-codigo, estrutura.quant-usada).
        END.
  
        FIND FIRST tt-est NO-ERROR.
        IF NOT AVAIL tt-est THEN NEXT.
  
        RUN pi-normal.
    END.
    
  
    RUN pi-finalizar IN h-acomp.
    
/*     OUTPUT CLOSE. */
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-ler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ler Procedure 
PROCEDURE pi-ler PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER c-it-codigo LIKE estrutura.es-codigo   NO-UNDO.
   DEFINE INPUT PARAMETER de-qtde     LIKE estrutura.quant-usada NO-UNDO.
        
   RUN pi-acompanhar IN h-acomp (INPUT "Lendo estrutura : " + c-it-codigo).

   FOR EACH b-estrutura NO-LOCK 
      WHERE b-estrutura.it-codigo     = c-it-codigo 
        AND b-estrutura.data-inicio  <= TODAY 
        AND b-estrutura.data-termino >= TODAY,
      FIRST ITEM NO-LOCK 
      WHERE ITEM.it-codigo = b-estrutura.es-codigo:

       ASSIGN v-seq-nivel = v-seq-nivel + 1.


      ASSIGN l-matriz    = NO.
        
      FIND item-uni-estab NO-LOCK
          WHERE item-uni-estab.cod-estabel = "101"
            AND item-uni-estab.it-codigo   = b-estrutura.es-codigo  NO-ERROR.
        
      IF  AVAIL item-uni-estab 
      AND item-uni-estab.tp-desp-padrao = 2 /*importado*/ THEN
          ASSIGN l-matriz = YES.
      
/*        IF b-estrutura.es-codigo = "3991466" THEN               */
/*            MESSAGE "antes" SKIP                                */
/*                    "c-estab-estrutura " c-estab-estrutura SKIP */
/*                    "v-nivel-matriz " v-nivel-matriz SKIP       */
/*                    "v-seq-nivel " v-seq-nivel                  */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.              */

       /*Itens abaixo da estrutura dos 250 s∆o fabricados na matriz*/
       IF b-estrutura.es-codigo BEGINS "250" THEN DO:
           ASSIGN c-estab-estrutura = "101"
                  v-nivel-matriz    = v-seq-nivel.
       END.
       /*Se voltou a um n°vel acima dos 250, volta o estab da tt-param*/
       ELSE IF v-nivel-matriz >= v-seq-nivel THEN DO:
            ASSIGN c-estab-estrutura = tt-param.cod-estabel
                   v-nivel-matriz    = 0.
       END.

       IF  v-nivel-matriz = 0 THEN DO:
           IF  l-matriz THEN 
               ASSIGN c-estab-estrutura = "101".
           ELSE 
               ASSIGN c-estab-estrutura = tt-param.cod-estabel.
       END.


/*        IF b-estrutura.es-codigo = "3991466" THEN                       */
/*            MESSAGE "depois" SKIP                                       */
/*                    "c-estab-estrutura " c-estab-estrutura SKIP         */
/*                    "v-nivel-matriz " v-nivel-matriz SKIP               */
/*                    "v-seq-nivel " v-seq-nivel SKIP                     */
/*                    "b-estrutura.fantasma "  b-estrutura.fantasma  SKIP */
/*                    "ITEM.compr-fabric " ITEM.compr-fabric              */
/*                VIEW-AS ALERT-BOX INFO BUTTONS OK.                      */

       IF  NOT b-estrutura.fantasma 
       AND ITEM.compr-fabric = 1 THEN DO:
           
          FIND FIRST tt-est 
               WHERE tt-est.it-codigo = b-estrutura.es-codigo NO-ERROR.

          IF NOT AVAIL tt-est THEN DO:
              ASSIGN c-descricao = ITEM.desc-item.

/*               RUN pi-print-editor (ITEM.desc-item). */

              CREATE tt-est.
              ASSIGN tt-est.it-codigo   = b-estrutura.es-codigo
                     tt-est.cod-estabel = c-estab-estrutura
                     tt-est.descricao   = c-descricao.
          END. 
          ASSIGN tt-est.qtde = tt-est.qtde + (b-estrutura.quant-usada * de-qtde).
       END. 

       RUN pi-ler(b-estrutura.es-codigo, b-estrutura.quant-usada * de-qtde).

       ASSIGN v-seq-nivel = v-seq-nivel - 1.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-mostra) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra Procedure 
PROCEDURE pi-mostra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN de-preco-fob    = 0
           de-preco-fob-us = 0
           de-fi           = 0
           de-fi-total     = 0
           de-qtde         = 0.

    FOR EACH tt-est:
        ASSIGN c-nome-abrev    = ""
               i-cod-emitente  = 0 
               de-preco-fob    = 0
               de-preco-fob-us = 0
               c-unid-med-for  = "".

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo item : " + tt-est.it-codigo).

        FIND FIRST ITEM NO-LOCK 
             WHERE ITEM.it-codigo = tt-est.it-codigo NO-ERROR.

        FOR EACH item-tab NO-LOCK 
           WHERE item-tab.it-codigo = tt-est.it-codigo 
             AND item-tab.situacao = 1,
           FIRST tb-pr-cc NO-LOCK 
           WHERE tb-pr-cc.cod-emitente = item-tab.cod-emitente
             AND tb-pr-cc.cod-cond-pag = item-tab.cod-cond-pag
             AND tb-pr-cc.nr-tab = item-tab.nr-tab
             AND tb-pr-cc.situacao = 1
             AND tb-pr-cc.dt-inicio  <= TODAY 
             AND tb-pr-cc.dt-termino >= TODAY,
           FIRST emitente NO-LOCK 
           WHERE emitente.nome-abrev = item-tab.nome-abrev,
           FIRST item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.cod-estabel = tt-est.cod-estabel
             AND item-fornec-estab.it-codigo = item-tab.it-codigo
             AND item-fornec-estab.cod-emitente = emitente.cod-emitente 
             AND item-fornec-estab.ativo:

            ASSIGN i-num-casa-dec = 1.

            DO i-cont = 1 TO item-fornec-estab.num-casa-dec:
               ASSIGN i-num-casa-dec = i-num-casa-dec * 10.
            END.

            ASSIGN de-fator-conver = item-fornec-estab.fator-conver / i-num-casa-dec
                   c-unid-med-for  = item-fornec-estab.unid-med-for.    

            ASSIGN de-preco-fob    = item-tab.pr-item
                   de-preco-fob-us = item-tab.pr-item.


            /*se o valor da tabela de preáo n∆o for em real ent∆o encontra o valor em real*/
            IF tb-pr-cc.mo-codigo <> 0 THEN  
               ASSIGN de-preco-fob = de-preco-fob * tt-param.cotacao.

            /*se o valor da tabela de preáo n∆o for em dolar ent∆o encontra o valor em dolar*/
            IF tb-pr-cc.mo-codigo <> 1 THEN
                ASSIGN de-preco-fob-us = de-preco-fob-us / tt-param.cotacao.

            /*Converte valores para unidade de medida do fornecedor*/
            ASSIGN de-preco-fob    = de-preco-fob    * de-fator-conver
                   de-preco-fob-us = de-preco-fob-us * de-fator-conver.

            IF tb-pr-cc.valor-taxa <> 0 THEN
               ASSIGN de-preco-fob    = de-preco-fob    + (de-preco-fob    * (tb-pr-cc.valor-taxa / 100))
                      de-preco-fob-us = de-preco-fob-us + (de-preco-fob-us * (tb-pr-cc.valor-taxa / 100)).

            IF  emitente.natureza     <> 3 
            AND item-tab.aliquota-icm <> 0 THEN 
               ASSIGN de-preco-fob    = de-preco-fob    * ((100 - item-tab.aliquota-icm) / 100)
                      de-preco-fob-us = de-preco-fob-us * ((100 - item-tab.aliquota-icm) / 100). 

            ASSIGN c-nome-abrev   = emitente.nome-abrev
                   i-cod-emitente = emitente.cod-emitente.

            IF emitente.natureza = 3 THEN DO:
               /*ASSIGN c-nacional = NO.*/
               LEAVE.
            END.
        END.

        ASSIGN de-val-unit = 0.

        FIND FIRST item-estab NO-LOCK
             WHERE item-estab.cod-estabel = tt-est.cod-estabel
               AND item-estab.it-codigo   = ITEM.it-codigo NO-ERROR.

        IF AVAIL item-estab THEN 
           ASSIGN de-val-unit = item-estab.val-unit-mat-m[1]
                              + item-estab.val-unit-mob-m[1]
                              + item-estab.val-unit-ggf-m[1].

        FIND FIRST item-uni-estab NO-LOCK 
             WHERE item-uni-estab.it-codigo   = item.it-codigo 
               AND item-uni-estab.cod-estabel = tt-est.cod-estabel NO-ERROR.
    
        IF  item-uni-estab.tp-desp-padrao = 2 /*importado*/ THEN
            ASSIGN c-nacional = "IMP".
        ELSE
            ASSIGN c-nacional = "NAC".

        CREATE tt-imp.
        ASSIGN tt-imp.nac-imp            = c-nacional
               tt-imp.it-codigo          = tt-est.it-codigo
               tt-imp.cod-estabel        = tt-est.cod-estabel
               tt-imp.descricao          = tt-est.descricao
               tt-imp.qtde               = tt-est.qtde 
               tt-imp.de-preco-fob-us    = de-preco-fob-us 
               tt-imp.de-preco-fob       = de-preco-fob 
               tt-imp.de-fob-us$-tot     = tt-est.qtde * de-preco-fob-us
               tt-imp.de-fob-r$-tot      = tt-est.qtde * de-preco-fob
               tt-imp.val-unit-mat       = de-val-unit 
               tt-imp.de-fi              = 1
               tt-imp.de-fi-total        = 1
               tt-imp.nome-abrev         = c-nome-abrev
               tt-imp.cod-emitente       = i-cod-emitente
               tt-imp.unid-med-for       = c-unid-med-for
               tt-imp.class-fiscal       = ITEM.class-fiscal
               tt-imp.un                 = ITEM.un
               tt-imp.numero             = 0. 

        IF AVAIL item-uni-estab THEN
            ASSIGN tt-imp.preco-ul-ent = item-uni-estab.preco-ul-ent
                   tt-imp.periodo-fixo = item-uni-estab.periodo-fixo
                   tt-imp.res-for-comp = item-uni-estab.res-for-comp
                   tt-imp.horiz-fixo   = item-uni-estab.horiz-fixo
                   tt-imp.horiz-lib    = int(substring(item-uni-estab.char-1,129,3))
                   tt-imp.tp-despesa   = item-uni-estab.tp-desp-padrao 
                   tt-imp.deposito-alm = item-uni-estab.deposito-pad.
        ELSE
            ASSIGN tt-imp.preco-ul-ent = item.preco-ul-ent
                   tt-imp.periodo-fixo = ITEM.periodo-fixo
                   tt-imp.res-for-comp = ITEM.res-for-comp
                   tt-imp.horiz-fixo   = ITEM.horiz-fixo
                   tt-imp.horiz-lib    = int(substring(item.char-1,129,3))
                   tt-imp.tp-despesa   = ITEM.tp-desp-padrao 
                   tt-imp.deposito-alm = ITEM.deposito-pad.
    END.
    
    FOR EACH docum-est USE-INDEX est-origem NO-LOCK  
       WHERE docum-est.cod-estabel = tt-param.cod-estabel
         AND docum-est.dt-trans   >= (TODAY - 180)
         AND docum-est.dt-trans   <= TODAY
       ,FIRST natur-oper NO-LOCK
       WHERE natur-oper.nat-operacao = docum-est.nat-operacao,
        FIRST emitente NO-LOCK
       WHERE emitente.cod-emitente = docum-est.cod-emitente,
        EACH item-doc-est OF docum-est NO-LOCK
       WHERE item-doc-est.it-codigo <> "",
       FIRST tt-est NO-LOCK
       WHERE tt-est.it-codigo = item-doc-est.it-codigo:

        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.

        IF NOT AVAIL ITEM THEN NEXT.

        IF NOT (ITEM.ge-codigo < 19 OR ITEM.ge-codigo = 45) THEN NEXT.

        IF NOT CAN-FIND(FIRST tt-excessao-nat 
                        WHERE tt-excessao-nat.nat-operacao = natur-oper.nat-operacao) THEN DO:
            IF NOT natur-oper.emite-duplic OR natur-oper.tipo-compra <> 1 THEN NEXT.
        END.

        ASSIGN de-desp-total = 0
               de-fi         = 0
               de-fi-total   = 0
               de-val-nc     = 0.

        IF SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN DO:

            FOR EACH item-doc-est-cex OF item-doc-est NO-LOCK:

                FOR FIRST desp-imp NO-LOCK
                    WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp
                      AND desp-imp.gera-custo:

                    ASSIGN de-desp-total      = de-desp-total + item-doc-est-cex.val-desp.
                END.
            END.

            ASSIGN de-fi         = (item-doc-est.preco-total[1] + de-desp-total) / item-doc-est.preco-total[1]. 

            FOR EACH rat-docum NO-LOCK USE-INDEX nf-docto
               WHERE rat-docum.nf-serie    = docum-est.serie-docto
                 AND rat-docum.nf-nro      = docum-est.nro-docto
                 AND rat-docum.nf-emitente = docum-est.cod-emitente
                 AND rat-docum.nf-nat-oper = docum-est.nat-oper:

                FIND FIRST bf-docum-est USE-INDEX documento NO-LOCK
                     WHERE bf-docum-est.serie-docto  = rat-docum.serie-docto 
                       AND bf-docum-est.nro-docto    = rat-docum.nro-docto   
                       AND bf-docum-est.cod-emitente = rat-docum.cod-emitente 
                       AND bf-docum-est.nat-operacao = rat-docum.nat-operacao NO-ERROR.

                IF AVAIL bf-docum-est THEN DO:

                    FOR EACH bf-item-doc-est OF bf-docum-est NO-LOCK
                       WHERE bf-item-doc-est.it-codigo = item-doc-est.it-codigo:

                        ASSIGN de-val-nc = de-val-nc + bf-item-doc-est.preco-total[1].
                    END.
                END.

                ASSIGN de-fi-total = (item-doc-est.preco-total[1] + de-desp-total + de-val-nc) / item-doc-est.preco-total[1].
            END.
        END.
        
        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo item : " + tt-est.it-codigo).

        IF de-fi = ? 
        OR de-fi = 0 THEN 
            ASSIGN de-fi = 1.

        IF de-fi-total = ? 
        OR de-fi-total = 0 THEN 
            ASSIGN de-fi-total = 1.

        FIND FIRST tt-imp NO-LOCK 
            WHERE tt-imp.it-codigo = tt-est.it-codigo NO-ERROR.


        IF SUBSTRING(docum-est.nat-operacao,1,1) = "3" THEN DO:
            IF tt-imp.numero = 0 THEN
                ASSIGN tt-imp.de-fi       = de-fi
                       tt-imp.de-fi-total = de-fi-total
                       tt-imp.desp-total  = de-desp-total
                       tt-imp.preco-total = item-doc-est.preco-total[1].
            ELSE
                ASSIGN tt-imp.de-fi       = (tt-imp.de-fi       + de-fi)
                       tt-imp.de-fi-total = (tt-imp.de-fi-total + de-fi-total)
                       tt-imp.desp-total  = tt-imp.desp-total   + de-desp-total
                       tt-imp.preco-total = tt-imp.preco-total  + item-doc-est.preco-total[1].

            ASSIGN tt-imp.numero = tt-imp.numero + 1.
        END.

        /******* O 1.015 ABAIXO Ç O FRETE  *******/
        IF c-nacional = "NAC" THEN
           ASSIGN tt-imp.de-cif-us$-tot = (de-preco-fob-us * tt-est.qtde) * 1.015.
        ELSE
           ASSIGN tt-imp.de-cif-us$-tot = (de-preco-fob-us * tt-est.qtde) * tt-imp.de-fi.

        IF c-nacional = "NAC" THEN
           ASSIGN tt-imp.de-cif-r$-tot = (de-preco-fob * tt-est.qtde) * 1.015
                  tt-imp.de-cif-r$     = de-preco-fob  * 1.015.
        ELSE
           ASSIGN tt-imp.de-cif-r$-tot = (de-preco-fob * tt-est.qtde) * tt-imp.de-fi
                  tt-imp.de-cif-r$     = de-preco-fob  * tt-imp.de-fi.
    END.

    ASSIGN de-fob-r$-tot-acum = 0 .
    FOR EACH tt-imp:
        ASSIGN de-fob-r$-tot-acum =  de-fob-r$-tot-acum + tt-imp.de-fob-r$-tot.
        IF tt-imp.numero > 0 THEN
            ASSIGN tt-imp.de-fi = (tt-imp.preco-total + tt-imp.desp-total) / tt-imp.preco-total 
                   tt-imp.de-fi-total = tt-imp.de-fi-total / tt-imp.numero NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-normal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-normal Procedure 
PROCEDURE pi-normal PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   FIND FIRST ITEM NO-LOCK 
        WHERE item.it-codigo = tt-digita.it-codigo NO-ERROR.
   
   FIND FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = tt-param.cod-estabel
          AND item-uni-estab.it-codigo   = tt-digita.it-codigo NO-ERROR.
          
   PUT UNFORMATTED "Data:"            + ";" + STRING(TODAY) SKIP
                   "Cotaá∆o:"         + ";" + STRING(tt-param.cotacao) SKIP
                   "Matr°cula:"       + ";" + c-seg-usuario SKIP
                   "Unidade Neg¢cio:" + ";" + IF AVAIL item-uni-estab THEN item-uni-estab.cod-unid-negoc ELSE ""
              SKIP "Item:"            + ";" + ITEM.it-codigo + " " + ITEM.desc-item SKIP(2).
         
   EMPTY TEMP-TABLE tt-excessao-nat.

    RUN esp/es0018p.p (INPUT "escsp007rp",
                       INPUT 1,
                       INPUT 0,
                       INPUT "", 
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        CREATE tt-excessao-nat.
        ASSIGN tt-excessao-nat.nat-operacao = tt-prog-ponto.conteudo.
    END.

   run pi-mostra.

   PUT UNFORMATTED "C¢digo;" +
                   "Descriá∆o Completa;" +
                   "Qtd.;" +
                   "Unidade Medida;" +
                   "FOB US$ Unit†rio;" +
                   "FOB US$ Total;" +
                   "FOB R$ Total;" +
                   "FI MÇdio;" +
                   "CIF R$ Unit†rio;" +
                   "CIF R$ Total;" +
                   "Custo Èltima Entrada Unit†rio R$;" +
                   "Nac/Imp;" +
                   "Nome Fornecedor;" +
                   "C¢digo Fornecedor;" +
                   "Lead Time Fornecedor;" +
                   "Unidade Medida Fornec;" +
                   "Estab.;" +
                   "Classificaá∆o Fiscal;" +
                   "Representatividade Item R$ (%)" SKIP.

 
   /*if tt-param.ind-tipo = 1 then do:   */
   FOR EACH tt-imp 
      BREAK BY tt-imp.nac-imp:
       IF FIRST-OF(tt-imp.nac-imp) THEN
          ASSIGN de-val-unit    = 0.
   
       ASSIGN de-val-unit    = de-val-unit    + (tt-imp.preco-ul-ent * tt-imp.qtde).
                              
       PUT UNFORMATTED tt-imp.it-codigo               + ";" + 
                       tt-imp.descricao               + ";" + 
                       STRING(tt-imp.qtde)            + ";" + 
                       STRING(tt-imp.un             ) + ";" + 
                       STRING(tt-imp.de-preco-fob-us) + ";" +
                       STRING(tt-imp.de-fob-us$-tot ) + ";" +
                       STRING(tt-imp.de-fob-r$-tot	) + ";" +
                       STRING(tt-imp.de-fi, ">>>>>>>9.99") + ";" +
                       STRING(tt-imp.de-cif-r$	    ) + ";" +
                       STRING(tt-imp.de-cif-r$-tot	) + ";" +
                       STRING(tt-imp.preco-ul-ent	) + ";" +
                       STRING(tt-imp.nac-imp	    ) + ";" +
                       STRING(tt-imp.nome-abrev	    ) + ";" +
                       STRING(tt-imp.cod-emitente	) + ";" +
                       STRING(tt-imp.res-for-comp	) + ";" +
                       STRING(tt-imp.unid-med-for	) + ";" +
                       STRING(tt-imp.cod-estabel	) + ";" +
                       STRING(tt-imp.class-fiscal   ) + ";" + 
                       STRING((tt-imp.de-fob-r$-to / de-fob-r$-tot-acum * 100) / 100)  SKIP.

   END.

   PUT SKIP(2).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

