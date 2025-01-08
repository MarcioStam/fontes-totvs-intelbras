/*********************************************************************************
** Programa: esp/crm/escrm027.p
** Vers∆o..: 1.00
** Data....: 10/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-find-titulos-cliente", programa "soap-b2b-tit-acr"
**           Listagem de T°tulos Em Aberto de um Cliente
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-tit-acr NO-UNDO
    FIELD cod-tit-acr     LIKE tit_acr.cod_tit_acr
    FIELD tit-status      AS   CHARACTER
    FIELD des-espec-docto LIKE espec_docto.des_espec_docto
    FIELD ser-notafis     LIKE tit_acr.cod_ser_docto
    FIELD nr-notafis      LIKE tit_acr.cod_tit_acr
    FIELD cod-parcela     LIKE tit_acr.cod_parcela
    FIELD dat-vecto       LIKE tit_acr.dat_vencto_tit_acr
    FIELD dias-atraso     AS   INTEGER
    FIELD cod-tit-acr-bco LIKE tit_acr.cod_tit_acr_bco
    FIELD val-saldo       LIKE tit_acr.val_sdo_tit_acr
    FIELD val-cartorio    LIKE int_tit_acr.val_desp_cartorio
    FIELD nome-portador   LIKE emscad.portador.nom_pessoa.

DEFINE BUFFER btit_acr FOR tit_acr.

/*--- Definiá∆o dos ParÉmetros ---*/
DEFINE INPUT  PARAMETER p-cod-cliente AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-estab   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-status-tit  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-inicial  AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-final    AS DATE        NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-tit-acr.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE hQuery                AS HANDLE      NO-UNDO.
DEFINE VARIABLE hBuffer               AS HANDLE      NO-UNDO.
DEFINE VARIABLE cWhere                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSort                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tit_acr_status      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod_tit_acr_bco     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-dat_vencto_tit_acr AS DATE        NO-UNDO.
DEFINE VARIABLE c-nr_notafis          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ser_notafis         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-val_saldo          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-val_cartorio       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-cod-estab-aux       AS CHARACTER   NO-UNDO.

/* 31395 - Ignora Estab caso n∆o informado. */
IF p-cod-estab = ? OR p-cod-estab = "":U THEN DO:
    ASSIGN cWhere = "EACH tit_acr FIELDS (cdn_cliente cod_estab log_sdo_tit_acr cod_portador cod_espec_docto cod_tit_acr_bco ind_tip_espec_docto cod_cart_bcia dat_vencto_tit_acr num_id_tit_acr cod_parcela cod_ser_docto cod_tit_acr val_sdo_tit_acr) NO-LOCK WHERE tit_acr.cdn_cliente = " + STRING(p-cod-cliente) + "
                     AND  tit_acr.log_sdo_tit_acr
                     AND  tit_acr.cod_portador <> '9955'
                     AND  tit_acr.cod_portador <> '9977'
                     AND (tit_acr.ind_tip_espec_docto = 'NORMAL' OR  tit_acr.ind_tip_espec_docto = 'VENDOR')
                     AND (tit_acr.cod_portador <> '9996' OR tit_acr.cod_cart_bcia <> '60') ".
