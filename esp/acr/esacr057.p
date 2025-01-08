/*****************************************************************************
** Descricao.............: Importa‡Æo Limites HSBC
** Versao................:  1.00.00.000
** Nome Externo..........: esp/acr/esacr057.p
** Criado por............: Fabiano Sakae Ribeiro (Exponencial TI)
** Criado em.............: 22/01/2013
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

/************************ Temp-Table Definition Begin ***********************/

DEF TEMP-TABLE tt_message_import
    FIELD tta_num_sequence   AS INTEGER   FORMAT ">>>9":U    LABEL "Seqˆncia":U     COLUMN-LABEL "Seq":U      VIEW-AS FILL-IN SIZE  8.00 BY 0.88 TOOLTIP "Seqˆncia":U
    FIELD tta_msg_type       AS CHARACTER FORMAT "x(11)":U   LABEL "Tipo Mensagem":U COLUMN-LABEL "Tp Msg":U   VIEW-AS FILL-IN SIZE 10.00 BY 0.88 TOOLTIP "Tipo de Mensagem":U
    FIELD tta_num_row_import AS INTEGER   FORMAT ">>>,>>9":U LABEL "Linha":U         COLUMN-LABEL "Linha":U    VIEW-AS FILL-IN SIZE 10.00 BY 0.88 TOOLTIP "Linha":U
    FIELD tta_message        AS CHARACTER FORMAT "x(80)":U   LABEL "Mensagem":U      COLUMN-LABEL "Mensagem":U VIEW-AS FILL-IN SIZE 60.00 BY 0.88 TOOLTIP "Mensagem":U
    FIELD tta_help           AS CHARACTER FORMAT "x(300)":U  LABEL "Ajuda":U         COLUMN-LABEL "Ajuda":U    VIEW-AS EDITOR  SIZE 40.00 BY 5.00 TOOLTIP "Ajuda":U
    INDEX idx_primary IS PRIMARY UNIQUE
        tta_num_sequence
    INDEX idx_num_row_import
        tta_num_row_import
        tta_num_sequence.

DEF TEMP-TABLE tt_int_emitente_hsbc_limite LIKE int-emitente-hsbc-limite.

/************************ Temp-Table Definition End *************************/

/************************* Variable Definition Begin ************************/

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER   NO-UNDO
    FORMAT "x(3)":U
    LABEL "Empresa":U COLUMN-LABEL "Empresa":U.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO
    FORMAT "x(12)":U
    LABEL "Usu rio Corrente":U COLUMN-LABEL "Usu rio Corrente":U.

DEFINE VARIABLE v_file_name AS CHARACTER   NO-UNDO
    FORMAT "x(256)":U
    LABEL "Nome Arquivo":U COLUMN-LABEL "Nome Arq":U
    VIEW-AS EDITOR MAX-CHARS 250 NO-WORD-WRAP SIZE 55.00 BY 0.88
    BGCOLOR 15
    FONT 2.

DEFINE VARIABLE v_today AS DATE LABEL "Data Limite" INITIAL TODAY FORMAT "99/99/9999" NO-UNDO. /* Local */
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
    TOOLTIP "Pesquisar Arquivo"
    SIZE 4.00 BY 1.10
    FONT ?.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

DEFINE FRAME f_bas_10_histor_fornec_import_ems
    rt_rgf         AT ROW 1.00 COLUMN  1.00
    rt_mold        AT ROW 2.50 COLUMN  2.00
    v_today        AT ROW 3    COLUMN 15.00 COLON-ALIGNED HELP "Data Limite":U 
    v_file_name    AT ROW 4    COLUMN 15.00 COLON-ALIGNED HELP "Nome Arquivo":U
    bt_search_file AT ROW 4    COLUMN 72.14               HELP "Pesquisar arquivo Lista Cliente":U
    bt_rnl1        AT ROW 1.08 COLUMN  2.14               HELP "Executar":U
    bt_exi         AT ROW 1.10 COLUMN 76.34               HELP "Sa¡da":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
        SIZE-CHAR 80.72 BY 6.00
        AT ROW 2.25 COLUMN 1.00
        FONT 1 FGCOLOR ? BGCOLOR 17
        TITLE "Importa‡Æo Limites HSBC (ESACR057) - ":U.

