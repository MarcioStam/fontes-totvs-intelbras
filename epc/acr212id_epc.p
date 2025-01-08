/* -------------------------------------------------------------------------------------------------------------
Programa : epc\acr212id_epc.p.p
           det_tit_acr_data
-------------------------------------------------------------------------------------------------------------- */

/*---[ Parameters ]---*/
DEFINE INPUT PARAMETER p-ind-event  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object AS HANDLE        NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table  AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p-rec-table  AS RECID         NO-UNDO.

/*---[ Local variable ]---*/
DEFINE VARIABLE h-object          AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-objeto          AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_hdl_btb_connect AS HANDLE    NO-UNDO.
DEFINE VARIABLE v_log_sucesso     AS LOG       NO-UNDO.
DEFINE VARIABLE v_val_subst       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-frame           AS HANDLE    NO-UNDO.

/*---[ Global variable ]---*/
DEFINE NEW GLOBAL SHARED variable v_cod_empres_usuar AS CHARACTER FORMAT "x(3)":U LABEL "Empresa" COLUMN-LABEL "Empresa" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-combo-det       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-txt-estabel     AS WIDGET-HANDLE NO-UNDO.

/*---[ Buffers ]---*/
DEF BUFFER b_tit_acr FOR tit_acr.

/*---[ Temp-tables ]---*/
DEFINE TEMP-TABLE tt_erros_conexao NO-UNDO 
    field ttv_cdn_erro                     as Integer format ">>>,>>9"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistˆncia" column-label "Inconsistˆncia".

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

/*---[ Procedures ]---*/
IF  p-ind-event = "INITIALIZE" AND p-ind-object = "VIEWER" THEN DO:
    CREATE TEXT wh-txt-estabel
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(15)"
           WIDTH        = 13
           SCREEN-VALUE = "Vl Total ST:"
           ROW          = 15
           COL          = 34.5
           VISIBLE      = YES.

    CREATE FILL-IN wh-combo-det
    ASSIGN FRAME       = p-wgh-frame
           DATA-TYPE   = "decimal"
           FORMAT      = ">>,>>>,>>9.99"
           WIDTH       = 16 
           ROW         = 14.8
           COL         = 43 
           HIDDEN      = no
           SENSITIVE   = NO
           VISIBLE     = YES.   
END. /* IF  p-ind-event = "INITIALIZE" AND p-ind-object = "VIEWER" THEN DO: */

IF  p-ind-event = "ENABLE" AND p-ind-object = "VIEWER" THEN DO:
    IF valid-handle(wh-combo-det) THEN ASSIGN wh-combo-det:SENSITIVE = NO.
END. /* IF  p-ind-event = "ENABLE" AND p-ind-object = "VIEWER" THEN DO: */


IF  p-ind-event = "DISPLAY" AND p-ind-object = "VIEWER" THEN DO:

     FIND b_tit_acr NO-LOCK WHERE RECID(b_tit_acr) = p-rec-table NO-ERROR.
     IF NOT AVAIL b_tit_acr THEN RETURN.

     IF valid-handle(wh-combo-det) THEN ASSIGN wh-combo-det:SCREEN-VALUE = "".

     IF  AVAIL b_tit_acr AND b_tit_acr.ind_orig_tit_acr = "FATEMS20" THEN DO:
         /* ** Chamada Programa ******/
         RUN epc/acr212id2_epc.p(INPUT  b_tit_acr.cod_estab,
                                 INPUT  b_tit_acr.cod_ser,
                                 INPUT  b_tit_acr.cod_tit_acr,
                                 OUTPUT v_val_subst).
        
         IF valid-handle(wh-combo-det) THEN ASSIGN wh-combo-det:SCREEN-VALUE = STRING(v_val_subst, ">>>,>>9.99").
     END. /* IF  AVAIL b_tit_acr AND b_tit_acr.ind_orig_tit_acr = "FATEMS20" THEN DO: */
END. /* IF  p-ind-event = "DISPLAY" AND p-ind-object = "VIEWER" THEN DO: */
