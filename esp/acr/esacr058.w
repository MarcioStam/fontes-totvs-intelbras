&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emscad             PROGRESS
          emsmov             PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt_tit_acr_hsbc NO-UNDO LIKE tit_acr
       FIELD r-Rowid           AS ROWID
       FIELD log_selecionar    AS LOGICAL FORMAT "Sim/N∆o":U INITIAL NO LABEL "":U COLUMN-LABEL "":U
       FIELD val_limite        LIKE int-emitente-hsbc-limite.val-limite
       FIELD log_destinados    AS LOGICAL FORMAT "Sim/N∆o":U INITIAL NO LABEL "":U COLUMN-LABEL "":U
       INDEX idx_selec
             log_selecionar
       INDEX idx_destinac
             log_destinados
       INDEX idx_query
             cdn_cliente
             cod_estab.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*****************************************************************************
** Descricao.............: T°tulos ACR Destinaá∆o HSBC
** Versao................:  5.06.00.000
** Nome Externo..........: esp/acr/esacr058.p
** Criado por............: Fabiano Sakae Ribeiro (Exponencial TI)
** Criado em.............: 28/01/2013
*****************************************************************************/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Local Preprocessor Definitions ---                                   */

&GLOBAL-DEFINE PROGRAM-TITLE    T°tulos ACR Destinaá∆o HSBC
&GLOBAL-DEFINE PROGRAM          ESACR058
&GLOBAL-DEFINE PROGRAM-VERSION  1.00.00.000

/* Include Definitions ---                                              */

{upc/btb910za-upc.i} /* Definiá∆o da vari†vel NEW GLOBAL SHARED
                        "v_cod_estab_usuar" */
{esp/acr/acr711zo.i} /* Definiá∆o das Temp-Tables de integraá∆o com a
                        API "acr711zo" */

/* Parameters Definitions ---                                           */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt_mensagem NO-UNDO
    FIELD cod_estabel    AS CHARACTER FORMAT "x(3)":U                 LABEL "Estabelecimento":U   COLUMN-LABEL "Est":U
    FIELD num_id_tit_acr AS INTEGER   FORMAT "9999999999":U INITIAL 0 LABEL "Token Cta Receber":U COLUMN-LABEL "Token Cta Rec":U
    FIELD num_mensagem   AS INTEGER   FORMAT ">>>>,>>9":U             LABEL "C¢digo Mensagem":U   COLUMN-LABEL "C¢d Msg":U
    FIELD tipo_mensagem  AS CHARACTER FORMAT "x(12)":U                LABEL "Tipo Mensagem":U     COLUMN-LABEL "Tp Msg":U
    FIELD texto_mensagem AS CHARACTER FORMAT "x(60)":U                LABEL "Mensagem":U          COLUMN-LABEL "Msg":U
    FIELD texto_ajuda    AS CHARACTER FORMAT "x(40)":U                LABEL "Ajuda":U             COLUMN-LABEL "Ajuda":U
    INDEX idx-primary IS PRIMARY
        cod_estabel
        num_id_tit_acr
        num_mensagem.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER b_tt_tit_acr_hsbc FOR tt_tit_acr_hsbc.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-prg-obj AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-prg-vrs AS CHARACTER   NO-UNDO.

DEFINE VARIABLE v_cod_estab_ini AS CHARACTER FORMAT "x(3)" 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_cod_estab_fin AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_dat_emis_docto_ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data  Emiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_dat_emis_docto_fin AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_dat_vencto_tit_acr_ini AS DATE FORMAT "99/99/9999" INITIAL 01/01/1800 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_dat_vencto_tit_acr_fin AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_cdn_cliente_ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_cdn_cliente_fin AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_val_sdo_tit_acr_ini AS DECIMAL FORMAT ">>>,>>>,>>9.99" INITIAL 0.00 
     LABEL "Saldo" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_val_sdo_tit_acr_fin AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 999999999.99 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88
     BGCOLOR 15 NO-UNDO.

DEFINE VARIABLE v_win_original_width  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE v_win_original_height AS DECIMAL     NO-UNDO.

DEFINE VARIABLE v_column AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_asc    AS LOGICAL     NO-UNDO.

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

/* Global Variable Definitions ---                                      */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_empres_usuar AS CHARACTER   NO-UNDO
    FORMAT "x(3)":U
    LABEL "Empresa":U COLUMN-LABEL "Empresa":U.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_estab_usuar AS CHARACTER   NO-UNDO
    FORMAT "x(3)":U
    LABEL "Estabelecimento":U COLUMN-LABEL "Estab":U.

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO
    FORMAT "x(12)":U
    LABEL "Usu†rio Corrente":U COLUMN-LABEL "Usu†rio Corrente":U.

DEFINE NEW GLOBAL SHARED VARIABLE v_rec_cliente AS RECID       NO-UNDO
    FORMAT ">>>>>>9":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME br_tit_acr_hsbc

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt_tit_acr_hsbc

/* Definitions for BROWSE br_tit_acr_hsbc                               */
&Scoped-define FIELDS-IN-QUERY-br_tit_acr_hsbc ~
tt_tit_acr_hsbc.log_selecionar tt_tit_acr_hsbc.cod_portador ~
tt_tit_acr_hsbc.cod_cart_bcia tt_tit_acr_hsbc.cod_estab ~
tt_tit_acr_hsbc.cod_espec_docto tt_tit_acr_hsbc.cod_ser_docto ~
tt_tit_acr_hsbc.cod_tit_acr tt_tit_acr_hsbc.cod_parcela ~
tt_tit_acr_hsbc.cdn_cliente tt_tit_acr_hsbc.nom_abrev ~
tt_tit_acr_hsbc.dat_emis_docto tt_tit_acr_hsbc.dat_vencto_tit_acr ~
tt_tit_acr_hsbc.val_sdo_tit_acr tt_tit_acr_hsbc.val_limite 
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_tit_acr_hsbc 
&Scoped-define QUERY-STRING-br_tit_acr_hsbc FOR EACH tt_tit_acr_hsbc NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_tit_acr_hsbc OPEN QUERY br_tit_acr_hsbc FOR EACH tt_tit_acr_hsbc NO-LOCK USE-INDEX idx_query INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_tit_acr_hsbc tt_tit_acr_hsbc
&Scoped-define FIRST-TABLE-IN-QUERY-br_tit_acr_hsbc tt_tit_acr_hsbc


/* Definitions for FRAME fPage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage0 ~
    ~{&OPEN-QUERY-br_tit_acr_hsbc}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_tit_acr_hsbc bt_all bt_none v_tot_sel ~
bt_ok bt_cancel bt_range bt_help 
&Scoped-Define DISPLAYED-OBJECTS v_tot_sel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU pm_br_tit_acr_hsbc 
       MENU-ITEM mi_ordenar_coluna LABEL "Ordenar Coluna?"
              TOGGLE-BOX
       MENU-ITEM mi_mover_coluna LABEL "Mover Coluna?" 
              TOGGLE-BOX.


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt_all 
     LABEL "&Todos" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_cancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_help 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_none 
     LABEL "&Nenhum" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_ok 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON bt_range 
     LABEL "Faixa" 
     SIZE 10 BY 1.

DEFINE VARIABLE v_tot_sel AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Selecionado" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE RECTANGLE rtFields
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.86 BY 15.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 18 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_tit_acr_hsbc FOR 
      tt_tit_acr_hsbc SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_tit_acr_hsbc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_tit_acr_hsbc wWindow _STRUCTURED
  QUERY br_tit_acr_hsbc NO-LOCK DISPLAY
      tt_tit_acr_hsbc.log_selecionar FORMAT "*/":U WIDTH 2.14
      tt_tit_acr_hsbc.cod_portador COLUMN-LABEL "Port" FORMAT "x(5)":U
            WIDTH 5.43
      tt_tit_acr_hsbc.cod_cart_bcia COLUMN-LABEL "Cart" FORMAT "x(3)":U
            WIDTH 5.43
      tt_tit_acr_hsbc.cod_estab COLUMN-LABEL "Est" FORMAT "x(3)":U
            WIDTH 4.43
      tt_tit_acr_hsbc.cod_espec_docto COLUMN-LABEL "Esp" FORMAT "x(3)":U
            WIDTH 4.43
      tt_tit_acr_hsbc.cod_ser_docto FORMAT "x(3)":U WIDTH 6.43
      tt_tit_acr_hsbc.cod_tit_acr FORMAT "x(10)":U WIDTH 18.43
      tt_tit_acr_hsbc.cod_parcela COLUMN-LABEL "/P" FORMAT "x(02)":U
            WIDTH 3.43
      tt_tit_acr_hsbc.cdn_cliente FORMAT ">>>,>>>,>>9":U WIDTH 11.43
      tt_tit_acr_hsbc.nom_abrev FORMAT "x(15)":U WIDTH 19.43
      tt_tit_acr_hsbc.dat_emis_docto COLUMN-LABEL "Emiss∆o" FORMAT "99/99/9999":U
            WIDTH 12.43
      tt_tit_acr_hsbc.dat_vencto_tit_acr FORMAT "99/99/9999":U
            WIDTH 12
      tt_tit_acr_hsbc.val_sdo_tit_acr FORMAT ">>>,>>>,>>9.99":U
            WIDTH 14.57
      tt_tit_acr_hsbc.val_limite COLUMN-LABEL "Limite Disp HSBC" FORMAT "->>>,>>>,>>9.99":U
            WIDTH 18
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 87.29 BY 13.63
         BGCOLOR 15 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     br_tit_acr_hsbc AT ROW 1.38 COL 2.29 HELP
          "T°tulos Contas a Receber"
     bt_all AT ROW 15 COL 2.29 HELP
          "Marcar a Seleá∆o de Todos os Registros"
     bt_none AT ROW 15 COL 12.29 HELP
          "Desmarcar a Seleá∆o de Todos os Registros"
     v_tot_sel AT ROW 15 COL 70.57 COLON-ALIGNED HELP
          "Total dos T°tulos Selecionados"
     bt_ok AT ROW 16.75 COL 2 HELP
          "OK"
     bt_cancel AT ROW 16.75 COL 13 HELP
          "Cancelar"
     bt_range AT ROW 16.75 COL 37 HELP
          "Faixa de Seleá∆o"
     bt_help AT ROW 16.75 COL 80 HELP
          "Ajuda"
     rtToolBar AT ROW 16.54 COL 1
     rtFields AT ROW 1.17 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         BGCOLOR 17 FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Temp-Tables and Buffers:
      TABLE: tt_tit_acr_hsbc T "?" NO-UNDO ems5 tit_acr
      ADDITIONAL-FIELDS:
          FIELD r-Rowid           AS ROWID
          FIELD log_selecionar    AS LOGICAL FORMAT "Sim/N∆o":U INITIAL NO LABEL "":U COLUMN-LABEL "":U
          FIELD val_limite        LIKE int-emitente-hsbc-limite.val-limite
          FIELD log_destinados    AS LOGICAL FORMAT "Sim/N∆o":U INITIAL NO LABEL "":U COLUMN-LABEL "":U
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 200
         MAX-WIDTH          = 300
         VIRTUAL-HEIGHT     = 200
         VIRTUAL-WIDTH      = 300
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = 8
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br_tit_acr_hsbc rtFields fPage0 */
ASSIGN 
       br_tit_acr_hsbc:POPUP-MENU IN FRAME fPage0             = MENU pm_br_tit_acr_hsbc:HANDLE
       br_tit_acr_hsbc:ALLOW-COLUMN-SEARCHING IN FRAME fPage0 = TRUE
       br_tit_acr_hsbc:COLUMN-RESIZABLE IN FRAME fPage0       = TRUE.

