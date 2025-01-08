/*****************************************************************************
** Programa..............: fas211aa5_epc.p
** Autor.................: Andrey Mauricio de Oliveira
** Criado em.............: 05/12/2018
*****************************************************************************/

/**************************************************** Initialize **********************************************************/

DEF NEW GLOBAL SHARED VAR v_rec_bem_pat_epc    AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_int_bem_pat_nf AS RECID FORMAT ">>>>>>9":U INITIAL ? NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_produt_corren  AS CHAR  FORMAT "x(50)":U             NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_centro-custo   AS RECID                              NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_rec_unid_negoc     AS RECID FORMAT ">>>>>>9":U           NO-UNDO.

DEF RECT rt_001 SIZE 1 BY 1.4 EDGE-PIXELS 2.2.
DEF RECT rt_002 SIZE 1 BY 1   EDGE-PIXELS 2.

DEF BUTTON bt_ok         LABEL "&OK":U         TOOLTIP "OK":U                   SIZE 1 BY 1.
DEF BUTTON bt_inventario LABEL "&Invent rio":U TOOLTIP "Hist¢rico Invent rio":U SIZE 1 BY 1.

DEF BUFFER b_int_bem_pat_nf FOR int_bem_pat_nf.

DEF TEMP-TABLE tt_erros_conexao NO-UNDO 
    FIELD ttv_cdn_erro AS INT  FORMAT ">>>,>>9":U
    FIELD ttv_des_erro AS CHAR FORMAT "x(50)":U LABEL "Inconsistˆncia":U COLUMN-LABEL "Inconsistˆncia":U.

DEF VAR v_hdl_btb_connect AS HANDLE NO-UNDO.
DEF VAR l-erro            AS LOG    NO-UNDO.

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def button bt_zoo_un
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

def button bt_zoo_cc
    label "Zoom"
    tooltip "Zoom"
    image-up file "image/im-zoo"
    image-insensitive file "image/ii-zoo"
    size 4 by .88.

def frame f_dlg_02_bem_pat
    rt_001                        at row 01.20 col 02.00 bgcolor 8 
    rt_002                        at row 13.00 col 02.00 BGCOLOR 7 
    int_bem_pat_nf.cod-estab      at row 01.52 col 21.00 colon-aligned view-as fill-in size-chars 8  by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.serie          at row 02.52 col 21.00 colon-aligned view-as fill-in size-chars 8  by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.nr-nota-fis    at row 03.52 col 21.00 colon-aligned view-as fill-in size-chars 19 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.nr-seq-fat     at row 04.52 col 21.00 colon-aligned view-as fill-in size-chars 10 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.it-codigo      at row 05.52 col 21.00 colon-aligned view-as fill-in size-chars 23 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.cod-emitente   at row 06.52 col 21.00 colon-aligned view-as fill-in size-chars 12 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.nat-operacao   at row 07.52 col 21.00 colon-aligned view-as fill-in size-chars 9  by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.dt-emis-nota   at row 08.52 col 21.00 colon-aligned view-as fill-in size-chars 13 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.val-icms       at row 09.52 col 21.00 colon-aligned view-as fill-in size-chars 17 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.ind-terceiro   at row 10.52 col 21.00 colon-aligned VIEW-AS COMBO-BOX SORT AUTO-COMPLETION 
                                  LIST-ITEM-PAIRS "","","Empr‚stimo","Empr‚stimo","Comodato","Comodato","Conserto","Conserto","Empr‚stimo Colaborador","Empr‚stimo Colaborador","Loca‡Æo","Loca‡Æo" 
                                  size-chars 26 by .88 fgcolor ? bgcolor 15 font 2
    int_bem_pat_nf.class-fiscal   at row 11.52 col 21.00 colon-aligned view-as fill-in size-chars 13 by .88 fgcolor ? bgcolor 15 font 2
    bt_ok                         at row 13.20 col 02.75 font ? help "OK":U
    with 1 down side-labels no-validate keep-tab-order three-d
         size-char 67.00 BY 14.83
         view-as dialog-box
         font 1 fgcolor ? bgcolor 8
         title "Informa‡äes Complementares - Bem Patrimonial".

assign bt_ok:width-chars                 in frame f_dlg_02_bem_pat = 10.00
       bt_ok:height-chars                in frame f_dlg_02_bem_pat = 01.00
       rt_001:width-chars                in frame f_dlg_02_bem_pat = 63.57
       rt_001:height-chars               in frame f_dlg_02_bem_pat = 11.70
       rt_002:width-chars                in frame f_dlg_02_bem_pat = 63.57
       rt_002:height-chars               in frame f_dlg_02_bem_pat = 01.42
       int_bem_pat_nf.class-fiscal:LABEL in frame f_dlg_02_bem_pat = "Class Fiscal".

