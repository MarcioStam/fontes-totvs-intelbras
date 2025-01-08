/*****************************************************************************
** Descricao.............: Rela‡Æo movimentos Limite e Aprova‡Æo Pedidos
** Versao................:  5.00.00.000
** Nome Externo..........: esp/acr/esacr056-1.p
** Criado por............: Fabiano Zarpe Henke
** Criado em.............: 29/01/2013
*****************************************************************************/

/******************************* Private-Data *******************************/
assign this-procedure:private-data = "HLP=22":U.
/*************************************  *************************************/

/************************** Window Definition Begin *************************/

def var wh_w_program
    as widget-handle
    no-undo.

IF session:window-system <> "TTY" THEN
DO:
create window wh_w_program
    assign
         row                  = 01.00
         col                  = 01.00
         height-chars         = 01.00
         width-chars          = 01.00
         min-width-chars      = 01.00
         min-height-chars     = 01.00
         max-width-chars      = 01.00
         max-height-chars     = 01.00
         virtual-width-chars  = 300.00
         virtual-height-chars = 200.00
         title                = "Program"
         resize               = YES
         scroll-bars          = NO
         status-area          = yes
         status-area-font     = ?
         message-area         = no
         message-area-font    = ?
         fgcolor              = ?
         bgcolor              = ?.
END.

/*************************** Window Definition End **************************/

/************************* Variable Definition Begin ************************/

DEF NEW GLOBAL SHARED VAR v_cod_empres_usuar
    AS CHARACTER 
    FORMAT "x(3)":U
    LABEL "Empresa"
    COLUMN-LABEL "Empresa"
    NO-UNDO.
DEFINE VARIABLE v_dat_ini              AS DATE FORMAT "99/99/9999"  INITIAL "01/01/0001" LABEL "Data" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEFINE VARIABLE v_dat_fim              AS DATE FORMAT "99/99/9999"  INITIAL "12/31/9999" LABEL "at‚"  VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEFINE VARIABLE v_dat_pedido           AS DATE NO-UNDO.
DEFINE VARIABLE v_dat_cobranca         AS DATE NO-UNDO. 
DEFINE VARIABLE v_cod_arq              AS CHAR.
DEFINE VARIABLE v_cod_filename_initial AS CHAR NO-UNDO.
DEFINE VARIABLE v_cod_filename_final   AS CHAR NO-UNDO.
DEFINE VARIABLE v_cdn_cliente_ini      AS INTEGER FORMAT ">>,>>>,>>9"  INITIAL 0           LABEL "Cliente" VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEFINE VARIABLE v_cdn_cliente_fim      AS INTEGER FORMAT ">>,>>>,>>9"  INITIAL "99999999"  LABEL "at‚"     VIEW-AS FILL-IN SIZE 11 BY .88 NO-UNDO.
DEFINE VARIABLE v_cod_cobranca_ini     AS INTEGER FORMAT ">>>>>9"      INITIAL 0           LABEL "Grupo de Cobran‡a" VIEW-AS FILL-IN SIZE 03 BY .88 NO-UNDO.
DEFINE VARIABLE v_cod_cobranca_fim     AS INTEGER FORMAT ">9"          INITIAL "99"        LABEL "at‚"     VIEW-AS FILL-IN SIZE 03 BY .88 NO-UNDO. 
DEFINE VARIABLE v_log_histor           AS LOGICAL  VIEW-AS TOGGLE-BOX  LABEL  "Cr‚dito"       NO-UNDO.
DEFINE VARIABLE v_log_ped              AS LOGICAL  VIEW-AS TOGGLE-BOX  LABEL  "Pedidos"       NO-UNDO.
DEFINE VARIABLE v_log_info_cobranca    AS LOGICAL VIEW-AS TOGGLE-BOX   LABEL  "Info.Cobran‡a" NO-UNDO.
DEFINE VARIABLE c-alt-data             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-alt-indicador        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont                 AS INTEGER     NO-UNDO.



/************************** Variable Definition End *************************/

/*************************** Buffer Definition Begin **************************/

DEF BUFFER b_pessoa_jurid   FOR pessoa_jurid.
DEF BUFFER b_cliente        FOR emscad.cliente.
DEF BUFFER b_cliente_matriz FOR emscad.cliente.
DEF BUFFER b_histor_clien   FOR histor_clien.


/**************************** Buffer Definition End ***************************/

/*************************** Menu Definition Begin **************************/

def sub-menu  mi_table
    menu-item mi_exi               label "Sa¡da".

