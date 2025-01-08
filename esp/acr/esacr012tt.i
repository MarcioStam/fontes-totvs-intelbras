DEF TEMP-TABLE tt_tit_acr
    FIELD vcod_estab          LIKE tit_acr.cod_estab
    FIELD vcod_espec          LIKE tit_acr.cod_espec_docto
    FIELD vcod_ser            LIKE tit_acr.cod_ser_docto
    FIELD vcod_tit_acr        LIKE tit_acr.cod_tit_acr
    FIELD vcod_parcela        LIKE tit_acr.cod_parcela
    FIELD vcdn_cliente        LIKE tit_acr.cdn_cliente
    FIELD vcod_grp_clien      LIKE emscad.cliente.cod_grp_clien
    FIELD vnom_abrev          LIKE tit_acr.nom_abrev
    FIELD cod_portad          LIKE tit_acr.cod_portad
    FIELD vdat_vencto_tit_acr LIKE tit_acr.dat_vencto_tit_acr 
    FIELD vdat_emis_tit_acr   LIKE tit_acr.dat_emis_docto
    FIELD vval_sdo_tit_acr    LIKE tit_acr.val_sdo_tit_acr
    FIELD selecionado         AS   LOG INITIAL NO FORMAT 'Sim/NÆo'
    FIELD vcont_parcelas      AS   INT INITIAL 0 FORMAT 'Z9'
    FIELD vnum_atras          AS   INT INITIAL 0 FORMAT 'ZZZ9' COLUMN-LABEL 'Num Atras'
    FIELD vsit_tit_acr        AS   CHAR FORMAT 'x(45)'         COLUMN-LABEL 'Regra'
    FIELD vregra              AS   INT INITIAL 0 FORMAT '9' /* "Todas", 1,
                                                               "+ de 180 dias ate R$ 5.000,00", 2,
                                                               "+ de 365 dias de R$ 5.001,00 ate R$ 30.000,00", 3,
                                                               "+ de 365 dias > R$ 30.000,00", 4*/
    INDEX vcod_tit_acr IS PRIMARY UNIQUE vcod_estab
                                         vcod_espec
                                         vcod_ser
                                         vcod_tit_acr
    INDEX vcdn_clien          vcdn_cliente
    INDEX vnum_atras          vnum_atras
    INDEX vdat_vencto_tit_acr vdat_vencto_tit_acr.


