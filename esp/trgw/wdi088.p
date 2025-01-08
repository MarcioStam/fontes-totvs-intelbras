/*******************************************************************************
 ** UPC........: wdi088- UPC WRITE it-nota-fisc - Item da Nota Fiscal
 ** Data.......: Dezembro / 2011
 ** Objetivo...: 
 *******************************************************************************/
DEFINE PARAMETER BUFFER b-it-nota-fisc       FOR it-nota-fisc.
DEFINE PARAMETER BUFFER b-old-it-nota-fisc   FOR it-nota-fisc.
DEFINE BUFFER           b-nota-fiscal-wdi088 FOR nota-fiscal.
DEFINE BUFFER           b-it-nota-fisc-docum FOR it-nota-fisc.
DEFINE BUFFER           b-nota-fiscal-rebate FOR nota-fiscal.

DEFINE VARIABLE i-niv-trib-icms AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-sub           AS LOGICAL    NO-UNDO.

RUN prmtw/prmtw-it-nota-fisc.p(BUFFER b-it-nota-fisc, BUFFER b-old-it-nota-fisc).

/* Criar tabela de rateio, utilizada no esftp061 */
IF CAN-FIND(FIRST int-rateio-kit
            WHERE int-rateio-kit.it-codigo = b-it-nota-fisc.it-codigo) 
AND NOT CAN-FIND (FIRST int-item-nota-fisc-kit 
                  WHERE int-item-nota-fisc-kit.cod-estabel    = b-it-nota-fisc.cod-estabel   
                    AND int-item-nota-fisc-kit.serie         = b-it-nota-fisc.serie         
                    AND int-item-nota-fisc-kit.nr-nota-fis   = b-it-nota-fisc.nr-nota-fis   
                    AND int-item-nota-fisc-kit.nr-seq-fat    = b-it-nota-fisc.nr-seq-fat    
                    AND int-item-nota-fisc-kit.it-codigo     = b-it-nota-fisc.it-codigo ) THEN DO:

    FOR EACH int-rateio-kit NO-LOCK
        WHERE int-rateio-kit.it-codigo = b-it-nota-fisc.it-codigo :
        CREATE int-item-nota-fisc-kit.
        ASSIGN int-item-nota-fisc-kit.cod-estabel   = b-it-nota-fisc.cod-estabel
               int-item-nota-fisc-kit.serie         = b-it-nota-fisc.serie
               int-item-nota-fisc-kit.nr-nota-fis   = b-it-nota-fisc.nr-nota-fis
               int-item-nota-fisc-kit.nr-seq-fat    = b-it-nota-fisc.nr-seq-fat
               int-item-nota-fisc-kit.it-codigo     = int-rateio-kit.it-codigo
               int-item-nota-fisc-kit.it-componente = int-rateio-kit.it-componente
               int-item-nota-fisc-kit.perc-custo    = int-rateio-kit.perc-custo
               int-item-nota-fisc-kit.perc-fatur    = int-rateio-kit.perc-fatur.
    END.

END.

IF NEW(b-it-nota-fisc) THEN DO:

