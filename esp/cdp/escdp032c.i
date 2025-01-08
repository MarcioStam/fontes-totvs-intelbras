/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : XX9999.I
    Purpose     : <none>
    Syntax      : <none>
    Description : <none>

    Author(s)   : <none>
    Created     : <none>
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS INTEGER
    FIELD arquivo          AS CHARACTER FORMAT "x(35)":U
    FIELD usuario          AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec        AS DATE
    FIELD hora-exec        AS INTEGER
    FIELD classifica       AS INTEGER
    FIELD desc-classifica  AS CHARACTER FORMAT "x(40)":U
    FIELD modelo           AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar
      se o RTF foi habilitado*/
    FIELD l-habilitaRtf    AS LOGICAL
    /*Fim alteracao 15/02/2005*/
    FIELD rs-imp-exp       AS CHAR
    FIELD arq-imp-exp      AS CHAR
    .

/*
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
          ordem . 
*/

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD r-rowid AS ROWID .


DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW .


DEFINE TEMP-TABLE tt-crm-desc-cli-imp NO-UNDO
    FIELD cd-unid-negoc   LIKE crm-desc-cli.cd-unid-negoc
    FIELD cod-emitente    LIKE crm-desc-cli.cod-emitente
    FIELD it-codigo      LIKE crm-desc-cli.it-codigo
    FIELD dt-vigencia-ini LIKE crm-desc-cli.dt-vigencia-ini
    FIELD dt-vigencia-fim LIKE crm-desc-cli.dt-vigencia-fim
    FIELD pc-desconto     LIKE crm-desc-cli.pc-desconto
    FIELD observacao      LIKE crm-desc-cli.observacao
    FIELD linha           AS INTEGER.