/* Adjust size of objects in this frame */
ASSIGN v_today:WIDTH-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems =  9.50
       bt_exi:WIDTH-CHARS   IN FRAME f_bas_10_histor_fornec_import_ems =  4.00
       bt_exi:HEIGHT-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems =  1.13
       bt_rnl1:WIDTH-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems =  4.00
       bt_rnl1:HEIGHT-CHARS IN FRAME f_bas_10_histor_fornec_import_ems =  1.13
       rt_rgf:WIDTH-CHARS   IN FRAME f_bas_10_histor_fornec_import_ems = 80.44
       rt_rgf:HEIGHT-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems =  1.29
       rt_mold:WIDTH-CHARS  IN FRAME f_bas_10_histor_fornec_import_ems = 78.44
       rt_mold:HEIGHT-CHARS IN FRAME f_bas_10_histor_fornec_import_ems =  3.00.

/* Set private-data for the help system */
ASSIGN bt_rnl1:PRIVATE-DATA        IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       bt_exi:PRIVATE-DATA         IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       v_file_name:PRIVATE-DATA    IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       bt_search_file:PRIVATE-DATA IN FRAME f_bas_10_histor_fornec_import_ems = "HLP=000000000":U
       FRAME f_bas_10_histor_fornec_import_ems:PRIVATE-DATA                   = "HLP=000000000":U.

ASSIGN bt_exi:FLAT-BUTTON  IN FRAME f_bas_10_histor_fornec_import_ems = YES
       bt_rnl1:FLAT-BUTTON IN FRAME f_bas_10_histor_fornec_import_ems = YES.

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON "CHOOSE":U OF bt_search_file IN FRAME f_bas_10_histor_fornec_import_ems OR
   "F5":U     OF v_file_name    IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_cod_get_file AS CHARACTER   NO-UNDO. /* Local */
    DEFINE VARIABLE v_log_pressed  AS LOGICAL     NO-UNDO. /* Local */

    /************************** Variable Definition End *************************/
    
    SYSTEM-DIALOG GET-FILE v_cod_get_file
        FILTERS "CSV (separado por ponto e v¡rgula) (*.csv)":U "*.csv":U,
                "Todos os arquivos (*.*)":U                    "*.*":U
        INITIAL-DIR SESSION:TEMP-DIRECTORY
        MUST-EXIST
        TITLE "Abrir":U
        UPDATE v_log_pressed.

    IF v_log_pressed THEN DO:
        ASSIGN v_file_name = v_cod_get_file.

        DISPLAY v_file_name
            WITH FRAME f_bas_10_histor_fornec_import_ems.

        APPLY "ENTRY":U TO v_file_name IN FRAME f_bas_10_histor_fornec_import_ems.
    END.

END. /* ON "CHOOSE":U OF bt_search_file IN FRAME f_bas_10_histor_fornec_import_ems OR
           "F5":U     OF v_file_name    IN FRAME f_bas_10_histor_fornec_import_ems DO: */

ON "LEAVE":U OF v_file_name IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

END. /* ON "LEAVE":U OF v_file_name IN FRAME f_bas_10_histor_fornec_import_ems DO: */

ON "CHOOSE":U OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

    RUN pi_close_program.

END. /* ON "CHOOSE":U OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems DO: */

