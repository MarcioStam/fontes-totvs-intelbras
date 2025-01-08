DEFINE VARIABLE l-av-a AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-ava-fim AS INTEGER FORMAT ">>9" 
     INITIAL 30
     LABEL "A Vencer at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.
    
DEFINE VARIABLE l-av-b AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avb-ini AS INTEGER FORMAT ">>9" 
     INITIAL 31
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avb-fim AS INTEGER FORMAT ">>9" 
     INITIAL 60
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-c AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avc-ini AS INTEGER FORMAT ">>9" 
     INITIAL 61
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avc-fim AS INTEGER FORMAT ">>9" 
     INITIAL 90
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-d AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avd-ini AS INTEGER FORMAT ">>9" 
     INITIAL 91
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avd-fim AS INTEGER FORMAT ">>9" 
     INITIAL 120
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-e AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-ave-ini AS INTEGER FORMAT ">>9"
     INITIAL 121
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ave-fim AS INTEGER FORMAT ">>9" 
     INITIAL 150
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-f AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avf-ini AS INTEGER FORMAT ">>9" 
     INITIAL 151
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-avf-fim AS INTEGER FORMAT ">>9" 
     INITIAL 180
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-av-g AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-avg-ini AS INTEGER FORMAT ">>9" 
     INITIAL 181
     LABEL "mais de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-a AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vea-fim AS INTEGER FORMAT ">>9" 
     INITIAL 30
     LABEL "Vencidos at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.
    
DEFINE VARIABLE l-ve-b AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-veb-ini AS INTEGER FORMAT ">>9" 
     INITIAL 31
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-veb-fim AS INTEGER FORMAT ">>9" 
     INITIAL 60
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-c AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vec-ini AS INTEGER FORMAT ">>9" 
     INITIAL 61
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vec-fim AS INTEGER FORMAT ">>9" 
     INITIAL 90
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-d AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-ved-ini AS INTEGER FORMAT ">>9" 
     INITIAL 91
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-ved-fim AS INTEGER FORMAT ">>9" 
     INITIAL 120
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-e AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vee-ini AS INTEGER FORMAT ">>9"
     INITIAL 121
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vee-fim AS INTEGER FORMAT ">>9" 
     INITIAL 150
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-f AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-vef-ini AS INTEGER FORMAT ">>9" 
     INITIAL 151
     LABEL "de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE fx-vef-fim AS INTEGER FORMAT ">>9" 
     INITIAL 180
     LABEL "at‚"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE l-ve-g AS LOGICAL INITIAL no 
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE VARIABLE fx-veg-ini AS INTEGER FORMAT ">>9" 
     INITIAL 181
     LABEL "mais de"
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEF VAR l-email     AS LOGICAL NO-UNDO.
DEF VAR cod-mensagem-ini        LIKE msg_financ.cod_mensagem.
DEF VAR cod-mensagem-fim        LIKE msg_financ.cod_mensagem.
DEF VAR c-narrativa-ini         AS CHAR FORMAT "x(2000)".
DEF VAR c-narrativa-fim         AS CHAR FORMAT "x(2000)".
DEF VAR l-detalhes  AS LOGICAL NO-UNDO.
DEF VAR l-grupo     AS LOGICAL NO-UNDO.
DEF VAR c-arq-2     AS CHAR    NO-UNDO.
DEF VAR rs-docto    AS INT NO-UNDO.

DEFINE VARIABLE  cod_espec_docto_ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cod_espec_docto_fim AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cod_portador_ini    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cod_portador_fim    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cod_cart_bcia_ini   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cod_cart_bcia_fim   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE  cdn_repres_ini      AS INTEGER     NO-UNDO.
DEFINE VARIABLE  cdn_repres_fim      AS INTEGER     NO-UNDO.

DEFINE VARIABLE c_cod_estab_selec AS CHARACTER FORMAT "x(2000)" 
     LABEL "Estabelecimento" 
     VIEW-AS EDITOR MAX-CHARS 2000
     SIZE 30 BY .88 NO-UNDO.

FIND Dwb_Set_List_Param NO-LOCK
    WHERE Dwb_Set_List_Param.Cod_Dwb_Program = "esacr014"
      AND Dwb_Set_List_Param.Cod_Dwb_User    = V_Cod_Usuar_Corren NO-ERROR.

