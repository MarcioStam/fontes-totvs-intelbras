/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESCPP061.I
    Purpose     : Relat¢rio de Mac Address Gerados
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Setembro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino            AS INTEGER
    FIELD arquivo            AS CHARACTER FORMAT "x(80)":U LABEL "Arquivo":U
    FIELD usuario            AS CHARACTER FORMAT "x(12)":U LABEL "Usu rio":U
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER
    FIELD mac-ini            LIKE mac-address.mac LABEL "Mac Address":U
    FIELD mac-fin            LIKE mac-address.mac
    FIELD cod-unid-negoc-ini LIKE mac-address.cod-unid-negoc LABEL "Unid. Neg¢cio":U
    FIELD cod-unid-negoc-fin LIKE mac-address.cod-unid-negoc
    FIELD it-codigo-ini      LIKE mac-address.it-codigo FORMAT "x(16)":U LABEL "Item":U
    FIELD it-codigo-fin      LIKE mac-address.it-codigo FORMAT "x(16)":U
    FIELD classificacao      AS INTEGER   FORMAT "9":U
    FIELD desc-classif       AS CHARACTER FORMAT "x(22)":U
    FIELD ind-etiqueta       AS INTEGER
    FIELD desc-param-etiq    AS CHARACTER FORMAT "x(30)":U
    FIELD l-param-impr       AS LOGICAL
    FIELD num-pedido-ini     AS INTEGER
    FIELD num-pedido-fim     AS INTEGER.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

