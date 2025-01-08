/***********************************************************************
**  Programa..: esp/cpp/escpp137rp.p
**  Autor.....: Vitor Inoue
**  Data......: Maio/2023 - Desenvolvimento
**  Descricao.: Impressao Etiquetas de Volume por etiqueta de separa‡Æo
**  Versao....: 001 04/05/2023
**                  Desenvolvimento Programa
************************************************************************/
{esp/es0018.i}
DEFINE STREAM str-excel.

DEFINE VARIABLE c-arquivo-saida-csv   AS CHARACTER   NO-UNDO.

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-arquivo-saida AS CHARACTER   NO-UNDO.


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
    FIELD de-etiq-ini      AS DECIMAL
    FIELD de-etiq-fim      AS DECIMAL
    FIELD tg-reimpressao    AS LOG.

define temp-table tt-param-esftp004 no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    FIELD iTipoNota        AS INT
    FIELD ItCodigoIni      LIKE ITEM.it-codigo
    FIELD ItCodigoFim      LIKE ITEM.it-codigo 
    FIELD NrEmbarqueIni    LIKE nota-fiscal.nr-embarque
    FIELD NrEmbarqueFim    LIKE nota-fiscal.nr-embarque 
    FIELD NrNotaFisIni     LIKE nota-fiscal.nr-nota-fis
    FIELD NrNotaFisFim     LIKE nota-fiscal.nr-nota-fis
    FIELD NrVolumeIni      AS INT /*LIKE volume-nf.nr-volume*/
    FIELD NrVolumeFim      AS INT /*LIKE volume-nf.nr-volume*/ 
    FIELD Rastreabilidade  AS INTEGER
    FIELD tipo-volume      AS INTEGER
    FIELD nome-transp-ini  LIKE embarque.nome-transp
    FIELD ImprimeEtiqueta  AS INT
    FIELD i-impressora     AS INT
    FIELD notas-mg         AS INT
    FIELD l-estado         AS LOG
    FIELD c-estado         AS CHAR
    field cod-estabel      as char
    FIELD notas-desconsiderar AS CHARACTER
    FIELD reimpressao      AS LOGICAL
    FIELD l-imprime-barra  AS LOGICAL.

DEFINE VARIABLE c-dir-saida AS CHARACTER NO-UNDO.

DEFINE VARIABLE dt-geracao AS DATE NO-UNDO.
DEFINE VARIABLE hr-geracao AS CHAR NO-UNDO.

DEFINE VARIABLE de-qt-item-etiq AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE TEMP-TABLE tt-emb-nf-vol NO-UNDO
    FIELD cdd-embarq       LIKE nota-fiscal.cdd-embarq
    FIELD cod-estabel      LIKE nota-fiscal.cod-estabel
    FIELD nr-nota-fis      LIKE nota-fiscal.nr-nota-fis
    FIELD serie            LIKE nota-fiscal.serie
    FIELD nr-volume        LIKE volume-nf.nr-volume
    FIELD nome-transp      LIKE nota-fiscal.nome-transp
    FIELD it-codigo        LIKE ITEM.it-codigo
    FIELD val-etiq-packing LIKE wms-etiq-packing.val-etiq-packing.