/*     MESSAGE 'b-it-nota-fisc.cod-estabel  ' b-it-nota-fisc.cod-estabel   SKIP */
/*             'b-it-nota-fisc.serie        ' b-it-nota-fisc.serie         SKIP */
/*             'b-it-nota-fisc.nr-nota-fis  ' b-it-nota-fisc.nr-nota-fis   SKIP */
/*             'b-it-nota-fisc.nr-seq-fat   ' b-it-nota-fisc.nr-seq-fat    SKIP */
/*             'b-it-nota-fisc.it-codigo    ' b-it-nota-fisc.it-codigo          */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                   */

    FIND FIRST int-it-nota-fisc
        WHERE int-it-nota-fisc.cod-estabel = b-it-nota-fisc.cod-estabel
          AND int-it-nota-fisc.serie       = b-it-nota-fisc.serie
          AND int-it-nota-fisc.nr-nota-fis = b-it-nota-fisc.nr-nota-fis
          AND int-it-nota-fisc.nr-seq-fat  = b-it-nota-fisc.nr-seq-fat
          AND int-it-nota-fisc.it-codigo   = b-it-nota-fisc.it-codigo EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE int-it-nota-fisc THEN DO:

        CREATE int-it-nota-fisc.
        ASSIGN int-it-nota-fisc.cod-estabel = b-it-nota-fisc.cod-estabel
               int-it-nota-fisc.serie       = b-it-nota-fisc.serie
               int-it-nota-fisc.nr-nota-fis = b-it-nota-fisc.nr-nota-fis
               int-it-nota-fisc.nr-seq-fat  = b-it-nota-fisc.nr-seq-fat
               int-it-nota-fisc.it-codigo   = b-it-nota-fisc.it-codigo.

        FIND FIRST b-it-nota-fisc-docum NO-LOCK
             WHERE b-it-nota-fisc-docum.cod-estabel = b-it-nota-fisc.cod-estabel
               AND b-it-nota-fisc-docum.serie       = b-it-nota-fisc.serie-docum
               AND b-it-nota-fisc-docum.nr-nota-fis = b-it-nota-fisc.nr-docum
               AND b-it-nota-fisc-docum.it-codigo   = b-it-nota-fisc.it-codigo NO-ERROR.
        IF AVAIL b-it-nota-fisc-docum THEN
            ASSIGN int-it-nota-fisc.codigo-orig = int(SUBSTRING(b-it-nota-fisc-docum.char-1,180,3)).
        ELSE DO:

            FIND FIRST ITEM WHERE item.it-codigo =  b-it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

            /*Primeira Busca - Cadastro de Itens - CD0903*/
            ASSIGN int-it-nota-fisc.codigo-orig = item.codigo-orig.
            
            /*Segunda Busca - Relacionamento Item x Estab Fat - CD0147*/
            FOR FIRST item-uni-estab NO-LOCK
                WHERE item-uni-estab.it-codigo   = b-it-nota-fisc.it-codigo
                  AND item-uni-estab.cod-estabel = b-it-nota-fisc.cod-estabel:
        
                IF &IF "{&bf_dis_versao_ems}" >= "2.09"
                   &THEN TRIM(STRING   (item-uni-estab.num-origem))
                   &ELSE TRIM(SUBSTRING(item-uni-estab.char-2,18,3)) &ENDIF
                <> "" THEN DO:
        
                    &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                        ASSIGN int-it-nota-fisc.codigo-orig = item-uni-estab.num-origem.
                    &ELSE
                        ASSIGN int-it-nota-fisc.codigo-orig = int(TRIM(SUBSTRING(item-uni-estab.char-2,18,3))).
                    &ENDIF
                END.
            END.
            /*----*/

        END.
            
                
        find estabelec where estabelec.cod-estabel = int-it-nota-fisc.cod-estabel no-lock no-error.

        FIND FIRST b-nota-fiscal-wdi088
            WHERE b-nota-fiscal-wdi088.cod-estabel = b-it-nota-fisc.cod-estabel
            AND   b-nota-fiscal-wdi088.serie       = b-it-nota-fisc.serie
            AND   b-nota-fiscal-wdi088.nr-nota-fis = b-it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.
        IF AVAIL b-nota-fiscal-wdi088 THEN DO:

