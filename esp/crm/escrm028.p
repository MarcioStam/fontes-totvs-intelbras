/*********************************************************************************
** Programa: esp/crm/escrm028.p
** Vers∆o..: 1.00
** Data....: 10/11/2010
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Relat¢rio do Portal B2B.
**           C¢pia da procedure "process-find-titulos", programa "soap-b2b-tit-acr"
**           Listagem dos T°tulos Em Aberto dos Clientes de um Representante
*********************************************************************************/

CREATE WIDGET-POOL.


/*--- Definiá∆o das Temp-Tables ---*/
DEFINE TEMP-TABLE tt-tit_acr    NO-UNDO
    FIELD repres_nome-abrev     LIKE repres.nome-abrev
    FIELD emitente_cod-emitente LIKE emitente.cod-emitente
    FIELD emitente_nome-emit    LIKE emitente.nome-emit
    FIELD emitente_cidade       LIKE emitente.cidade
    FIELD emitente_estado       LIKE emitente.estado
    FIELD emitente_lim-credito  LIKE emitente.lim-credito
    FIELD emitente_dt-lim-cred  LIKE emitente.dt-lim-cred
    FIELD tit_acr_dat_vencto    LIKE tit_acr.dat_vencto_tit_acr
    FIELD val_saldo             LIKE tit_acr.val_sdo_tit_acr
    INDEX tt-tit_acr            IS   PRIMARY emitente_cod-emitente.

DEFINE TEMP-TABLE tt-devolucao  NO-UNDO
    FIELD nome-abrev-repres     LIKE repres.nome-abrev
    FIELD cod-emitente          LIKE emitente.cod-emitente
    FIELD nome-emit             LIKE emitente.nome-emit
    FIELD cidade                LIKE emitente.cidade
    FIELD estado                LIKE emitente.estado
    FIELD lim-credito           LIKE emitente.lim-credito
    FIELD dt-lim-cred           LIKE emitente.dt-lim-cred
    FIELD tot-vencido           AS   DECIMAL
    FIELD tot-a-vencer          AS   DECIMAL
    FIELD total-geral           AS   DECIMAL
    INDEX id-emitente IS PRIMARY cod-emitente.

DEFINE BUFFER btit_acr FOR tit_acr.

/*--- ParÉmetros do Programa ---*/
DEFINE INPUT  PARAMETER p-cod-repres  AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-cliente AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER p-cod-estab   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-status-tit  AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-inicial  AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER p-dt-final    AS DATE        NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-devolucao.

/*--- Definiá∆o das Vari†veis ---*/
DEFINE VARIABLE hQuery                AS HANDLE      NO-UNDO.
DEFINE VARIABLE hBuffer               AS HANDLE      NO-UNDO.
DEFINE VARIABLE cWhere                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSort                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-dat_vencto_tit_acr AS DATE        NO-UNDO.
DEFINE VARIABLE d-val_saldo           AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-vencido         AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-a-vencer        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE p-cod-estab-aux       AS CHARACTER   NO-UNDO.

IF p-cod-estab = "101" OR p-cod-estab = "104" THEN
    ASSIGN p-cod-estab-aux = IF p-cod-estab = "101" THEN "104" ELSE "101".
ELSE
    ASSIGN p-cod-estab-aux = p-cod-estab.

/* /*--- Bloco Principal ---*/                                                                                           */
/* ASSIGN cWhere = "EACH  repres FIELDS (cod-rep nome-abrev) NO-LOCK                                                     */
/*                  WHERE repres.cod-rep = " + string(p-cod-repres) + ",                                                 */
/*                  EACH  emitente FIELDS (cod-rep cod-emitente nome-emit cidade estado lim-credito dt-lim-cred) NO-LOCK */
/*                  WHERE emitente.cod-rep = repres.cod-rep ".                                                           */
/*                                                                                                                       */
/* IF  (p-cod-cliente <> 0) AND (p-cod-cliente <> ?) THEN                                                                */
/*     ASSIGN cWhere = cWhere + " AND emitente.cod-emitente = " + string(p-cod-cliente). */

