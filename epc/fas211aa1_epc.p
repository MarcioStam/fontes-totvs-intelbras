/*****************************************************************************
** Programa..............: fas211aa1_epc.p
** Autor.................: Fabiano Zarpe Henke
** Criado em.............: 10/03/2010
*****************************************************************************/

DEFINE TEMP-TABLE tt_int_bem_pat_nf NO-UNDO LIKE int_bem_pat_nf.

DEF NEW GLOBAL SHARED VAR v_rec_bem_pat_epc    AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_int_bem_pat_nf AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.

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
DEF BUTTON bt_elim        LABEL "&Elimina":U     TOOLTIP "Elimina":U               SIZE 1 BY 1.
DEF BUTTON bt_inventario LABEL "&Invent†rio":U TOOLTIP "Hist¢rico Invent†rio":U SIZE 1 BY 1.

DEFINE QUERY qr_int_bem_pat_nf FOR tt_int_bem_pat_nf SCROLLING.

DEFINE BROWSE br_int_bem_pat_nf QUERY qr_int_bem_pat_nf DISPLAY 
    tt_int_bem_pat_nf.nr-nota-fis   WIDTH-CHARS 11.00 COLUMN-LABEL "NF EmprÇstimo":U
    tt_int_bem_pat_nf.class-fiscal  WIDTH-CHARS 09.00 COLUMN-LABEL "Class Fiscal":U
    tt_int_bem_pat_nf.ind-terceiro  WIDTH-CHARS 10.00 COLUMN-LABEL "Ind Terceiro":U 
    tt_int_bem_pat_nf.cod-emitente  WIDTH-CHARS 08.00 COLUMN-LABEL "Cliente":U 
    tt_int_bem_pat_nf.dt-emis-nota  WIDTH-CHARS 10.00 COLUMN-LABEL "Dt EmprÇstimo":U
    tt_int_bem_pat_nf.val-icms      WIDTH-CHARS 13.00 COLUMN-LABEL "Valor ICMS":U
    WITH NO-BOX SEPARATORS SINGLE SIZE 63.57 BY 06.58 FONT 1 BGCOLOR 15 FIT-LAST-COLUMN. 

DEFINE FRAME fPage0
    br_int_bem_pat_nf AT ROW 01.17 COL 02.00
    rt_002            AT ROW 07.75 COL 02.00 BGCOLOR 7 
    bt_ok             AT ROW 07.95 COL 02.75 font ? help "OK":U
    bt_inc            AT ROW 07.95 COL 12.75 font ? help "Inclui":U
    bt_mod            AT ROW 07.95 COL 22.75 font ? help "Modifica":U
    bt_elim           AT ROW 07.95 COL 32.75 font ? help "Elimina":U
    bt_inventario     AT ROW 07.95 COL 54.75 font ? help "Invent†rio":U
    WITH 1 DOWN SIDE-LABELS NO-VALIDATE KEEP-TAB-ORDER THREE-D
         SIZE-CHAR 67.00 BY 09.83
         VIEW-AS DIALOG-BOX
         FONT 1 FGCOLOR ? BGCOLOR 8
         TITLE "Informaá‰es Complementares - Bem Patrimonial".

ASSIGN bt_ok:WIDTH-CHARS          IN FRAME fPage0 = 10.00
       bt_ok:HEIGHT-CHARS         IN FRAME fPage0 = 01.00
       bt_inc:WIDTH-CHARS         IN FRAME fPage0 = 10.00
       bt_inc:HEIGHT-CHARS        IN FRAME fPage0 = 01.00
       bt_mod:WIDTH-CHARS         IN FRAME fPage0 = 10.00
       bt_mod:HEIGHT-CHARS        IN FRAME fPage0 = 01.00
       bt_elim:WIDTH-CHARS        IN FRAME fPage0 = 10.00
       bt_elim:HEIGHT-CHARS       IN FRAME fPage0 = 01.00
       bt_inventario:WIDTH-CHARS  IN FRAME fPage0 = 10.00
       bt_inventario:HEIGHT-CHARS IN FRAME fPage0 = 01.00
       rt_002:WIDTH-CHARS         IN FRAME fPage0 = 63.57
       rt_002:HEIGHT-CHARS        IN FRAME fPage0 = 01.42.

FIND FIRST prog_dtsul
    WHERE prog_dtsul.cod_prog_dtsul = "fas211aa1" NO-LOCK NO-ERROR.

