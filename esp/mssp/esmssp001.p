/**
 * Zoom de centro de custo para SharePoint
 **/
 
define temp-table ttCentroCusto no-undo
   field cod-estabel    like int-centro-custo.cod-estabel
   field cc-codigo      like centro-custo.cc-codigo
   field descricao      like centro-custo.descricao
   field usu-aprovador  like usuar_mestre.cod_usuario
   field nome-aprovador like usuar_mestre.nom_usuario
   FIELD e-mail         LIKE usuar_mestre.cod_e_mail_local
   index idx_pri is primary unique cod-estabel cc-codigo.

DEF TEMP-TABLE tt_usuar_mestre NO-UNDO LIKE usuar_mestre.
DEF TEMP-TABLE tt_ccusto       NO-UNDO LIKE emscad.ccusto.

DEF VAR v_nom_usuar      LIKE usuar_mestre.nom_usuario      NO-UNDO.
DEF VAR v_email          LIKE usuar_mestre.cod_e_mail_local NO-UNDO.
DEF VAR v_cdn_unid_negoc LIKE unid_negoc.cdn_unid_negoc     NO-UNDO.

define output parameter table for ttCentroCusto.

EMPTY TEMP-TABLE ttCentroCusto.
EMPTY TEMP-TABLE tt_usuar_mestre.
EMPTY TEMP-TABLE tt_ccusto.

FOR EACH usuar_mestre NO-LOCK:
    CREATE tt_usuar_mestre.
    BUFFER-COPY usuar_mestre TO tt_usuar_mestre.
END.

FOR EACH emscad.ccusto NO-LOCK
    WHERE emscad.ccusto.cod_empresa = "1":

    IF  emscad.ccusto.dat_fim_valid < TODAY THEN
        NEXT.

    CREATE tt_ccusto.
    BUFFER-COPY emscad.ccusto TO tt_ccusto.
END.

FOR EACH estabelecimento 
    WHERE estabelecimento.cod_empresa = "1" NO-LOCK:
    
    for each int-centro-custo 
        WHERE int-centro-custo.cod-estabel = estabelecimento.cod_estab no-lock:
    
        FIND FIRST tt_usuar_mestre NO-LOCK
            WHERE  tt_usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
    
        IF  AVAIL tt_usuar_mestre THEN DO:
            ASSIGN v_nom_usuar = tt_usuar_mestre.nom_usuario
                   v_email     = tt_usuar_mestre.cod_e_mail_local.
        END.
        
        FOR FIRST tt_ccusto NO-LOCK
           WHERE tt_ccusto.cod_empresa      = estabelecimento.cod_empresa
           AND   tt_ccusto.cod_plano_ccusto = "PADRAO"
           AND   tt_ccusto.cod_ccusto       = int-centro-custo.cc-codigo:
    
           create ttCentroCusto.
           assign ttCentroCusto.cod-estabel    = int-centro-custo.cod-estabel
                  ttCentroCusto.cc-codigo      = int-centro-custo.cc-codigo
                  ttCentroCusto.descricao      = tt_ccusto.des_tit_ctbl
                  ttCentroCusto.usu-aprovador  = int-centro-custo.cod_usuario
                  ttCentroCusto.nome-aprovador = v_nom_usuar
                  ttCentroCusto.e-mail         = v_email.
        end.
    END.
END.
