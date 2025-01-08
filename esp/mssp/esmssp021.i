/*------------------------------------------------------------------------
    File        : ESMSSP021.I
    Purpose     : Include Busca C¢digo Item - Procedure: buscaCodigoItem
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Dezembro de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo LIKE item.it-codigo
    INDEX chPrimario IS PRIMARY UNIQUE
        it-codigo.

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD sequencia AS INTEGER              FORMAT ">>>>>>>>9":U LABEL "Sequencia":U       COLUMN-LABEL "Seq":U
    FIELD codigo    LIKE cadast_msg.cdn_msg                         LABEL "C¢digo Mensagem":U COLUMN-LABEL "C¢digo":U
    FIELD tipo      AS CHARACTER            FORMAT "x(12)":U     LABEL "Tipo Mensagem":U   COLUMN-LABEL "Tp Msgs":U
    FIELD mensagem  LIKE cadast_msg.des_text_msg                      LABEL "Mensagem":U        COLUMN-LABEL "Msgs":U
    FIELD ajuda     LIKE cadast_msg.dsl_help_msg                       LABEL "Ajuda":U           COLUMN-LABEL "Ajuda":U
    INDEX chPrimario IS PRIMARY UNIQUE
        sequencia
    INDEX chCodigo
        codigo
        sequencia
    INDEX chTipo
        tipo
        sequencia.