FIND bem_pat
    WHERE RECID(bem_pat) = v_rec_bem_pat_epc NO-LOCK NO-ERROR.

IF  NOT AVAIL bem_pat THEN DO:
    RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 17006,
                           INPUT "Bem Patrimonial nÆo Localizado !":U).

    APPLY "entry" TO int_bem_pat_nf.nr-nota-fis IN frame f_dlg_02_bem_pat.
    RETURN NO-APPLY.
END.

IF  v_rec_int_bem_pat_nf <> ? THEN
    FIND FIRST int_bem_pat_nf 
        WHERE RECID(int_bem_pat_nf) = v_rec_int_bem_pat_nf EXCLUSIVE-LOCK NO-ERROR.


ON 'LEAVE':U OF int_bem_pat_nf.nr-nota-fis IN FRAME f_dlg_02_bem_pat DO:
    RUN pi-leave-item.
    RETURN.
END.

ON 'LEAVE':U OF int_bem_pat_nf.nr-seq-fat IN FRAME f_dlg_02_bem_pat DO:
    RUN pi-leave-item.
    RETURN.
END.

ON 'LEAVE':U OF int_bem_pat_nf.it-codigo IN FRAME f_dlg_02_bem_pat DO:
    RUN pi-leave-item.
    RETURN.
END.

ON 'LEAVE':U OF int_bem_pat_nf.cod-estab IN FRAME f_dlg_02_bem_pat DO:
    RUN pi-leave-item.
    RETURN.
END.

ON 'LEAVE':U OF int_bem_pat_nf.serie IN FRAME f_dlg_02_bem_pat DO:
    RUN pi-leave-item.
    RETURN.
END.