/*             MESSAGE 'b-nota-fiscal-wdi088  '           */
/*                 b-nota-fiscal-wdi088.cod-estabel '   ' */
/*                 b-nota-fiscal-wdi088.serie       '   ' */
/*                 b-nota-fiscal-wdi088.nr-nota-fis       */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.     */

            FIND item-uf NO-LOCK 
                 WHERE item-uf.it-codigo           = b-it-nota-fisc.it-codigo
                 AND   item-uf.cod-estado-orig     = estabelec.estado
                 AND   item-uf.estado              = b-nota-fiscal-wdi088.estado NO-ERROR.
            IF  AVAIL item-uf THEN do:
                assign int-it-nota-fisc.perc-mva        = item-uf.per-sub-tri
                       int-it-nota-fisc.perc-red-icm    = item-uf.perc-red-sub
                       int-it-nota-fisc.perc-icms-intra = item-uf.dec-1
                       int-it-nota-fisc.perc-icms-inter = b-it-nota-fisc.aliquota-icm.
                find first int-item-uf
                 where int-item-uf.it-codigo       = item-uf.it-codigo      
                 and   int-item-uf.cod-estado-orig = item-uf.cod-estado-orig
                 and   int-item-uf.estado          = item-uf.estado          
                 NO-LOCK no-error.
                if  avail int-item-uf then
                    assign int-it-nota-fisc.perc-cred-intra = int-item-uf.perc-credito-interno.
            end.
        END. /* IF AVAIL b-nota-fiscal-wdi088 THEN DO: */

    END. /* IF NOT AVAILABLE int-it-nota-fisc THEN DO: */

    IF b-it-nota-fisc.nr-pedcli <> "" THEN DO: /*tratar o desconto top milhao mais verde na nota  */

        FOR FIRST b-nota-fiscal-rebate OF b-it-nota-fisc NO-LOCK:
        END.

        FIND FIRST int-ped-item-rebate NO-LOCK USE-INDEX idx_es745
             WHERE int-ped-item-rebate.nome-abrev   = b-nota-fiscal-rebate.nome-ab-cli
               AND int-ped-item-rebate.nr-pedcli    = b-it-nota-fisc.nr-pedcli
               AND int-ped-item-rebate.it-codigo    = b-it-nota-fisc.it-codigo
               AND int-ped-item-rebate.nr-sequencia = b-it-nota-fisc.nr-seq-ped  NO-ERROR.
        IF AVAIL int-ped-item-rebate THEN DO:
            FIND FIRST int-it-nota-fisc-rebate NO-LOCK USE-INDEX ch-principal
                 WHERE int-it-nota-fisc-rebate.cod-estabel  = b-it-nota-fisc.cod-estabel
                   and int-it-nota-fisc-rebate.nr-nota-fis  = b-it-nota-fisc.nr-nota-fis
                   and int-it-nota-fisc-rebate.serie        = b-it-nota-fisc.serie      
                   and int-it-nota-fisc-rebate.nr-seq-fat   = b-it-nota-fisc.nr-seq-fat
                   and int-it-nota-fisc-rebate.it-codigo    = b-it-nota-fisc.it-codigo NO-ERROR.
            IF NOT AVAIL int-it-nota-fisc-rebate THEN DO:
               CREATE int-it-nota-fisc-rebate.
               ASSIGN int-it-nota-fisc-rebate.cod-estabel             = b-it-nota-fisc.cod-estabel
                      int-it-nota-fisc-rebate.nr-nota-fis             = b-it-nota-fisc.nr-nota-fis
                      int-it-nota-fisc-rebate.serie                   = b-it-nota-fisc.serie
                      int-it-nota-fisc-rebate.nr-seq-fat              = b-it-nota-fisc.nr-seq-fat
                      int-it-nota-fisc-rebate.it-codigo               = b-it-nota-fisc.it-codigo
                      int-it-nota-fisc-rebate.perc-rebate-antec       = int-ped-item-rebate.perc-rebate-antec     
                      int-it-nota-fisc-rebate.perc-descto-verde       = int-ped-item-rebate.perc-descto-verde     
                      int-it-nota-fisc-rebate.perc-descto-top-milhao  = int-ped-item-rebate.perc-descto-top-milhao.

               RELEASE int-it-nota-fisc-rebate.
            END.
        END.
    END.


    FIND FIRST int-ped-venda USE-INDEX ch-pedseq
        WHERE int-ped-venda.nr-pedido = b-it-nota-fisc.nr-pedido NO-LOCK NO-ERROR.
    IF AVAILABLE int-ped-venda THEN DO:
        ASSIGN int-it-nota-fisc.cd-unid-comerc = INTEGER(TRIM(STRING(SUBSTRING(int-ped-venda.char-1, 16, 3), ">>9":U))) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN
            ASSIGN int-it-nota-fisc.cd-unid-comerc = 0.
    END.
    ELSE
        ASSIGN int-it-nota-fisc.cd-unid-comerc = 0.