/* SETTINGS FOR RECTANGLE rtFields IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE rtToolBar IN FRAME fPage0
   NO-ENABLE                                                            */
ASSIGN 
       v_tot_sel:READ-ONLY IN FRAME fPage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_tit_acr_hsbc
/* Query rebuild information for BROWSE br_tit_acr_hsbc
     _TblList          = "Temp-Tables.tt_tit_acr_hsbc"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"tt_tit_acr_hsbc.log_selecionar" ? "*~~/" ? ? ? ? ? ? ? no ? no no "2.14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Temp-Tables.tt_tit_acr_hsbc.cod_portador
"tt_tit_acr_hsbc.cod_portador" "Port" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Temp-Tables.tt_tit_acr_hsbc.cod_cart_bcia
"tt_tit_acr_hsbc.cod_cart_bcia" "Cart" ? "character" ? ? ? ? ? ? no ? no no "5.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Temp-Tables.tt_tit_acr_hsbc.cod_estab
"tt_tit_acr_hsbc.cod_estab" "Est" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Temp-Tables.tt_tit_acr_hsbc.cod_espec_docto
"tt_tit_acr_hsbc.cod_espec_docto" "Esp" ? "character" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Temp-Tables.tt_tit_acr_hsbc.cod_ser_docto
"tt_tit_acr_hsbc.cod_ser_docto" ? ? "character" ? ? ? ? ? ? no ? no no "6.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Temp-Tables.tt_tit_acr_hsbc.cod_tit_acr
"tt_tit_acr_hsbc.cod_tit_acr" ? ? "character" ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Temp-Tables.tt_tit_acr_hsbc.cod_parcela
"tt_tit_acr_hsbc.cod_parcela" "/P" ? "character" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Temp-Tables.tt_tit_acr_hsbc.cdn_cliente
"tt_tit_acr_hsbc.cdn_cliente" ? ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > Temp-Tables.tt_tit_acr_hsbc.nom_abrev
"tt_tit_acr_hsbc.nom_abrev" ? ? "character" ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > Temp-Tables.tt_tit_acr_hsbc.dat_emis_docto
"tt_tit_acr_hsbc.dat_emis_docto" "Emiss∆o" ? "date" ? ? ? ? ? ? no ? no no "12.43" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > Temp-Tables.tt_tit_acr_hsbc.dat_vencto_tit_acr
"tt_tit_acr_hsbc.dat_vencto_tit_acr" ? ? "date" ? ? ? ? ? ? no ? no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > Temp-Tables.tt_tit_acr_hsbc.val_sdo_tit_acr
"tt_tit_acr_hsbc.val_sdo_tit_acr" ? ? "decimal" ? ? ? ? ? ? no ? no no "14.57" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"tt_tit_acr_hsbc.val_limite" "Limite Disp HSBC" "->>>,>>>,>>9.99" ? ? ? ? ? ? ? no ? no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE br_tit_acr_hsbc */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-RESIZED OF wWindow
DO:
    DEFINE VARIABLE v_win_dif_width  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE v_win_dif_height AS DECIMAL     NO-UNDO.

    ASSIGN v_win_dif_width       = CURRENT-WINDOW:WIDTH  - v_win_original_width
           v_win_dif_height      = CURRENT-WINDOW:HEIGHT - v_win_original_height
           v_win_original_width  = CURRENT-WINDOW:WIDTH
           v_win_original_height = CURRENT-WINDOW:HEIGHT.

    IF v_win_dif_width < 0 THEN DO:
        DO WITH FRAME fPage0:
            ASSIGN bt_range:COLUMN                    = bt_range:COLUMN                    + (v_win_dif_width / 2)
                   bt_help:COLUMN                     = bt_help:COLUMN                     +  v_win_dif_width
                   rtToolBar:WIDTH                    = rtToolBar:WIDTH                    +  v_win_dif_width
                   br_tit_acr_hsbc:WIDTH              = br_tit_acr_hsbc:WIDTH              +  v_win_dif_width
                   v_tot_sel:SIDE-LABEL-HANDLE:COLUMN = v_tot_sel:SIDE-LABEL-HANDLE:COLUMN +  v_win_dif_width
                   v_tot_sel:COLUMN                   = v_tot_sel:COLUMN                   +  v_win_dif_width
                   rtFields:WIDTH                     = rtFields:WIDTH                     +  v_win_dif_width.
        END.

        ASSIGN FRAME fPage0:WIDTH         = CURRENT-WINDOW:WIDTH
               FRAME fPage0:WIDTH-CHARS   = CURRENT-WINDOW:WIDTH-CHARS
               FRAME fPage0:VIRTUAL-WIDTH = FRAME fPage0:WIDTH.
    END.
    ELSE DO:
        ASSIGN FRAME fPage0:WIDTH         = CURRENT-WINDOW:WIDTH
               FRAME fPage0:WIDTH-CHARS   = CURRENT-WINDOW:WIDTH-CHARS
               FRAME fPage0:VIRTUAL-WIDTH = FRAME fPage0:WIDTH.

        DO WITH FRAME fPage0:
            ASSIGN bt_range:COLUMN                    = bt_range:COLUMN                    + (v_win_dif_width / 2)
                   bt_help:COLUMN                     = bt_help:COLUMN                     +  v_win_dif_width
                   rtToolBar:WIDTH                    = rtToolBar:WIDTH                    +  v_win_dif_width
                   br_tit_acr_hsbc:WIDTH              = br_tit_acr_hsbc:WIDTH              +  v_win_dif_width
                   v_tot_sel:SIDE-LABEL-HANDLE:COLUMN = v_tot_sel:SIDE-LABEL-HANDLE:COLUMN +  v_win_dif_width
                   v_tot_sel:COLUMN                   = v_tot_sel:COLUMN                   +  v_win_dif_width
                   rtFields:WIDTH                     = rtFields:WIDTH                     +  v_win_dif_width.
        END.
    END.

    IF v_win_dif_height < 0 THEN DO:
        DO WITH FRAME fPage0:
            ASSIGN bt_ok:ROW                       = bt_ok:ROW                       + v_win_dif_height
                   bt_cancel:ROW                   = bt_cancel:ROW                   + v_win_dif_height
                   bt_range:ROW                    = bt_range:ROW                    + v_win_dif_height
                   bt_help:ROW                     = bt_help:ROW                     + v_win_dif_height
                   rtToolBar:ROW                   = rtToolBar:ROW                   + v_win_dif_height
                   br_tit_acr_hsbc:HEIGHT          = br_tit_acr_hsbc:HEIGHT          + v_win_dif_height
                   bt_all:ROW                      = bt_all:ROW                      + v_win_dif_height
                   bt_none:ROW                     = bt_none:ROW                     + v_win_dif_height
                   v_tot_sel:SIDE-LABEL-HANDLE:ROW = v_tot_sel:SIDE-LABEL-HANDLE:ROW + v_win_dif_height
                   v_tot_sel:ROW                   = v_tot_sel:ROW                   + v_win_dif_height
                   rtFields:HEIGHT                 = rtFields:HEIGHT                 + v_win_dif_height.
        END.

        ASSIGN FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
               FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
               FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.
    END.
    ELSE DO:
        ASSIGN FRAME fPage0:HEIGHT         = CURRENT-WINDOW:HEIGHT
               FRAME fPage0:HEIGHT-CHARS   = CURRENT-WINDOW:HEIGHT-CHARS
               FRAME fPage0:VIRTUAL-HEIGHT = FRAME fPage0:HEIGHT.

        DO WITH FRAME fPage0:
            ASSIGN bt_ok:ROW                       = bt_ok:ROW                       + v_win_dif_height
                   bt_cancel:ROW                   = bt_cancel:ROW                   + v_win_dif_height
                   bt_range:ROW                    = bt_range:ROW                    + v_win_dif_height
                   bt_help:ROW                     = bt_help:ROW                     + v_win_dif_height
                   rtToolBar:ROW                   = rtToolBar:ROW                   + v_win_dif_height
                   br_tit_acr_hsbc:HEIGHT          = br_tit_acr_hsbc:HEIGHT          + v_win_dif_height
                   bt_all:ROW                      = bt_all:ROW                      + v_win_dif_height
                   bt_none:ROW                     = bt_none:ROW                     + v_win_dif_height
                   v_tot_sel:SIDE-LABEL-HANDLE:ROW = v_tot_sel:SIDE-LABEL-HANDLE:ROW + v_win_dif_height
                   v_tot_sel:ROW                   = v_tot_sel:ROW                   + v_win_dif_height
                   rtFields:HEIGHT                 = rtFields:HEIGHT                 + v_win_dif_height.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_tit_acr_hsbc
