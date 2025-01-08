/********************************************************************************
 ** UPC........: wfin490.p - UPC WRITE tit_acr
 ** Autor......: Andrey M Oliveira
 ** Data.......: 07/03/2019
 ********************************************************************************/

DEF PARAM BUFFER b_tit_acr     FOR tit_acr.
DEF PARAM BUFFER b_old_tit_acr FOR tit_acr.

{esp/es0018.i}
{esp/esb/esesb000.i}

DEF VAR v_prox_boleto   AS CHAR                    NO-UNDO.
DEF VAR v_tamanho_bloq  AS INT                     NO-UNDO.
DEF VAR v_formato       AS CHAR                    NO-UNDO.
DEF VAR v_boleto_digito AS CHAR                    NO-UNDO.
DEF VAR v_boleto        AS CHAR                    NO-UNDO.
DEF VAR v_oper          AS CHAR                    NO-UNDO.
DEF VAR v_char_1        LIKE mgcad.portador.char-1 NO-UNDO.
DEF VAR v_num_bloq      AS CHAR FORMAT "X(256)":U  NO-UNDO.
DEF VAR v_seq_boleto    AS INT FORMAT "99999"      NO-UNDO.
DEF VAR v_digito        AS CHAR                    NO-UNDO.
DEF VAR i-multiplicador AS INT INIT 1              NO-UNDO.
DEF VAR i-acum          AS INT                     NO-UNDO.
DEF VAR i-divisao       AS INT                     NO-UNDO.
DEF VAR i-digito        AS INT                     NO-UNDO.
DEF VAR i-resto         AS INT                     NO-UNDO.
DEF VAR i-tamanho       AS INT                     NO-UNDO.
DEF VAR i-cont          AS INT                     NO-UNDO.
DEF VAR c-number        AS CHAR                    NO-UNDO.
DEF VAR c-numero1       AS CHAR                    NO-UNDO.


