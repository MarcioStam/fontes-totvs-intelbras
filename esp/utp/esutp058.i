/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESUTP058.I
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

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD arquivo              AS CHARACTER FORMAT "x(110)":U LABEL "Arquivo":U
    FIELD usuario              AS CHARACTER FORMAT "x(12)":U  LABEL "Usu rio":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD classifica           AS INTEGER
    FIELD desc-classifica      AS CHARACTER FORMAT "x(40)":U
    FIELD modelo               AS CHARACTER FORMAT "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    FIELD l-habilitaRtf        AS LOGICAL
    /*Fim alteracao 15/02/2005*/
    FIELD l-param-impr         AS LOGICAL
    FIELD l-centro-custo       AS LOGICAL FORMAT "Sim/NÆo":U LABEL "Exporta Centro Custo":U
    FIELD l-aprov-centro-custo AS LOGICAL FORMAT "Sim/NÆo":U LABEL "Exporta Aprovador Centro Custo":U
    FIELD l-colaboradores      AS LOGICAL FORMAT "Sim/NÆo":U LABEL "Exporta Colaboradores"
    FIELD c-ccusto-ini         AS CHAR
    FIELD c-ccusto-fim         AS CHAR
    FIELD c-ind-movto          AS CHAR.

DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem   AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo AS CHARACTER FORMAT "x(30)":U
    INDEX id
        ordem.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-integra-ccusto NO-UNDO
    FIELD c-cod-estab AS CHAR
    FIELD c-cod-ccusto AS CHAR
    FIELD c-nom-ccusto AS CHAR
    FIELD c-ind-movto  AS CHAR
    INDEX id-ccusto
            c-cod-ccusto
            c-cod-estab.

DEF TEMP-TABLE tt-tmp-integra-ccusto NO-UNDO LIKE tt-integra-ccusto.

DEF TEMP-TABLE tt-integra-colab NO-UNDO
    FIELD NomeEmpresa       AS CHAR
    FIELD NomeEmpresaCCusto AS CHAR
    FIELD Matricula         AS CHAR
    FIELD NomeCompleto      AS CHAR
    FIELD Cargo             AS CHAR
    FIELD Departamento      AS CHAR
    FIELD CCusto            AS CHAR
    FIELD E-mail            AS CHAR
    FIELD E-mailAlternativo AS CHAR
    FIELD DataNascimento    AS INT
    FIELD Sexo              AS INT
    FIELD LoginAlatur       AS CHAR
    FIELD Telefone          AS CHAR
    FIELD Endereco          AS CHAR
    FIELD Cidade            AS CHAR
    FIELD Estado            AS CHAR
    FIELD CEP               AS CHAR
    FIELD CPF               AS CHAR
    FIELD RG                AS CHAR
    FIELD Tercerizado       AS INT.

DEF TEMP-TABLE tt-tmp-integra-colab NO-UNDO LIKE tt-integra-colab.

DEFINE TEMP-TABLE tt-arquivos-colab NO-UNDO
    FIELD nom-arquivo      AS CHAR
    FIELD nom-completo     AS CHAR
    FIELD ind-tipo-arquivo AS CHAR
    INDEX id-arquivo
            nom-arquivo DESC.