ON "CHOOSE":U OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems DO:

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_row_import           AS CHARACTER   NO-UNDO. /* Local */
    DEFINE VARIABLE v_num_row_import       AS INTEGER     NO-UNDO. /* Local */
    DEFINE VARIABLE v_num_sequence         AS INTEGER     NO-UNDO. /* Local */
    DEFINE VARIABLE v_limite               AS CHARACTER   NO-UNDO. /* Local */
    DEFINE VARIABLE v_id_federal           AS CHARACTER   NO-UNDO. /* Local */
    DEFINE VARIABLE v_val_limite           AS DECIMAL     NO-UNDO. /* Local */
    DEFINE VARIABLE v_val_limite_utilizado AS DECIMAL     NO-UNDO. /* Local */
    DEFINE VARIABLE l_resp                 AS LOGICAL     NO-UNDO. /* Local */
    DEFINE VARIABLE i_aux                  AS INTEGER     NO-UNDO. /* Local */
    DEFINE VARIABLE c_aux                  AS CHARACTER   NO-UNDO. /* Local */

    /************************** Variable Definition End *************************/

    ASSIGN INPUT FRAME f_bas_10_histor_fornec_import_ems v_file_name
           INPUT FRAME f_bas_10_histor_fornec_import_ems v_today.

    FILE-INFO:FILE-NAME = v_file_name.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "F":U) = 0    THEN DO:
        MESSAGE "Arquivo nÆo encontrado!":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

        RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    FOR EACH tt_message_import:
        DELETE tt_message_import.
    END.

    FOR EACH tt_int_emitente_hsbc_limite:
        DELETE tt_int_emitente_hsbc_limite.
    END.

    ASSIGN v_num_sequence   = 0
           v_num_row_import = 0
           v_today          = TODAY
           v_limite         = "Limite":U.

    INPUT FROM VALUE(v_file_name) CONVERT TARGET "ibm850":U.
    import_block:
    REPEAT:
        IMPORT UNFORMATTED v_row_import.

        ASSIGN v_num_row_import = v_num_row_import + 1.

        IF v_row_import BEGINS "INTELBRAS":U THEN DO:
            IF NUM-ENTRIES(v_row_import, ";":U) < 9 THEN DO:
                CREATE tt_message_import.
                ASSIGN v_num_sequence                       = v_num_sequence + 1
                       tt_message_import.tta_num_sequence   = v_num_sequence
                       tt_message_import.tta_msg_type       = "Erro":U
                       tt_message_import.tta_num_row_import = v_num_row_import
                       tt_message_import.tta_message        = "Falta(m) coluna(s) para importa‡Æo.":U
                       tt_message_import.tta_help           = "Para importa‡Æo da linha, necessita-se ter a 5¦ com o CNPJ/CPF, a 8¦ coluna com o Valor do Limite e a 9¦ com o STATUS.":U
                       v_id_federal                         = "":U.

                NEXT import_block.
            END.

            ASSIGN c_aux = TRIM(ENTRY(9, v_row_import, ";":U)) NO-ERROR.
            IF c_aux <> "Ativo" 
               THEN NEXT.

            ASSIGN c_aux = TRIM(ENTRY(5, v_row_import, ";":U)) NO-ERROR.

            /* Remover car cteres especiais e letras - In¡cio */
            DO i_aux = 1 TO 47:
                ASSIGN c_aux = REPLACE(c_aux, CHR(i_aux), "":U).
            END.

            DO i_aux = 58 TO 255:
                ASSIGN c_aux = REPLACE(c_aux, CHR(i_aux), "":U).
            END.
            /* Remover car cteres especiais e letras - Final */

            ASSIGN v_id_federal = TRIM(c_aux) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                CREATE tt_message_import.
                ASSIGN v_num_sequence                       = v_num_sequence + 1
                       tt_message_import.tta_num_sequence   = v_num_sequence
                       tt_message_import.tta_msg_type       = "Erro":U
                       tt_message_import.tta_num_row_import = v_num_row_import
                       tt_message_import.tta_message        = "Campo ~"CNPJ/CPF~" com tipo de dado inv lido!":U
                       tt_message_import.tta_help           = "A informa‡Æo do campo ~"CNPJ/CPF~" deve ser em formato car cter.":U
                       v_id_federal                         = "":U.
            END.
            ELSE IF v_id_federal = "":U THEN DO:
                CREATE tt_message_import.
                ASSIGN v_num_sequence                       = v_num_sequence + 1
                       tt_message_import.tta_num_sequence   = v_num_sequence
                       tt_message_import.tta_msg_type       = "Erro":U
                       tt_message_import.tta_num_row_import = v_num_row_import
                       tt_message_import.tta_message        = "Campo ~"CNPJ/CPF~" em branco!":U
                       tt_message_import.tta_help           = "A informa‡Æo do campo ~"CNPJ/CPF~" deve ser informado.":U.
            END.

            ASSIGN c_aux = TRIM(ENTRY(8, v_row_import, ";":U)) NO-ERROR.

            DO i_aux = 1 TO 42:
                ASSIGN c_aux = REPLACE(c_aux, CHR(i_aux), "":U).
            END.

            DO i_aux = 58 TO 255:
                ASSIGN c_aux = REPLACE(c_aux, CHR(i_aux), "":U).
            END.

            ASSIGN v_val_limite = DECIMAL(TRIM(c_aux)) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                CREATE tt_message_import.
                ASSIGN v_num_sequence                       = v_num_sequence + 1
                       tt_message_import.tta_num_sequence   = v_num_sequence
                       tt_message_import.tta_msg_type       = "Erro":U
                       tt_message_import.tta_num_row_import = v_num_row_import
                       tt_message_import.tta_message        = "Campo ~"Valor Limite~" com tipo de dado inv lido!":U
                       tt_message_import.tta_help           = "A informa‡Æo do campo ~"Valor Limite~" deve ser em formato num‚rico.":U
                       v_val_limite                         = 0.0.
            END.

            ASSIGN c_aux = TRIM(ENTRY(7, v_row_import, ";":U)) NO-ERROR.

            DO i_aux = 1 TO 42:
                ASSIGN c_aux = REPLACE(c_aux, CHR(i_aux), "":U).
            END.

            DO i_aux = 58 TO 255:
                ASSIGN c_aux = REPLACE(c_aux, CHR(i_aux), "":U).
            END.

            ASSIGN v_val_limite_utilizado = DECIMAL(TRIM(c_aux)) NO-ERROR.

            IF ERROR-STATUS:ERROR THEN DO:
                CREATE tt_message_import.
                ASSIGN v_num_sequence                       = v_num_sequence + 1
                       tt_message_import.tta_num_sequence   = v_num_sequence
                       tt_message_import.tta_msg_type       = "Erro":U
                       tt_message_import.tta_num_row_import = v_num_row_import
                       tt_message_import.tta_message        = "Campo ~"Valor Limite Utilizado~" com tipo de dado inv lido!":U
                       tt_message_import.tta_help           = "A informa‡Æo do campo ~"Valor Limite Utilizado~" deve ser em formato num‚rico.":U
                       v_val_limite_utilizado               = 0.0.
            END.

            IF v_id_federal <> "":U AND
               v_id_federal <> ?    THEN DO:
                FIND FIRST emscad.cliente
                    WHERE emscad.cliente.cod_pais     = "BRA":U
                      AND emscad.cliente.cod_id_feder = v_id_federal NO-LOCK NO-ERROR.

                IF NOT AVAILABLE emscad.cliente THEN DO:
                    CREATE tt_message_import.
                    ASSIGN v_num_sequence                       = v_num_sequence + 1
                           tt_message_import.tta_num_sequence   = v_num_sequence
                           tt_message_import.tta_msg_type       = "Erro":U
                           tt_message_import.tta_num_row_import = v_num_row_import
                           tt_message_import.tta_message        = "NÆo foi encontrado cliente com o CNPJ/CPF informado!":U
                           tt_message_import.tta_help           = "O CNPJ/CPF ":U + TRIM(ENTRY(5, v_row_import, ";":U)) + " nÆo foi encontrado no registro de clientes.":U.
                END.
            END.

            IF NOT CAN-FIND(FIRST tt_message_import
                            WHERE tt_message_import.tta_num_row_import = v_num_row_import
                              AND tt_message_import.tta_msg_type       = "Erro":U) THEN DO:
                FIND FIRST int-emitente-hsbc-limite
                    WHERE int-emitente-hsbc-limite.cod-emitente   = emscad.cliente.cdn_cliente
                      AND int-emitente-hsbc-limite.dat-ocorrencia = v_today
                      AND int-emitente-hsbc-limite.ind-tipo       = v_limite NO-LOCK NO-ERROR.

                IF AVAILABLE int-emitente-hsbc-limite THEN DO:
                    CREATE tt_message_import.
                    ASSIGN v_num_sequence                       = v_num_sequence + 1
                           tt_message_import.tta_num_sequence   = v_num_sequence
                           tt_message_import.tta_msg_type       = "Alerta":U
                           tt_message_import.tta_num_row_import = v_num_row_import
                           tt_message_import.tta_message        = "Foi encontrado registro de limite HSBC para cliente na data de hoje.":U
                           tt_message_import.tta_help           = "O CNPJ/CPF ~"":U + TRIM(ENTRY(5, v_row_import, ";":U)) + "~" (Cliente ":U + TRIM(STRING(emscad.cliente.cdn_cliente)) + " - ":U + emscad.cliente.nom_abrev + ") j  teve o limite importado para a data de hoje. Logo, caso seja efetivada a importa‡Æo, o registro ser  sobreposto.":U.
                END.

                FIND FIRST tt_int_emitente_hsbc_limite
                    WHERE tt_int_emitente_hsbc_limite.cod-emitente   = emscad.cliente.cdn_cliente
                      AND tt_int_emitente_hsbc_limite.dat-ocorrencia = v_today
                      AND tt_int_emitente_hsbc_limite.ind-tipo       = v_limite NO-ERROR.

                IF AVAILABLE tt_int_emitente_hsbc_limite THEN DO:
                    CREATE tt_message_import.
                    ASSIGN v_num_sequence                       = v_num_sequence + 1
                           tt_message_import.tta_num_sequence   = v_num_sequence
                           tt_message_import.tta_msg_type       = "Alerta":U
                           tt_message_import.tta_num_row_import = v_num_row_import
                           tt_message_import.tta_message        = "Foi encontrado registro de limite HSBC com CNPJ/CPF duplicado no arquivo importado.":U
                           tt_message_import.tta_help           = "O CNPJ/CPF ~"":U + TRIM(ENTRY(5, v_row_import, ";":U)) + " (Cliente ~"":U + TRIM(STRING(emscad.cliente.cdn_cliente)) + " - ":U + emscad.cliente.nom_abrev + ") est  duplicado no arquivo importado. Logo, caso seja efetivada a importa‡Æo, valer  o primeiro registro encontrado.":U.

                    NEXT import_block.
                END.
                ELSE DO:
                    CREATE tt_int_emitente_hsbc_limite.
                    ASSIGN tt_int_emitente_hsbc_limite.cod-emitente         = emscad.cliente.cdn_cliente
                           tt_int_emitente_hsbc_limite.dat-ocorrencia       = v_today
                           tt_int_emitente_hsbc_limite.ind-tipo             = v_limite
                           tt_int_emitente_hsbc_limite.val-limite           = v_val_limite
                           tt_int_emitente_hsbc_limite.val-limite-utilizado = v_val_limite_utilizado
                           tt_int_emitente_hsbc_limite.cod-usuario          = v_cod_usuar_corren.
                END.
            END.
        END.
    END.
    INPUT CLOSE.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    ASSIGN l_resp = YES.

    IF CAN-FIND(FIRST tt_message_import) THEN DO:
        ASSIGN l_resp = NO.

        RUN pi_display_message.

        IF CAN-FIND(FIRST tt_int_emitente_hsbc_limite) THEN DO:
            MESSAGE "Foi(ram) gerado(s) mensagem(s) de alerta para o arquivo importado.":U SKIP
                    "Deseja efetivar a importa‡Æo do(s) registros SEM erro?":U
                UPDATE l_resp
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Pergunta":U.

            IF NOT l_resp THEN DO:
                MESSAGE "Importa‡Æo abortada!":U
                    VIEW-AS ALERT-BOX WARNING BUTTONS OK.

                RETURN.
            END.
        END.
    END.

    IF NOT CAN-FIND(FIRST tt_int_emitente_hsbc_limite) THEN DO:
        MESSAGE "NÆo existe(m) registro(s) para ser(em) importado(s).":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

        ASSIGN l_resp = NO.
    END.

    IF l_resp THEN DO:
        IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

        FOR EACH int-emitente-hsbc-limite EXCLUSIVE-LOCK
            WHERE int-emitente-hsbc-limite.dat-ocorrencia = v_today
              AND int-emitente-hsbc-limite.ind-tipo       = v_limite:
            DELETE int-emitente-hsbc-limite.
        END.

        FOR EACH tt_int_emitente_hsbc_limite:
            FIND FIRST int-emitente-hsbc-limite
                WHERE int-emitente-hsbc-limite.cod-emitente   = tt_int_emitente_hsbc_limite.cod-emitente
                  AND int-emitente-hsbc-limite.dat-ocorrencia = tt_int_emitente_hsbc_limite.dat-ocorrencia
                  AND int-emitente-hsbc-limite.ind-tipo       = tt_int_emitente_hsbc_limite.ind-tipo EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE int-emitente-hsbc-limite THEN DO:
                CREATE int-emitente-hsbc-limite.
                ASSIGN int-emitente-hsbc-limite.cod-emitente   = tt_int_emitente_hsbc_limite.cod-emitente
                       int-emitente-hsbc-limite.dat-ocorrencia = tt_int_emitente_hsbc_limite.dat-ocorrencia
                       int-emitente-hsbc-limite.ind-tipo       = tt_int_emitente_hsbc_limite.ind-tipo.
            END.

            ASSIGN int-emitente-hsbc-limite.val-limite           = tt_int_emitente_hsbc_limite.val-limite
                   int-emitente-hsbc-limite.val-limite-utilizado = tt_int_emitente_hsbc_limite.val-limite-utilizado
                   int-emitente-hsbc-limite.cod-usuario          = tt_int_emitente_hsbc_limite.cod-usuario.
        END.

        IF SESSION:SET-WAIT-STATE("":U) THEN.

        MESSAGE "Importa‡Æo realizada com sucesso!":U
            VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Informa‡Æo":U.
    END.

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

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

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

ENABLE bt_rnl1
       bt_exi
       v_today
       v_file_name
       bt_search_file
    WITH FRAME f_bas_10_histor_fornec_import_ems.

DISPLAY v_today
        v_file_name
        bt_search_file
    WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
DO ON ENDKEY UNDO main_block, LEAVE main_block
   ON ERROR  UNDO main_block, LEAVE main_block:
    ASSIGN v_file_name:READ-ONLY IN FRAME f_bas_10_histor_fornec_import_ems = NO.

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR "CHOOSE":U OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems.
END.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_display_message :
    DEFINE VARIABLE v_filter_msg AS CHARACTER   NO-UNDO
        FORMAT "x(11)":U
        INITIAL "Todos":U
        LABEL "Filtro":U
        VIEW-AS RADIO-SET HORIZONTAL
            RADIO-BUTTONS "Todos":U, "Todos":U, "Erro":U, "Erro":U, "Alerta":U, "Alerta":U, "Informa‡Æo":U, "Informa‡Æo":U
        SIZE 35 BY 0.83.

    DEFINE QUERY qr_message_import_msg FOR tt_message_import SCROLLING.

    DEFINE BROWSE br_message_import_msg
        QUERY qr_message_import_msg NO-LOCK
        DISPLAY tt_message_import.tta_num_sequence   WIDTH  4.25
                tt_message_import.tta_msg_type
                tt_message_import.tta_num_row_import
                tt_message_import.tta_message        WIDTH 60.00
            WITH NO-ASSIGN SEPARATORS SIZE 60 BY 4.50.

    DEFINE VARIABLE v_help_msg AS CHARACTER   NO-UNDO
        FORMAT "x(300)":U
        LABEL "Ajuda":U COLUMN-LABEL "Ajuda":U
        VIEW-AS EDITOR SIZE 60 BY 3 SCROLLBAR-VERTICAL TOOLTIP "Ajuda":U.

    DEFINE BUTTON bt_exit_msg AUTO-END-KEY
        LABEL "&Sair":U
        SIZE 10.00 BY 1.00
        BGCOLOR 8.

    DEFINE RECTANGLE rt_button_msg
        EDGE-PIXELS 2 GRAPHIC-EDGE
        SIZE 62 BY 1.42
        BGCOLOR 7.

    DEFINE FRAME f_dialog_msg
        v_filter_msg          AT ROW  1.17 COLUMN 2.00
        br_message_import_msg AT ROW  2.17 COLUMN 2.00
        "Ajuda:":U            AT ROW  6.75 COLUMN 2.00
        v_help_msg            AT ROW  7.50 COLUMN 2.00 NO-LABEL
        bt_exit_msg           AT ROW 11.18 COLUMN 2.14
        rt_button_msg         AT ROW 10.93 COLUMN 1.00
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE
            THREE-D SCROLLABLE TITLE "Mensagem (5.06.00.000)":U FONT 1
            BGCOLOR 8
            CANCEL-BUTTON bt_exit_msg.

    ON "VALUE-CHANGED":U OF v_filter_msg IN FRAME f_dialog_msg DO:
        ASSIGN INPUT FRAME f_dialog_msg v_filter_msg.

        OPEN QUERY qr_message_import_msg
            FOR EACH tt_message_import NO-LOCK
                WHERE tt_message_import.tta_msg_type = v_filter_msg
                   OR v_filter_msg                   = "Todos":U INDEXED-REPOSITION.

        APPLY "ENTRY":U         TO br_message_import_msg IN FRAME f_dialog_msg.
        APPLY "VALUE-CHANGED":U TO br_message_import_msg IN FRAME f_dialog_msg.
        APPLY "ENTRY":U         TO v_filter_msg          IN FRAME f_dialog_msg.
    END.

    ON "VALUE-CHANGED":U OF br_message_import_msg IN FRAME f_dialog_msg DO:
        IF AVAILABLE tt_message_import THEN
            ASSIGN v_help_msg = tt_message_import.tta_help.
        ELSE
            ASSIGN v_help_msg = "":U.

        DISPLAY v_help_msg
            WITH FRAME f_dialog_msg.
    END.

    ON "WINDOW-CLOSE":U OF FRAME f_dialog_msg
        APPLY "END-ERROR":U TO FRAME f_dialog_msg.

    ASSIGN br_message_import_msg:ALLOW-COLUMN-SEARCHING IN FRAME f_dialog_msg = YES
           br_message_import_msg:COLUMN-MOVABLE         IN FRAME f_dialog_msg = NO
           br_message_import_msg:COLUMN-RESIZABLE       IN FRAME f_dialog_msg = YES
           v_help_msg:READ-ONLY                         IN FRAME f_dialog_msg = YES
           v_help_msg:BGCOLOR                           IN FRAME f_dialog_msg = 15.

    ENABLE v_filter_msg
           br_message_import_msg
           v_help_msg
           bt_exit_msg
        WITH FRAME f_dialog_msg.

    DISPLAY v_filter_msg
        WITH FRAME f_dialog_msg.

    APPLY "VALUE-CHANGED":U TO v_filter_msg IN FRAME f_dialog_msg.
    APPLY "ENTRY":U         TO bt_exit_msg  IN FRAME f_dialog_msg.

    WAIT-FOR "GO":U OF FRAME f_dialog_msg.

END PROCEDURE. /* pi_display_error */

PROCEDURE pi_close_program :

    /************************ Parameter Definition Begin ************************/

    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    /************************** Variable Definition End *************************/

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

PROCEDURE pi_messages :

    /************************ Parameter Definition Begin ************************/

    DEFINE INPUT  PARAMETER c_action AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER i_msg    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER c_param  AS CHARACTER   NO-UNDO.

    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE c_prg_msg AS CHARACTER   NO-UNDO. /* Local */

    /************************* Variable Definition Begin ************************/

    ASSIGN c_prg_msg = "messages/":U + STRING(TRUNCATE(i_msg / 1000, 0), "99":U) + "/msg":U + STRING(i_msg, "99999":U).

    IF SEARCH(c_prg_msg + ".r":U) = ? AND
       SEARCH(c_prg_msg + ".p":U) = ? THEN DO:
        MESSAGE "Mensagem nr. ":U i_msg "!!!":U SKIP
                "Programa Mensagem":U c_prg_msg "nÆo encontrado.":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        RETURN ERROR.
    END.

    RUN VALUE(c_prg_msg + ".p":U) (INPUT c_action,
                                   INPUT c_param).

    RETURN RETURN-VALUE.

END PROCEDURE. /* pi_messages */

/*************************** Internal Procedure End *************************/
