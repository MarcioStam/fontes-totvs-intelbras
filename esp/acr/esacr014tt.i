/*************************************************
**
** Descri‡Æo..: Temp-table do programa esacr014
** Autor......: Anderson Silvano
** Data.......: 12/05/2005 
**
**************************************************/
                                               
def temp-table tt-portador
    field l_ok           as   CHAR
    field cod_portador   like tit_acr.cod_portador
    field cod_cart_bcia  like tit_acr.cod_cart_bcia
    index portador is primary UNIQUE cod_portador cod_cart_bcia.

def temp-table tt-emitente
    field cod-emitente like emitente.cod-emitente
    field e-mail       like cont-emit.e-mail
    FIELD e-mail-ger   LIKE gerente.e-mail
    field e-mail-rep   like repres.e-mail
    FIELD e-mail-cont  LIKE contato.cod_e_mail_contat
    field ve-a         as dec format ">>,>>>,>>9.99"
    field ve-b         as dec format ">>,>>>,>>9.99"
    field ve-c         as dec format ">>,>>>,>>9.99"
    field ve-d         as dec format ">>,>>>,>>9.99"
    field ve-e         as dec format ">>,>>>,>>9.99"
    field ve-f         as dec format ">>,>>>,>>9.99"
    FIELD ve-g         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-a         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-b         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-c         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-d         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-e         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-f         AS DEC FORMAT ">>,>>>,>>9.99"
    FIELD av-g         AS DEC FORMAT ">>,>>>,>>9.99"
    field Total        as dec format ">>,>>>,>>9.99"
    field mail         as log format "Sim/Nao" label "Mail"
    FIELD mail-ger     AS LOG FORMAT "Sim/Nao" LABEL "Ger"
    field mail-rep     as log format "Sim/Nao" Label "Rep"
    FIELD mail-cont    AS LOG FORMAT "Sim/Nao" LABEL "Cont"
    field cod-port     like tit_acr.cod_portador
    field modalidade   like tit_acr.cod_cart_bcia
    FIELD l-portador     AS LOG
    field cod_portador   like tit_acr.cod_portador
    field cod_cart_bcia  like tit_acr.cod_cart_bcia
    index emitente is primary cod-emitente
    ve-a ve-b ve-c ve-d ve-e ve-f ve-g
    av-a av-b av-c av-d av-e av-f av-g
    index valor TOTAL DESCENDING ve-a descending ve-b descending ve-c descending ve-d DESCENDING ve-e DESCENDING ve-f DESCENDING ve-g DESCENDING
    index valor2 ve-a descending TOTAL DESCENDING ve-b descending ve-c DESCENDING ve-d DESCENDING ve-e DESCENDING ve-f DESCENDING ve-g DESCENDING.

def temp-table tt-saldo
    field cod_empresa               like tit_acr.cod_empresa
    field cod_estab                 like tit_acr.cod_estab
    field cod_espec_docto           like tit_acr.cod_espec_docto
    field cod_ser_docto             like tit_acr.cod_ser_docto
    field num_id_tit_acr            like tit_acr.num_id_tit_acr
    field cod_tit_acr               like tit_acr.cod_tit_acr
    field cod_parcela               like tit_acr.cod_parcela
    field val_origin_tit_acr        AS dec format ">>,>>>,>>9.99"
    field val_sdo_tit_acr           AS dec format ">>,>>>,>>9.99" 
    field cartorio                  AS DEC FORMAT ">>>,>>9.99"
    field num_atr                   AS DEC FORMAT ">>>,>>9.99"
    field ind_tip_espec_docto       like tit_acr.ind_tip_espec_docto   
    field num_planinha_vendor       like dupl_vendor.num_planilha_vendor   
    field dat_ult_liquidac_tit_acr  like tit_acr.dat_ult_liquidac_tit_acr
    field dat_vencto_tit_acr        like tit_acr.dat_vencto_tit_acr
    field dat_emis_docto            like tit_acr.dat_emis_docto
    field cod_portador              like tit_acr.cod_portador format ">>9"
    field cod_cart_bcia             like tit_acr.cod_cart_bcia
    field nr_duplic                 like tit_acr.cod_tit_acr  format ">>>>>>"
    index vencimento dat_vencto_tit_acr.


DEFINE TEMP-TABLE tt-param NO-UNDO 
    FIELD destino          AS INTEGER 
    FIELD arquivo          AS CHAR FORMAT "x(35)":U
    FIELD usuario          AS CHAR FORMAT "x(12)":U
    FIELD data-exec        AS DATE 
    FIELD hora-exec        AS INTEGER.

DEFINE TEMP-TABLE tt-digita NO-UNDO LIKE tt-emitente.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.