END.
ELSE DO:    
    IF p-cod-estab = "101" OR p-cod-estab = "104" THEN
        ASSIGN p-cod-estab-aux = IF p-cod-estab = "101" THEN "104" ELSE "101".
    ELSE
        ASSIGN p-cod-estab-aux = p-cod-estab.

    ASSIGN cWhere = "EACH tit_acr FIELDS (cdn_cliente cod_estab log_sdo_tit_acr cod_portador cod_espec_docto cod_tit_acr_bco ind_tip_espec_docto cod_cart_bcia dat_vencto_tit_acr num_id_tit_acr cod_parcela cod_ser_docto cod_tit_acr val_sdo_tit_acr) NO-LOCK WHERE tit_acr.cdn_cliente = " + STRING(p-cod-cliente) + "
                     AND (tit_acr.cod_estab   = " + "'" + p-cod-estab + "'" + "
                       OR tit_acr.cod_estab   = " + "'" + p-cod-estab-aux + "'" + ")
                     AND  tit_acr.log_sdo_tit_acr
                     AND  tit_acr.cod_portador <> '9955'
                     AND  tit_acr.cod_portador <> '9977'
                     AND (tit_acr.ind_tip_espec_docto = 'NORMAL' OR  tit_acr.ind_tip_espec_docto = 'VENDOR')
                     AND (tit_acr.cod_portador <> '9996' OR tit_acr.cod_cart_bcia <> '60') ".
END.

/* CASE p-status-tit:                                                                        */
/*     WHEN "V" THEN                                                                         */
/*         ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr < TODAY ".              */
/*     WHEN "A" THEN                                                                         */
/*         ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr >= TODAY ".             */
/* END CASE.                                                                                 */
/*                                                                                           */
/*                                                                                           */
/* ASSIGN cWhere = cWhere + "AND  tit_acr.dat_vencto_tit_acr >= " + string(p-dt-inicial) + " */
/*                           AND  tit_acr.dat_vencto_tit_acr <= " + string(p-dt-final).      */

CASE p-status-tit:
    WHEN "V" THEN
        ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr < TODAY ".
    WHEN "A" THEN
        ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr >= TODAY
                                   AND tit_acr.dat_vencto_tit_acr >= " + string(p-dt-inicial) + "
                                   AND tit_acr.dat_vencto_tit_acr <= " + string(p-dt-final).
    WHEN "T" THEN
        ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr >= " + string(p-dt-inicial) + "
                                   AND tit_acr.dat_vencto_tit_acr <= " + string(p-dt-final).
END CASE.


ASSIGN cWhere = cWhere + ", FIRST portador FIELDS (cod_portador nom_pessoa) NO-LOCK
                            WHERE portador.cod_portador = tit_acr.cod_portador,
                            FIRST espec_docto FIELDS (cod_espec_docto des_espec_docto) NO-LOCK
                            WHERE espec_docto.cod_espec_docto = tit_acr.cod_espec_docto ".

ASSIGN cSort = " BY tit_acr.dat_vencto_tit_acr BY tit_acr.num_id_tit_acr ".

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(BUFFER tit_acr:HANDLE, BUFFER emscad.portador:HANDLE, BUFFER espec_docto:HANDLE).


IF (hQuery:QUERY-PREPARE("PRESELECT " + cWhere + cSort) = FALSE) THEN DO:
    MESSAGE "Erro na Query"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    LEAVE.
END.


hQuery:QUERY-OPEN.