IF  NEW b_tit_acr THEN DO:

    IF  b_tit_acr.ind_tip_espec_docto = "Normal"
    OR  b_tit_acr.ind_tip_espec_docto = "Antecipa‡Æo" THEN DO:

        FOR FIRST int-emitente NO-LOCK
            WHERE int-emitente.cod-emitente = b_tit_acr.cdn_cliente:

            RUN esp/es0018p.p (INPUT "dps-canal-cr",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:

                FIND FIRST tit_acr_deps
                    WHERE tit_acr_deps.cod_estab      = b_tit_acr.cod_estab
                    AND   tit_acr_deps.num_id_tit_acr = b_tit_acr.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.

                IF  NOT AVAIL tit_acr_deps THEN DO:
                    CREATE tit_acr_deps.

                    ASSIGN tit_acr_deps.cod_estab      = b_tit_acr.cod_estab
                           tit_acr_deps.num_id_tit_acr = b_tit_acr.num_id_tit_acr
                           tit_acr_deps.dat_gerac      = TODAY.
                END.

                ASSIGN tit_acr_deps.log_integra = NO
                       tit_acr_deps.dat_gerac   = TODAY.
            END.
        END.
    END.
END.
ELSE DO:

    IF  AVAIL b_old_tit_acr
    AND (b_old_tit_acr.cod_cart_bcia             <> b_tit_acr.cod_cart_bcia
    OR   b_old_tit_acr.cod_portador              <> b_tit_acr.cod_portador
    OR   b_old_tit_acr.dat_emis_docto            <> b_tit_acr.dat_emis_docto
    OR   b_old_tit_acr.dat_vencto_origin_tit_acr <> b_tit_acr.dat_vencto_origin_tit_acr
    OR   b_old_tit_acr.dat_vencto_tit_acr        <> b_tit_acr.dat_vencto_tit_acr
    OR   b_old_tit_acr.cod_tit_acr_bco           <> b_tit_acr.cod_tit_acr_bco
    OR   b_old_tit_acr.dat_liquidac_tit_acr      <> b_tit_acr.dat_liquidac_tit_acr
    OR   b_old_tit_acr.log_sdo_tit_acr           <> b_tit_acr.log_sdo_tit_acr
    OR   b_old_tit_acr.val_sdo_tit_acr           <> b_tit_acr.val_sdo_tit_acr
    OR   b_old_tit_acr.log_tit_acr_estordo       <> b_tit_acr.log_tit_acr_estordo) THEN DO:

        IF  b_tit_acr.ind_tip_espec_docto = "Normal" 
        OR  b_tit_acr.ind_tip_espec_docto = "Antecipa‡Æo" THEN DO:
            
            FOR FIRST int-emitente NO-LOCK
                 WHERE int-emitente.cod-emitente = b_tit_acr.cdn_cliente:

                RUN esp/es0018p.p (INPUT "dps-canal-cr",
                                   INPUT 1,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE tt-prog-ponto.conteudo = string(int-emitente.cod-gr-cob)) THEN DO:
    
    
                    FIND FIRST tit_acr_deps
                        WHERE tit_acr_deps.cod_estab      = b_tit_acr.cod_estab      
                        AND   tit_acr_deps.num_id_tit_acr = b_tit_acr.num_id_tit_acr EXCLUSIVE-LOCK NO-ERROR.
            
                    IF  NOT AVAIL tit_acr_deps THEN DO:
                        CREATE tit_acr_deps.
                        
                        ASSIGN tit_acr_deps.cod_estab      = b_tit_acr.cod_estab
                               tit_acr_deps.num_id_tit_acr = b_tit_acr.num_id_tit_acr
                               tit_acr_deps.dat_gerac      = TODAY.
                    END.
            
                    ASSIGN tit_acr_deps.log_integra = NO
                           tit_acr_deps.dat_gerac   = TODAY.
                END.
            END.
        END.

        /* chamado C2207-0151 */
        IF  b_tit_acr.ind_tip_espec_docto = "Normal" 
        AND b_old_tit_acr.cod_portador    <> b_tit_acr.cod_portador THEN DO:
            RUN esp/es0018p.p (INPUT "num-bancario",
                               INPUT 1,
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.
    
            IF  CAN-FIND (FIRST tt-prog-ponto
                             WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(b_tit_acr.cod_portador)
                             AND   ENTRY(2,tt-prog-ponto.conteudo,";") = string(b_tit_acr.cod_cart_bcia)) THEN DO:

                find first trad_org_ext
                     where trad_org_ext.cod_matriz_trad_org_ext = "EMS"
                     and   trad_org_ext.cod_tip_unid_organ      = "998"
                     AND   trad_org_ext.cod_unid_organ          = b_tit_acr.cod_empresa no-lock no-error.
                 
                if  avail trad_org_ext then do:
            
                    find matriz_trad_portad_ext no-lock 
                        where matriz_trad_portad_ext.cod_matriz_trad_portad_ext = trad_org_ext.cod_matriz_trad_portad_ext no-error. 
                     
                    if  avail matriz_trad_portad_ext then do:
             
                        find first trad_portad_ext no-lock 
                            where trad_portad_ext.cod_matriz_trad_portad_ext = matriz_trad_portad_ext.cod_matriz_trad_portad_ext
                            AND   trad_portad_ext.cod_portador               = b_tit_acr.cod_portador
                            and   trad_portad_ext.cod_cart_bcia              = b_tit_acr.cod_cart_bcia no-error.
                         
                        if  avail trad_portad_ext then
                            RUN pi-busca-numero (INPUT trad_portad_ext.cod_portad_ext,
                                                 INPUT trad_portad_ext.cod_modalid_ext).
                    END.
                END.
            END.
            ELSE DO:
                ASSIGN v_prox_boleto = "".

                RUN esp/es0018p.p (INPUT "num-bancario",
                                   INPUT 2,
                                   INPUT 0,
                                   INPUT "",
                                   OUTPUT TABLE tt-prog-ponto) NO-ERROR.

                IF  CAN-FIND (FIRST tt-prog-ponto
                                 WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(b_tit_acr.cod_portador)
                                 AND   ENTRY(2,tt-prog-ponto.conteudo,";") = string(b_tit_acr.cod_cart_bcia)) THEN DO:

                    FOR EACH tt-prog-ponto
                        WHERE ENTRY(1,tt-prog-ponto.conteudo,";") = string(b_tit_acr.cod_portador)
                        AND   ENTRY(2,tt-prog-ponto.conteudo,";") = string(b_tit_acr.cod_cart_bcia):

                        find first trad_org_ext
                             where trad_org_ext.cod_matriz_trad_org_ext = "EMS"
                               and trad_org_ext.cod_tip_unid_organ      = "998"
                               and trad_org_ext.cod_unid_organ          = b_tit_acr.cod_empresa no-lock no-error.

                        if  avail trad_org_ext then do:

                            find matriz_trad_portad_ext no-lock 
                                 where matriz_trad_portad_ext.cod_matriz_trad_portad_ext = trad_org_ext.cod_matriz_trad_portad_ext no-error. 

                            if  avail matriz_trad_portad_ext then do:

                                find first trad_portad_ext no-lock 
                                     where trad_portad_ext.cod_matriz_trad_portad_ext = matriz_trad_portad_ext.cod_matriz_trad_portad_ext
                                     AND   trad_portad_ext.cod_portador               = b_tit_acr.cod_portador
                                     and   trad_portad_ext.cod_cart_bcia              = b_tit_acr.cod_cart_bcia no-error.

                                if  avail trad_portad_ext then DO:
                                    find first mgcad.portador
                                         where mgcad.portador.ep-codigo    = b_tit_acr.cod_empresa
                                         and   mgcad.portador.cod-portador = int(trad_portad_ext.cod_portad_ext)
                                         and   mgcad.portador.modalidade   = int(trad_portad_ext.cod_modalid_ext) exclusive-LOCK no-error.

                                    if  avail mgcad.portador THEN DO:
                                        ASSIGN mgcad.portador.int-4 = mgcad.portador.int-4 + 1
                                               v_seq_boleto         = mgcad.portador.int-4.
                                        
                                        ASSIGN v_prox_boleto = ENTRY(4,tt-prog-ponto.conteudo,";") + ENTRY(6,tt-prog-ponto.conteudo,";") +
                                                               ENTRY(5,tt-prog-ponto.conteudo,";") + ENTRY(8,tt-prog-ponto.conteudo,";") /* ano */ +
                                                               ENTRY(7,tt-prog-ponto.conteudo,";") + STRING(v_seq_boleto,"99999").

                                        RELEASE mgcad.portador.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.

                IF  v_prox_boleto <> "" THEN DO:
                    RUN pi-calcula-digito-11-sicredi.

                    ASSIGN b_tit_acr.cod_tit_acr_bco = SUBSTR(v_prox_boleto,12,8) + v_digito.
                END.
            END.
        END.
    END.
END.

RETURN 'OK'.


PROCEDURE pi-busca-numero :
    DEF INPUT PARAM p_cod_portador LIKE nota-fiscal.cod-portador.
    DEF INPUT PARAM p_modalidade   LIKE nota-fiscal.modalidade.

    find first mgcad.portador
         where mgcad.portador.ep-codigo    = b_tit_acr.cod_empresa
         and   mgcad.portador.cod-portador = p_cod_portador 
         and   mgcad.portador.modalidade   = p_modalidade exclusive-LOCK no-error.

    if avail mgcad.portador
    and mgcad.portador.emite-bloq = 1 then do:
        
        if  mgcad.portador.char-1 <> "" then do:
            assign v_tamanho_bloq = length(mgcad.portador.char-1)
                   v_boleto       = mgcad.portador.char-1
                   v_oper         = "". 

            run ftp/ft0503c.p (input  rowid(mgcad.portador),
                               input  v_boleto,
                               input  v_oper,
                               output v_boleto_digito).

            run pi-mostra-numero.

            if  mgcad.portador.cod-febraban = 237 then do:
                assign mgcad.portador.char-1 = substr(v_boleto,1,2) + v_prox_boleto.
            end.

            if  mgcad.portador.cod-febraban = 341 then do:
                if  length(v_boleto) > 12 then
                    assign mgcad.portador.char-1 = substr(v_boleto,1,4) + substr(v_boleto,5,5) + substr(v_boleto,10,3) + v_prox_boleto.
                else 
                    assign mgcad.portador.char-1 = substr(v_boleto,1,3) + v_prox_boleto.
            end.

            if  mgcad.portador.cod-febraban = 422 then do:
                assign mgcad.portador.char-1 = v_prox_boleto.
            end.

            assign b_tit_acr.cod_tit_acr_bco = v_prox_boleto. /* chamado C2207-0151 andrey */
        end.       
    end.

END PROCEDURE.

PROCEDURE pi-mostra-numero :

    assign v_tamanho_bloq = length(v_boleto_digito).

    case mgcad.portador.cod-febraban:
         when 237 then do:
              assign v_prox_boleto  = string(decimal(substring(v_boleto_digito, 1, v_tamanho_bloq)), "99999999999")
                     v_formato      = "99999999999".
              assign v_tamanho_bloq = length(v_boleto_digito).
         end.               
    
         when 341 then
            if v_tamanho_bloq > 12 then
               assign v_tamanho_bloq = v_tamanho_bloq - 12
                      v_prox_boleto  = string(decimal(substring(v_boleto_digito, 13, v_tamanho_bloq)),"99999999")
                      v_formato      = "99999999".
            else
               assign v_tamanho_bloq = v_tamanho_bloq /* - 4 */
                      v_prox_boleto  = v_boleto_digito
                      v_formato      = "99999999".
    
         when 422 then do:
              assign v_prox_boleto  = string(decimal(substring(v_boleto_digito, 1, v_tamanho_bloq)), "99999999")
                     v_formato      = "99999999".
              assign v_tamanho_bloq = length(v_boleto_digito).
         end.               
    end.
    
    ASSIGN v_num_bloq = string(v_prox_boleto, v_formato).

END PROCEDURE.

procedure pi-calcula-digito-11-sicredi: 
    ASSIGN i-multiplicador = 1
           i-acum          = 0.

    ASSIGN i-tamanho = length(v_prox_boleto)
           i-cont    = i-tamanho.

    do  while i-tamanho >= 1:
        assign i-multiplicador = i-multiplicador + 1.

        if  i-multiplicador > 9 then
            assign i-multiplicador = 2.

        assign c-number  = string(integer(substring(v_prox_boleto,i-tamanho,1)) * i-multiplicador)
               c-numero1 = c-number
               i-acum    = i-acum + integer(c-number)
               i-tamanho = i-tamanho - 1.
    end.

    assign i-resto  = i-acum MODULO 11
           v_digito = string(11 - i-resto).          

    if  integer(v_digito) >= 10 then 
        assign v_digito = "0".   
end.
