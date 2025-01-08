/*****************************************************************************
** Descricao.............: Exporta‡Æo BECOMEX
** Versao................:  1.00.00.000
** Nome Externo..........: esp/fgl/esfgl002.p
*****************************************************************************/

/******************************* Private-Data *******************************/
ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "HLP=00":U.
/*************************************  *************************************/

/************************** Window Definition Begin *************************/

DEFINE VARIABLE wh_w_program AS WIDGET-HANDLE NO-UNDO.

IF SESSION:WINDOW-SYSTEM <> "TTY":U THEN DO:
    CREATE WINDOW wh_w_program
    ASSIGN ROW                  =   1.00
           COLUMN               =   1.00
           HEIGHT-CHARS         =   1.00
           WIDTH-CHARS          =   1.00
           MIN-WIDTH-CHARS      =   1.00
           MIN-HEIGHT-CHARS     =   1.00
           MAX-WIDTH-CHARS      =   1.00
           MAX-HEIGHT-CHARS     =   1.00
           VIRTUAL-WIDTH-CHARS  = 300.00
           VIRTUAL-HEIGHT-CHARS = 200.00
           TITLE                = "Program":U
           RESIZE               = YES
           SCROLL-BARS          = NO
           STATUS-AREA          = YES
           STATUS-AREA-FONT     = ?
           MESSAGE-AREA         = NO
           MESSAGE-AREA-FONT    = ?
           FGCOLOR              = ?
           BGCOLOR              = ?.
END.

/*************************** Window Definition End **************************/

/************************* Variable Definition Begin ************************/

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER   NO-UNDO
    FORMAT "x(3)":U
    LABEL "Empresa":U COLUMN-LABEL "Empresa":U.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO
    FORMAT "x(12)":U
    LABEL "Usu rio Corrente":U COLUMN-LABEL "Usu rio Corrente":U.

DEFINE VARIABLE v_dir_name AS CHARACTER   NO-UNDO
    FORMAT "x(256)":U
    LABEL "Diret¢rio Destino":U COLUMN-LABEL "Nome Arq":U
    VIEW-AS EDITOR MAX-CHARS 250 NO-WORD-WRAP SIZE 55.00 BY 0.88
    BGCOLOR 15
    FONT 2.

DEFINE VARIABLE v_periodo AS CHAR LABEL "Per¡odo" FORMAT "99/9999" NO-UNDO
    BGCOLOR 15
    FONT 2. /* Local */

DEF STREAM s_export_1.
DEF STREAM s_export_2.

/************************** Variable Definition End *************************/

/************************ Rectangle Definition Begin ************************/

DEFINE RECTANGLE rt_rgf
    EDGE-PIXELS 2
    SIZE 1.00 BY 1.00
    BGCOLOR 18.

DEFINE RECTANGLE rt_mold
    EDGE-PIXELS 2
    SIZE 1.00 BY 1.00.

/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

DEFINE BUTTON bt_exi
    LABEL "Sa¡da":U
    IMAGE-UP FILE "image/toolbar/im-exi.bmp":U
    IMAGE-DOWN FILE "image/toolbar/im-exi.bmp":U
    IMAGE-INSENSITIVE FILE "image/toolbar/ii-exi.bmp":U
    TOOLTIP "Sa¡da":U
    SIZE 1.00 BY 1.00
    FONT ?.

DEFINE BUTTON bt_rnl1
    LABEL "Executar":U
    IMAGE-UP FILE "image/toolbar/im-rnl.bmp":U
    IMAGE-DOWN FILE "image/toolbar/im-rnl.bmp":U
    IMAGE-INSENSITIVE FILE "image/toolbar/ii-rnl.bmp":U
    TOOLTIP "Executar":U
    SIZE 1.00 BY 1.00
    FONT ?.