ASSIGN cWhere = "EACH  tit_acr FIELDS (num_id_tit_acr cdn_repres cdn_cliente cod_estab log_sdo_tit_acr cod_portador ind_tip_espec_docto cod_cart_bcia dat_vencto_tit_acr val_sdo_tit_acr cod_tit_acr cod_espec_docto cod_parcela cod_ser_docto) NO-LOCK
                 WHERE (tit_acr.cod_estab   = " + "'" + p-cod-estab + "'" + "
                    OR tit_acr.cod_estab    = " + "'" + p-cod-estab-aux + "'" + ")
                 AND   tit_acr.log_sdo_tit_acr
                 AND   tit_acr.cod_portador <> '9955'
                 AND   tit_acr.cod_portador <> '9977'
                 AND  (tit_acr.ind_tip_espec_docto = 'NORMAL'
                 OR    tit_acr.ind_tip_espec_docto = 'VENDOR')
                 AND  (tit_acr.cod_portador <> '9996' OR tit_acr.cod_cart_bcia <> '60') ".

IF  (p-cod-cliente <> 0) AND (p-cod-cliente <> ?) THEN
    ASSIGN cWhere = cWhere + " AND tit_acr.cdn_cliente = " + STRING(p-cod-cliente).

IF  (p-cod-repres <> 0) AND (p-cod-repres <> ?) THEN
    ASSIGN cWhere = cWhere + " AND tit_acr.cdn_repres = " + STRING(p-cod-repres).

CASE p-status-tit:
    WHEN "V" THEN
        ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr < TODAY ".
    WHEN "A" THEN
        ASSIGN cWhere = cWhere + " AND tit_acr.dat_vencto_tit_acr >= TODAY
                                   AND tit_acr.dat_vencto_tit_acr >= " + string(p-dt-inicial) + "
                                   AND tit_acr.dat_vencto_tit_acr <= " + string(p-dt-final).
END CASE.

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


ASSIGN cSort = " BY tit_acr.cdn_repres BY tit_acr.cdn_cliente".

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(BUFFER tit_acr:HANDLE).

IF (hQuery:QUERY-PREPARE("PRESELECT " + cWhere + cSort) = FALSE) THEN DO:
    RETURN "NOK":U.
END.


hQuery:QUERY-OPEN.