IF  AVAIL prog_dtsul THEN DO:
    ASSIGN l-segur-usuar = NO.

    FOR EACH usuar_grp_usuar NO-LOCK
        WHERE usuar_grp_usuar.cod_usuar = v_cod_usuar_corren:
        
        IF  NOT CAN-FIND(FIRST prog_dtsul_segur NO-LOCK
                         WHERE prog_dtsul_segur.cod_prog_dtsul = "fas211aa1"
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
                               INPUT "Usu†rio n∆o possui permiss∆o para acessar o programa FAS211AA1 !":U).
    
        RETURN 'nok'.
    END.
END.
ELSE DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                       INPUT 17006,
                       INPUT "Programa FAS211AA1 n∆o cadastrado no menu !":U).

    RETURN 'nok'.
END.

/* bot∆o invent†rio */
ON  CHOOSE OF bt_inventario IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.    
    RUN epc/fas211aa2_epc.p.    
    IF SESSION:SET-WAIT-STATE("") THEN.
END.

/* bot∆o inclui */
ON  CHOOSE OF bt_inc IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    ASSIGN v_rec_int_bem_pat_nf = ?.

    RUN epc/fas211aa5_epc.p.
    
    RUN pi_monta_temptable.

    OPEN QUERY qr_int_bem_pat_nf FOR EACH tt_int_bem_pat_nf NO-LOCK.
    
    FIND FIRST int_bem_pat_nf NO-LOCK
        WHERE int_bem_pat_nf.cod-estabel = tt_int_bem_pat_nf.cod-estabel 
        AND   int_bem_pat_nf.serie       = tt_int_bem_pat_nf.serie       
        AND   int_bem_pat_nf.nr-nota-fis = tt_int_bem_pat_nf.nr-nota-fis 
        AND   int_bem_pat_nf.nr-seq-fat  = tt_int_bem_pat_nf.nr-seq-fat  
        AND   int_bem_pat_nf.it-codigo   = tt_int_bem_pat_nf.it-codigo   NO-ERROR.

    IF  AVAIL int_bem_pat_nf THEN
        ASSIGN v_rec_int_bem_pat_nf = RECID(int_bem_pat_nf).

    IF SESSION:SET-WAIT-STATE("") THEN.
END.

/* bot∆o modifica */
ON  CHOOSE OF bt_mod IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    RUN epc/fas211aa5_epc.p.
    
    RUN pi_monta_temptable.

    OPEN QUERY qr_int_bem_pat_nf FOR EACH tt_int_bem_pat_nf NO-LOCK.
    
    FIND FIRST int_bem_pat_nf NO-LOCK
        WHERE int_bem_pat_nf.cod-estabel = tt_int_bem_pat_nf.cod-estabel 
        AND   int_bem_pat_nf.serie       = tt_int_bem_pat_nf.serie       
        AND   int_bem_pat_nf.nr-nota-fis = tt_int_bem_pat_nf.nr-nota-fis 
        AND   int_bem_pat_nf.nr-seq-fat  = tt_int_bem_pat_nf.nr-seq-fat  
        AND   int_bem_pat_nf.it-codigo   = tt_int_bem_pat_nf.it-codigo   NO-ERROR.

    IF  AVAIL int_bem_pat_nf THEN
        ASSIGN v_rec_int_bem_pat_nf = RECID(int_bem_pat_nf).

    IF SESSION:SET-WAIT-STATE("") THEN.
END.

