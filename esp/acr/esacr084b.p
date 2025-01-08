/*****************************************************************************
** Programa..............: esacr084b.p
** Autor.................: Andrey Mauricio de Oliveira
** Criado em.............: 13/12/2021
*****************************************************************************/

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

DEF VAR v_segur_usuar AS LOG                 NO-UNDO.
DEF VAR v_dias_negoc  AS INT  FORMAT ">>>>9" NO-UNDO.
DEF VAR v_text_dias   AS CHAR FORMAT "x(16)" NO-UNDO.

DEF RECT rt_002 SIZE 1 BY 1 EDGE-PIXELS 2.
DEF RECT rt_001 SIZE 1 BY 1 EDGE-PIXELS 2.

DEF BUTTON bt_ok LABEL "&OK":U TOOLTIP "OK":U SIZE 1 BY 1 AUTO-GO.

DEFINE FRAME fPage0
    rt_001            AT ROW 01.10 COL 01.50
    v_text_dias       AT ROW 02.00 COL 24.25 LABEL "ES0018"
    v_dias_negoc      AT ROW 02.88 COL 18.00 LABEL "Dias Negociaá∆o"
    rt_002            AT ROW 04.60 COL 01.50 BGCOLOR 7 
    bt_ok             AT ROW 04.80 COL 02.75 font ? help "OK":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 65.50 BY 06.40
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Ajustar dias negociaá∆o pedidos DEPS".

ASSIGN rt_001:WIDTH-CHARS         IN FRAME fPage0 = 63.57
       rt_001:HEIGHT-CHARS        IN FRAME fPage0 = 03.42
       bt_ok:WIDTH-CHARS          IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS         IN FRAME fPage0 = 01.00
       rt_002:WIDTH-CHARS         IN FRAME fPage0 = 63.57
       rt_002:HEIGHT-CHARS        IN FRAME fPage0 = 01.42.

FIND FIRST prog_dtsul
    WHERE prog_dtsul.cod_prog_dtsul = "esacr084b" NO-LOCK NO-ERROR.

IF  AVAIL prog_dtsul THEN DO:
    ASSIGN v_segur_usuar = NO.

    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        
        IF  NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                         WHERE prog_dtsul_segur.cod_prog_dtsul = "esacr084b"
                         AND  (prog_dtsul_segur.cod_grp_usuar  = usuar_grp_usuar.cod_grp_usuar
                         OR    prog_dtsul_segur.cod_grp_usuar  = "*")) THEN DO:

            ASSIGN v_segur_usuar = NO.
        END.
        ELSE DO:
            ASSIGN v_segur_usuar = YES.
            LEAVE.
        END.
    END.

    IF  v_segur_usuar = NO THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Usu†rio n∆o possui permiss∆o para acessar o programa esacr084b !":U).
    
        RETURN 'nok'.
    END.
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "Programa esacr084b n∆o cadastrado no menu !":U).

    RETURN 'nok'.
END.

ON  CHOOSE OF bt_ok IN FRAME fPage0 DO:

    FIND FIRST ponto-programa NO-LOCK
         WHERE ponto-programa.nome-programa = "dps-dias-neg"
         AND   ponto-programa.ponto         = 1 NO-ERROR.
    
    IF  AVAIL ponto-programa THEN DO:

        FIND FIRST conteudo-programa EXCLUSIVE-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-ERROR.
        
        IF  AVAIL conteudo-programa THEN DO:
            ASSIGN conteudo-programa.conteudo = INPUT FRAME fPage0 v_dias_negoc.
        END.
        ELSE DO:
            MESSAGE "Conte£do n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "OK".
        END.
    END.
    ELSE DO:
        MESSAGE "DPS-DIAS-NEG n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.    

    RETURN "OK".
END.

bem_nf_block:
DO  ON ENDKEY UNDO bem_nf_block, LEAVE bem_nf_block:
    VIEW FRAME fPage0.

    ASSIGN v_text_dias:SCREEN-VALUE IN FRAME fPage0 = "DPS-DIAS-NEG".

    ENABLE ALL WITH FRAME fPage0.
    DISABLE v_text_dias WITH FRAME fPage0.

    RUN pi_carrega_dias.

    WAIT-FOR GO OF FRAME fPage0.
END.

HIDE FRAME fPage0.

RETURN "OK".

PROCEDURE pi_carrega_dias:
    FIND FIRST ponto-programa NO-LOCK
         WHERE ponto-programa.nome-programa = "dps-dias-neg"
         AND   ponto-programa.ponto         = 1 NO-ERROR.
    
    IF  AVAIL ponto-programa THEN DO:    
        FIND FIRST conteudo-programa NO-LOCK
            WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa NO-ERROR.
        
        IF  AVAIL conteudo-programa THEN DO:
            ASSIGN v_dias_negoc:SCREEN-VALUE IN FRAME fPage0 = conteudo-programa.conteudo.
        END.
        ELSE DO:
            MESSAGE "Conte£do n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN "OK".
        END.
    END.
    ELSE DO:
        MESSAGE "DPS-DIAS-NEG n∆o localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.

END PROCEDURE.