DEFINE BUTTON bt_search_file
    LABEL "Pesquisar"
    IMAGE-UP FILE "image/im-sea2.bmp":U
    IMAGE-INSENSITIVE FILE "image/ii-sea2.bmp":U
    TOOLTIP "Pesquisar Diret¢rio"
    SIZE 4.00 BY 1.10
    FONT ?.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

DEFINE FRAME f_bas_10_histor_fornec_import_ems
    rt_rgf         AT ROW 1.00 COLUMN  1.00
    rt_mold        AT ROW 2.50 COLUMN  2.00
    v_periodo      AT ROW 3    COLUMN 15.00 COLON-ALIGNED HELP "Per¡odo":U 
    v_dir_name     AT ROW 4    COLUMN 15.00 COLON-ALIGNED HELP "Nome Diret¢rio":U
    bt_search_file AT ROW 4    COLUMN 72.14               HELP "Pesquisar Diret¢rio":U
    bt_rnl1        AT ROW 1.08 COLUMN  2.14               HELP "Executar":U
    bt_exi         AT ROW 1.10 COLUMN 76.34               HELP "Sa¡da":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
        SIZE-CHAR 80.72 BY 6.00
        AT ROW 2.25 COLUMN 1.00
        FONT 1 FGCOLOR ? BGCOLOR 17
        TITLE "Exporta‡Æo BECOMEX (ESFGL002) - ":U.

/* Adjust size of objects in this frame */
ASSIGN v_periodo:WIDTH-CHARS IN FRAME f_bas_10_histor_fornec_import_ems =  8
       bt_exi:WIDTH-CHARS    IN FRAME f_bas_10_histor_fornec_import_ems =  4.00
       bt_exi:HEIGHT-CHARS   IN FRAME f_bas_10_histor_fornec_import_ems =  1.13
       bt_rnl1:WIDTH-CHARS   IN FRAME f_bas_10_histor_fornec_import_ems =  4.00
       bt_rnl1:HEIGHT-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems =  1.13
       rt_rgf:WIDTH-CHARS    IN FRAME f_bas_10_histor_fornec_import_ems = 80.44
       rt_rgf:HEIGHT-CHARS   IN FRAME f_bas_10_histor_fornec_import_ems =  1.29
       rt_mold:WIDTH-CHARS   IN FRAME f_bas_10_histor_fornec_import_ems = 78.44
       rt_mold:HEIGHT-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems =  3.00.

/* Set private-data for the help system */
ASSIGN bt_rnl1:PRIVATE-DATA        IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       bt_exi:PRIVATE-DATA         IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       v_dir_name:PRIVATE-DATA     IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       bt_search_file:PRIVATE-DATA IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       FRAME f_bas_10_histor_fornec_import_ems:PRIVATE-DATA                   = "HLP=000000000":U.

ASSIGN bt_exi:FLAT-BUTTON  IN FRAME f_bas_10_histor_fornec_import_ems = YES
       bt_rnl1:FLAT-BUTTON IN FRAME f_bas_10_histor_fornec_import_ems = YES.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON "CHOOSE":U OF bt_search_file IN FRAME f_bas_10_histor_fornec_import_ems OR
   "F5":U     OF v_dir_name    IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_cod_get_file AS CHARACTER   NO-UNDO. /* Local */
    DEFINE VARIABLE v_log_pressed  AS LOGICAL     NO-UNDO. /* Local */

    /************************** Variable Definition End *************************/
    
    SYSTEM-DIALOG GET-DIR v_cod_get_file
        INITIAL-DIR SESSION:TEMP-DIRECTORY
        TITLE "Abrir":U
        UPDATE v_log_pressed.

    IF v_log_pressed THEN DO:
        ASSIGN v_dir_name = v_cod_get_file + "\".

        DISPLAY v_dir_name
            WITH FRAME f_bas_10_histor_fornec_import_ems.

        APPLY "ENTRY":U TO v_dir_name IN FRAME f_bas_10_histor_fornec_import_ems.
    END.

