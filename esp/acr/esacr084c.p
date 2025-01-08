/*****************************************************************************
** Programa..............: esacr084c.p
** Autor.................: Andrey Mauricio de Oliveira
** Criado em.............: 13/12/2021
*****************************************************************************/

DEFINE TEMP-TABLE tt_data_negoc NO-UNDO
    FIELD num_mes  AS INT  FORMAT 99
    FIELD dt_negoc AS DATE
    INDEX id_mes
        num_mes.

DEF NEW GLOBAL SHARED VAR v_rec_bem_pat_epc AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_data_negoc  AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF VAR l-segur-usuar AS LOG NO-UNDO.

DEF RECT rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.

DEF BUTTON bt_ok         LABEL "&OK":U         TOOLTIP "OK":U                   SIZE 1 BY 1 AUTO-GO.
DEF BUTTON bt_inc        LABEL "&Inclui":U     TOOLTIP "Inclui":U               SIZE 1 BY 1.
DEF BUTTON bt_mod        LABEL "&Modifica":U   TOOLTIP "Modifica":U             SIZE 1 BY 1.
DEF BUTTON bt_elim       LABEL "&Elimina":U     TOOLTIP "Elimina":U             SIZE 1 BY 1.

DEFINE QUERY qr_data_negoc FOR tt_data_negoc SCROLLING.

DEFINE BROWSE br_data_negoc QUERY qr_data_negoc DISPLAY 
    tt_data_negoc.num_mes   WIDTH-CHARS 05.00 COLUMN-LABEL "Màs":U
    tt_data_negoc.dt_negoc  WIDTH-CHARS 10.00 COLUMN-LABEL "Dt Negoc":U
    WITH NO-BOX SEPARATORS SINGLE SIZE 63.57 BY 06.58 FONT 1 BGCOLOR 15 /*FIT-LAST-COLUMN*/. 

DEFINE FRAME fPage0
    br_data_negoc AT ROW 01.17 COL 02.00
    rt_002            AT ROW 07.75 COL 02.00 BGCOLOR 7 
    bt_ok             AT ROW 07.95 COL 02.75 font ? help "OK":U
    bt_inc            AT ROW 07.95 COL 12.75 font ? help "Inclui":U
    bt_mod            AT ROW 07.95 COL 22.75 font ? help "Modifica":U
    bt_elim           AT ROW 07.95 COL 32.75 font ? help "Elimina":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 67.00 BY 09.83
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Data Negociaá∆o - DEPS - MSG0310".

ASSIGN bt_ok:WIDTH-CHARS          IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS         IN FRAME fPage0 = 01.00
       bt_inc:WIDTH-CHARS         IN FRAME fPage0 = 10.00
       bt_inc:HEIGHT-CHARS        IN FRAME fPage0 = 01.00
       bt_mod:WIDTH-CHARS         IN FRAME fPage0 = 10.00
       bt_mod:HEIGHT-CHARS        IN FRAME fPage0 = 01.00
       bt_elim:WIDTH-CHARS        IN FRAME fPage0 = 10.00
       bt_elim:HEIGHT-CHARS       IN FRAME fPage0 = 01.00
       rt_002:WIDTH-CHARS         IN FRAME fPage0 = 63.57
       rt_002:HEIGHT-CHARS        IN FRAME fPage0 = 01.42.

FIND FIRST prog_dtsul
    WHERE prog_dtsul.cod_prog_dtsul = "esacr084c" NO-LOCK NO-ERROR.

IF  AVAIL prog_dtsul THEN DO:
    ASSIGN l-segur-usuar = NO.

    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        
        IF  NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                         WHERE prog_dtsul_segur.cod_prog_dtsul = "esacr084c"
                         AND  (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                         OR    prog_dtsul_segur.cod_grp_usuar  = "*")) THEN DO:

            ASSIGN l-segur-usuar = NO.
        END.
        ELSE DO:
            ASSIGN l-segur-usuar = YES.
            LEAVE.
        END.
    END.

    IF  l-segur-usuar = NO THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Usu†rio n∆o possui permiss∆o para acessar o programa esacr084c !":U).
    
        RETURN 'nok'.
    END.
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "Programa esacr084c n∆o cadastrado no menu !":U).

    RETURN 'nok'.
