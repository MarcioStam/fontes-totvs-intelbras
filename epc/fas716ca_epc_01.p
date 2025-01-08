/*****************************************************************************
** Programa..............: fas716ca_epc_01.p - rpt_bem_pat_pis_cofins
** Autor.................: Andrey M Oliveira
** Criado em.............: 20/08/2018.
*****************************************************************************/

DEF INPUT PARAM p_ind_event       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_ind_object      AS CHAR           NO-UNDO.
DEF INPUT PARAM p_wgh_object      AS HANDLE         NO-UNDO.
DEF INPUT PARAM p_wgh_frame       AS WIDGET-HANDLE  NO-UNDO.
DEF INPUT PARAM p_cod_table       AS CHAR           NO-UNDO.
DEF INPUT PARAM p_rec_table       AS RECID          NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR h_cod_cta_pat     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_cod_estab       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h_cod_localiz     AS WIDGET-HANDLE NO-UNDO.


PROCEDURE pi_leave_bem:

    MESSAGE "pi-leave-bem" VIEW-AS ALERT-BOX.

    IF  h_cod_cta_pat:SCREEN-VALUE <> "" THEN
        MESSAGE "informou cta" VIEW-AS ALERT-BOX.
    ELSE
        MESSAGE "cta em branco" VIEW-AS ALERT-BOX.


        IF   VALID-HANDLE(h_cod_cta_pat)
        AND  (h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (12 MESES)" 
        AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (36 MESES)"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (48 MESES)"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "LOCACAO (60 MESES)"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "PROJ. ANDAM. INTAN"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "PROJETOS EM ANDAME"
        AND   h_cod_cta_pat:SCREEN-VALUE <> "VEICULOS") THEN DO:
    
            IF  VALID-HANDLE(h_cod_localiz) THEN DO:                
                IF  h_cod_estab:SCREEN-VALUE = "101" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "PATRIMONIO".
        
                IF  h_cod_estab:SCREEN-VALUE = "103" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "MAXCOM".
        
                IF  h_cod_estab:SCREEN-VALUE = "104" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "SERTAO".
        
                IF  h_cod_estab:SCREEN-VALUE = "105" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "MANAUS".
        
                IF  h_cod_estab:SCREEN-VALUE = "109" THEN
                    ASSIGN h_cod_localiz:SCREEN-VALUE = "DEPOSITO AM".
            END.
        END.
        ELSE DO:
            IF  VALID-HANDLE(h_cod_localiz) THEN
                ASSIGN h_cod_localiz:SCREEN-VALUE = "".
        END.

END PROCEDURE.