&Scoped-define SELF-NAME br_tit_acr_hsbc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tit_acr_hsbc wWindow
ON MOUSE-SELECT-DBLCLICK OF br_tit_acr_hsbc IN FRAME fPage0
DO:
    APPLY "RETURN":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tit_acr_hsbc wWindow
ON RETURN OF br_tit_acr_hsbc IN FRAME fPage0
DO:
    IF AVAILABLE tt_tit_acr_hsbc THEN DO:
        IF NOT tt_tit_acr_hsbc.log_selecionar                           AND
           tt_tit_acr_hsbc.val_limite < tt_tit_acr_hsbc.val_sdo_tit_acr THEN DO:
            MESSAGE "N∆o h† limite dispon°vel para o t°tulo/parcela selecionado!":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            RETURN NO-APPLY.
        END.

        ASSIGN tt_tit_acr_hsbc.log_selecionar = NOT tt_tit_acr_hsbc.log_selecionar.

        FOR EACH tt_tit_acr_hsbc:
            FIND LAST int-emitente-hsbc-limite
                WHERE int-emitente-hsbc-limite.cod-emitente = tt_tit_acr_hsbc.cdn_cliente
                  AND int-emitente-hsbc-limite.ind-tipo     = "Limite":U NO-LOCK NO-ERROR.

            IF AVAILABLE int-emitente-hsbc-limite THEN
                ASSIGN tt_tit_acr_hsbc.val_limite = int-emitente-hsbc-limite.val-limite.
            ELSE
                ASSIGN tt_tit_acr_hsbc.val_limite = 0.00.
        END.

        FOR EACH tt_tit_acr_hsbc:
            IF tt_tit_acr_hsbc.log_selecionar THEN DO:
                FOR EACH b_tt_tit_acr_hsbc
                    WHERE b_tt_tit_acr_hsbc.cdn_cliente = tt_tit_acr_hsbc.cdn_cliente:
                    ASSIGN b_tt_tit_acr_hsbc.val_limite = b_tt_tit_acr_hsbc.val_limite - tt_tit_acr_hsbc.val_sdo_tit_acr.
                END.
            END.
        END.

        ASSIGN v_tot_sel = 0.00.

        FOR EACH tt_tit_acr_hsbc:
            IF tt_tit_acr_hsbc.log_selecionar THEN
                ASSIGN v_tot_sel = v_tot_sel + tt_tit_acr_hsbc.val_sdo_tit_acr.
        END.

        br_tit_acr_hsbc:REFRESH() IN FRAME fPage0.

        DISPLAY v_tot_sel
            WITH FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tit_acr_hsbc wWindow
ON ROW-DISPLAY OF br_tit_acr_hsbc IN FRAME fPage0
DO:
    IF AVAILABLE tt_tit_acr_hsbc THEN DO:
        IF tt_tit_acr_hsbc.log_selecionar THEN
            ASSIGN tt_tit_acr_hsbc.log_selecionar:FONT     IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_portador:FONT       IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_cart_bcia:FONT      IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_estab:FONT          IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_espec_docto:FONT    IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_ser_docto:FONT      IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_tit_acr:FONT        IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cod_parcela:FONT        IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.cdn_cliente:FONT        IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.nom_abrev:FONT          IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.dat_emis_docto:FONT     IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.dat_vencto_tit_acr:FONT IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.val_sdo_tit_acr:FONT    IN BROWSE br_tit_acr_hsbc = 0
                   tt_tit_acr_hsbc.val_limite:FONT         IN BROWSE br_tit_acr_hsbc = 0.
        ELSE
            ASSIGN tt_tit_acr_hsbc.log_selecionar:FONT     IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_portador:FONT       IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_cart_bcia:FONT      IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_estab:FONT          IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_espec_docto:FONT    IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_ser_docto:FONT      IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_tit_acr:FONT        IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cod_parcela:FONT        IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.cdn_cliente:FONT        IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.nom_abrev:FONT          IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.dat_emis_docto:FONT     IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.dat_vencto_tit_acr:FONT IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.val_sdo_tit_acr:FONT    IN BROWSE br_tit_acr_hsbc = 2
                   tt_tit_acr_hsbc.val_limite:FONT         IN BROWSE br_tit_acr_hsbc = 2.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_tit_acr_hsbc wWindow
ON START-SEARCH OF br_tit_acr_hsbc IN FRAME fPage0
DO:
    DEFINE VARIABLE i_count AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_index AS INTEGER     NO-UNDO.

    SELF:CLEAR-SORT-ARROWS().

    IF SELF:CURRENT-COLUMN:TABLE = "":U OR
       SELF:CURRENT-COLUMN:TABLE = ?    THEN
        RETURN NO-APPLY.

    IF v_column <> SELF:CURRENT-COLUMN:NAME THEN
        ASSIGN v_column = SELF:CURRENT-COLUMN:NAME
               v_asc    = YES.
    ELSE
        ASSIGN v_asc = NOT v_asc.

    IF v_asc THEN
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME).
    ELSE
        SELF:QUERY:QUERY-PREPARE("FOR EACH ":U + SELF:CURRENT-COLUMN:TABLE + " ":U +
                                 "    OUTER-JOIN BY ":U + SELF:CURRENT-COLUMN:TABLE + ".":U + SELF:CURRENT-COLUMN:NAME + " DESC":U).
            
    DO i_count = 1 TO SELF:NUM-COLUMNS:
        IF SELF:CURRENT-COLUMN = SELF:GET-BROWSE-COLUMN(i_count) THEN
            ASSIGN i_index = i_count.
    END.

    SELF:SET-SORT-ARROW(i_index, v_asc).

    SELF:QUERY:QUERY-OPEN().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_all wWindow
ON CHOOSE OF bt_all IN FRAME fPage0 /* Todos */
DO:
    DEFINE VARIABLE v_sem_saldo AS LOGICAL     NO-UNDO.

    ASSIGN v_tot_sel   = 0.00
           v_sem_saldo = NO.

    IF NOT CAN-FIND(FIRST tt_tit_acr_hsbc) THEN
        RETURN NO-APPLY.

    FOR EACH tt_tit_acr_hsbc:
        ASSIGN tt_tit_acr_hsbc.log_selecionar = NO.

        FIND LAST int-emitente-hsbc-limite
            WHERE int-emitente-hsbc-limite.cod-emitente = tt_tit_acr_hsbc.cdn_cliente
              AND int-emitente-hsbc-limite.ind-tipo     = "Limite":U NO-LOCK NO-ERROR.

        IF AVAILABLE int-emitente-hsbc-limite THEN
            ASSIGN tt_tit_acr_hsbc.val_limite = int-emitente-hsbc-limite.val-limite.
        ELSE
            ASSIGN tt_tit_acr_hsbc.val_limite = 0.00.
    END.

    FOR EACH tt_tit_acr_hsbc:
        IF tt_tit_acr_hsbc.val_sdo_tit_acr <= tt_tit_acr_hsbc.val_limite THEN DO:
            ASSIGN tt_tit_acr_hsbc.log_selecionar = YES
                   v_tot_sel                      = v_tot_sel + tt_tit_acr_hsbc.val_sdo_tit_acr.

            FOR EACH b_tt_tit_acr_hsbc
                WHERE b_tt_tit_acr_hsbc.cdn_cliente = tt_tit_acr_hsbc.cdn_cliente:
                ASSIGN b_tt_tit_acr_hsbc.val_limite = b_tt_tit_acr_hsbc.val_limite - tt_tit_acr_hsbc.val_sdo_tit_acr.
            END.
        END.
        ELSE
            ASSIGN v_sem_saldo = YES.
    END.

    br_tit_acr_hsbc:REFRESH() IN FRAME fPage0.

    DISPLAY v_tot_sel
        WITH FRAME fPage0.

    IF v_sem_saldo THEN
        MESSAGE "Algum(ns) t°tulo(s) n∆o foi(ram) selecionado(s) por falta de limite dispon°vel!":U
            VIEW-AS ALERT-BOX WARNING BUTTONS OK TITLE "Atená∆o":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_cancel wWindow
