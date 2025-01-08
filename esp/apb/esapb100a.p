/*****************************************************************************
** Programa..............: esapb100a.p - Confirmaá∆o Pagamento Pinho via WS
** Autor.................: Fabiano Sakae Ribeiro (Exponencial TI)
** Criado em.............: 26/03/2013
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/* Includes Definitions ---                                             */

/* Definiá∆o da Temp-Table "tt_mensagem" */
{esp/apb/esapb029.i}
{include/i_dbinst.i}
{include/i_dbtype.i}
{include/i_fcldef.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_mensagem_aux NO-UNDO LIKE tt_mensagem.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE i_cont      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i_sequencia AS INTEGER     NO-UNDO.

/* New Global Shared Variable Definitions ---                           */

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_bord_ap_upc AS RECID       NO-UNDO
    FORMAT ">>>>>>9":U
    INITIAL ?.


/* ***************************  Main Block  *************************** */

EMPTY TEMP-TABLE tt_mensagem.
EMPTY TEMP-TABLE tt_mensagem_aux.

FIND FIRST bord_ap
    WHERE RECID(bord_ap) = v_rec_bord_ap_upc NO-LOCK NO-ERROR.

IF NOT AVAILABLE bord_ap THEN DO:
    MESSAGE "Borderì n∆o localizado!":U
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    RETURN.
END.

IF bord_ap.ind_sit_bord_ap <> "Totalmente Baixado":U THEN DO:
    MESSAGE "Borderì n∆o est† Totalmente Baixado!":U
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    RETURN.
END.

IF NOT CAN-FIND(FIRST item_bord_ap OF bord_ap NO-LOCK
                WHERE item_bord_ap.cdn_fornec           = 5949
                  AND item_bord_ap.ind_sit_item_bord_ap = "Baixado":U) THEN DO:
    MESSAGE "Borderì n∆o possui pagamento para a PINHO!":U
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    RETURN.
END.

IF NOT CAN-FIND(FIRST item_bord_ap OF bord_ap NO-LOCK
                WHERE item_bord_ap.cdn_fornec            = 5949
                  AND item_bord_ap.ind_sit_item_bord_ap  = "Baixado":U
                  AND CAN-FIND(FIRST antecip_pef_pend NO-LOCK
                               WHERE antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
                                 AND antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef
                                 AND antecip_pef_pend.des_text_histor MATCHES "*#Remessa:*":U)) THEN DO:
    MESSAGE "N∆o existem T°tulos no Borderì com N£mero da Remessa!":U
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

    RETURN.
END.

trans-integracao:
FOR EACH item_bord_ap OF bord_ap NO-LOCK
    WHERE item_bord_ap.cdn_fornec            = 5949
      AND item_bord_ap.ind_sit_item_bord_ap  = "Baixado":U,
    FIRST antecip_pef_pend NO-LOCK
    WHERE antecip_pef_pend.cod_estab = item_bord_ap.cod_estab
      AND antecip_pef_pend.cod_refer = item_bord_ap.cod_refer_antecip_pef
      AND antecip_pef_pend.des_text_histor MATCHES "*#Remessa:*":U:

    DO i_cont = 1 TO NUM-ENTRIES(antecip_pef_pend.des_text_histor, "#":U):
        IF INDEX(TRIM(ENTRY(i_cont, antecip_pef_pend.des_text_histor, "#":U)), "Remessa:":U) > 0 THEN DO:
            RUN esp/apb/esapb029.p (INPUT  REPLACE(TRIM(ENTRY(i_cont, antecip_pef_pend.des_text_histor, "#":U)), "Remessa:":U, "":U), /* Remessa */
                                    INPUT  antecip_pef_pen.cod_tit_ap,                                                                /* Processo de Embarque */
                                    OUTPUT TABLE tt_mensagem).

            FOR EACH tt_mensagem:
                FIND LAST tt_mensagem_aux NO-ERROR.

                ASSIGN i_sequencia = IF AVAILABLE tt_mensagem_aux THEN tt_mensagem_aux.sequencia + 1 ELSE 1.

                CREATE tt_mensagem_aux.
                BUFFER-COPY tt_mensagem EXCEPT sequencia TO tt_mensagem_aux.
                ASSIGN tt_mensagem_aux.sequencia = i_sequencia.
            END.

            EMPTY TEMP-TABLE tt_mensagem.

            IF CAN-FIND(FIRST tt_mensagem_aux
                        WHERE tt_mensagem_aux.subtipo = "Sistema":U) THEN
                LEAVE trans-integracao.
        END.
    END.
END.

IF NOT CAN-FIND(FIRST tt_mensagem_aux
                WHERE tt_mensagem_aux.tipo <> "Informacao":U) THEN
    MESSAGE "Confirmaá∆o de Pagamento com a Pinho realizada com sucesso!":U
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE
    RUN pi_tela_mensagem IN THIS-PROCEDURE.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */

PROCEDURE pi_tela_mensagem PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Mostrar o conte£do da mensagem retornada pela API que conecta com
               o Web Service da Pinho.
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE BUTTON bt_ok AUTO-GO 
         LABEL "OK" 
         SIZE 10 BY 1 TOOLTIP "OK".

    DEFINE VARIABLE ed_ajuda AS CHARACTER 
         VIEW-AS EDITOR SCROLLBAR-VERTICAL
         SIZE 62 BY 4.17 TOOLTIP "Texto de ajuda da descriá∆o da mensagem"
         BGCOLOR 15  NO-UNDO.

    DEFINE IMAGE im_subtipo
         FILENAME "image/im-mqerr.bmp":U
         SIZE 5 BY 1.5.

    DEFINE RECTANGLE rt_cxcf
         EDGE-PIXELS 2 GRAPHIC-EDGE    
         SIZE 67 BY 1.42
         BGCOLOR 7 .

    DEFINE QUERY br_mensagem FOR 
          tt_mensagem_aux SCROLLING.

    DEFINE BROWSE br_mensagem
      QUERY br_mensagem DISPLAY
          tt_mensagem_aux.sequencia COLUMN-LABEL "Seq":U       FORMAT ">>,>>9":U
          tt_mensagem_aux.tipo      COLUMN-LABEL "Tipo":U      FORMAT "x(11)":U
          tt_mensagem_aux.descricao COLUMN-LABEL "Descriá∆o":U FORMAT "x(255)":U
        WITH NO-COLUMN-SCROLLING SEPARATORS SIZE 62 BY 4.5
             FONT 1 TOOLTIP "Mensagem".

    DEFINE FRAME f_mensagem
         br_mensagem AT ROW 1.17 COL 6.5
         ed_ajuda AT ROW 5.84 COL 6.5 NO-LABEL
         bt_ok AT ROW 10.42 COL 2.35
         rt_cxcf AT ROW 10.17 COL 1.5
         im_subtipo AT ROW 1.17 COL 1.5
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "Mensagem - Confirmaá∆o Pagamento Pinho":U.

    ASSIGN 
           FRAME f_mensagem:SCROLLABLE       = FALSE
           FRAME f_mensagem:HIDDEN           = TRUE.

    ASSIGN 
           br_mensagem:NUM-LOCKED-COLUMNS IN FRAME f_mensagem     = 2.

    ASSIGN 
           ed_ajuda:READ-ONLY IN FRAME f_mensagem        = TRUE.

    {include/i_fclfrm.i f_mensagem }

    ON WINDOW-CLOSE OF FRAME f_mensagem /* Mensagem */
    DO:
      APPLY "END-ERROR":U TO FRAME f_mensagem.
    END.

    ON VALUE-CHANGED OF br_mensagem IN FRAME f_mensagem
    DO:
        IF AVAILABLE tt_mensagem_aux THEN DO:
            CASE tt_mensagem_aux.tipo:
                WHEN "Aviso":U THEN
                    im_subtipo:LOAD-IMAGE("image/im-mqwar.bmp":U) IN FRAME f_mensagem.
                WHEN "Pergunta":U THEN
                    im_subtipo:LOAD-IMAGE("image/im-mqqst.bmp":U) IN FRAME f_mensagem.
                WHEN "Informacao":U THEN
                    im_subtipo:LOAD-IMAGE("image/im-mqinf.bmp":U) IN FRAME f_mensagem.
                OTHERWISE
                    im_subtipo:LOAD-IMAGE("image/im-mqerr.bmp":U) IN FRAME f_mensagem.
            END CASE.
    
            ASSIGN ed_ajuda:SCREEN-VALUE IN FRAME f_mensagem = tt_mensagem_aux.ajuda.
        END.
        ELSE DO:
            im_subtipo:LOAD-IMAGE("image/im-mqerr.bmp":U) IN FRAME f_mensagem.
    
            ASSIGN ed_ajuda:SCREEN-VALUE IN FRAME f_mensagem = "":U.
        END.
    END.

    IF VALID-HANDLE(ACTIVE-WINDOW)  AND
       FRAME f_mensagem:PARENT EQ ? THEN
        FRAME f_mensagem:PARENT = ACTIVE-WINDOW.

    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

      ENABLE im_subtipo
             br_mensagem
             ed_ajuda
             bt_ok 
          WITH FRAME f_mensagem.

      VIEW FRAME f_mensagem.

      OPEN QUERY br_mensagem FOR EACH tt_mensagem_aux INDEXED-REPOSITION.

      APPLY "ENTRY":U TO BROWSE br_mensagem.
      APPLY "VALUE-CHANGED":U TO BROWSE br_mensagem.
      APPLY "ENTRY":U TO FRAME f_mensagem.
    
      WAIT-FOR GO OF FRAME f_mensagem.
    END.
    
    HIDE FRAME f_mensagem.

    RETURN "OK":U.

END PROCEDURE.