END.


/*Grava informa‡äes comissäes*/
FIND FIRST b-nota-fiscal-wdi088
     WHERE b-nota-fiscal-wdi088.cod-estabel = b-it-nota-fisc.cod-estabel
       AND b-nota-fiscal-wdi088.serie       = b-it-nota-fisc.serie
       AND b-nota-fiscal-wdi088.nr-nota-fis = b-it-nota-fisc.nr-nota-fis NO-LOCK NO-ERROR.

FOR FIRST ped-venda NO-LOCK
    WHERE ped-venda.nr-pedcli  = b-nota-fiscal-wdi088.nr-pedcli
      AND ped-venda.nome-abrev = b-nota-fiscal-wdi088.nome-ab-cli,
    FIRST ped-item NO-LOCK
    WHERE ped-item.nr-sequencia = b-it-nota-fisc.nr-seq-ped
      AND ped-item.it-codigo    = b-it-nota-fisc.it-codigo:

    FIND FIRST int-it-nota-fisc EXCLUSIVE-LOCK
         WHERE int-it-nota-fisc.cod-estabel = b-it-nota-fisc.cod-estabel
           AND int-it-nota-fisc.serie       = b-it-nota-fisc.serie
           AND int-it-nota-fisc.nr-nota-fis = b-it-nota-fisc.nr-nota-fis
           AND int-it-nota-fisc.nr-seq-fat  = b-it-nota-fisc.nr-seq-fat
           AND int-it-nota-fisc.it-codigo   = b-it-nota-fisc.it-codigo NO-ERROR.

    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = b-it-nota-fisc.it-codigo NO-ERROR.

    IF NOT AVAILABLE int-it-nota-fisc THEN DO:
        CREATE int-it-nota-fisc.
        ASSIGN int-it-nota-fisc.cod-estabel = b-it-nota-fisc.cod-estabel
               int-it-nota-fisc.serie       = b-it-nota-fisc.serie
               int-it-nota-fisc.nr-nota-fis = b-it-nota-fisc.nr-nota-fis
               int-it-nota-fisc.nr-seq-fat  = b-it-nota-fisc.nr-seq-fat
               int-it-nota-fisc.it-codigo   = b-it-nota-fisc.it-codigo.
    END.

   /* RUN ftp/ft0515a.p (INPUT  ROWID(b-it-nota-fisc), 
                       OUTPUT i-niv-trib-icms,      
                       OUTPUT l-sub). */

    ASSIGN int-it-nota-fisc.cod-unid-negoc = ped-item.cod-unid-neg
           int-it-nota-fisc.cod-segmento   = IF AVAIL ITEM THEN int(substr(item.fm-cod-com,3,2)) ELSE 0
           int-it-nota-fisc.fm-cod-com     = IF AVAIL ITEM THEN item.fm-cod-com ELSE ""
           int-it-nota-fisc.fm-codigo      = IF AVAIL ITEM THEN item.fm-codigo  ELSE "".
           /*int-it-nota-fisc.cst            = STRING(INT(SUBSTRING(b-it-nota-fisc.char-1,180,3))) + STRING(i-niv-trib-icms, "99"). */
        
    FIND CURRENT int-it-nota-fisc NO-LOCK NO-ERROR.

END.

RETURN 'OK'.