ON CHOOSE OF bt_cancel IN FRAME fPage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_none
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_none wWindow
ON CHOOSE OF bt_none IN FRAME fPage0 /* Nenhum */
DO:
    ASSIGN v_tot_sel = 0.00.

    IF NOT CAN-FIND(FIRST tt_tit_acr_hsbc) THEN
        RETURN NO-APPLY.

    FOR EACH tt_tit_acr_hsbc:
        ASSIGN tt_tit_acr_hsbc.log_selecionar = NO.
    END.

    FOR EACH tt_tit_acr_hsbc:
        ASSIGN tt_tit_acr_hsbc.log_selecionar = NO.

        FIND LAST int-emitente-hsbc-limite
            WHERE int-emitente-hsbc-limite.cod-emitente = tt_tit_acr_hsbc.cdn_cliente
              AND int-emitente-hsbc-limite.ind-tipo     = "Limite":U NO-LOCK NO-ERROR.

        IF AVAILABLE int-emitente-hsbc-limite THEN
            ASSIGN tt_tit_acr_hsbc.val_limite = int-emitente-hsbc-limite.val-limite.
        ELSE
            ASSIGN tt_tit_acr_hsbc.val_limite = 0.00.
    END.

    DISPLAY v_tot_sel
        WITH FRAME fPage0.

    br_tit_acr_hsbc:REFRESH() IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_ok wWindow
ON CHOOSE OF bt_ok IN FRAME fPage0 /* OK */
DO:
    RUN pi_execute.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt_range
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt_range wWindow
ON CHOOSE OF bt_range IN FRAME fPage0 /* Faixa */
DO:
    RUN frame_range.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi_mover_coluna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi_mover_coluna wWindow
ON VALUE-CHANGED OF MENU-ITEM mi_mover_coluna /* Mover Coluna? */
DO:
    br_tit_acr_hsbc:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    ASSIGN MENU-ITEM mi_ordenar_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc = NOT SELF:CHECKED.

    ASSIGN br_tit_acr_hsbc:ALLOW-COLUMN-SEARCHING IN FRAME fPage0 = MENU-ITEM mi_ordenar_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc
           br_tit_acr_hsbc:COLUMN-MOVABLE         IN FRAME fPage0 = MENU-ITEM mi_mover_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi_ordenar_coluna
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi_ordenar_coluna wWindow
ON VALUE-CHANGED OF MENU-ITEM mi_ordenar_coluna /* Ordenar Coluna? */
DO:
    br_tit_acr_hsbc:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    ASSIGN MENU-ITEM mi_mover_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc = NOT SELF:CHECKED.

    ASSIGN br_tit_acr_hsbc:ALLOW-COLUMN-SEARCHING IN FRAME fPage0 = MENU-ITEM mi_ordenar_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc
           br_tit_acr_hsbc:COLUMN-MOVABLE         IN FRAME fPage0 = MENU-ITEM mi_mover_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
    RUN destroy_interface.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

&IF DEFINED(PROGRAM-TITLE) <> 0    AND
    "{&PROGRAM-TITLE}":U   <> "":U &THEN
ASSIGN CURRENT-WINDOW:TITLE = "{&PROGRAM-TITLE}":U.
&ELSE
ASSIGN CURRENT-WINDOW:TITLE = "<T÷TULO>":U.
&ENDIF
    
&IF DEFINED(PROGRAM) <> 0    AND
    "{&PROGRAM}":U   <> "":U &THEN
ASSIGN CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - {&PROGRAM}":U.
&ELSE
ASSIGN CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - <PROGRAMA>":U.
&ENDIF
    
&IF DEFINED(PROGRAM-VERSION) <> 0    AND
    "{&PROGRAM-VERSION}":U   <> "":U &THEN
ASSIGN CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - ({&PROGRAM-VERSION})":U.
&ELSE
ASSIGN CURRENT-WINDOW:TITLE = CURRENT-WINDOW:TITLE + " - (9.99.99.999)":U.
&ENDIF

ASSIGN CURRENT-WINDOW:MIN-WIDTH  = CURRENT-WINDOW:WIDTH
       CURRENT-WINDOW:MIN-HEIGHT = CURRENT-WINDOW:HEIGHT
       v_win_original_width      = CURRENT-WINDOW:WIDTH
       v_win_original_height     = CURRENT-WINDOW:HEIGHT.
       
ASSIGN MENU-ITEM mi_ordenar_coluna:CHECKED IN MENU pm_br_tit_acr_hsbc = YES
       MENU-ITEM mi_mover_coluna:CHECKED   IN MENU pm_br_tit_acr_hsbc = NO.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN initialize_interface.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy_interface wWindow 
PROCEDURE destroy_interface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Before disable_UI */


    /* disable_UI */
    RUN disable_UI.

    /* After disable_UI */


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY v_tot_sel 
      WITH FRAME fPage0 IN WINDOW wWindow.
  ENABLE br_tit_acr_hsbc bt_all bt_none v_tot_sel bt_ok bt_cancel bt_range 
         bt_help 
      WITH FRAME fPage0 IN WINDOW wWindow.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE frame_range wWindow 