/* bot∆o Elimina */
ON  CHOOSE OF bt_elim IN FRAME fPage0 DO:
    IF SESSION:SET-WAIT-STATE("general") THEN.
    
    FIND FIRST int_bem_pat_nf
        WHERE int_bem_pat_nf.cod-estabel = tt_int_bem_pat_nf.cod-estabel 
        AND   int_bem_pat_nf.serie       = tt_int_bem_pat_nf.serie       
        AND   int_bem_pat_nf.nr-nota-fis = tt_int_bem_pat_nf.nr-nota-fis 
        AND   int_bem_pat_nf.nr-seq-fat  = tt_int_bem_pat_nf.nr-seq-fat  
        AND   int_bem_pat_nf.it-codigo   = tt_int_bem_pat_nf.it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF  AVAIL int_bem_pat_nf THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 
                           INPUT 27100, 
                           INPUT "Confirma exclus∆o ?.").

        IF  RETURN-VALUE <> "YES" THEN
            RETURN.
        ELSE
            DELETE int_bem_pat_nf.
    END.
    
    RUN pi_monta_temptable.

    OPEN QUERY qr_int_bem_pat_nf FOR EACH tt_int_bem_pat_nf NO-LOCK.
    
    FIND FIRST int_bem_pat_nf NO-LOCK
        WHERE int_bem_pat_nf.cod-estabel = tt_int_bem_pat_nf.cod-estabel 
        AND   int_bem_pat_nf.serie       = tt_int_bem_pat_nf.serie       
        AND   int_bem_pat_nf.nr-nota-fis = tt_int_bem_pat_nf.nr-nota-fis 
        AND   int_bem_pat_nf.nr-seq-fat  = tt_int_bem_pat_nf.nr-seq-fat  
        AND   int_bem_pat_nf.it-codigo   = tt_int_bem_pat_nf.it-codigo   NO-ERROR.

    IF  AVAIL int_bem_pat_nf THEN
        ASSIGN v_rec_int_bem_pat_nf = RECID(int_bem_pat_nf).

    IF SESSION:SET-WAIT-STATE("") THEN.
END.

ON 'VALUE-CHANGED':U OF br_int_bem_pat_nf IN FRAME fPage0 DO:
    IF  AVAIL tt_int_bem_pat_nf THEN DO:
        FIND FIRST int_bem_pat_nf NO-LOCK
            WHERE int_bem_pat_nf.cod-estabel = tt_int_bem_pat_nf.cod-estabel 
            AND   int_bem_pat_nf.serie       = tt_int_bem_pat_nf.serie       
            AND   int_bem_pat_nf.nr-nota-fis = tt_int_bem_pat_nf.nr-nota-fis 
            AND   int_bem_pat_nf.nr-seq-fat  = tt_int_bem_pat_nf.nr-seq-fat  
            AND   int_bem_pat_nf.it-codigo   = tt_int_bem_pat_nf.it-codigo   NO-ERROR.

        IF  AVAIL int_bem_pat_nf THEN
            ASSIGN v_rec_int_bem_pat_nf = RECID(int_bem_pat_nf).
    END.

    RETURN "OK".
END.

bem_nf_block:
DO  ON ENDKEY UNDO bem_nf_block, LEAVE bem_nf_block:
    VIEW FRAME fPage0.

    ENABLE ALL WITH FRAME fPage0.
    
    RUN pi_monta_temptable.

    OPEN QUERY qr_int_bem_pat_nf FOR EACH tt_int_bem_pat_nf NO-LOCK.
    
    FIND FIRST int_bem_pat_nf NO-LOCK
        WHERE int_bem_pat_nf.cod-estabel = tt_int_bem_pat_nf.cod-estabel 
        AND   int_bem_pat_nf.serie       = tt_int_bem_pat_nf.serie       
        AND   int_bem_pat_nf.nr-nota-fis = tt_int_bem_pat_nf.nr-nota-fis 
        AND   int_bem_pat_nf.nr-seq-fat  = tt_int_bem_pat_nf.nr-seq-fat  
        AND   int_bem_pat_nf.it-codigo   = tt_int_bem_pat_nf.it-codigo   NO-ERROR.

    IF  AVAIL int_bem_pat_nf THEN
        ASSIGN v_rec_int_bem_pat_nf = RECID(int_bem_pat_nf).

    WAIT-FOR GO OF FRAME fPage0.
END.

HIDE FRAME fPage0.

RETURN "OK".

PROCEDURE pi_monta_temptable:

    FIND bem_pat NO-LOCK WHERE RECID(bem_pat) = v_rec_bem_pat_epc NO-ERROR.
    
    IF  NOT AVAIL bem_pat THEN DO:
        MESSAGE "Bem Patrimonial n∆o Localizado !" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN "OK".
    END.
    
    EMPTY TEMP-TABLE tt_int_bem_pat_nf NO-ERROR.
    
    FOR EACH  int_bem_pat_nf NO-LOCK
        WHERE int_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat     
        AND   int_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat     
        AND   int_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat:

        CREATE tt_int_bem_pat_nf.
        BUFFER-COPY int_bem_pat_nf to tt_int_bem_pat_nf no-error.
    END.

END PROCEDURE.