IF AVAIL Dwb_Set_List_Param 
THEN 
    ASSIGN cdn_repres_ini      =     int(entry(02,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           cdn_repres_fim      =     int(entry(03,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           cod_espec_docto_ini =         entry(08,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_espec_docto_fim =         entry(09,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_portador_ini    =         entry(10,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_portador_fim    =         entry(11,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_cart_bcia_ini   =         entry(12,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod_cart_bcia_fim   =         entry(13,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-mensagem-ini    =         ENTRY(15,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c-narrativa-ini     =         ENTRY(16,dwb_set_list_param.cod_dwb_parameters,chr(10))
           cod-mensagem-fim    =         ENTRY(17,dwb_set_list_param.cod_dwb_parameters,chr(10))
           c-narrativa-fim     =         ENTRY(18,dwb_set_list_param.cod_dwb_parameters,chr(10))
           l-detalhes          = LOGICAL(ENTRY(31,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           c_cod_estab_selec   =         ENTRY(32,dwb_set_list_param.cod_dwb_parameters,chr(10))
           rs-docto            =     INT(ENTRY(34,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-a              = LOGICAL(ENTRY(19,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-b              = LOGICAL(ENTRY(20,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-c              = LOGICAL(ENTRY(21,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-d              = LOGICAL(ENTRY(22,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-e              = LOGICAL(ENTRY(23,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-f              = LOGICAL(ENTRY(24,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-ve-g              = LOGICAL(ENTRY(38,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-a              = LOGICAL(ENTRY(25,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-b              = LOGICAL(ENTRY(26,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-c              = LOGICAL(ENTRY(27,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-d              = LOGICAL(ENTRY(28,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-e              = LOGICAL(ENTRY(39,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-f              = LOGICAL(ENTRY(40,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           l-av-g              = LOGICAL(ENTRY(41,dwb_set_list_param.cod_dwb_parameters,chr(10)))
           fx-vea-fim          =     INT(ENTRY(42,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-veb-ini          =     INT(ENTRY(43,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-veb-fim          =     INT(ENTRY(44,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vec-ini          =     INT(ENTRY(45,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vec-fim          =     INT(ENTRY(46,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-ved-ini          =     INT(ENTRY(47,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-ved-fim          =     INT(ENTRY(48,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vee-ini          =     INT(ENTRY(49,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vee-fim          =     INT(ENTRY(50,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vef-ini          =     INT(ENTRY(51,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-vef-fim          =     INT(ENTRY(52,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-veg-ini          =     INT(ENTRY(53,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-ava-fim          =     INT(ENTRY(54,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avb-ini          =     INT(ENTRY(55,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avb-fim          =     INT(ENTRY(56,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avc-ini          =     INT(ENTRY(57,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avc-fim          =     INT(ENTRY(58,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avd-ini          =     INT(ENTRY(59,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avd-fim          =     INT(ENTRY(60,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-ave-ini          =     INT(ENTRY(61,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-ave-fim          =     INT(ENTRY(62,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avf-ini          =     INT(ENTRY(63,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avf-fim          =     INT(ENTRY(64,dwb_set_list_param.cod_dwb_parameters,CHR(10)))
           fx-avg-ini          =     INT(ENTRY(65,dwb_set_list_param.cod_dwb_parameters,CHR(10))).

    IF  LOGICAL(ENTRY(14,dwb_set_list_param.cod_dwb_parameters,chr(10))) = YES OR
        LOGICAL(ENTRY(66,dwb_set_list_param.cod_dwb_parameters,chr(10))) = YES OR
        LOGICAL(ENTRY(67,dwb_set_list_param.cod_dwb_parameters,chr(10))) = YES
    THEN
        ASSIGN l-email = YES.
    ELSE
        ASSIGN l-email = NO.

/* IF  V_Num_Ped_Exec_Corren > 0                                               */
/* THEN DO:                                                                    */
/*     FIND Ped_Exec_Param NO-LOCK                                             */
/*         WHERE Ped_Exec_Param.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR. */
/*                                                                             */
/*     IF AVAIL Ped_Exec_Param                                                 */
/*     THEN                                                                    */
/*         ASSIGN V_Cod_Dwb_File  = Ped_Exec_Param.Cod_Dwb_File                */
/*               V_Cod_Dwb_Output = Ped_Exec_Param.Cod_Dwb_Output              */
/*               C-Impressora     = Ped_Exec_Param.Nom_Dwb_Printer             */
/*               C-Layout         = Ped_Exec_Param.Cod_Dwb_Print_Layout.       */
/* END.                                                                        */