PROCEDURE frame_range :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE IMAGE IMAGE-1
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-2
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-3
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-4
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-5
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-6
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY .88.

    DEFINE BUTTON bt_pesq_cliente_ini
         IMAGE-UP FILE "image/im-consulta.bmp":U
         LABEL "&Pesquisar":U
         SIZE 4 BY 1.

    DEFINE IMAGE IMAGE-7
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-8
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY .88.

    DEFINE BUTTON bt_pesq_cliente_fin
         IMAGE-UP FILE "image/im-consulta.bmp":U
         LABEL "&Pesquisar":U
         SIZE 4 BY 1.

    DEFINE IMAGE IMAGE-9
         FILENAME "image/im-fir.bmp":U
         SIZE 3 BY .88.

    DEFINE IMAGE IMAGE-10
         FILENAME "image/im-las.bmp":U
         SIZE 3 BY .88.

    DEFINE RECTANGLE rtFields
         EDGE-PIXELS 2 GRAPHIC-EDGE NO-FILL
         SIZE 60 BY 5.25.

    DEFINE BUTTON bt_ok_range AUTO-GO
         LABEL "&OK":U
         SIZE 10 BY 1.

    DEFINE BUTTON bt_cancel_range AUTO-END-KEY
         LABEL "&Cancelar":U
         SIZE 10 BY 1.

    DEFINE BUTTON bt_help_range
         LABEL "&Ajuda":U
         SIZE 10 BY 1.

    DEFINE RECTANGLE rtToolBar
         EDGE-PIXELS 2 GRAPHIC-EDGE
         SIZE 60 BY 1.42
         BGCOLOR 18.

    DEFINE FRAME f_dlg_01_range
        v_cod_estab_ini          AT ROW 1.33 COLUMN 27.00 RIGHT-ALIGNED HELP "C¢digo Estabelecimento - Inicial":U
        IMAGE-1                  AT ROW 1.33 COLUMN 28.43
        IMAGE-2                  AT ROW 1.33 COLUMN 36.43
        v_cod_estab_fin          AT ROW 1.33 COLUMN 39.71               HELP "C¢digo Estabelecimento - Final":U         NO-LABEL
        v_dat_emis_docto_ini     AT ROW 2.33 COLUMN 27.00 RIGHT-ALIGNED HELP "Data Emiss∆o Documento - Inicial":U
        IMAGE-3                  AT ROW 2.33 COLUMN 28.43
        IMAGE-4                  AT ROW 2.33 COLUMN 36.43
        v_dat_emis_docto_fin     AT ROW 2.33 COLUMN 39.71               HELP "Data Emiss∆o Documento - Final":U         NO-LABEL
        v_dat_vencto_tit_acr_ini AT ROW 3.33 COLUMN 27.00 RIGHT-ALIGNED HELP "Data Vencimento T°tulo - Inicial":U
        IMAGE-5                  AT ROW 3.33 COLUMN 28.43
        IMAGE-6                  AT ROW 3.33 COLUMN 36.43
        v_dat_vencto_tit_acr_fin AT ROW 3.33 COLUMN 39.71               HELP "Data Vencimento T°tulo - Final":U         NO-LABEL
        v_cdn_cliente_ini        AT ROW 4.33 COLUMN 22.86 RIGHT-ALIGNED HELP "C¢digo Cliente - Inicial":U
        bt_pesq_cliente_ini      AT ROW 4.25 COLUMN 27.00 RIGHT-ALIGNED HELP "Pesquisar Cliente - Inicial":U
        IMAGE-7                  AT ROW 4.33 COLUMN 28.43
        IMAGE-8                  AT ROW 4.33 COLUMN 36.43
        v_cdn_cliente_fin        AT ROW 4.33 COLUMN 39.71               HELP "C¢digo Cliente - Final":U                 NO-LABEL
        bt_pesq_cliente_fin      AT ROW 4.25 COLUMN 50.43               HELP "Pesquisar Cliente - Final":U
        v_val_sdo_tit_acr_ini    AT ROW 5.33 COLUMN 27.00 RIGHT-ALIGNED HELP "Valor Saldo Contas a Receber - Inicial":U
        IMAGE-9                  AT ROW 5.33 COLUMN 28.43
        IMAGE-10                 AT ROW 5.33 COLUMN 36.43
        v_val_sdo_tit_acr_fin    AT ROW 5.33 COLUMN 39.71               HELP "Valor Saldo Contas a Receber - Final":U   NO-LABEL
        rtFields                 AT ROW 1.17 COLUMN  1.57
        bt_ok_range              AT ROW 6.83 COLUMN  2.57               HELP "OK":U
        bt_cancel_range          AT ROW 6.83 COLUMN 13.57               HELP "Cancelar":U
        bt_help_range            AT ROW 6.83 COLUMN 59.57 RIGHT-ALIGNED HELP "Ajuda":U
        rtToolBar                AT ROW 6.58 COLUMN  1.57
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE THREE-D
            SCROLLABLE FONT 1 BGCOLOR 17 TITLE "Faixa":U
            DEFAULT-BUTTON bt_ok_range CANCEL-BUTTON bt_cancel_range.

    &IF DEFINED(PROGRAM-TITLE) <> 0    AND
        "{&PROGRAM-TITLE}":U   <> "":U &THEN
    ASSIGN FRAME f_dlg_01_range:TITLE = FRAME f_dlg_01_range:TITLE + " - ":U + "{&PROGRAM-TITLE}":U.
    &ENDIF

    ASSIGN FRAME f_dlg_01_range:SCROLLABLE = NO
           FRAME f_dlg_01_range:HIDDEN     = YES.

    ON WINDOW-CLOSE OF FRAME f_dlg_01_range
    DO:
        APPLY "END-ERROR":U TO FRAME f_dlg_01_range.
    END.

    ON "F5":U OF v_cdn_cliente_ini IN FRAME f_dlg_01_range
    DO:
        APPLY "CHOOSE":U TO bt_pesq_cliente_ini IN FRAME f_dlg_01_range.
        APPLY "ENTRY":U TO v_cdn_cliente_ini IN FRAME f_dlg_01_range.
    END.

    ON CHOOSE OF bt_pesq_cliente_ini IN FRAME f_dlg_01_range
    DO:
        IF SEARCH("prgint/utb/utb107ka.r":U) = ? AND
           SEARCH("prgint/utb/utb107ka.p":U) = ? THEN DO:
            MESSAGE "Programa execut†vel n∆o foi encontrado: prgint/utb/utb107ka.p.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            RETURN NO-APPLY.
        END.
        ELSE
            RUN prgint/utb/utb107ka.p.

        IF v_rec_cliente <> ? THEN DO:
            FIND FIRST emscad.cliente
                WHERE RECID(emscad.cliente) = v_rec_cliente NO-LOCK NO-ERROR.

            IF AVAILABLE emscad.cliente THEN DO:
                ASSIGN v_cdn_cliente_ini = emscad.cliente.cdn_cliente.

                DISPLAY v_cdn_cliente_ini
                    WITH FRAME f_dlg_01_range.
            END.
        END.

        APPLY "ENTRY":U TO bt_pesq_cliente_ini IN FRAME f_dlg_01_range.
    END.

    ON "F5":U OF v_cdn_cliente_fin IN FRAME f_dlg_01_range
    DO:
        APPLY "CHOOSE":U TO bt_pesq_cliente_fin IN FRAME f_dlg_01_range.
        APPLY "ENTRY":U TO v_cdn_cliente_fin IN FRAME f_dlg_01_range.
    END.

    ON CHOOSE OF bt_pesq_cliente_fin IN FRAME f_dlg_01_range /* Pesquisar */
    DO:
        IF SEARCH("prgint/utb/utb107ka.r":U) = ? AND
           SEARCH("prgint/utb/utb107ka.p":U) = ? THEN DO:
            MESSAGE "Programa execut†vel n∆o foi encontrado: prgint/utb/utb107ka.p.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            RETURN NO-APPLY.
        END.
        ELSE
            RUN prgint/utb/utb107ka.p.

        IF v_rec_cliente <> ? THEN DO:
            FIND FIRST emscad.cliente
                WHERE RECID(emscad.cliente) = v_rec_cliente NO-LOCK NO-ERROR.

            IF AVAILABLE emscad.cliente THEN DO:
                ASSIGN v_cdn_cliente_fin = emscad.cliente.cdn_cliente.

                DISPLAY v_cdn_cliente_fin
                    WITH FRAME f_dlg_01_range.
            END.
        END.

        APPLY "ENTRY":U TO bt_pesq_cliente_fin IN FRAME f_dlg_01_range.
    END.

    ON "CHOOSE":U OF bt_ok_range IN FRAME f_dlg_01_range
    DO:
        ASSIGN INPUT FRAME f_dlg_01_range v_cod_estab_ini
                                          v_cod_estab_fin
                                          v_dat_emis_docto_ini
                                          v_dat_emis_docto_fin
                                          v_dat_vencto_tit_acr_ini
                                          v_dat_vencto_tit_acr_fin
                                          v_cdn_cliente_ini
                                          v_cdn_cliente_fin
                                          v_val_sdo_tit_acr_ini
                                          v_val_sdo_tit_acr_fin.

        IF v_cod_estab_ini > v_cod_estab_fin THEN DO:
            MESSAGE "O C¢digo Estabelecimento Inicial deve ser menor ou igual ao C¢digo Estabelecimento Final.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            APPLY "ENTRY":U TO v_cod_estab_ini IN FRAME f_dlg_01_range.

            RETURN NO-APPLY.
        END.

        IF v_dat_emis_docto_ini > v_dat_emis_docto_fin THEN DO:
            MESSAGE "O Data Emiss∆o Inicial deve ser menor ou igual ao Data Emiss∆o Final.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            APPLY "ENTRY":U TO v_dat_emis_docto_ini IN FRAME f_dlg_01_range.

            RETURN NO-APPLY.
        END.

        IF v_dat_vencto_tit_acr_ini > v_dat_vencto_tit_acr_fin THEN DO:
            MESSAGE "O Data Vencimento Inicial deve ser menor ou igual ao Data Vencimento Final.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            APPLY "ENTRY":U TO v_dat_vencto_tit_acr_ini IN FRAME f_dlg_01_range.

            RETURN NO-APPLY.
        END.

        IF v_cdn_cliente_ini > v_cdn_cliente_fin THEN DO:
            MESSAGE "O C¢digo Cliente Inicial deve ser menor ou igual ao C¢digo Cliente Final.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            APPLY "ENTRY":U TO v_cdn_cliente_ini IN FRAME f_dlg_01_range.

            RETURN NO-APPLY.
        END.

        IF v_val_sdo_tit_acr_ini > v_val_sdo_tit_acr_fin THEN DO:
            MESSAGE "O Saldo Inicial deve ser menor ou igual ao Saldo Final.":U
                VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

            APPLY "ENTRY":U TO v_val_sdo_tit_acr_ini IN FRAME f_dlg_01_range.

            RETURN NO-APPLY.
        END.

        APPLY "GO":U TO FRAME f_dlg_01_range.

        HIDE FRAME f_dlg_01_range.

        RUN search_tit_acr.

        APPLY "ENTRY":U TO br_tit_acr_hsbc IN FRAME fPage0.
    END.

    MAIN-BLOCK-RANGE:
    DO ON ERROR   UNDO MAIN-BLOCK-RANGE, LEAVE MAIN-BLOCK-RANGE
       ON END-KEY UNDO MAIN-BLOCK-RANGE, LEAVE MAIN-BLOCK-RANGE:
        DISPLAY v_cod_estab_ini
                v_cod_estab_fin
                v_dat_emis_docto_ini
                v_dat_emis_docto_fin
                v_dat_vencto_tit_acr_ini
                v_dat_vencto_tit_acr_fin
                v_cdn_cliente_ini
                v_cdn_cliente_fin
                v_val_sdo_tit_acr_ini
                v_val_sdo_tit_acr_fin
            WITH FRAME f_dlg_01_range.

        ENABLE v_cod_estab_ini
               v_cod_estab_fin
               v_dat_emis_docto_ini
               v_dat_emis_docto_fin
               v_dat_vencto_tit_acr_ini
               v_dat_vencto_tit_acr_fin
               v_cdn_cliente_ini
               bt_pesq_cliente_ini
               v_cdn_cliente_fin
               bt_pesq_cliente_fin
               v_val_sdo_tit_acr_ini
               v_val_sdo_tit_acr_fin
               bt_ok_range
               bt_cancel_range
               bt_help_range
            WITH FRAME f_dlg_01_range.

        VIEW FRAME f_dlg_01_range.

        WAIT-FOR GO OF FRAME f_dlg_01_range.
    END.

    HIDE FRAME f_dlg_01_range.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize_interface wWindow 
PROCEDURE initialize_interface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Before enable_UI */
    RUN initialize_range_variable.

    /* enable_UI */
    RUN enable_UI.

    /* After enable_UI */
    RUN frame_range.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize_range_variable wWindow 
PROCEDURE initialize_range_variable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF v_cod_estab_usuar <> "":U AND
       v_cod_estab_usuar <> ?    THEN
        ASSIGN v_cod_estab_ini = v_cod_estab_usuar
               v_cod_estab_fin = v_cod_estab_usuar.
    ELSE IF v_cod_estab_usuar <> "":U AND
            v_cod_estab_usuar <> ?    THEN
        ASSIGN v_cod_estab_ini = v_cod_estab_usuar
               v_cod_estab_fin = v_cod_estab_usuar.
    ELSE
        ASSIGN v_cod_estab_ini = "":U
               v_cod_estab_fin = "ZZZ":U.

    ASSIGN v_dat_emis_docto_ini     = DATE(MONTH(TODAY), 01, YEAR(TODAY))
           v_dat_emis_docto_fin     = TODAY
           v_dat_vencto_tit_acr_ini = DATE(01, 01, YEAR(TODAY))
           v_dat_vencto_tit_acr_fin = DATE(12, 31, YEAR(TODAY))
           v_cdn_cliente_ini        = 0
           v_cdn_cliente_fin        = 999999999
           v_val_sdo_tit_acr_ini    = 0.00
           v_val_sdo_tit_acr_fin    = 999999999.99.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_execute wWindow 
