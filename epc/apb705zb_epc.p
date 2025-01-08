/****************************************************************************
** Programa..............: apb705zb_epc
** Versao................: 1.00.00.000
** Nome Externo..........: epc/apb705zb_epc.p
** Criado por............: Andrey Mauricio de Oliveira
** Criado em.............: 31/05/2021
*****************************************************************************/

DEF TEMP-TABLE tt_epc NO-UNDO
    FIELD cod_event        AS CHARACTER
    FIELD cod_parameter    AS CHARACTER
    FIELD val_parameter    AS CHARACTER
    INDEX id IS PRIMARY cod_parameter cod_event ASCENDING.

DEF INPUT PARAM p_cod_evento
    AS CHARACTER 
    FORMAT "x(1)"
    NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE 
    FOR tt_epc.

DEF VAR v_recid_tit_ap AS int64 NO-UNDO.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren
    AS CHARACTER
    FORMAT "x(12)":U
    LABEL "Usu rio Corrente"
    COLUMN-LABEL "Usu rio Corrente"
    NO-UNDO.

IF  p_cod_evento <> "Acerto de Valor" THEN 
    RETURN "OK".

FIND FIRST tt_epc
    WHERE tt_epc.cod_event     = "Acerto de Valor"
    AND   tt_epc.cod_parameter = "Acerto Valor a Maior" NO-LOCK NO-ERROR.

IF  NOT AVAIL tt_epc THEN 
    RETURN "OK".

ASSIGN v_recid_tit_ap = int64(entry(2,tt_epc.val_parameter,";")).

/* busca t¡tulo gerado pela substitui‡Æo */
FIND FIRST tit_ap
    WHERE RECID(tit_ap) = v_recid_tit_ap NO-LOCK NO-ERROR.

IF  AVAIL tit_ap THEN DO:
    
    IF  tit_ap.ind_origin_tit_ap = "REC" 
    OR  tit_ap.ind_origin_tit_ap = "APB" THEN DO:

        FIND FIRST int-emitente
            WHERE int-emitente.cod-emit = tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.

        IF  AVAIL int-emitente THEN DO:

            FIND FIRST int_espec_fornec NO-LOCK
                 WHERE int_espec_fornec.cod_empresa     = tit_ap.cod_empresa
                 AND   int_espec_fornec.cdn_fornec      = tit_ap.cdn_fornecedor
                 AND   int_espec_fornec.cod_espec_docto = tit_ap.cod_espec_docto 
                 AND   int_espec_fornec.log_ativo       = YES NO-ERROR.

            IF  AVAIL int_espec_fornec THEN DO:
                CREATE proces_pagto.
                ASSIGN proces_pagto.cod_empresa            = tit_ap.cod_empresa
                       proces_pagto.cod_estab              = tit_ap.cod_estab
                       proces_pagto.cod_refer_antecip_pef  = ""
                       proces_pagto.cod_espec_docto        = tit_ap.cod_espec_docto
                       proces_pagto.cod_ser_docto          = tit_ap.cod_ser_docto  
                       proces_pagto.cdn_fornecedor         = tit_ap.cdn_fornecedor 
                       proces_pagto.cod_tit_ap             = tit_ap.cod_tit_ap     
                       proces_pagto.cod_parcela            = tit_ap.cod_parcela    
                       proces_pagto.num_seq_pagto_tit_ap   = 001
                       proces_pagto.cod_portador           = tit_ap.cod_portador
                       proces_pagto.dat_vencto_tit_ap      = tit_ap.dat_vencto_tit_ap
                       proces_pagto.dat_prev_pagto         = tit_ap.dat_prev_pagto 
                       proces_pagto.dat_desconto           = tit_ap.dat_desconto
                       proces_pagto.ind_sit_proces_pagto   = "Liberado"
                       proces_pagto.cod_usuar_prepar_pagto = v_cod_usuar_corren
                       proces_pagto.dat_prepar_pagto       = TODAY
                       proces_pagto.dat_liber_pagto        = TODAY
                       proces_pagto.val_liberd_pagto       = tit_ap.val_sdo_tit_ap
                       proces_pagto.val_liber_pagto_orig   = tit_ap.val_sdo_tit_ap 
                       proces_pagto.cod_indic_econ         = tit_ap.cod_indic_econ
                       NO-ERROR.
            END.
        END.
    END.
END.