def menu      m_10                  menubar
    sub-menu  mi_table              label "Tabela".

/**************************** Menu Definition End ***************************/

/************************ Rectangle Definition Begin ************************/

def rectangle rt_mold
    size 1 by 1
    edge-pixels 2.
def rectangle rt_rgf
    size 1 BY 1 
    edge-pixels 2.


/************************* Rectangle Definition End *************************/

/************************** Button Definition Begin *************************/

def button bt_exi
    label "Sa¡da"
    tooltip "Sa¡da"
    image-up file "image/im-exi"
    image-insensitive file "image/ii-exi"
    size 1 by 1.
def button bt_rnl1
    label "Exc"
    tooltip "Executar"
    image-up file "image/im-rnl"
    image-insensitive file "image/ii-rnl"
    size 1 by 1.

/*************************** Button Definition End **************************/

/************************** Frame Definition Begin **************************/

def frame f_bas_10_histor_fornec_import_ems
    rt_rgf
         at row 01.00 col 01.00 bgcolor 7 
    rt_mold
         at row 02.50 col 02.00
    v_dat_ini 
         at row 03 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_dat_fim
         at row 03 col 35.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cdn_cliente_ini
         at row 04 col 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cdn_cliente_fim
         at row 04 col 35.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cod_cobranca_ini
         AT ROW 05 COL 18.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_cod_cobranca_fim
         AT ROW 05 COL 35.00 COLON-ALIGNED BGCOLOR 15 FONT 2
    v_log_histor     
         at row 03 col 58.00 COLON-ALIGNED FONT 2
    v_log_ped
         at row 04 col 58.00 COLON-ALIGNED FONT 2
    v_log_info_cobranca 
         AT ROW 05 COL 58.00 COLON-ALIGNED FONT 2
    v_cod_arq
         at row 06 col 18.00 colon-aligned label "Nome Arquivo"
         help "Arquivo para exporta‡Æo"
         view-as editor max-chars 250 no-word-wrap
         size 55 by 1
         bgcolor 15 font 2
    bt_rnl1
         at row 01.08 col 02.14 font ?
         help "Executar Lista"
    bt_exi
         at row 01.10 col 76.34 font ?
         help "Sa¡da"
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 80.72 by 08
         at row 02.25 col 01.00
         font 1 fgcolor ? bgcolor 8
         title "Evolu‡Æo Limite Cr‚dito - Aprova‡Æo Pedidos (ESACR056) - ".
    /* adjust size of objects in this frame */
    assign bt_exi:width-chars     in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_exi:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.13
           bt_rnl1:width-chars    in frame f_bas_10_histor_fornec_import_ems = 04.00
           bt_rnl1:height-chars   in frame f_bas_10_histor_fornec_import_ems = 01.13
           rt_mold:width-chars    in frame f_bas_10_histor_fornec_import_ems = 78.44
           rt_mold:height-chars   in frame f_bas_10_histor_fornec_import_ems = 04.80
           rt_rgf:width-chars     in frame f_bas_10_histor_fornec_import_ems = 80.44
           rt_rgf:height-chars    in frame f_bas_10_histor_fornec_import_ems = 01.29.
    /* set return-inserted = yes for editors */
    assign v_cod_arq:return-inserted in frame f_bas_10_histor_fornec_import_ems = yes.
    /* set private-data for the help system */
    assign bt_rnl1:private-data   in frame f_bas_10_histor_fornec_import_ems = "HLP=000008794":U
           bt_exi:private-data    in frame f_bas_10_histor_fornec_import_ems = "HLP=000004665":U
           v_cod_arq:private-data in frame f_bas_10_histor_fornec_import_ems = "HLP=000017147":U
           frame f_bas_10_histor_fornec_import_ems:private-data = "HLP=000023693".
    /* enable function buttons */

/*************************** Frame Definition End ***************************/

/*********************** User Interface Trigger Begin ***********************/

ON CHOOSE OF bt_exi IN FRAME f_bas_10_histor_fornec_import_ems
DO:

    RUN pi_close_program.
END.

