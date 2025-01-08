/******************************************************************************
*      Programa .....: utb080-upc.p                                           *
*      Data .........: 30 de Novembro de 2022                                 *
*      Sistema ......:                                                        *
*      Empresa ......: iDBA                                                   *
*      Cliente ......: Intelbras                                              *
*      Programador ..: Mauricio                                               *
*      Objetivo .....: UPC para o add_cta_ctbl (utb080db),                    *
*                                 mod_cta_ctbl (utb080fb) e                   *
*                                 det_cta_ctbl (utb080jb)                     *
*******************************************************************************
*      VERSAO      DATA        RESPONSAVEL   MOTIVO                           *
*      1.00.00.000 30/11/2022  Mauricio      Desenvolvimento                  *
******************************************************************************/
{include/i-prgvrs.i "utb080-upc" 1.00.00.000}

define input param p_ind_event  as char          no-undo.
define input param p_ind_object as char          no-undo.
define input param p_wgh_object as widget-handle no-undo.
define input param p_wgh_frame  as widget-handle no-undo.
define input param p_cod_table  as char          no-undo.
define input param p_rec_table  as recid         no-undo.

def var c_objeto as char no-undo.

DEF VAR h_cod_cta_ctbl AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh_ind_ariba AS WIDGET-HANDLE NO-UNDO.

assign c_objeto = entry(num-entries(p_wgh_object:file-name,'~/'),p_wgh_object:file-name,'~/') no-error.

/* message "p_ind_event  = " p_ind_event  skip        */
/*         "p_ind_object = " p_ind_object skip        */
/*         "p_wgh_object = " p_wgh_object skip        */
/*         "p_wgh_frame  = " p_wgh_frame  skip        */
/*         "p_cod_table  = " p_cod_table  skip        */
/*         "p_rec_table  = " string(p_rec_table) skip */
/*         "c_objeto     = " c_objeto                 */
/*         view-as alert-box.                         */

IF  p_ind_event  = "initialize"
AND p_ind_object = "viewer"
AND NOT (c_objeto <> "utb080db.p" AND
         c_objeto <> "utb080fb.p" AND
         c_objeto <> "utb080jb.p")
THEN DO:
     run pi-recupera-campo (input  p_wgh_frame,
                            input  "fill-in",
                            input  "cod_cta_ctbl",
                            output h_cod_cta_ctbl).

    CREATE TOGGLE-BOX wh_ind_ariba
    ASSIGN FRAME     = p_wgh_frame
           NAME      = "wh_ind_ariba"
           HEIGHT    = 0.88
           WIDTH     = 7
           ROW       = 1.45
           COL       = 62.00
           LABEL     = "Ariba"
           VISIBLE   = YES
           SENSITIVE = NO
           CHECKED   = NO.

    IF VALID-HANDLE(h_cod_cta_ctbl)
    THEN wh_ind_ariba:MOVE-AFTER-TAB-ITEM(h_cod_cta_ctbl).   

    ASSIGN wh_ind_ariba:SENSITIVE = c_objeto <> "utb080jb.p".
END.

IF  p_ind_event  = "display"
AND p_ind_object = "viewer"
AND NOT (c_objeto <> "utb080fb.p" AND
         c_objeto <> "utb080jb.p")
AND VALID-HANDLE(wh_ind_ariba)
THEN do:
     ASSIGN wh_ind_ariba:CHECKED = NO.

     FOR FIRST cta_ctbl NO-LOCK
         WHERE RECID(cta_ctbl) = p_rec_table,
         FIRST int_cta_ctbl NO-LOCK
         WHERE int_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
           AND int_cta_ctbl.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl:
         ASSIGN wh_ind_ariba:CHECKED = int_cta_ctbl.ind_ariba.
     END. /* FOR FIRST cta_ctbl */
END.

IF  p_ind_event  = "validate"
AND p_ind_object = "viewer"
AND VALID-HANDLE(wh_ind_ariba)
AND NOT (c_objeto <> "utb080db.p" AND
         c_objeto <> "utb080fb.p")
THEN IF wh_ind_ariba:FRAME = p_wgh_frame
     THEN FOR FIRST cta_ctbl NO-LOCK
              WHERE RECID(cta_ctbl) = p_rec_table:
              FOR FIRST int_cta_ctbl
                  WHERE int_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
                    AND int_cta_ctbl.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl
                        EXCLUSIVE-LOCK: END.
        
              IF NOT AVAIL int_cta_ctbl
              THEN DO:
                   CREATE int_cta_ctbl.
                   ASSIGN int_cta_ctbl.cod_plano_cta_ctbl = cta_ctbl.cod_plano_cta_ctbl
                          int_cta_ctbl.cod_cta_ctbl       = cta_ctbl.cod_cta_ctbl.
              END. /* IF NOT AVAIL int_cta_ctbl */
        
              ASSIGN int_cta_ctbl.ind_ariba = wh_ind_ariba:CHECKED.
              FIND CURRENT int_cta_ctbl NO-LOCK NO-ERROR.
              RELEASE int_cta_ctbl.
          END. /* FOR FIRST cta_ctbl */
     ELSE run utp/ut-msgs.p (input "show", input 17567, input "Ocorreu uma inconsistància. Campo ARIBA n∆o foi salvo!").                      

/********** PROCEDURES **********/
procedure pi-recupera-campo:
   define input  parameter pWghFrame as widget-handle no-undo.
   define input  parameter pObjType  as character     no-undo.
   define input  parameter pObjName  as character     no-undo.
   define output parameter phObj     as handle        no-undo.

   define variable wgh-obj as widget-handle no-undo.

   assign wgh-obj = pWghFrame:first-child.

   do while valid-handle(wgh-obj):
       if  wgh-obj:type = pObjType 
       and wgh-obj:name = pObjName 
       then do:
            assign phObj = wgh-obj:handle.

            leave.
       end.

       if wgh-obj:type = "FIELD-GROUP":U 
       then assign wgh-obj = wgh-obj:first-child.
       else assign wgh-obj = wgh-obj:next-sibling.
   end.

   assign wgh-obj = ?.

   return "OK":U.
end procedure. /* procedure pi-recupera-campo */