END. /* ON "CHOOSE":U OF bt_search_file IN FRAME f_bas_10_histor_fornec_import_ems OR
           "F5":U     OF v_dir_name    IN FRAME f_bas_10_histor_fornec_import_ems DO: */

ON "LEAVE":U OF v_dir_name IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

END. /* ON "LEAVE":U OF v_dir_name IN FRAME f_bas_10_histor_fornec_import_ems DO: */

ON "CHOOSE":U OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

    RUN pi_close_program.

END. /* ON "CHOOSE":U OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems DO: */

ON "CHOOSE":U OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/
    DEFINE VARIABLE v_dat_ini       AS DATE        NO-UNDO.
    DEFINE VARIABLE v_dat_fim       AS DATE        NO-UNDO.
    DEFINE VARIABLE v_des_histor    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_des_docto     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_ano       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_num_mes_refer AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cod_separador AS CHARACTER   NO-UNDO.
    /************************** Variable Definition End *************************/

    ASSIGN INPUT FRAME f_bas_10_histor_fornec_import_ems v_dir_name
           INPUT FRAME f_bas_10_histor_fornec_import_ems v_periodo.

    ASSIGN v_cod_separador = '"'.

    /* ** Calcula intervalo de datas ***/
    ASSIGN v_num_ano       = INT(SUBSTRING(v_periodo, 3, 4))
           v_num_mes_refer = INT(SUBSTRING(v_periodo, 1, 2)) + 1.

    IF v_num_mes_refer = 13
       THEN ASSIGN v_num_mes_refer = 1
                   v_num_ano       = v_num_ano + 1.

    /* ** Diminui um dia para pegar o £ltimo dia do mˆs anterior ***/
    ASSIGN v_dat_fim = DATE('01' + STRING(v_num_mes_refer, '99') + STRING(v_num_ano, '9999'))
           v_dat_fim = v_dat_fim - 1
           v_dat_ini = DATE('01' + SUBSTRING(v_periodo, 1, 2) + SUBSTRING(v_periodo, 3, 4)).

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    OUTPUT STREAM s_export_1 TO VALUE (v_dir_name + "blr_lancamento" + STRING(YEAR(v_dat_ini), '9999') + STRING(MONTH(v_dat_ini), '99') + ".txt") CONVERT TARGET "iso8859-1".
    OUTPUT STREAM s_export_2 TO VALUE (v_dir_name + "blr_lancamento_it" + STRING(YEAR(v_dat_ini), '9999') + STRING(MONTH(v_dat_ini), '99') + ".txt") CONVERT TARGET "iso8859-1".

    FOR EACH lancto_ctbl NO-LOCK  
        WHERE lancto_ctbl.cod_empresa      = v_cod_empres_usuar
          AND lancto_ctbl.dat_lancto_ctbl >= v_dat_ini 
          AND lancto_ctbl.dat_lancto_ctbl <= v_dat_fim
        BREAK BY lancto_ctbl.num_lote_ctbl:

        FIND lote_ctbl NO-LOCK
           WHERE lote_ctbl.cod_empresa   = lancto_ctbl.cod_empresa
             AND lote_ctbl.num_lote_ctbl = lancto_ctbl.num_lote_ctbl NO-ERROR.
        IF lote_ctbl.ind_sit_lote_ctbl <> "CTBZ"
           THEN NEXT.

        IF FIRST-OF(lancto_ctbl.num_lote_ctbl) 
        THEN DO:
             PUT STREAM s_export_1 UNFORMATTED "LANC;"
                                               STRING(lancto_ctbl.dat_lancto_ctbl, "99/99/9999") ";"
                                               TRIM(STRING(lote_ctbl.num_lote_ctbl) + "-" + STRING(MONTH(lancto_ctbl.dat_lancto_ctbl), "99"))  ";"
                                               lote_ctbl.cod_modul_dtsul                         ";"
                                               lote_ctbl.cod_usuar_ult_atualiz                   ";"
                                               STRING(lote_ctbl.dat_lote_ctbl, "99/99/9999") SKIP.
        END.
        item_lancto: 
        FOR EACH item_lancto_ctbl NO-LOCK  
           WHERE item_lancto_ctbl.num_lote_ctbl   = lancto_ctbl.num_lote_ctbl 
             AND item_lancto_ctbl.num_lancto_ctbl = lancto_ctbl.num_lancto_ctbl,
           FIRST aprop_lancto_ctbl NO-LOCK  
              WHERE aprop_lancto_ctbl.num_lote_ctbl       = item_lancto_ctbl.num_lote_ctbl 
                AND aprop_lancto_ctbl.num_lancto_ctbl     = item_lancto_ctbl.num_lancto_ctbl 
                AND aprop_lancto_ctbl.num_seq_lancto_ctbl = item_lancto_ctbl.num_seq_lancto_ctbl
                AND aprop_lancto_ctbl.cod_finalid_econ    = "Corrente":

           ASSIGN v_des_histor = TRIM(REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl, CHR(10), "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, "&", "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, "'", "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, '"', "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, "*", "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, "@", "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, "%", "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, "#", "")).
           ASSIGN v_des_histor = TRIM(REPLACE(v_des_histor, ";", ",")).

           ASSIGN v_des_docto = TRIM(REPLACE(item_lancto_ctbl.des_docto, CHR(10), "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, "&", "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, "'", "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, '"', "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, "*", "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, "@", "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, "%", "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, "#", "")).
           ASSIGN v_des_docto = TRIM(REPLACE(v_des_docto, ";", ",")).

           PUT STREAM s_export_2 UNFORMATTED "LANI;"
                                             STRING(lancto_ctbl.dat_lancto_ctbl, "99/99/9999") ";"
                                             TRIM(STRING(lote_ctbl.num_lote_ctbl) + "-" + STRING(MONTH(lancto_ctbl.dat_lancto_ctbl), "99"))           ";"
                                             INT(STRING(lancto_ctbl.num_lancto_ctbl, "999") + STRING(item_lancto_ctbl.num_seq_lancto_ctbl, "999999")) ";"
                                             TRIM(STRING(v_des_docto, "x(20)"))                ";"
                                             IF item_lancto_ctbl.dat_docto = ?                                                                        
                                                THEN ""                                                                                          
                                                ELSE STRING(item_lancto_ctbl.dat_docto, "99/99/9999") ";"
                                             item_lancto_ctbl.cod_cta_ctbl                            ";"                                                
                                             item_lancto_ctbl.cod_ccusto                              ";"                                                
                                             ";;"
                                             IF item_lancto_ctbl.ind_natur_lancto_ctbl = "CR"                                                         
                                                THEN TRIM(STRING(aprop_lancto_ctbl.val_lancto_ctbl * (-1), "->>>>>>>>>>9.99"))
                                                ELSE TRIM(STRING(aprop_lancto_ctbl.val_lancto_ctbl       , "->>>>>>>>>>9.99"))      
                                             ";"
                                             SUBSTRING(item_lancto_ctbl.ind_natur_lancto_ctbl, 1, 1) ";"                                                 
                                             TRIM(STRING(v_des_histor, "x(250)")) SKIP.

        END. 
    END. 

    OUTPUT STREAM s_export_1 CLOSE.
    OUTPUT STREAM s_export_2 CLOSE.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    MESSAGE "Arquivos gerados no diret¢rio: " v_dir_name
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RETURN.

END. /* ON "CHOOSE":U OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems DO: */

/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON "END-ERROR":U OF FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

    RUN pi_close_program.

END. /* ON "END-ERROR":U OF FRAME f_bas_10_histor_fornec_import_ems DO: */

/****************************** Frame Trigger End ***************************/

/*************************** Window Trigger Begin ***************************/

ON "WINDOW-CLOSE":U OF wh_w_program DO:

    APPLY "CHOOSE":U TO bt_exi IN FRAME f_bas_10_histor_fornec_import_ems.

END. /* ON "WINDOW-CLOSE":U OF wh_w_program DO: */

/**************************** Window Trigger End ****************************/

/****************************** Main Code Begin *****************************/

ASSIGN wh_w_program:TITLE                             = FRAME f_bas_10_histor_fornec_import_ems:TITLE + CHR(32) + CHR(40) + TRIM(" 1.00.00.000":U) + CHR(41)
       FRAME f_bas_10_histor_fornec_import_ems:TITLE  = ?
       wh_w_program:WIDTH-CHARS                       = FRAME f_bas_10_histor_fornec_import_ems:WIDTH-CHARS
       wh_w_program:HEIGHT-CHARS                      = FRAME f_bas_10_histor_fornec_import_ems:HEIGHT-CHARS - 0.85
       FRAME f_bas_10_histor_fornec_import_ems:ROW    = 1
       FRAME f_bas_10_histor_fornec_import_ems:COLUMN = 1
       wh_w_program:COLUMN                            = MAXIMUM((SESSION:WIDTH-CHARS  - wh_w_program:WIDTH-CHARS)  / 2, 1)
       wh_w_program:ROW                               = MAXIMUM((SESSION:HEIGHT-CHARS - wh_w_program:HEIGHT-CHARS) / 2, 1)
       CURRENT-WINDOW                                 = wh_w_program.

RUN pi_frame_settings (INPUT FRAME f_bas_10_histor_fornec_import_ems:HANDLE).

PAUSE 0 BEFORE-HIDE.

VIEW FRAME f_bas_10_histor_fornec_import_ems.

ASSIGN v_periodo = "012013"
       v_dir_name = SESSION:TEMP-DIRECTORY.

ENABLE bt_rnl1
       bt_exi
       v_periodo
       bt_search_file
    WITH FRAME f_bas_10_histor_fornec_import_ems.

DISPLAY v_periodo
        v_dir_name
        bt_search_file
    WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
DO ON ENDKEY UNDO main_block, LEAVE main_block
   ON ERROR  UNDO main_block, LEAVE main_block:
    ASSIGN v_dir_name:READ-ONLY IN FRAME f_bas_10_histor_fornec_import_ems = YES.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR "CHOOSE":U OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems.
END.

/******************************* Main Code End ******************************/

PROCEDURE pi_close_program :

    DELETE WIDGET wh_w_program.

    IF THIS-PROCEDURE:PERSISTENT THEN
        DELETE PROCEDURE THIS-PROCEDURE.

END PROCEDURE. /* pi_close_program */

PROCEDURE pi_frame_settings :

    /************************ Parameter Definition Begin ************************/

    DEFINE INPUT  PARAMETER p_wgh_frame AS WIDGET-HANDLE NO-UNDO
        FORMAT ">>>>>>9":U.

    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_wgh_child AS WIDGET-HANDLE NO-UNDO. /* Local */
    DEFINE VARIABLE v_wgh_group AS WIDGET-HANDLE NO-UNDO. /* Local */

    /************************** Variable Definition End *************************/

    ASSIGN v_wgh_group = p_wgh_frame:FIRST-CHILD.

    block_group:
    DO WHILE v_wgh_group <> ?:
        ASSIGN v_wgh_child = v_wgh_group:FIRST-CHILD.

        block_child:
        DO WHILE v_wgh_child <> ?:
            IF v_wgh_child:TYPE = "EDITOR":U THEN
                ASSIGN v_wgh_child:READ-ONLY = YES
                       v_wgh_child:SENSITIVE = YES.

            ASSIGN v_wgh_child = v_wgh_child:NEXT-SIBLING.
        END.

        ASSIGN v_wgh_group = v_wgh_group:NEXT-SIBLING.
    END.

END PROCEDURE. /* pi_frame_settings */

/*************************** Internal Procedure End *************************/