ON CHOOSE OF bt_rnl1 IN FRAME f_bas_10_histor_fornec_import_ems
DO:
    ASSIGN v_dat_ini             
           v_dat_fim             
           v_cod_arq             
           v_cdn_cliente_ini     
           v_cdn_cliente_fim
           v_cod_cobranca_ini
           v_cod_cobranca_fim 
           v_log_histor          
           v_log_ped
           v_log_info_cobranca.             

    IF v_dat_ini > v_dat_fim 
    THEN DO:
         MESSAGE "Data Inicial maior que Data Final !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.
           
    IF v_cdn_cliente_ini > v_cdn_cliente_fim 
    THEN DO:
         MESSAGE "Cliente Inicial maior que Cliente Final !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF v_cod_cobranca_ini > v_cod_cobranca_fim
    THEN DO:
        MESSAGE "Valor de cobran‡a Inicial maior que valor de cobran‡a FINAL !"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN NO-APPLY.
    END.

    IF  NOT v_log_histor
    AND NOT v_log_ped
    AND NOT v_log_info_cobranca
    THEN DO:
         MESSAGE "Indicar ao menos uma op‡Æo de Execu‡Æo !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_arq:SCREEN-VALUE = REPLACE(v_cod_arq:SCREEN-VALUE, '~\', '/').

    IF NUM-ENTRIES(v_cod_arq, "/") = 0
    THEN DO:
         MESSAGE "Diret¢rio nÆo informado !"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    ASSIGN v_cod_filename_initial = ENTRY(NUM-ENTRIES(v_cod_arq:SCREEN-VALUE, '/'), v_cod_arq:SCREEN-VALUE, '/')
           v_cod_filename_final   = SUBSTRING(v_cod_arq:SCREEN-VALUE, 1,
                                              LENGTH(v_cod_arq:SCREEN-VALUE) - LENGTH(v_cod_filename_initial) - 1)
           FILE-INFO:FILE-NAME    = v_cod_filename_final.
    IF FILE-INFO:FILE-TYPE = ?
    THEN DO:
         MESSAGE "Diret¢rio nÆo localizado: " v_cod_filename_final
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
         RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("general") THEN.

    OUTPUT TO VALUE(v_cod_arq) CONVERT TARGET 'iso8859-1'.

    PUT UNFORMATTED "Tipo;Pedido;Condicao;Descricao;Matriz;Cliente;CNPJ;Nome;Abrev;Data;Usuario;Valor;Movto;Observacao;Grupo.Cobranca".

    IF v_log_info_cobranca THEN
        PUT UNFORMATTED ";Dt.Cobranca;Valor.Cobranca".

    IF v_log_histor THEN
        PUT UNFORMATTED ";Alt. Dt. de limite de cr‚dito;Alt. do indicador de cr‚dito".

    PUT UNFORMATTED SKIP.
    
    IF v_log_histor 
    THEN DO:
        blk_histor:
        FOR EACH histor_clien NO-LOCK
            WHERE histor_clien.cod_empresa = v_cod_empres_usuar:
            
            IF histor_clien.des_histor_clien BEGINS "An lise de Cr‚dito alterado em" THEN DO:
                 
                 IF DEC(SUBSTRING(ENTRY(5, histor_clien.des_histor_clien, ":"), 1, 15)) <> DEC(SUBSTRING(ENTRY(5, histor_clien.des_histor_clien, ":"), 21, 15))
                 AND DATE(SUBSTRING (histor_clien.des_histor_clien, 32, 10)) >= v_dat_ini 
                 AND DATE(SUBSTRING (histor_clien.des_histor_clien, 32, 10)) <= v_dat_fim 
                 THEN DO:
                     
                      ASSIGN c-alt-data = SUBSTRING(ENTRY(3, histor_clien.des_histor_clien, ":"),2,26).

                      DO i-cont = 1 TO 31:
                          ASSIGN c-alt-data = REPLACE(c-alt-data, CHR(i-cont), CHR(32)).
                      END.
                    
                      IF INDEX(c-alt-data, CHR(32) + CHR(32)) <> 0 THEN DO:
                          DO i-cont = 12 TO 2 BY -1:
                              ASSIGN c-alt-data = REPLACE(c-alt-data, FILL(CHR(32), i-cont), CHR(32)).
                          END.
                      END.

                      IF INDEX(c-alt-data, "Indicador") <> 0 THEN
                          ASSIGN c-alt-data = REPLACE(c-alt-data,"Indicador", " / / ").

                      ASSIGN c-alt-indicador = SUBSTRING(ENTRY(4, histor_clien.des_histor_clien, ":"),2,8).
                      ASSIGN c-alt-indicador = REPLACE(c-alt-indicador,"1","Normal").
                      ASSIGN c-alt-indicador = REPLACE(c-alt-indicador,"2","Autom tico").
                      ASSIGN c-alt-indicador = REPLACE(c-alt-indicador,"3","S¢ Imp Ped").
                      ASSIGN c-alt-indicador = REPLACE(c-alt-indicador,"4","Suspenso").
                      ASSIGN c-alt-indicador = REPLACE(c-alt-indicador,"5","Pg … Vista").

                      FIND emscad.cliente NO-LOCK
                          WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                            AND emscad.cliente.cdn_cliente = histor_clien.cdn_cliente NO-ERROR.
                      FIND pessoa_jurid NO-LOCK
                         WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
                      IF AVAIL pessoa_jurid 
                      THEN DO:
                           FIND b_cliente_matriz NO-LOCK 
                              WHERE b_cliente_matriz.cod_empresa = v_cod_empres_usuar
                                AND b_cliente_matriz.num_pessoa  = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.

                           FOR EACH int-emitente NO-LOCK
                               WHERE int-emitente.cod-emitente = histor_clien.cdn_cliente
                                 AND int-emitente.cod-gr-cob >= v_cod_cobranca_ini 
                                 AND int-emitente.cod-gr-cob <= v_cod_cobranca_fim:
                               
                               IF NOT AVAIL b_cliente_matriz THEN NEXT.
                               
                               IF  histor_clien.cdn_cliente >= v_cdn_cliente_ini
                                   AND histor_clien.cdn_cliente <= v_cdn_cliente_fim THEN DO:
                                   
                                   PUT UNFORMATTED "Credito;"
                                                   "0;;;"
                                                   b_cliente_matriz.cdn_cliente ";"
                                                   emscad.cliente.cdn_cliente     ";"
                                                   pessoa_jurid.cod_id_feder    ";"
                                                   emscad.cliente.nom_pessoa      ";"
                                                   emscad.cliente.nom_abrev       ";"
                                                   SUBSTRING (histor_clien.des_histor_clien, 32, 10) ";"
                                                   SUBSTRING (histor_clien.des_histor_clien, 56, 8)  ";"
                                                   SUBSTRING(ENTRY(5, histor_clien.des_histor_clien, ":"), 21, 15) ";"
                                                   "Limite" ";"
                                                   "de: " ENTRY(5, histor_clien.des_histor_clien, ":") ";"
                                                   int-emitente.cod-gr-cob ";"
                                                   c-alt-data ";"
                                                   c-alt-indicador  ";" SKIP.

                                                NEXT blk_histor.
                               
                               END.
                               
                               ELSE DO:
                                   FOR EACH b_pessoa_jurid NO-LOCK
                                       WHERE b_pessoa_jurid.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz:
                                       FIND b_cliente NO-LOCK
                                           WHERE b_cliente.cod_empresa = v_cod_empres_usuar
                                             AND b_cliente.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.
                                       
                                       IF  AVAIL b_cliente
                                           AND b_cliente.cdn_cliente >= v_cdn_cliente_ini
                                           AND b_cliente.cdn_cliente <= v_cdn_cliente_fim
                                           
                                           THEN DO:
                                                PUT UNFORMATTED "Credito;"
                                                                 "0;;;"
                                                                 b_cliente_matriz.cdn_cliente ";"
                                                                 emscad.cliente.cdn_cliente     ";"
                                                                 pessoa_jurid.cod_id_feder    ";"
                                                                 emscad.cliente.nom_pessoa      ";"
                                                                 emscad.cliente.nom_abrev       ";"
                                                                 SUBSTRING (histor_clien.des_histor_clien, 32, 10) ";"
                                                                 SUBSTRING (histor_clien.des_histor_clien, 56, 8)  ";"
                                                                 SUBSTRING(ENTRY(5, histor_clien.des_histor_clien, ":"), 21, 15) ";"
                                                                 "Limite" ";"
                                                                 "de: " ENTRY(5, histor_clien.des_histor_clien, ":") ";"
                                                                 int-emitente.cod-gr-cob ";" 
                                                                 c-alt-data ";"
                                                                 c-alt-indicador  ";" SKIP.
                                                                 
                                                NEXT blk_histor.

                                           END.
                                   END.
                               END.
                           END.
                      END.
                      ELSE DO:
                          FIND pessoa_fisic NO-LOCK
                              WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.

                          FOR EACH int-emitente NO-LOCK
                              WHERE int-emitente.cod-emitente = histor_clien.cdn_cliente
                                AND int-emitente.cod-gr-cob >= v_cod_cobranca_ini 
                                AND int-emitente.cod-gr-cob <= v_cod_cobranca_fim:
                              
                              IF NOT AVAIL pessoa_fisic THEN NEXT.
                              IF  histor_clien.cdn_cliente >= v_cdn_cliente_ini
                              AND histor_clien.cdn_cliente <= v_cdn_cliente_fim
                                  THEN DO:
                                    PUT UNFORMATTED "Credito;"
                                                    "0;;;"
                                                    emscad.cliente.cdn_cliente  ";"
                                                    emscad.cliente.cdn_cliente  ";"
                                                    pessoa_fisic.cod_id_feder ";"
                                                    emscad.cliente.nom_pessoa   ";"
                                                    emscad.cliente.nom_abrev    ";"
                                                    SUBSTRING (histor_clien.des_histor_clien, 32, 10) ";"
                                                    SUBSTRING (histor_clien.des_histor_clien, 56, 8)  ";"
                                                    SUBSTRING(ENTRY(5, histor_clien.des_histor_clien, ":"), 21, 15) ";"
                                                    "Limite" ";"
                                                    "de: " ENTRY(5, histor_clien.des_histor_clien, ":") ";"
                                                    int-emitente.cod-gr-cob ";"
                                                    c-alt-data ";"
                                                    c-alt-indicador  ";" SKIP.

                                    NEXT blk_histor.
                              END.
                          END.
                      END.
                 END.
            END.
        END.
    END.
    
    IF v_log_ped 
    THEN DO:

        DO v_dat_pedido = v_dat_ini TO v_dat_fim:

            blk_histor:
            FOR EACH historico-credito NO-LOCK
                WHERE historico-credito.dt-data-movto = v_dat_pedido:

                FIND ped-venda NO-LOCK
                    WHERE ped-venda.nr-pedcli  = historico-credito.nr-pedcli
                      AND ped-venda.nome-abrev = historico-credito.nome-abrev NO-ERROR.

                IF NOT AVAIL ped-venda
                OR ped-venda.cod-sit-aval <> 3
                OR ped-venda.cod-cond-pag  = 0
                   THEN NEXT.

                FIND cond-pagto NO-LOCK
                   WHERE cond-pagto.cod-cond-pag = ped-venda.cod-cond-pag NO-ERROR.

                FIND emscad.cliente NO-LOCK
                    WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                      AND emscad.cliente.cdn_cliente = ped-venda.cod-emitente NO-ERROR.
                FIND pessoa_jurid NO-LOCK
                   WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
                IF AVAIL pessoa_jurid 
                THEN DO:
                     FIND b_cliente_matriz NO-LOCK 
                        WHERE b_cliente_matriz.cod_empresa = v_cod_empres_usuar
                          AND b_cliente_matriz.num_pessoa  = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.

                     FOR EACH int-emitente NO-LOCK
                         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente
                           AND int-emitente.cod-gr-cob >= v_cod_cobranca_ini 
                           AND int-emitente.cod-gr-cob <= v_cod_cobranca_fim:
                         
                         IF NOT AVAIL b_cliente_matriz 
                            THEN NEXT.

                         IF  ped-venda.cod-emitente >= v_cdn_cliente_ini
                         AND ped-venda.cod-emitente <= v_cdn_cliente_fim

                             THEN DO:
                                  PUT UNFORMATTED "Pedido;"
                                          ped-venda.nr-pedcli               ";"
                                          ped-venda.cod-cond-pag            ";"
                                          IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "Condi‡Æo nÆo localizada" ";"
                                          b_cliente_matriz.cdn_cliente      ";"
                                          emscad.cliente.cdn_cliente          ";"
                                          pessoa_jurid.cod_id_feder         ";"
                                          emscad.cliente.nom_pessoa           ";"
                                          emscad.cliente.nom_abrev            ";"
                                          historico-credito.dt-data-movto   ";"
                                          historico-credito.usuar-movto     ";"
                                          ped-venda.vl-tot-ped              ";"
                                          historico-credito.tipo-movto      ";"
                                          IF historico-credito.motivo <> "" THEN REPLACE(historico-credito.motivo, ";", ",") ELSE historico-credito.usuar-movto ";"
                                          int-emitente.cod-gr-cob SKIP.
                                          
                                  NEXT blk_histor.
                             END.
                             ELSE DO:
                                 FOR EACH b_pessoa_jurid NO-LOCK
                                     WHERE b_pessoa_jurid.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz:
                                     FIND b_cliente NO-LOCK
                                         WHERE b_cliente.cod_empresa = v_cod_empres_usuar
                                           AND b_cliente.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.

                                     IF  AVAIL b_cliente
                                         AND b_cliente.cdn_cliente >= v_cdn_cliente_ini
                                         AND b_cliente.cdn_cliente <= v_cdn_cliente_fim

                                         THEN DO:
                                              PUT UNFORMATTED "Pedido;"
                                                   ped-venda.nr-pedcli               ";"
                                                   ped-venda.cod-cond-pag            ";"
                                                   IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "Condi‡Æo nÆo localizada" ";"
                                                   b_cliente_matriz.cdn_cliente      ";"
                                                   emscad.cliente.cdn_cliente          ";"
                                                   pessoa_jurid.cod_id_feder         ";"
                                                   emscad.cliente.nom_pessoa           ";"
                                                   emscad.cliente.nom_abrev            ";"
                                                   historico-credito.dt-data-movto   ";"
                                                   historico-credito.usuar-movto     ";"
                                                   ped-venda.vl-tot-ped              ";"
                                                   historico-credito.tipo-movto      ";"
                                                   IF historico-credito.motivo <> "" THEN REPLACE(historico-credito.motivo, ";", ",") ELSE historico-credito.usuar-movto
                                                   int-emitente.cod-gr-cob SKIP.
                                              NEXT blk_histor.
                                         END.
                                 END.
                             END.
                     END.
                END.
                ELSE DO:
                     FIND pessoa_fisic NO-LOCK
                         WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.

                     FOR EACH int-emitente NO-LOCK
                         WHERE int-emitente.cod-emitente = ped-venda.cod-emitente
                           AND int-emitente.cod-gr-cob >= v_cod_cobranca_ini 
                           AND int-emitente.cod-gr-cob <= v_cod_cobranca_fim:

                         IF NOT AVAIL pessoa_fisic 
                            THEN NEXT.
    
                         IF  ped-venda.cod-emitente >= v_cdn_cliente_ini
                         AND ped-venda.cod-emitente <= v_cdn_cliente_fim 
                         THEN DO:
                              PUT UNFORMATTED "Pedido;"
                                              ped-venda.nr-pedcli               ";"
                                              ped-venda.cod-cond-pag            ";"
                                              IF AVAIL cond-pagto THEN cond-pagto.descricao ELSE "Condi‡Æo nÆo localizada" ";"
                                              emscad.cliente.cdn_cliente          ";"
                                              emscad.cliente.cdn_cliente          ";"
                                              pessoa_fisic.cod_id_feder         ";"
                                              emscad.cliente.nom_pessoa           ";"
                                              emscad.cliente.nom_abrev            ";"
                                              historico-credito.dt-data-movto   ";"
                                              historico-credito.usuar-movto     ";"
                                              ped-venda.vl-tot-ped              ";"
                                              historico-credito.tipo-movto      ";"
                                              IF historico-credito.motivo <> "" THEN REPLACE(historico-credito.motivo, ";", ",") ELSE historico-credito.usuar-movto
                                              int-emitente.cod-gr-cob SKIP.
                         END.
                     END.
                END.

            END.

        END.

    END.
    
    IF v_log_info_cobranca
    THEN DO:
        
        blk_histor:
        FOR EACH b_histor_clien NO-LOCK
            WHERE b_histor_clien.cod_empresa = v_cod_empres_usuar:
           
            IF b_histor_clien.des_histor_clien BEGINS "Enviado e-mail de cobran‡a para o cliente em" THEN DO:
                
                IF  DATE(SUBSTRING (b_histor_clien.des_histor_clien, 46, 10)) >= v_dat_ini 
                AND DATE(SUBSTRING (b_histor_clien.des_histor_clien, 46, 10)) <= v_dat_fim THEN DO:
                
                FIND FIRST emscad.cliente NO-LOCK
                    WHERE emscad.cliente.cod_empresa = v_cod_empres_usuar
                      AND emscad.cliente.cdn_cliente = b_histor_clien.cdn_cliente NO-ERROR.

                FIND pessoa_jurid NO-LOCK
                   WHERE pessoa_jurid.num_pessoa_jurid = emscad.cliente.num_pessoa NO-ERROR.
                IF AVAIL pessoa_jurid 
                THEN DO:

                    FIND b_cliente_matriz NO-LOCK
                        WHERE b_cliente_matriz.cod_empresa = v_cod_empres_usuar
                          AND b_cliente_matriz.num_pessoa  = pessoa_jurid.num_pessoa_jurid_matriz NO-ERROR.

                    FOR EACH int-emitente NO-LOCK
                        WHERE int-emitente.cod-emitente = b_histor_clien.cdn_cliente
                          AND int-emitente.cod-gr-cob >= v_cod_cobranca_ini 
                          AND int-emitente.cod-gr-cob <= v_cod_cobranca_fim:

                        IF NOT AVAIL b_cliente_matriz THEN NEXT.

                        IF  b_histor_clien.cdn_cliente >= v_cdn_cliente_ini
                        AND b_histor_clien.cdn_cliente <= v_cdn_cliente_fim THEN DO:

                            PUT UNFORMATTED "Cobran‡a;"
                                              "0;;;"
                                              emscad.cliente.cdn_cliente  ";"
                                              emscad.cliente.cdn_cliente  ";"
                                              pessoa_jurid.cod_id_feder ";"
                                              emscad.cliente.nom_pessoa   ";"
                                              emscad.cliente.nom_abrev    ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                              int-emitente.cod-gr-cob   ";"
                                              SUBSTRING (b_histor_clien.des_histor_clien, 46, 10) ";"
                                              ENTRY(5, b_histor_clien.des_histor_clien, ":") ";" SKIP.
                            NEXT blk_histor.
                        END.
                        ELSE DO:
                            FOR EACH b_pessoa_jurid NO-LOCK
                                WHERE b_pessoa_jurid.num_pessoa_jurid_matriz = pessoa_jurid.num_pessoa_jurid_matriz:
                                FIND b_cliente NO-LOCK
                                    WHERE b_cliente.cod_empresa = v_cod_empres_usuar
                                      AND b_cliente.num_pessoa  = b_pessoa_jurid.num_pessoa_jurid NO-ERROR.
                                
                                IF  AVAIL b_cliente
                                    AND b_cliente.cdn_cliente >= v_cdn_cliente_ini
                                    AND b_cliente.cdn_cliente <= v_cdn_cliente_fim
                                    
                                    THEN DO:
                                         PUT UNFORMATTED "Cobran‡a;"
                                              "0;;;"
                                              emscad.cliente.cdn_cliente  ";"
                                              emscad.cliente.cdn_cliente  ";"
                                              pessoa_jurid.cod_id_feder ";"
                                              emscad.cliente.nom_pessoa   ";"
                                              emscad.cliente.nom_abrev    ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                              int-emitente.cod-gr-cob   ";"
                                              SUBSTRING (b_histor_clien.des_histor_clien, 46, 10) ";"
                                              ENTRY(5, b_histor_clien.des_histor_clien, ":") ";" SKIP.

                                         NEXT blk_histor.
                                                          
                                END.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    FIND pessoa_fisic NO-LOCK
                        WHERE pessoa_fisic.num_pessoa_fisic = emscad.cliente.num_pessoa NO-ERROR.
                    
                    FOR EACH int-emitente NO-LOCK
                        WHERE int-emitente.cod-emitente = b_histor_clien.cdn_cliente
                          AND int-emitente.cod-gr-cob >= v_cod_cobranca_ini 
                          AND int-emitente.cod-gr-cob <= v_cod_cobranca_fim:
                        
                        IF NOT AVAIL pessoa_fisic THEN NEXT.
                        IF  b_histor_clien.cdn_cliente >= v_cdn_cliente_ini
                        AND b_histor_clien.cdn_cliente <= v_cdn_cliente_fim
                            THEN DO:
                              PUT UNFORMATTED "Cobran‡a;"
                                              "0;;;"
                                              emscad.cliente.cdn_cliente  ";"
                                              emscad.cliente.cdn_cliente  ";"
                                              pessoa_fisic.cod_id_feder ";"
                                              emscad.cliente.nom_pessoa   ";"
                                              emscad.cliente.nom_abrev    ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                                                        ";"
                                              int-emitente.cod-gr-cob   ";"
                                              SUBSTRING (b_histor_clien.des_histor_clien, 46, 10) ";"
                                              ENTRY(5, b_histor_clien.des_histor_clien, ":") ";" SKIP.

                              NEXT blk_histor.

                        END.
                    END.
                END.
               END.
            END.
        END.
    END.
    
    OUTPUT CLOSE.

    IF SESSION:SET-WAIT-STATE("") THEN.

    MESSAGE "Processamento conclu¡do !" SKIP(1) "Verificar arquivo: " v_cod_arq
      VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.


