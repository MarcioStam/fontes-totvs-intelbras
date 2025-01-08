/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESUTP058-EMS5.I
    Purpose     : Exporta‡Æo do Centro de Custo e do Aprovador do Centro
                  de Custo.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-centro-custo NO-UNDO
    FIELD empresa      AS CHARACTER
    FIELD centro-custo AS CHARACTER
    FIELD desc-c-custo AS CHARACTER
    FIELD pais         AS CHARACTER.

DEFINE TEMP-TABLE tt-aprov-centro-custo NO-UNDO
    FIELD empresa      AS CHARACTER
    FIELD centro-custo AS CHARACTER
    FIELD tp-aprovacao AS CHARACTER
    FIELD tp-estrutura AS CHARACTER
    FIELD login-aprov  AS CHARACTER
    FIELD nome-aprov   AS CHARACTER
    FIELD email-aprov  AS CHARACTER
    FIELD ordem-aprov  AS CHARACTER.

