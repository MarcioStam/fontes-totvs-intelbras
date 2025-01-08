/*****************************************************************************
** Programa..............: esacr084ca.p
** Autor.................: Andrey Mauricio de Oliveira
** Criado em.............: 13/12/2021
*****************************************************************************/

DEF BUFFER b-conteudo-programa FOR conteudo-programa.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF VAR l-segur-usuar AS LOG                      NO-UNDO.
DEF VAR v_dt_negoc    AS DATE FORMAT "99/99/9999" NO-UNDO.
DEF VAR v_mes         AS INT                      NO-UNDO.
DEF VAR v_conteudo    AS CHAR                     NO-UNDO.
DEF VAR v_data        AS CHAR                     NO-UNDO.
DEF VAR v_log_data    AS LOG                      NO-UNDO.

DEF RECT rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECT rt_001 SIZE 1 BY 2 EDGE-PIXELS 2.

DEF BUTTON bt_ok         LABEL "&OK":U         TOOLTIP "OK":U                   SIZE 1 BY 1 AUTO-GO.

FUNCTION validarData RETURNS LOG ( INPUT data AS CHAR ) FORWARD.

FUNCTION validarData RETURNS LOG ( INPUT data AS CHAR ):
    DEFINE VARIABLE valida AS LOGICAL NO-UNDO.
    
    /* primeira validacao */
    valida = DATE(data) <> ? NO-ERROR.
    IF valida THEN DO:
        valida = DATE( SUBSTITUTE("&1/&2/&3",
        MONTH( DATE(data)),
        DAY ( DATE(data)),
        YEAR ( DATE(data))
        )) <> ? NO-ERROR.
    END.

    RETURN valida.
END.

DEFINE FRAME fPage0
    rt_001            AT ROW 01.20 COL 01.50
    v_mes             AT ROW 02.00 COL 18.70 LABEL "Màs"
    v_dt_negoc        AT ROW 03.00 COL 15.00 LABEL "Dt Negoc"
    rt_002            AT ROW 04.75 COL 01.50 BGCOLOR 7 
    bt_ok             AT ROW 04.95 COL 02.70 font ? help "OK":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 65.70 BY 06.60
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Inclus∆o Data Negociaá∆o - DEPS - MSG0310".

ASSIGN rt_001:WIDTH-CHARS         IN FRAME fPage0 = 63.57
       rt_001:HEIGHT-CHARS        IN FRAME fPage0 = 03.42
       bt_ok:WIDTH-CHARS          IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS         IN FRAME fPage0 = 01.00
       rt_002:WIDTH-CHARS         IN FRAME fPage0 = 63.57
       rt_002:HEIGHT-CHARS        IN FRAME fPage0 = 01.42
       v_dt_negoc:WIDTH-CHARS     IN FRAME fPage0 = 10.00 .

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

ON  CHOOSE OF bt_ok IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.    
    
    ASSIGN v_conteudo = string(INPUT FRAME fPage0 v_mes) + ";" + string(INPUT FRAME fPage0 v_dt_negoc,"99/99/9999").

    FIND FIRST ponto-programa NO-LOCK
         WHERE ponto-programa.nome-programa = "dps-dt-negoc"
         AND   ponto-programa.ponto         = 1 NO-ERROR.
    
    IF  AVAIL ponto-programa THEN DO:    
        FIND FIRST conteudo-programa EXCLUSIVE-LOCK
            WHERE conteudo-programa.cod-programa          = ponto-programa.cod-programa 
            AND   entry(1,conteudo-programa.conteudo,";") = entry(1,v_conteudo,";") NO-ERROR.
        
        IF  NOT AVAIL conteudo-programa THEN DO:
            
            ASSIGN v_data = INPUT FRAME fPage0 v_dt_negoc.
        
            ASSIGN v_log_data = validarData(v_data).
        
            IF  v_log_data = NO THEN DO:
                MESSAGE "Data inv†lida !" VIEW-AS ALERT-BOX.
                RETURN "OK".
            END.

            FIND LAST b-conteudo-programa NO-LOCK
                WHERE b-conteudo-programa.cod-programa = ponto-programa.cod-programa NO-ERROR.

            CREATE conteudo-programa.
            ASSIGN conteudo-programa.sequencia    = IF  AVAIL b-conteudo-programa THEN b-conteudo-programa.sequencia + 1 ELSE 1
                   conteudo-programa.cod-programa = ponto-programa.cod-programa
                   conteudo-programa.conteudo     = string(INPUT FRAME fPage0 v_mes) + ";" + string(INPUT FRAME fPage0 v_dt_negoc,"99/99/9999").
                   
        END.
        ELSE DO:
            MESSAGE "Conte£do j† cadastrado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "OK".
        END.
    END.
    ELSE DO:
        MESSAGE "DPS-DT-NEGOC n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.

    IF SESSION:SET-WAIT-STATE("") THEN.
END.

bem_nf_block:
DO  ON ENDKEY UNDO bem_nf_block, LEAVE bem_nf_block:
    VIEW FRAME fPage0.

    ENABLE ALL WITH FRAME fPage0.
    
    WAIT-FOR GO OF FRAME fPage0.
END.

HIDE FRAME fPage0.

RETURN "OK".