IF (hQuery:NUM-RESULTS <> 0) THEN DO:
    REPEAT:
        hQuery:GET-NEXT.
        IF (hQuery:QUERY-OFF-END) THEN
            LEAVE.

        /** Tratamento para quando o titulo for de vendor **/
        /** Procura a data de vencimento do titulo no VE para exibir o valor correto **/
        IF (tit_acr.cod_espec_docto = "vd") THEN DO:
            FIND FIRST relacto_tit_acr OF tit_acr NO-LOCK NO-ERROR.
            IF  AVAIL  relacto_tit_acr THEN DO:
                FIND FIRST btit_acr NO-LOCK
                    WHERE  btit_acr.cod_estab      = relacto_tit_acr.cod_estab_tit_acr_pai
                    AND    btit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai NO-ERROR.
                IF  AVAIL  btit_acr THEN
                    ASSIGN dt-dat_vencto_tit_acr = btit_acr.dat_vencto_tit_acr.
            END.
        END.
        ELSE DO:
            ASSIGN dt-dat_vencto_tit_acr = tit_acr.dat_vencto_tit_acr.
        END.

        /** Tratamento para quando o titulo for de vendor **/
        /** Procura o valor do titulo em aberto na parc_vendor quando for vendor **/
        /** Procura o numero da nota fiscal no titulo original **/
        IF (tit_acr.cod_espec_docto = "vd" OR tit_acr.cod_espec_docto = "ve") THEN DO:
            FIND FIRST dupl_vendor NO-LOCK
                WHERE  dupl_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr)
                AND    dupl_vendor.cod_estab           = tit_acr.cod_estab NO-ERROR.

            IF (tit_acr.cod_espec_docto = "ve") THEN
                FIND FIRST parc_vendor NO-LOCK
                    WHERE  parc_vendor.cod_estab           = tit_acr.cod_estab
                    AND    parc_vendor.num_planilha_vendor = INT(tit_acr.cod_tit_acr) NO-ERROR.
        END.

        FOR FIRST emitente
            WHERE emitente.cod-emitente = tit_acr.cdn_cliente:
        END.

        IF NOT AVAIL emitente THEN NEXT.

        FOR FIRST repres
            WHERE repres.cod-rep = tit_acr.cdn_repres:
        END.

        IF NOT AVAIL repres THEN NEXT.

        IF  AVAIL parc_vendor THEN
            ASSIGN d-val_saldo = parc_vendor.val_parc_vendor_clien.
        ELSE
            ASSIGN d-val_saldo = tit_acr.val_sdo_tit_acr.

        CREATE tt-tit_acr.
        ASSIGN tt-tit_acr.repres_nome-abrev     = repres.nome-abrev
               tt-tit_acr.emitente_cod-emitente = emitente.cod-emitente
               tt-tit_acr.emitente_nome-emit    = emitente.nome-emit
               tt-tit_acr.emitente_cidade       = emitente.cidade
               tt-tit_acr.emitente_estado       = emitente.estado
               tt-tit_acr.emitente_lim-credito  = emitente.lim-credito
               tt-tit_acr.emitente_dt-lim-cred  = emitente.dt-lim-cred
               tt-tit_acr.tit_acr_dat_vencto    = dt-dat_vencto_tit_acr
               tt-tit_acr.val_saldo             = d-val_saldo.

        /** Se nao liberar a tabela, da erro na proxima iteracao **/
        RELEASE parc_vendor NO-ERROR.
    END.

    /** Cria o XML a partir da temp-table **/
    FOR EACH  tt-tit_acr NO-LOCK
        BREAK BY tt-tit_acr.emitente_cod-emitente:

        IF  FIRST-OF (tt-tit_acr.emitente_cod-emitente) THEN
            ASSIGN d-tot-vencido  = 0
                   d-tot-a-vencer = 0.

        /** Faz o somatorio **/
        IF (tt-tit_acr.tit_acr_dat_vencto < TODAY) THEN
            ASSIGN d-tot-vencido  = d-tot-vencido  + tt-tit_acr.val_saldo.
        ELSE
            ASSIGN d-tot-a-vencer = d-tot-a-vencer + tt-tit_acr.val_saldo.

        IF  NOT LAST-OF (tt-tit_acr.emitente_cod-emitente) THEN
            NEXT.

        CREATE tt-devolucao.
        ASSIGN tt-devolucao.nome-abrev-repres = tt-tit_acr.repres_nome-abrev
               tt-devolucao.cod-emitente      = tt-tit_acr.emitente_cod-emitente
               tt-devolucao.nome-emit         = tt-tit_acr.emitente_nome-emit
               tt-devolucao.cidade            = tt-tit_acr.emitente_cidade
               tt-devolucao.estado            = tt-tit_acr.emitente_estado
               tt-devolucao.lim-credito       = tt-tit_acr.emitente_lim-credito
               tt-devolucao.dt-lim-cred       = tt-tit_acr.emitente_dt-lim-cred
               tt-devolucao.tot-vencido       = d-tot-vencido
               tt-devolucao.tot-a-vencer      = d-tot-a-vencer
               tt-devolucao.total-geral       = d-tot-vencido + d-tot-a-vencer.
    END.
END.

DELETE OBJECT hQuery.


DELETE WIDGET-POOL.
RETURN "OK":U.