PROCEDURE pi_execute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c_status         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_num_procedure  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_cod_refer_impl AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE v_count          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE v_aux            AS INTEGER     NO-UNDO.

    IF NOT CAN-FIND(FIRST tt_tit_acr_hsbc
                    WHERE tt_tit_acr_hsbc.log_selecionar = YES) THEN DO:
        MESSAGE "Nenhum t°tulo selecionado!":U SKIP
                "Selecione ao menos um t°tulo para realizar a destinaá∆o.":U
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.

        RETURN NO-APPLY.
    END.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    FOR EACH tt_mensagem:
        DELETE tt_mensagem.
    END.

    FOR EACH tt_tit_acr_hsbc
        WHERE tt_tit_acr_hsbc.log_selecionar = YES:

        FIND FIRST tit_acr
            WHERE ROWID(tit_acr) = tt_tit_acr_hsbc.r-Rowid NO-LOCK NO-ERROR.

        IF NOT AVAILABLE tit_acr THEN
            NEXT.

        ASSIGN c_status = "Status... ":U +
                          tit_acr.cod_estab + "/":U +
                          tit_acr.cod_espec_docto + "/":U +
                          tit_acr.cod_ser_docto + "/":U +
                          tit_acr.cod_tit_acr + "/":U +
                          tit_acr.cod_parcela.

        STATUS INPUT c_status IN WINDOW wWindow.

        FOR EACH tt_alter_tit_acr_base_2:
            DELETE tt_alter_tit_acr_base_2.
        END.

        REPEAT:
            ASSIGN v_cod_refer_impl = "HS":U + STRING(YEAR(TODAY), "9999":U) + STRING(MONTH(TODAY), "99":U) + STRING(DAY(TODAY), "99":U)
                   v_num_procedure  = INTEGER(THIS-PROCEDURE:HANDLE) NO-ERROR.

            DO v_count = 1 TO 3:
                ASSIGN v_aux            = (RANDOM(0, v_num_procedure) MODULO 26) + 97
                       v_cod_refer_impl = v_cod_refer_impl + CHR(v_aux).
            END.

            FIND FIRST movto_tit_acr
                WHERE movto_tit_acr.cod_estab = tit_acr.cod_estab
                  AND movto_tit_acr.cod_refer = v_cod_refer_impl NO-LOCK NO-ERROR.

            IF NOT AVAILABLE movto_tit_acr THEN
                LEAVE.
        END. /* REPEAT: */

        CREATE tt_alter_tit_acr_base_2.
        ASSIGN tt_alter_tit_acr_base_2.tta_cod_estab                   = tit_acr.cod_estab
               tt_alter_tit_acr_base_2.tta_num_id_tit_acr              = tit_acr.num_id_tit_acr
               tt_alter_tit_acr_base_2.tta_dat_transacao               = TODAY
               tt_alter_tit_acr_base_2.tta_cod_refer                   = v_cod_refer_impl
               tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_imp = ?
               tt_alter_tit_acr_base_2.tta_val_sdo_tit_acr             = ?
               tt_alter_tit_acr_base_2.ttv_cod_motiv_movto_tit_acr_alt = ?
               tt_alter_tit_acr_base_2.ttv_ind_motiv_acerto_val        = ?
               tt_alter_tit_acr_base_2.tta_cod_portador                = ?
               tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = ?
               tt_alter_tit_acr_base_2.tta_val_despes_bcia             = ?
               tt_alter_tit_acr_base_2.tta_cod_agenc_cobr_bcia         = ?
               tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
               tt_alter_tit_acr_base_2.tta_dat_emis_docto              = ?
               tt_alter_tit_acr_base_2.tta_dat_vencto_tit_acr          = tit_acr.dat_vencto_tit_acr
               tt_alter_tit_acr_base_2.tta_dat_prev_liquidac           = tit_acr.dat_prev_liquidac
               tt_alter_tit_acr_base_2.tta_dat_fluxo_tit_acr           = ?
               tt_alter_tit_acr_base_2.tta_ind_sit_tit_acr             = ?
               tt_alter_tit_acr_base_2.tta_cod_cond_cobr               = ?
               tt_alter_tit_acr_base_2.tta_log_tip_cr_perda_dedut_tit  = ?
               tt_alter_tit_acr_base_2.tta_dat_abat_tit_acr            = ?
               tt_alter_tit_acr_base_2.tta_val_perc_abat_acr           = ?
               tt_alter_tit_acr_base_2.tta_val_abat_tit_acr            = ?
               tt_alter_tit_acr_base_2.tta_dat_desconto                = ?
               tt_alter_tit_acr_base_2.tta_val_perc_desc               = ?
               tt_alter_tit_acr_base_2.tta_val_desc_tit_acr            = ?
               tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_juros_acr   = ?
               tt_alter_tit_acr_base_2.tta_val_perc_juros_dia_atraso   = ?
               tt_alter_tit_acr_base_2.tta_qtd_dias_carenc_multa_acr   = ?
               tt_alter_tit_acr_base_2.tta_val_perc_multa_atraso       = ?
               tt_alter_tit_acr_base_2.ttv_cod_portador_mov            = ?
               tt_alter_tit_acr_base_2.tta_ind_tip_cobr_acr            = ?
               tt_alter_tit_acr_base_2.tta_ind_ender_cobr              = ?
               tt_alter_tit_acr_base_2.tta_nom_abrev_contat            = ?
               tt_alter_tit_acr_base_2.tta_val_liq_tit_acr             = ?
               tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_1_movto    = ?
               tt_alter_tit_acr_base_2.tta_cod_instruc_bcia_2_movto    = ?
               tt_alter_tit_acr_base_2.tta_log_tit_acr_destndo         = ?
               tt_alter_tit_acr_base_2.tta_cod_histor_padr             = ?
               tt_alter_tit_acr_base_2.ttv_des_text_histor             = "Titulo destinado para o HSBC - processo de Cess∆o de CrÇdito em ":U + STRING(TODAY, "99/99/9999":U)
               tt_alter_tit_acr_base_2.tta_des_obs_cobr                = ?
               tt_alter_tit_acr_base_2.tta_num_seq_tit_acr             = ?
               tt_alter_tit_acr_base_2.ttv_cod_estab_planilha          = ?
               tt_alter_tit_acr_base_2.tta_cod_tit_acr_bco             = ?
               tt_alter_tit_acr_base_2.tta_cod_portador                = "399":U
               tt_alter_tit_acr_base_2.tta_cod_cart_bcia               = "10":U.

        RUN prgfin/acr/acr711zo.py (INPUT  4,
                                    INPUT  TABLE tt_alter_tit_acr_base_2,
                                    INPUT  TABLE tt_alter_tit_acr_rateio,
                                    INPUT  TABLE tt_alter_tit_acr_ped_vda,
                                    INPUT  TABLE tt_alter_tit_acr_comis,
                                    INPUT  TABLE tt_alter_tit_acr_cheq,
                                    INPUT  TABLE tt_alter_tit_acr_iva,
                                    INPUT  TABLE tt_alter_tit_acr_impto_retid_2,
                                    INPUT  TABLE tt_alter_tit_acr_cobr_espec_2,
                                    INPUT  TABLE tt_alter_tit_acr_rat_desp_rec,
                                    OUTPUT TABLE tt_log_erros_alter_tit_acr,
                                    INPUT  NO).

        IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO:
            FOR EACH tt_log_erros_alter_tit_acr:
                CREATE tt_mensagem.
                ASSIGN tt_mensagem.cod_estabel    = tt_log_erros_alter_tit_acr.tta_cod_estab
                       tt_mensagem.num_id_tit_acr = tt_log_erros_alter_tit_acr.tta_num_id_tit_acr
                       tt_mensagem.num_mensagem   = tt_log_erros_alter_tit_acr.ttv_num_mensagem
                       tt_mensagem.texto_mensagem = tt_log_erros_alter_tit_acr.ttv_des_msg_erro
                       tt_mensagem.texto_ajuda    = tt_log_erros_alter_tit_acr.ttv_des_msg_ajuda.

                CASE tt_log_erros_alter_tit_acr.ttv_cod_tip_msg_dwb:
                    WHEN "Warning":U THEN
                        ASSIGN tt_mensagem.tipo_mensagem = "Advertància":U.
                    WHEN "Information":U THEN
                        ASSIGN tt_mensagem.tipo_mensagem = "Informaá∆o":U.
                    WHEN "Question":U THEN
                        ASSIGN tt_mensagem.tipo_mensagem = "Pergunta":U.
                    OTHERWISE
                        ASSIGN tt_mensagem.tipo_mensagem = "Erro":U.
                END CASE.
            END.
        END. /* IF CAN-FIND(FIRST tt_log_erros_alter_tit_acr) THEN DO: */
    END. /* FOR EACH tt_tit_acr_hsbc
                WHERE tt_tit_acr_hsbc.log_selecionar = YES: */

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    RUN pi_report.

    EMPTY TEMP-TABLE tt_tit_acr_hsbc.

    br_tit_acr_hsbc:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    ASSIGN v_tot_sel = 0.00.

    DISPLAY v_tot_sel
        WITH FRAME fPage0.

    {&OPEN-QUERY-br_tit_acr_hsbc}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_report wWindow 