END.

/* bot∆o inclui */
ON  CHOOSE OF bt_inc IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    ASSIGN v_rec_data_negoc = ?.

    RUN esp/acr/esacr084ca.r .

    RUN pi_monta_temptable.
    OPEN QUERY qr_data_negoc FOR EACH tt_data_negoc USE-INDEX id_mes NO-LOCK.
    
    IF SESSION:SET-WAIT-STATE("") THEN.
END.

/* bot∆o modifica */
ON  CHOOSE OF bt_mod IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    RUN esp/acr/esacr084cb.p(INPUT tt_data_negoc.num_mes,
                             INPUT tt_data_negoc.dt_negoc).
    
    RUN pi_monta_temptable.

    OPEN QUERY qr_data_negoc FOR EACH tt_data_negoc USE-INDEX id_mes NO-LOCK.
    
    IF SESSION:SET-WAIT-STATE("") THEN.
END.

/* bot∆o Elimina */
ON  CHOOSE OF bt_elim IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    FIND FIRST ponto-programa NO-LOCK
         WHERE ponto-programa.nome-programa = "dps-dt-negoc"
         AND   ponto-programa.ponto         = 1 NO-ERROR.
    
    IF  AVAIL ponto-programa THEN DO:    
        FIND FIRST conteudo-programa EXCLUSIVE-LOCK
            WHERE conteudo-programa.cod-programa          = ponto-programa.cod-programa 
            AND   entry(1,conteudo-programa.conteudo,";") = string(tt_data_negoc.num_mes) NO-ERROR.
        
        IF  AVAIL conteudo-programa THEN DO:
            MESSAGE "Confirma eliminaá∆o do registro ? " VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE lConfirma AS LOGICAL.
        
            IF  lConfirma THEN
                DELETE conteudo-programa.
        END.
        ELSE DO:
            MESSAGE "Conte£do n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        MESSAGE "DPS-DT-NEGOC n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "NOK".
    END.

    RUN pi_monta_temptable.
    OPEN QUERY qr_data_negoc FOR EACH tt_data_negoc USE-INDEX id_mes NO-LOCK.

    IF SESSION:SET-WAIT-STATE("") THEN.
END.

ON 'VALUE-CHANGED':U OF br_data_negoc IN FRAME fPage0 DO:

    RETURN "OK".
END.

bem_nf_block:
DO  ON ENDKEY UNDO bem_nf_block, LEAVE bem_nf_block:
    VIEW FRAME fPage0.

    ENABLE ALL WITH FRAME fPage0.
    
    RUN pi_monta_temptable.

    OPEN QUERY qr_data_negoc FOR EACH tt_data_negoc USE-INDEX id_mes NO-LOCK.
    
    WAIT-FOR GO OF FRAME fPage0.
END.

HIDE FRAME fPage0.

RETURN "OK".

PROCEDURE pi_monta_temptable:
    EMPTY TEMP-TABLE tt_data_negoc NO-ERROR.

    FIND FIRST ponto-programa NO-LOCK
         WHERE ponto-programa.nome-programa = "dps-dt-negoc"
         AND   ponto-programa.ponto         = 1 NO-ERROR.
    
    IF AVAIL ponto-programa THEN DO:

        FOR EACH conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

            CREATE tt_data_negoc.
            ASSIGN tt_data_negoc.num_mes  = int(ENTRY(1,conteudo-programa.conteudo,";"))
                   tt_data_negoc.dt_negoc = date(ENTRY(2,conteudo-programa.conteudo,";")).
        END.
    END.
END PROCEDURE.