/************************ User Interface Trigger End ************************/

/**************************** Frame Trigger Begin ***************************/

ON END-ERROR OF FRAME f_bas_10_histor_fornec_import_ems
DO:

    run pi_close_program.
END.

/*************************** Window Trigger Begin ***************************/

ON WINDOW-CLOSE OF wh_w_program
DO:

    apply "choose" to bt_exi in frame f_bas_10_histor_fornec_import_ems.
END.

/**************************** Window Trigger End ****************************/

/****************************** Main Code Begin *****************************/

assign wh_w_program:title         = frame f_bas_10_histor_fornec_import_ems:title
                                  + chr(32)
                                  + chr(40)
                                  + trim(" 5.00.00.000":U)
                                  + chr(41)
       frame f_bas_10_histor_fornec_import_ems:title       = ?
       wh_w_program:width-chars   = frame f_bas_10_histor_fornec_import_ems:width-chars
       wh_w_program:height-chars  = frame f_bas_10_histor_fornec_import_ems:height-chars - 0.85
       frame f_bas_10_histor_fornec_import_ems:row         = 1
       frame f_bas_10_histor_fornec_import_ems:col         = 1
       wh_w_program:menubar       = menu m_10:handle
       wh_w_program:col           = max((session:width-chars - wh_w_program:width-chars) / 2, 1)
       wh_w_program:row           = max((session:height-chars - wh_w_program:height-chars) / 2, 1)
       current-window             = wh_w_program.