ON 'CHOOSE':U OF bt_ok DO:
    ASSIGN l-erro = NO.

    IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-estabel   = ""
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat    = 0
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie         = ""
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis   = ""
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo     = ""
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-emitente  = 0
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nat-operacao  = ""
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.dt-emis-nota  = ?
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.ind-terceiro  = ""
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.class-fiscal  = "" 
    OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.class-fiscal  = "00000000" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Existem dados obrigat¢rios nÆo informados !" + "~~" +
                                     "Ser  necess rio inform -los para que o registro possa ser confirmado.":U).

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-estabel = "" THEN
            APPLY "entry" TO int_bem_pat_nf.cod-estabel IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat = 0 THEN
            APPLY "entry" TO int_bem_pat_nf.nr-seq-fat IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie = "" THEN
            APPLY "entry" TO int_bem_pat_nf.serie IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis = "" THEN
            APPLY "entry" TO int_bem_pat_nf.nr-nota-fis IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo = "" THEN
            APPLY "entry" TO int_bem_pat_nf.it-codigo IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-emitente = 0 THEN
            APPLY "entry" TO int_bem_pat_nf.cod-emitente IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nat-operacao = "" THEN
            APPLY "entry" TO int_bem_pat_nf.nat-operacao IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.dt-emis-nota = ? THEN
            APPLY "entry" TO int_bem_pat_nf.dt-emis-nota IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.ind-terceiro = "" THEN
            APPLY "entry" TO int_bem_pat_nf.ind-terceiro IN frame f_dlg_02_bem_pat.

        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.class-fiscal = "" THEN
            APPLY "entry" TO int_bem_pat_nf.class-fiscal IN frame f_dlg_02_bem_pat.

        ASSIGN l-erro = yes.
        RETURN NO-APPLY.
    END.

    FIND FIRST nota-fiscal
        WHERE nota-fiscal.cod-estabel = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-estabel
        AND   nota-fiscal.serie       = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie      
        AND   nota-fiscal.nr-nota-fis = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis NO-LOCK NO-ERROR.

    IF  NOT AVAIL nota-fiscal THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Nota fiscal informada nÆo existe !":U + "~~" +
                                     "Nota fiscal informada nÆo existe !":U).

        APPLY "entry" TO int_bem_pat_nf.nr-nota-fis IN frame f_dlg_02_bem_pat.
        ASSIGN l-erro = yes.
        RETURN NO-APPLY.
    END.
    ELSE DO:
        FIND FIRST it-nota-fisc
            WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
            AND   it-nota-fisc.serie       = nota-fiscal.serie      
            AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
            AND   it-nota-fisc.nr-seq-fat  = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat 
            AND   it-nota-fisc.it-codigo   = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo NO-LOCK NO-ERROR.

        IF  NOT AVAIL it-nota-fisc THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                                   INPUT 17006,
                                   INPUT "NÆo existe o item vinculado … nota fiscal !":U).
    
            APPLY "entry" TO int_bem_pat_nf.nr-nota-fis IN frame f_dlg_02_bem_pat.
            ASSIGN l-erro = yes.
            RETURN NO-APPLY.
        END.

        IF  v_rec_int_bem_pat_nf = ? THEN DO:
            FIND FIRST b_int_bem_pat_nf
                WHERE b_int_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat    
                AND   b_int_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat    
                AND   b_int_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat
                AND   b_int_bem_pat_nf.cod-estabel     = nota-fiscal.cod-estabel 
                AND   b_int_bem_pat_nf.serie           = nota-fiscal.serie       
                AND   b_int_bem_pat_nf.nr-nota-fis     = nota-fiscal.nr-nota-fis 
                AND   b_int_bem_pat_nf.nr-seq-fat      = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat  
                AND   b_int_bem_pat_nf.it-codigo       = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo NO-LOCK NO-ERROR.
    
            IF  AVAIL b_int_bem_pat_nf THEN DO:
                RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT 17006,
                                       INPUT "J  existem informa‡äes complementares informadas !":U + "~~" +
                                             "J  existem informa‡äes complementares vinculadas ao bem para a nota e item informados.":U).
        
                APPLY "entry" TO int_bem_pat_nf.nr-nota-fis IN frame f_dlg_02_bem_pat.
                ASSIGN l-erro = yes.
                RETURN NO-APPLY.
            END.
        END.
    END.

    FIND FIRST natur-oper
         WHERE natur-oper.nat-operacao = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nat-operacao NO-LOCK NO-ERROR.

    IF  NOT AVAIL natur-oper THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Natureza de opera‡Æo inexistente !":U).

        APPLY "entry" TO int_bem_pat_nf.nat-operacao IN frame f_dlg_02_bem_pat.
        ASSIGN l-erro = yes.
        RETURN NO-APPLY.
    END.

    FIND FIRST emitente
         WHERE emitente.cod-emit   = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-emitente
         AND   emitente.identific <> 2 NO-LOCK NO-ERROR.

    IF  NOT AVAIL emitente THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT "Cliente informado inexistente !":U).

        APPLY "entry" TO int_bem_pat_nf.cod-emitente IN frame f_dlg_02_bem_pat.
        ASSIGN l-erro = yes.
        RETURN NO-APPLY.
    END.

    IF  l-erro = NO 
    AND v_rec_int_bem_pat_nf = ? THEN DO:
        CREATE int_bem_pat_nf.
        ASSIGN int_bem_pat_nf.cod_cta_pat     = bem_pat.cod_cta_pat    
               int_bem_pat_nf.num_bem_pat     = bem_pat.num_bem_pat    
               int_bem_pat_nf.num_seq_bem_pat = bem_pat.num_seq_bem_pat
               int_bem_pat_nf.cod-estabel     = bem_pat.cod_estab
               int_bem_pat_nf.nr-seq-fat      = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat    
               int_bem_pat_nf.cod-estab       = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-estab     
               int_bem_pat_nf.serie           = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie         
               int_bem_pat_nf.nr-nota-fis     = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis   
               int_bem_pat_nf.nr-seq-fat      = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat    
               int_bem_pat_nf.it-codigo       = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo     
               int_bem_pat_nf.cod-emitente    = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-emitente  
               int_bem_pat_nf.nat-operacao    = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nat-operacao  
               int_bem_pat_nf.dt-emis-nota    = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.dt-emis-nota  
               int_bem_pat_nf.val-icms        = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.val-icms      
               int_bem_pat_nf.ind-terceiro    = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.ind-terceiro  
               int_bem_pat_nf.class-fiscal    = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.class-fiscal.
    END.

    APPLY "GO" TO FRAME f_dlg_02_bem_pat.
END.

