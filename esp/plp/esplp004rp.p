DEF NEW GLOBAL SHARED VAR V_Num_Ped_Exec_Corren   AS   INTE   FORM ">>>>>9" NO-UNDO.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD ativa-desativa   AS INT.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

IF V_Num_Ped_Exec_Corren <> 0 THEN 
DO.
    FIND Ped_Exec NO-LOCK
        WHERE Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
    IF AVAIL Ped_Exec THEN 
    DO:
        FIND FIRST servid_exec WHERE
                   servid_exec.cod_servid_exec = Ped_Exec.Cod_Servid_Exec
                   NO-LOCK NO-ERROR.

        IF AVAIL servid_exec AND 
                 servid_exec.ind_tip_fila_exec = "UNIX" 
        THEN RETURN "SERVIDOR DEVE SER WINDOWS".    
    END.
END.
DO ON STOP UNDO, LEAVE:
    
    IF tt-param.ativa-desativa = 1 THEN DO:
        /*** UPC no PL0501rp ***/
        FIND FIRST prog_dtsul 
             WHERE prog_dtsul.cod_prog_dtsul = "PL0501rp" NO-ERROR.
        IF AVAIL prog_dtsul THEN
            ASSIGN prog_dtsul.nom_prog_upc    = "upc/pl0501rp-upc.p".
    
    
        /*** UPC no PLAPI501 ***/
        FIND FIRST prog_dtsul 
             WHERE prog_dtsul.cod_prog_dtsul = "PLAPI501" NO-ERROR.
        IF AVAIL prog_dtsul THEN
            ASSIGN prog_dtsul.nom_prog_upc    = "upc/plapi501-upc.p".
    
        //UNIX SILENT VALUE("/opt/progress/scripts/programas-plano -b").
        OS-COMMAND VALUE("\\erpapp\erp\especificos\programas-plano-desativa.bat").
          
        /*
        /* INICIO - Regra para atender o plano OEM(mono-estabelcimento) at‚ o APS entrar */
        DISABLE TRIGGERS FOR LOAD OF ITEM.
        FOR EACH item-uni-estab NO-LOCK
           WHERE item-uni-estab.cod-estabel = "104",
           FIRST ITEM EXCLUSIVE-LOCK
           WHERE ITEM.it-codigo = item-uni-estab.it-codigo
             AND ITEM.ge-codigo = 45: /* OEM */
        
            ASSIGN ITEM.cod-comprado     = item-uni-estab.cod-comprado
                   ITEM.res-for-comp     = item-uni-estab.res-for-comp
                   ITEM.res-int-comp     = item-uni-estab.res-int-comp
                   ITEM.horiz-fixo       = item-uni-estab.horiz-fixo
                   ITEM.lote-minimo      = item-uni-estab.lote-minimo
                   ITEM.lote-multipl     = item-uni-estab.lote-multipl
                   ITEM.quant-segur      = item-uni-estab.quant-segur.
        
            FIND FIRST item-man EXCLUSIVE-LOCK
                 WHERE item-man.it-codigo = item-uni-estab.it-codigo NO-ERROR.
            IF AVAIL item-man THEN DO:
               ASSIGN item-man.res-for-comp     = item-uni-estab.res-for-comp
                      item-man.res-int-comp     = item-uni-estab.res-int-comp
                      item-man.horiz-fixo       = item-uni-estab.horiz-fixo
                      item-man.lote-minimo      = item-uni-estab.lote-minimo
                      item-man.lote-multipl     = item-uni-estab.lote-multipl
                      item-man.quant-segur      = item-uni-estab.quant-segur.
            END.
        END.
        
        FOR EACH item-fornec-estab NO-LOCK
           WHERE item-fornec-estab.cod-estabel = "104",
           FIRST ITEM EXCLUSIVE-LOCK
           WHERE ITEM.it-codigo = item-fornec-estab.it-codigo
             AND ITEM.ge-codigo = 45: /* OEM */
            FIND FIRST item-fornec EXCLUSIVE-LOCK
                 WHERE item-fornec.it-codigo    = item-fornec-estab.it-codigo
                   AND item-fornec.cod-emitente = item-fornec-estab.cod-emitente NO-ERROR.
            IF AVAIL item-fornec THEN DO:
               ASSIGN item-fornec.perc-compra  = item-fornec-estab.perc-compra 
                      item-fornec.lote-minimo  = item-fornec-estab.lote-minimo 
                      item-fornec.lote-mul-for = item-fornec-estab.lote-mul-for
                      item-fornec.tempo-ressup = item-fornec-estab.tempo-ressup   
                      item-fornec.horiz-fixo   = item-fornec-estab.horiz-fixo.
                      
            END.
        END.
        */

        /* FIM - Regra para atender o plano OEM(mono-estabelcimento) at‚ o APS entrar */

        RETURN "Programas bloqueados".
    END.
    ELSE DO:
        /*** UPC no PL0501rp ***/
        FIND FIRST prog_dtsul 
             WHERE prog_dtsul.cod_prog_dtsul = "PL0501rp" NO-ERROR.
        IF AVAIL prog_dtsul THEN
            ASSIGN prog_dtsul.nom_prog_upc    = "".
    
        /*** UPC no PLAPI501 ***/
        FIND FIRST prog_dtsul 
             WHERE prog_dtsul.cod_prog_dtsul = "PLAPI501" NO-ERROR.
        IF AVAIL prog_dtsul THEN
            ASSIGN prog_dtsul.nom_prog_upc    = "upc/plapi501b-upc.p".
    
        //UNIX SILENT VALUE("/opt/progress/scripts/programas-plano -l").
        OS-COMMAND VALUE("\\erpapp\erp\especificos\programas-plano-ativa.bat").

        RETURN "Programas liberados".
    END.
END.

RETURN "OK".   

