/*------------------------------------------------------------------------
    File        : ESMSSP023.I
    Purpose     : Consulta Fam¡lia Material
    Procedure   : consultaFamiliaMaterial
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (SQL Works / Exponencial TI)
    Created     : Julho de 2012
    Notes       : <none>
------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE tt-familia NO-UNDO
    FIELD fm-codigo    LIKE familia.fm-codigo    /* Fam¡lia Material            */
    FIELD descricao    LIKE familia.descricao    /* Descri‡Æo Fam¡lia Material  */
    FIELD un           LIKE familia.un           /* Unidade de Medida           */
    FIELD contr-qualid LIKE familia.contr-qualid /* Controle de Qualidade       */
    FIELD fraciona     LIKE familia.fraciona     /* Quantidade Fracionada       */
    FIELD criticidade  LIKE familia.criticidade  /* Criticidade                 */
    FIELD perc-nqa     LIKE familia.perc-nqa     /* NQA                         */
    INDEX chPrimario IS UNIQUE PRIMARY
        fm-codigo.

DEFINE TEMP-TABLE tt-mensagem NO-UNDO
    FIELD sequencia   AS INTEGER   FORMAT ">>>>9":U LABEL "Sequˆncia":U     COLUMN-LABEL "Seq":U
    FIELD codigo      LIKE cadast_msg.cdn_msg
    FIELD tipo        AS CHARACTER FORMAT "x(20)":U LABEL "Tipo Mensagem":U COLUMN-LABEL "Tipo Msg":U
    FIELD mensagem    LIKE cadast_msg.des_text_msg
    FIELD complemento LIKE cadast_msg.dsl_help_msg
    INDEX chPrimaria IS PRIMARY UNIQUE
        sequencia
    INDEX chCodigo
        sequencia
        codigo
    INDEX chTipo
        sequencia
        tipo.