PROCEDURE pi-leave-item:
    IF  AVAIL int_bem_pat_nf THEN DO:
        IF  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie       <> int_bem_pat_nf.serie      
        OR  INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis <> int_bem_pat_nf.nr-nota-fis THEN DO:
            
            FIND FIRST nota-fiscal
                WHERE nota-fiscal.cod-estabel = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-estabel
                AND   nota-fiscal.serie       = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie      
                AND   nota-fiscal.nr-nota-fis = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis NO-LOCK NO-ERROR.
    
            IF  AVAIL nota-fiscal THEN DO:
                FIND FIRST it-nota-fisc
                    WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                    AND   it-nota-fisc.serie       = nota-fiscal.serie      
                    AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                    AND   it-nota-fisc.nr-seq-fat  = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat 
                    AND   it-nota-fisc.it-codigo   = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo NO-LOCK NO-ERROR.
    
                IF  AVAIL it-nota-fisc THEN
                    ASSIGN int_bem_pat_nf.val-icms:SCREEN-VALUE     IN FRAME f_dlg_02_bem_pat = string(it-nota-fisc.vl-icms-it)
                           int_bem_pat_nf.class-fiscal:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = it-nota-fisc.class-fiscal
                           int_bem_pat_nf.nat-operacao:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = it-nota-fisc.nat-operacao.
    
                ASSIGN int_bem_pat_nf.cod-emitente:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = string(nota-fiscal.cod-emitente)
                       int_bem_pat_nf.dt-emis-nota:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = string(nota-fiscal.dt-emis-nota).
            END.
        END.
    END.
    ELSE DO:
        FIND FIRST nota-fiscal
            WHERE nota-fiscal.cod-estabel = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.cod-estabel
            AND   nota-fiscal.serie       = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.serie      
            AND   nota-fiscal.nr-nota-fis = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-nota-fis NO-LOCK NO-ERROR.

        IF  AVAIL nota-fiscal THEN DO:
            FIND FIRST it-nota-fisc
                WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                AND   it-nota-fisc.serie       = nota-fiscal.serie      
                AND   it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                AND   it-nota-fisc.nr-seq-fat  = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.nr-seq-fat 
                AND   it-nota-fisc.it-codigo   = INPUT FRAME f_dlg_02_bem_pat int_bem_pat_nf.it-codigo NO-LOCK NO-ERROR.

            IF  AVAIL it-nota-fisc THEN
                ASSIGN int_bem_pat_nf.val-icms:SCREEN-VALUE     IN FRAME f_dlg_02_bem_pat = string(it-nota-fisc.vl-icms-it)
                       int_bem_pat_nf.class-fiscal:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = it-nota-fisc.class-fiscal
                       int_bem_pat_nf.nat-operacao:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = it-nota-fisc.nat-operacao.

            ASSIGN int_bem_pat_nf.cod-emitente:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = string(nota-fiscal.cod-emitente)
                   int_bem_pat_nf.dt-emis-nota:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = string(nota-fiscal.dt-emis-nota).
        END.
    END.
END PROCEDURE.


histor_block:
do  on endkey undo histor_block, leave histor_block:
    view frame f_dlg_02_bem_pat.

    ENABLE ALL WITH FRAME f_dlg_02_bem_pat.

    ASSIGN int_bem_pat_nf.class-fiscal:SCREEN-VALUE IN FRAME f_dlg_02_bem_pat = '00000000'.

    IF  v_rec_int_bem_pat_nf <> ? THEN
        DISPLAY int_bem_pat_nf.cod-estab
                int_bem_pat_nf.class-fiscal
                int_bem_pat_nf.serie       
                int_bem_pat_nf.nr-nota-fis 
                int_bem_pat_nf.nr-seq-fat  
                int_bem_pat_nf.it-codigo   
                int_bem_pat_nf.cod-emitente
                int_bem_pat_nf.nat-operacao
                int_bem_pat_nf.dt-emis-nota
                int_bem_pat_nf.val-icms    
                int_bem_pat_nf.ind-terceiro WITH FRAME f_dlg_02_bem_pat.

    WAIT-FOR GO OF FRAME f_dlg_02_bem_pat.

    IF  v_rec_int_bem_pat_nf <> ? THEN
        ASSIGN int_bem_pat_nf.cod-estab
               int_bem_pat_nf.class-fiscal
               int_bem_pat_nf.serie       
               int_bem_pat_nf.nr-nota-fis 
               int_bem_pat_nf.nr-seq-fat  
               int_bem_pat_nf.it-codigo   
               int_bem_pat_nf.cod-emitente
               int_bem_pat_nf.nat-operacao
               int_bem_pat_nf.dt-emis-nota
               int_bem_pat_nf.val-icms    
               int_bem_pat_nf.ind-terceiro.
end.

hide frame f_dlg_02_bem_pat.

RETURN "OK".