DEFINE BUFFER b-volume-nf FOR volume-nf.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
{upc\btb910za-upc.i}
{utp/ut-glob.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar in h-acomp (input "Buscando ...").

EMPTY TEMP-TABLE tt-emb-nf-vol.
EMPTY TEMP-TABLE tt-param-esftp004.

FOR EACH  wms-etiq-packing NO-LOCK
    WHERE wms-etiq-packing.val-etiq-packing >= tt-param.de-etiq-ini
      AND wms-etiq-packing.val-etiq-packing <= tt-param.de-etiq-fim
      AND wms-etiq-packing.cdd-embarq NE 0.

    RUN pi-acompanhar in h-acomp (input "Etiqueta Packing: " + STRING(wms-etiq-packing.val-etiq-packing)).
    
    IF NOT tt-param.tg-reimpressao THEN DO:

        FOR EACH  es-wm-box-movto-etiq NO-LOCK
            WHERE es-wm-box-movto-etiq.val-etiq-separacao = wms-etiq-packing.val-etiq-packing:
        
            FIND FIRST wm-docto NO-LOCK
                 WHERE wm-docto.cod-estabel  = es-wm-box-movto-etiq.cod-estabel
                   AND wm-docto.cod-local    = es-wm-box-movto-etiq.cod-local
                   AND wm-docto.id-docto     = es-wm-box-movto-etiq.id-docto NO-ERROR.
        
            FOR FIRST wm-box-movto NO-LOCK
                WHERE wm-box-movto.cod-estabel    = es-wm-box-movto-etiq.cod-estabel
                  AND wm-box-movto.cod-local      = es-wm-box-movto-etiq.cod-local
                  AND wm-box-movto.id-movto       = es-wm-box-movto-etiq.id-movto
                  AND wm-box-movto.ind-tipo-movto = 2. /* 2- Sa¡da */
                
                ASSIGN de-qt-item-etiq = wm-box-movto.qtd-item.                       
                       
                bloco_nota:
                FOR EACH  nota-fiscal NO-LOCK
                    WHERE nota-fiscal.cdd-embarq = wms-etiq-packing.cdd-embarq
                      AND nota-fiscal.dt-cancela = ?.
        
                    FOR EACH  volume-nf NO-LOCK
                        WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                          AND volume-nf.serie       = nota-fiscal.serie
                          AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                          AND volume-nf.it-codigo   = wm-box-movto.cod-item                              
                          AND NOT volume-nf.impresso
                           BY volume-nf.varios-itens
                           BY volume-nf.nr-volume.

                        IF NOT CAN-FIND(FIRST integra-mft-wms-notas
                                        WHERE integra-mft-wms-notas.cod-estabel = volume-nf.cod-estabel
                                          AND integra-mft-wms-notas.serie       = volume-nf.serie
                                          AND integra-mft-wms-notas.nr-nota-fis = volume-nf.nr-nota-fis
                                          AND integra-mft-wms-notas.it-codigo   = volume-nf.it-codigo
                                          AND integra-mft-wms-notas.qtd-integra = volume-nf.qtde
                                          AND integra-mft-wms-notas.l-fracionado) THEN DO:

                            IF NOT CAN-FIND(FIRST tt-emb-nf-vol
                                            WHERE tt-emb-nf-vol.cod-estabel = volume-nf.cod-estabel
                                              AND tt-emb-nf-vol.serie       = volume-nf.serie
                                              AND tt-emb-nf-vol.nr-nota-fis = volume-nf.nr-nota-fis
                                              AND tt-emb-nf-vol.nr-volume   = volume-nf.nr-volume 
                                              AND tt-emb-nf-vol.it-codigo   = volume-nf.it-codigo) THEN DO:
                            
                                CREATE tt-emb-nf-vol.
                                ASSIGN tt-emb-nf-vol.val-etiq-packing = wms-etiq-packing.val-etiq-packing
                                       tt-emb-nf-vol.cdd-embarq       = nota-fiscal.cdd-embarq
                                       tt-emb-nf-vol.cod-estabel      = nota-fiscal.cod-estabel
                                       tt-emb-nf-vol.serie            = nota-fiscal.serie
                                       tt-emb-nf-vol.nr-nota-fis      = nota-fiscal.nr-nota-fis
                                       tt-emb-nf-vol.nr-volume        = volume-nf.nr-volume
                                       tt-emb-nf-vol.nome-transp      = nota-fiscal.nome-transp
                                       tt-emb-nf-vol.it-codigo        = volume-nf.it-codigo.
                                
                                ASSIGN de-qt-item-etiq = de-qt-item-etiq - volume-nf.qtde.
                                
                                IF de-qt-item-etiq <= 0 THEN LEAVE bloco_nota.
                            END.
                        END.
                    END.
                END.
            END. /* for first wm-box-movto */
        END. /* for each es-wm-box-movto-etiq */
    END. /* IF NOT tt-param.tg-reimpressao */
    ELSE DO: /* IF tt-param.tg-reimpressao */
        
        FOR EACH  volume-nf NO-LOCK
            WHERE volume-nf.val-etiq-packing = wms-etiq-packing.val-etiq-packing.

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = volume-nf.cod-estabel
                   AND nota-fiscal.serie       = volume-nf.serie
                   AND nota-fiscal.nr-nota-fis = volume-nf.nr-nota-fis NO-ERROR.
            
            CREATE tt-emb-nf-vol.
            ASSIGN tt-emb-nf-vol.val-etiq-packing = wms-etiq-packing.val-etiq-packing
                   tt-emb-nf-vol.cdd-embarq       = nota-fiscal.cdd-embarq   
                   tt-emb-nf-vol.cod-estabel      = nota-fiscal.cod-estabel
                   tt-emb-nf-vol.serie            = nota-fiscal.serie
                   tt-emb-nf-vol.nr-nota-fis      = nota-fiscal.nr-nota-fis
                   tt-emb-nf-vol.nr-volume        = volume-nf.nr-volume
                   tt-emb-nf-vol.nome-transp      = nota-fiscal.nome-transp
                   tt-emb-nf-vol.it-codigo        = volume-nf.it-codigo.
        END.
    END.
END. /* for each wms-etiq-packing */

RUN pi-finalizar IN h-acomp.

bloco_impressao:
DO TRANS:

    FOR EACH tt-emb-nf-vol ON ERROR UNDO, THROW
        BREAK 
        BY tt-emb-nf-vol.it-codigo
        BY tt-emb-nf-vol.cod-estabel
        BY tt-emb-nf-vol.cdd-embarq
        BY tt-emb-nf-vol.nr-nota-fis
        BY tt-emb-nf-vol.nr-volume.        
    
        EMPTY TEMP-TABLE tt-param-esftp004.
    
        CREATE tt-param-esftp004.
        ASSIGN tt-param-esftp004.usuario              = c-seg-usuario
               tt-param-esftp004.destino              = 1 /* 1- Impressora */
               tt-param-esftp004.data-exec            = today
               tt-param-esftp004.hora-exec            = time
               tt-param-esftp004.ImprimeEtiqueta      = 2 /* 2- Sem endere‡o */
               tt-param-esftp004.i-impressora         = 1 /* 1- Zembra 600 */
               tt-param-esftp004.iTipoNota            = 1 /* 1- Notas com Embarque */
               tt-param-esftp004.c-estado             = ?
               tt-param-esftp004.cod-estabel          = v_cod_estab_usuar
               tt-param-esftp004.l-estado             = NO
               tt-param-esftp004.ItCodigoIni          = tt-emb-nf-vol.it-codigo
               tt-param-esftp004.ItCodigoFim          = tt-emb-nf-vol.it-codigo
               tt-param-esftp004.NrEmbarqueIni        = tt-emb-nf-vol.cdd-embarq
               tt-param-esftp004.NrEmbarqueFim        = tt-emb-nf-vol.cdd-embarq
               tt-param-esftp004.NrNotaFisIni         = tt-emb-nf-vol.nr-nota-fis
               tt-param-esftp004.NrNotaFisFim         = tt-emb-nf-vol.nr-nota-fis
               tt-param-esftp004.NrVolumeIni          = tt-emb-nf-vol.nr-volume
               tt-param-esftp004.NrVolumeFim          = tt-emb-nf-vol.nr-volume
               tt-param-esftp004.Rastreabilidade      = 3 /* 3- Ambos */
               tt-param-esftp004.tipo-volume          = 3 /* 3- Ambos */
               tt-param-esftp004.nome-transp-ini      = tt-emb-nf-vol.nome-transp
               tt-param-esftp004.notas-desconsiderar  = ""
               tt-param-esftp004.reimpressao          = tt-param.tg-reimpressao
               tt-param-esftp004.arquivo              = tt-param.arquivo.   

        IF LAST-OF(tt-emb-nf-vol.cod-estabel) THEN
            ASSIGN tt-param-esftp004.l-imprime-barra = YES.
        
        ASSIGN raw-param = ?.
    
        raw-transfer tt-param-esftp004  to raw-param.
    
        RUN esp/ftp/esftp004rp.p (INPUT raw-param,
                                  INPUT TABLE tt-raw-digita).
    
        IF NOT tt-param.tg-reimpressao THEN DO:
            FIND FIRST volume-nf NO-LOCK
                 WHERE volume-nf.cod-estabel = tt-emb-nf-vol.cod-estabel
                   AND volume-nf.serie       = tt-emb-nf-vol.serie
                   AND volume-nf.nr-nota-fis = tt-emb-nf-vol.nr-nota-fis
                   AND volume-nf.nr-volume   = tt-emb-nf-vol.nr-volume
                   AND volume-nf.it-codigo   = tt-emb-nf-vol.it-codigo NO-ERROR.
            IF AVAIL volume-nf THEN DO:
            
                IF volume-nf.impresso THEN DO:
            
                    FIND FIRST b-volume-nf EXCLUSIVE-LOCK
                         WHERE rowid(b-volume-nf) = ROWID(volume-nf) NO-ERROR.
                    IF AVAIL b-volume-nf THEN DO:
            
                        ASSIGN b-volume-nf.val-etiq-packing = tt-emb-nf-vol.val-etiq-packing.
            
                        RELEASE b-volume-nf NO-ERROR.
                    END.
                END.
                ELSE DO:
            
                    UNDO bloco_impressao, RETURN "NOK".
                END.
            END.
        END.
    END.
END.

RETURN "OK".
