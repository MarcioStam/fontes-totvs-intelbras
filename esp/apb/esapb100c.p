/*****************************************************************************
** Programa..............: esapb100c.p - Verifica Divergàncias
** Autor.................: Heron Lu°s de Borba
** Criado em.............: 10/02/2017
*****************************************************************************/

def new global shared var v_rec_bord_ap_upc
    as recid
    format ">>>>>>9"
    initial ?
    no-undo.

DEFINE VARIABLE v_log_erro AS LOGICAL     NO-UNDO.

DEFINE TEMP-TABLE tt_divergencias_bord NO-UNDO
    FIELD num_seq_bord         LIKE item_bord_ap.num_seq_bord 
    FIELD val_pagto            LIKE item_bord_ap.val_pagto
    FIELD val_cotac_indic_econ LIKE item_bord_ap.val_cotac_indic_econ 
    FIELD val_pagto_calculado  LIKE item_bord_ap.val_pagto_orig.

DEFINE VARIABLE v_desc_divergencia_parte1 AS CHAR FORMAT 'x(100)' NO-UNDO.
DEFINE VARIABLE v_desc_divergencia_parte2 AS CHAR FORMAT 'x(100)' NO-UNDO.
DEFINE VARIABLE v_desc_divergencia_parte3 AS CHAR FORMAT 'x(200)' NO-UNDO.

FIND bord_ap NO-LOCK
    WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-ERROR.
IF NOT AVAIL bord_ap THEN DO:
     MESSAGE "Borderì n∆o Localizado!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
     RETURN.
END.

ASSIGN v_log_erro = NO
       v_desc_divergencia_parte1 = ""
       v_desc_divergencia_parte3 = "".

EMPTY TEMP-TABLE tt_divergencias_bord NO-ERROR.

FOR EACH item_bord_ap OF bord_ap NO-LOCK: 
    
    IF  item_bord_ap.val_pagto_orig = 0 THEN NEXT.

    IF  (ROUND(item_bord_ap.val_pagto, 2) - ROUND((item_bord_ap.val_pagto_orig / item_bord_ap.val_cotac_indic_econ), 2)) > 0.02 THEN DO:
        CREATE tt_divergencias_bord.
        ASSIGN tt_divergencias_bord.num_seq_bord         = item_bord_ap.num_seq_bord
               tt_divergencias_bord.val_pagto            = ROUND(item_bord_ap.val_pagto, 2)
               tt_divergencias_bord.val_cotac_indic_econ = item_bord_ap.val_cotac_indic_econ 
               tt_divergencias_bord.val_pagto_calculado  = ROUND((item_bord_ap.val_pagto_orig / item_bord_ap.val_cotac_indic_econ), 2).
    END.
END.

IF  CAN-FIND(FIRST tt_divergencias_bord) THEN DO:
    ASSIGN v_desc_divergencia_parte1  = "Ocorreram divergàncias nas seguintes seqÅàncias:" 
           v_desc_divergencia_parte2 = "Seq. | Vl.Pag. | Cotac. | Vl.Calc." .

    FOR EACH tt_divergencias_bord:
        IF  v_desc_divergencia_parte3 = "" 
        THEN ASSIGN v_desc_divergencia_parte3 = STRING(tt_divergencias_bord.num_seq_bord)         + " | " + 
                                                STRING(tt_divergencias_bord.val_pagto)            + " | " + 
                                                STRING(tt_divergencias_bord.val_cotac_indic_econ) + " | " + 
                                                STRING(tt_divergencias_bord.val_pagto_calculado)  + CHR(10).
        ELSE ASSIGN v_desc_divergencia_parte3 = v_desc_divergencia_parte3 + 
                                               STRING(tt_divergencias_bord.num_seq_bord)         + " | " + 
                                               STRING(tt_divergencias_bord.val_pagto)            + " | " + 
                                               STRING(tt_divergencias_bord.val_cotac_indic_econ) + " | " + 
                                               STRING(tt_divergencias_bord.val_pagto_calculado)  + CHR(10).
    END.

    MESSAGE v_desc_divergencia_parte1 chr(10) 
            v_desc_divergencia_parte2 chr(10) 
            v_desc_divergencia_parte3 VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    ASSIGN v_log_erro = YES.
END.

IF v_log_erro = NO THEN MESSAGE "Sem divergàncias!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