run pi_frame_settings (Input frame f_bas_10_histor_fornec_import_ems:handle).

pause 0 before-hide.

view frame f_bas_10_histor_fornec_import_ems.

ENABLE bt_rnl1
       bt_exi
       v_dat_ini        
       v_dat_fim        
       v_cdn_cliente_ini
       v_cdn_cliente_fim
       v_cod_cobranca_ini
       v_cod_cobranca_fim 
       v_log_histor     
       v_log_ped
       v_cod_arq
       v_log_info_cobranca WITH FRAME f_bas_10_histor_fornec_import_ems.       

ASSIGN v_cod_arq = SESSION:TEMP-DIRECTORY + "esacr056.csv".

DISP v_dat_ini      
     v_dat_fim      
     v_cdn_cliente_ini
     v_cdn_cliente_fim
     v_cod_cobranca_ini
     v_cod_cobranca_fim 
     v_log_histor     
     v_log_ped
     v_cod_arq 
     v_log_info_cobranca WITH FRAME f_bas_10_histor_fornec_import_ems.

main_block:
do on endkey undo main_block, leave main_block on error undo main_block, leave main_block:

    assign v_cod_arq:read-only in frame f_bas_10_histor_fornec_import_ems = no.

    if  this-procedure:persistent = no
    then do:
        wait-for choose of bt_exi in frame f_bas_10_histor_fornec_import_ems.
    end.