IF (hQuery:NUM-RESULTS <> 0) THEN DO:
    REPEAT:
        hQuery:GET-NEXT.
        IF (hQuery:QUERY-OFF-END) THEN
            LEAVE.
    
        /** Tratamento para quando o titulo for de vendor **/
        /** Procura o numero do titulo no VE para exibir o valor correto **/
        IF (tit_acr.cod_espec_docto = "vd") THEN DO:
            FIND FIRST btit_acr NO-LOCK
                WHERE  btit_acr.cod_estab       = tit_acr.cod_estab
                AND    btit_acr.cod_ser_docto   = tit_acr.cod_ser_docto
                AND    btit_acr.cod_espec_docto = "ve"
                AND    btit_acr.cod_tit_acr     = tit_acr.cod_tit_acr
                AND    btit_acr.cod_parcela     = tit_acr.cod_parcela NO-ERROR.
            IF  AVAIL  btit_acr THEN
                ASSIGN c-cod_tit_acr_bco     = btit_acr.cod_tit_acr_bco.
                       dt-dat_vencto_tit_acr = btit_acr.dat_vencto_tit_acr.
        END.
        ELSE DO:
            ASSIGN c-cod_tit_acr_bco     = tit_acr.cod_tit_acr_bco.
                   dt-dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr.
        END.
    
        /** Tratamento para quando o titulo for de vendor **/
        /** Procura o valor do titulo em aberto na parc_vendor quando for vendor **/
        /** Procura o numero da nota fiscal no titulo original **/
        IF (tit_acr.cod_espec_docto = "vd" OR tit_acr.cod_espec_docto = "ve") THEN DO:
            FIND FIRST dupl_vendor NO-LOCK
                WHERE  dupl_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr)
                AND    dupl_vendor.cod_estab           = tit_acr.cod_estab NO-ERROR.
            IF  AVAIL  dupl_vendor THEN DO:
                FIND FIRST btit_acr NO-LOCK
                    WHERE  btit_acr.cod_estab      = tit_acr.cod_estab
                    AND    btit_acr.num_id_tit_acr = dupl_vendor.num_id_tit_acr NO-ERROR.
                IF  AVAIL  btit_acr THEN
                    ASSIGN c-nr_notafis  = btit_acr.cod_tit_acr
                           c-ser_notafis = btit_acr.cod_ser_docto.
            END.
    
            IF (tit_acr.cod_espec_docto = "ve") THEN
                FIND FIRST parc_vendor NO-LOCK
                    WHERE  parc_vendor.cod_estab           = tit_acr.cod_estab
                    AND    parc_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr)
                    AND    parc_vendor.num_seq_parc_vendor = INT(tit_acr.cod_parcela) NO-ERROR.
        END.
        ELSE
            ASSIGN c-nr_notafis  = tit_acr.cod_tit_acr
                   c-ser_notafis = tit_acr.cod_ser_docto.
    
    
        IF  AVAIL parc_vendor THEN
            ASSIGN de-val_saldo = parc_vendor.val_parc_vendor_clien.
        ELSE
            ASSIGN de-val_saldo = tit_acr.val_sdo_tit_acr.
    
    
        /** Procura o valor de cartorio, quando existente **/
        FIND FIRST int_tit_acr NO-LOCK OF tit_acr NO-ERROR.
        IF  AVAIL  int_tit_acr THEN
            ASSIGN de-val_cartorio = int_tit_acr.val_desp_cartorio.
        ELSE
            ASSIGN de-val_cartorio = 0.00.
    
    
        /** Atributo para saber se o titulo esta vencido ou nao **/
        IF (tit_acr.dat_vencto_tit_acr < TODAY) THEN
            ASSIGN c-tit_acr_status = "vencido".
        ELSE
            ASSIGN c-tit_acr_status = "a-vencer".
    
    
        CREATE tt-tit-acr.
        ASSIGN tt-tit-acr.cod-tit-acr     = tit_acr.cod_tit_acr
               tt-tit-acr.tit-status      = c-tit_acr_status
               tt-tit-acr.des-espec-docto = espec_docto.des_espec_docto
               tt-tit-acr.ser-notafis     = c-ser_notafis
               tt-tit-acr.nr-notafis      = c-nr_notafis
               tt-tit-acr.cod-parcela     = tit_acr.cod_parcela
               tt-tit-acr.dat-vecto       = dt-dat_vencto_tit_acr
               tt-tit-acr.dias-atraso     = TODAY - dt-dat_vencto_tit_acr
               tt-tit-acr.cod-tit-acr-bco = c-cod_tit_acr_bco
               tt-tit-acr.val-saldo       = de-val_saldo
               tt-tit-acr.val-cartorio    = de-val_cartorio
               tt-tit-acr.nome-portador   = portador.nom_pessoa.

        /** Se nao liberar a tabela, da erro na proxima iteracao **/
        RELEASE parc_vendor NO-ERROR.
    END.
END.

DELETE OBJECT hQuery.


DELETE WIDGET-POOL.
RETURN "OK":U.
