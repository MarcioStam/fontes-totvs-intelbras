/*------------------------------------------------------------------------
    File        : GK0004.I
    Purpose     : Importa‡Æo Contabiliza‡Æo GKO
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Junho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino   AS INTEGER
    FIELD arquivo   AS CHARACTER FORMAT "x(35)":U
    FIELD usuario   AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec AS DATE
    FIELD hora-exec AS INTEGER
    FIELD diretorio AS CHARACTER
    FIELD dt-ctbl   AS DATE.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