end.

/******************************* Main Code End ******************************/

/************************* Internal Procedure Begin *************************/

PROCEDURE pi_close_program:

    delete widget wh_w_program.
    if  this-procedure:persistent = yes
    then do:
        delete procedure this-procedure.
    end.
END PROCEDURE. /* pi_close_program */
PROCEDURE pi_frame_settings:

    /************************ Parameter Definition Begin ************************/
    def Input param p_wgh_frame
        as widget-handle
        format ">>>>>>9"
        no-undo.
    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/
    def var v_wgh_child                      as widget-handle   no-undo. /*local*/
    def var v_wgh_group                      as widget-handle   no-undo. /*local*/
    /************************** Variable Definition End *************************/

    assign v_wgh_group = p_wgh_frame:first-child.
    block_group:
    do while v_wgh_group <> ?:

        assign v_wgh_child = v_wgh_group:first-child.

        block_child:
        do while v_wgh_child <> ?:
            if  v_wgh_child:type = "editor" /*l_editor*/ 
            then do:
                assign v_wgh_child:read-only = yes
                       v_wgh_child:sensitive = yes.
            end /* if */.
            assign v_wgh_child = v_wgh_child:next-sibling.
        end /* do block_child */.

        assign v_wgh_group = v_wgh_group:next-sibling.
    end /* do block_group */.

END PROCEDURE. /* pi_frame_settings */
PROCEDURE pi_messages:

    def input param c_action    as char    no-undo.
    def input param i_msg       as integer no-undo.
    def input param c_param     as char    no-undo.

    def var c_prg_msg           as char    no-undo.

    assign c_prg_msg = "messages/":U
                     + string(trunc(i_msg / 1000,0),"99":U)
                     + "/msg":U
                     + string(i_msg, "99999":U).

    if search(c_prg_msg + ".r":U) = ? and search(c_prg_msg + ".p":U) = ? then do:
        message "Mensagem nr. " i_msg "!!!":U skip
                "Programa Mensagem" c_prg_msg "nÆo encontrado."
                view-as alert-box error.
        return error.
    end.

    run value(c_prg_msg + ".p":U) (input c_action, input c_param).
    return return-value.
END PROCEDURE.