PROCEDURE pi_report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-empresa      AS CHARACTER   NO-UNDO FORMAT "x(40)":U.
    DEFINE VARIABLE c-titulo-relat AS CHARACTER   NO-UNDO FORMAT "x(50)":U.
    DEFINE VARIABLE c-sistema      AS CHARACTER   NO-UNDO FORMAT "x(25)":U.
    DEFINE VARIABLE c-rodape       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-programa     AS CHARACTER   NO-UNDO FORMAT "x(8)":U.
    DEFINE VARIABLE c-versao       AS CHARACTER   NO-UNDO FORMAT "x(4)":U.
    DEFINE VARIABLE c-dir          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-dir-subdir   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-observacao   AS CHARACTER   NO-UNDO FORMAT "x(60)":U LABEL "Observaá∆o":U COLUMN-LABEL "Observaá∆o":U.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    FIND FIRST emscad.empresa
        WHERE emscad.empresa.cod_empresa = v_cod_empres_usuar NO-LOCK NO-ERROR.

    ASSIGN c-empresa = IF AVAILABLE emscad.empresa THEN emscad.empresa.nom_razao_social ELSE "":U
           c-sistema = "Espec°ficos Intelbras":U.

    &IF DEFINED(PROGRAM-TITLE) <> 0    AND
        "{&PROGRAM-TITLE}":U   <> "":U &THEN
    ASSIGN c-titulo-relat = "{&PROGRAM-TITLE}":U.
    &ENDIF
    
    &IF DEFINED(PROGRAM) <> 0    AND
        "{&PROGRAM}":U   <> "":U &THEN
    ASSIGN c-programa = "{&PROGRAM}":U.
    &ENDIF
    
    &IF DEFINED(PROGRAM-VERSION) <> 0 AND
        "{&PROGRAM-VERSION}":U   <> "":U &THEN
    ASSIGN c-versao = "{&PROGRAM-VERSION}":U.
    &ENDIF

    FORM HEADER
        FILL("-":U, 153) FORMAT "x(153)":U SKIP
        c-empresa c-titulo-relat AT 61
        TODAY FORMAT "99/99/9999":U AT 133 "-":U AT 144 STRING(TIME, "HH:MM:SS":U) AT 146 SKIP
        FILL("-":U, 153) FORMAT "x(153)":U SKIP(1)
        WITH STREAM-IO WIDTH 153 NO-LABELS NO-BOX PAGE-TOP FRAME f-cabec.

    ASSIGN c-rodape = "DATASUL - ":U + c-sistema + " - " + c-programa + " - V:":U + c-versao.
           c-rodape = fill("-", 153 - length(c-rodape)) + c-rodape.

    FORM HEADER
        c-rodape FORMAT "x(153)":U
        WITH STREAM-IO WIDTH 153 NO-LABELS NO-BOX PAGE-BOTTOM FRAME f-rodape.

    FORM tt_tit_acr_hsbc.cod_estab
         tt_tit_acr_hsbc.cod_espec_docto
         tt_tit_acr_hsbc.cod_ser_docto
         tt_tit_acr_hsbc.cod_tit_acr
         tt_tit_acr_hsbc.cod_parcela
         tt_tit_acr_hsbc.cdn_cliente
         tt_tit_acr_hsbc.nom_abrev
         tt_tit_acr_hsbc.dat_emis_docto
         tt_tit_acr_hsbc.dat_vencto_tit_acr
         tt_tit_acr_hsbc.val_sdo_tit_acr
        WITH FRAME f_destinacao DOWN STREAM-IO WIDTH 153.

    FORM tt_tit_acr_hsbc.cod_estab       COLUMN-LABEL "Est":U
         tt_tit_acr_hsbc.cod_espec_docto COLUMN-LABEL "Esp":U
         tt_tit_acr_hsbc.cod_ser_docto   COLUMN-LABEL "Ser":U
         tt_tit_acr_hsbc.cod_tit_acr
         tt_tit_acr_hsbc.cod_parcela     COLUMN-LABEL "/P":U
         tt_tit_acr_hsbc.cdn_cliente
         tt_tit_acr_hsbc.nom_abrev
         tt_tit_acr_hsbc.dat_emis_docto
         tt_tit_acr_hsbc.dat_vencto_tit_acr
         tt_tit_acr_hsbc.val_sdo_tit_acr
         c-observacao
        WITH FRAME f_nao_destinacao DOWN STREAM-IO WIDTH 153.

    ASSIGN c-arquivo = "":U.

    FIND FIRST usuar_mestre
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK NO-ERROR.

    IF AVAILABLE usuar_mestre THEN DO:
        ASSIGN c-dir = REPLACE(usuar_mestre.nom_dir_spool, "~\":U, "/":U).

        IF SUBSTRING(c-dir, LENGTH(c-dir), 1) <> "/":U THEN
            ASSIGN c-dir = c-dir + "/":U.

        ASSIGN c-dir-subdir = c-dir + REPLACE(usuar_mestre.nom_subdir_spool, "~\":U, "/":U).

        FILE-INFO:FILE-NAME = c-dir-subdir.

        IF FILE-INFO:FULL-PATHNAME           <> ?    AND
           FILE-INFO:FULL-PATHNAME           <> "":U AND
           INDEX(FILE-INFO:FILE-TYPE, "D":U) <> 0    THEN
            ASSIGN c-arquivo = FILE-INFO:FULL-PATHNAME.
        ELSE DO:
            FILE-INFO:FILE-NAME = c-dir.

            IF FILE-INFO:FULL-PATHNAME           <> ?    AND
               FILE-INFO:FULL-PATHNAME           <> "":U AND
               INDEX(FILE-INFO:FILE-TYPE, "D":U) <> 0    THEN DO:
                OS-CREATE-DIR VALUE(c-dir-subdir).

                FILE-INFO:FILE-NAME = c-dir-subdir.

                IF FILE-INFO:FULL-PATHNAME           <> ?    AND
                   FILE-INFO:FULL-PATHNAME           <> "":U AND
                   INDEX(FILE-INFO:FILE-TYPE, "D":U) <> 0    THEN
                    ASSIGN c-arquivo = FILE-INFO:FULL-PATHNAME.
                ELSE
                    ASSIGN c-arquivo = c-dir.
            END.
        END.
    END.

    IF c-arquivo = "":U THEN DO:
        FILE-INFO:FILE-NAME = "C:/temp":U.

        IF FILE-INFO:FULL-PATHNAME           <> ?    AND
           FILE-INFO:FULL-PATHNAME           <> "":U AND
           INDEX(FILE-INFO:FILE-TYPE, "D":U) <> 0    THEN
            ASSIGN c-arquivo = FILE-INFO:FULL-PATHNAME.
        ELSE DO:
            FILE-INFO:FILE-NAME = SESSION:TEMP-DIRECTORY.

            IF FILE-INFO:FULL-PATHNAME           <> ?    AND
               FILE-INFO:FULL-PATHNAME           <> "":U AND
               INDEX(FILE-INFO:FILE-TYPE, "D":U) <> 0    THEN
                ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY.
            ELSE DO:
                IF SESSION:SET-WAIT-STATE("":U) THEN.

                MESSAGE "N∆o encontrado diret¢rio para geraá∆o do arquivo":U SKIP
                        "com os t°tulos destinados.":U
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

                RETURN "NOK":U.
            END.
        END.
    END.

    ASSIGN c-arquivo = REPLACE(c-arquivo, "~\":U, "/":U).

    IF SUBSTRING(c-arquivo, LENGTH(c-arquivo), 1) <> "/":U THEN
        ASSIGN c-arquivo = c-arquivo + "/":U.

    &IF DEFINED(PROGRAM) <> 0    AND
        "{&PROGRAM}":U   <> "":U &THEN
    ASSIGN c-arquivo = c-arquivo + "{&PROGRAM}":U.
    &ELSE
    ASSIGN c-arquivo = c-arquivo + "ESACR058":U.
    &ENDIF
    
    ASSIGN c-arquivo = c-arquivo + "-":U + SUBSTRING(ISO-DATE(TODAY), 1, 10) + "-":U + REPLACE(STRING(TIME, "hh:mm:ss":U), ":":U, ".":U) + ".txt":U.

    FOR EACH tt_tit_acr_hsbc:
        IF tt_tit_acr_hsbc.log_selecionar AND
           NOT CAN-FIND(FIRST tt_mensagem
                        WHERE tt_mensagem.cod_estabel    = tt_tit_acr_hsbc.cod_estab
                          AND tt_mensagem.num_id_tit_acr = tt_tit_acr_hsbc.num_id_tit_acr
                          AND tt_mensagem.tipo_mensagem  = "Erro":U) THEN DO:
            ASSIGN tt_tit_acr_hsbc.log_destinados    = YES.
        END.
        ELSE
            ASSIGN tt_tit_acr_hsbc.log_destinados    = NO.
    END.

    OUTPUT STREAM str-rp TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1":U.

    VIEW STREAM str-rp FRAME f-cabec.

    FOR EACH tt_tit_acr_hsbc
        WHERE tt_tit_acr_hsbc.log_destinados = YES
        BREAK BY tt_tit_acr_hsbc.cod_estab:

        IF FIRST-OF(tt_tit_acr_hsbc.cod_estab) THEN
            PUT STREAM str-rp UNFORMATTED SKIP "Relaá∆o dos T°tulos Destinados":U SKIP(1).

        DISPLAY STREAM str-rp
                tt_tit_acr_hsbc.cod_estab
                tt_tit_acr_hsbc.cod_espec_docto
                tt_tit_acr_hsbc.cod_ser_docto
                tt_tit_acr_hsbc.cod_tit_acr
                tt_tit_acr_hsbc.cod_parcela
                tt_tit_acr_hsbc.cdn_cliente
                tt_tit_acr_hsbc.nom_abrev
                tt_tit_acr_hsbc.dat_emis_docto
                tt_tit_acr_hsbc.dat_vencto_tit_acr
                tt_tit_acr_hsbc.val_sdo_tit_acr
            WITH FRAME f_destinacao.
        DOWN STREAM str-rp WITH FRAME f_destinacao.

        ACCUMULATE tt_tit_acr_hsbc.val_sdo_tit_acr (TOTAL COUNT).

        IF LAST-OF(tt_tit_acr_hsbc.cod_estab) THEN
            PUT STREAM str-rp UNFORMATTED FILL("-":U, 14)                                                         AT  87 SKIP
                                          "Total Geral:":U                                                        AT  75
                                          STRING(ACCUM TOTAL tt_tit_acr_hsbc.val_sdo_tit_acr, ">>>,>>>,>>9.99":U) AT  87
                                          "-":U                                                                   AT 102
                                          STRING(ACCUM COUNT tt_tit_acr_hsbc.val_sdo_tit_acr, ">>>>>>>9":U)       AT 104
                                          "T°tulo(s)":U                                                           AT 113 SKIP(2).
    END.

    FOR EACH tt_tit_acr_hsbc
        WHERE tt_tit_acr_hsbc.log_destinados = NO
        BREAK BY tt_tit_acr_hsbc.cod_estab:

        IF FIRST-OF(tt_tit_acr_hsbc.cod_estab) THEN
            PUT STREAM str-rp UNFORMATTED SKIP "Relaá∆o dos T°tulos N∆o Destinados":U SKIP(1).

        DISPLAY STREAM str-rp
                tt_tit_acr_hsbc.cod_estab
                tt_tit_acr_hsbc.cod_espec_docto
                tt_tit_acr_hsbc.cod_ser_docto
                tt_tit_acr_hsbc.cod_tit_acr
                tt_tit_acr_hsbc.cod_parcela
                tt_tit_acr_hsbc.cdn_cliente
                tt_tit_acr_hsbc.nom_abrev
                tt_tit_acr_hsbc.dat_emis_docto
                tt_tit_acr_hsbc.dat_vencto_tit_acr
                tt_tit_acr_hsbc.val_sdo_tit_acr
                c-observacao
            WITH FRAME f_nao_destinacao.

        IF tt_tit_acr_hsbc.log_selecionar AND
           CAN-FIND(FIRST tt_mensagem
                    WHERE tt_mensagem.cod_estabel    = tt_tit_acr_hsbc.cod_estab
                      AND tt_mensagem.num_id_tit_acr = tt_tit_acr_hsbc.num_id_tit_acr
                      AND tt_mensagem.tipo_mensagem  = "Erro":U) THEN DO:
            FOR EACH tt_mensagem
                WHERE tt_mensagem.cod_estabel    = tt_tit_acr_hsbc.cod_estab
                  AND tt_mensagem.num_id_tit_acr = tt_tit_acr_hsbc.num_id_tit_acr
                  AND tt_mensagem.tipo_mensagem  = "Erro":U:
                ASSIGN c-observacao = tt_mensagem.texto_mensagem.

                DISPLAY STREAM str-rp
                        c-observacao
                    WITH FRAME f_nao_destinacao.
                DOWN STREAM str-rp WITH FRAME f_nao_destinacao.
            END.
        END.
        ELSE DO:
            ASSIGN c-observacao = IF NOT tt_tit_acr_hsbc.log_selecionar THEN "T°tulo/Parcela n∆o selecionado(a)":U ELSE "":U.

            DISPLAY STREAM str-rp
                    c-observacao
                WITH FRAME f_nao_destinacao.
            DOWN STREAM str-rp WITH FRAME f_nao_destinacao.
        END.

        ACCUMULATE tt_tit_acr_hsbc.val_sdo_tit_acr (TOTAL COUNT).

        IF LAST-OF(tt_tit_acr_hsbc.cod_estab) THEN
            PUT STREAM str-rp UNFORMATTED FILL("-":U, 14)                                                         AT  77 SKIP
                                          "Total Geral:":U                                                        AT  65
                                          STRING(ACCUM TOTAL tt_tit_acr_hsbc.val_sdo_tit_acr, ">>>,>>>,>>9.99":U) AT  77
                                          "-":U                                                                   AT  92
                                          STRING(ACCUM COUNT tt_tit_acr_hsbc.val_sdo_tit_acr, ">>>>>>>9":U)       AT  94
                                          "T°tulo(s)":U                                                           AT 103 SKIP(2).
    END.

    VIEW STREAM str-rp FRAME f-rodape.

    OUTPUT STREAM str-rp CLOSE.

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    FILE-INFO:FILE-NAME = c-arquivo.

    IF FILE-INFO:FULL-PATHNAME           = ?    OR
       FILE-INFO:FULL-PATHNAME           = "":U OR
       INDEX(FILE-INFO:FILE-TYPE, "F":U) = 0    THEN DO:
        MESSAGE "Arquivo de t°tulos destinados n∆o encontrado!":U SKIP
                c-arquivo
            VIEW-AS ALERT-BOX ERROR BUTTONS OK TITLE "Erro":U.

        RETURN "NOK":U.
    END.

    OS-COMMAND NO-WAIT VALUE(c-arquivo) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        MESSAGE "Arquivo gerado em: ":U c-arquivo
            VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Informaá∆o":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE search_tit_acr wWindow 
PROCEDURE search_tit_acr :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c_status AS CHARACTER   NO-UNDO.

    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN.

    EMPTY TEMP-TABLE tt_tit_acr_hsbc.

    br_tit_acr_hsbc:CLEAR-SORT-ARROWS() IN FRAME fPage0.

    ASSIGN v_tot_sel = 0.00.

    DISPLAY v_tot_sel
        WITH FRAME fPage0.

    {&OPEN-QUERY-br_tit_acr_hsbc}

    STATUS INPUT "Iniciando Busca...":U IN WINDOW wWindow.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_empresa = v_cod_empres_usuar
          AND estabelecimento.cod_estab  >= v_cod_estab_ini
          AND estabelecimento.cod_estab  <= v_cod_estab_fin,
        EACH tit_acr NO-LOCK
        WHERE tit_acr.cod_estab             = estabelecimento.cod_estab
          AND tit_acr.log_sdo_tit_acr       = YES
          AND tit_acr.log_tit_acr_estordo   = NO
          AND tit_acr.log_tit_acr_cobr_bcia = NO
          AND tit_acr.ind_tip_espec_docto   = "Normal":U
          AND tit_acr.ind_sit_tit_acr       = "Normal":U
          AND tit_acr.num_bord_acr          = 0
          AND tit_acr.cod_indic_econ        = "Real":U
          AND tit_acr.cod_portad            = "999"
          AND tit_acr.cod_cart_bcia         = "00"
          AND tit_acr.dat_transacao        <= TODAY
          AND tit_acr.dat_emis_docto       >= v_dat_emis_docto_ini
          AND tit_acr.dat_emis_docto       <= v_dat_emis_docto_fin
          AND tit_acr.dat_vencto_tit_acr   >= v_dat_vencto_tit_acr_ini
          AND tit_acr.dat_vencto_tit_acr   <= v_dat_vencto_tit_acr_fin
          AND tit_acr.cdn_cliente          >= v_cdn_cliente_ini
          AND tit_acr.cdn_cliente          <= v_cdn_cliente_fin
          AND tit_acr.val_sdo_tit_acr      >= v_val_sdo_tit_acr_ini
          AND tit_acr.val_sdo_tit_acr      <= v_val_sdo_tit_acr_fin,
         LAST int-emitente-hsbc NO-LOCK
        WHERE int-emitente-hsbc.cod-emitente = tit_acr.cdn_cliente
          AND int-emitente-hsbc.log-docto    = YES,
         LAST int-emitente-hsbc-limite NO-LOCK
        WHERE int-emitente-hsbc-limite.cod-emitente   = tit_acr.cdn_cliente
          AND int-emitente-hsbc-limite.ind-tipo       = "Limite":U
          AND int-emitente-hsbc-limite.dat-ocorrencia = TODAY:

        ASSIGN c_status = "Status... ":U +
                          tit_acr.cod_estab + "/":U +
                          tit_acr.cod_espec_docto + "/":U +
                          tit_acr.cod_ser_docto + "/":U +
                          tit_acr.cod_tit_acr + "/":U +
                          tit_acr.cod_parcela.

        STATUS INPUT c_status IN WINDOW wWindow.

        CREATE tt_tit_acr_hsbc.
        BUFFER-COPY tit_acr TO tt_tit_acr_hsbc.
        ASSIGN tt_tit_acr_hsbc.r-Rowid        = ROWID(tit_acr)
               tt_tit_acr_hsbc.log_selecionar = NO
               tt_tit_acr_hsbc.val_limite     = int-emitente-hsbc-limite.val-limite.
    END.

    {&OPEN-QUERY-br_tit_acr_hsbc}

    IF SESSION:SET-WAIT-STATE("":U) THEN.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

