/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*------------------------------------------------------------------------
    File        : ESUTP058RP-EMS5.P
    Purpose     : Exporta‡Æo do Centro de Custo e do Aprovador do Centro
                  de Custo.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/utp/esutp058-ems5.i} /* Defini‡Æo das Temp-Tables */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE v-cc-codigo      LIKE int-centro-custo.cc-codigo NO-UNDO.
DEFINE VARIABLE v_cdn_unid_negoc LIKE emscad.unid_negoc.cdn_unid_negoc    NO-UNDO.
DEFINE VARIABLE v-cod-usuario    LIKE usuar_mestre.cod_usuario          NO-UNDO.
DEFINE VARIABLE v-empresa        AS CHARACTER                           NO-UNDO.

/* Parameter Definitions ---                                            */

DEFINE INPUT  PARAMETER p-acomp     AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER p-ccusto    AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER p-ap-ccusto AS LOGICAL     NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-centro-custo.
DEFINE OUTPUT PARAMETER TABLE FOR tt-aprov-centro-custo.


/* ***************************  Main Block  *************************** */

IF VALID-HANDLE(p-acomp) THEN
    RUN pi-seta-titulo IN p-acomp (INPUT "Gerando dados de exporta‡Æo...").

IF VALID-HANDLE(p-acomp) THEN
    RUN pi-acompanhar IN p-acomp (INPUT "Gerando dados...").

EMPTY TEMP-TABLE tt-centro-custo.
EMPTY TEMP-TABLE tt-aprov-centro-custo.

FOR EACH int-centro-custo NO-LOCK
    BREAK BY int-centro-custo.cod-estabel
          BY int-centro-custo.cc-codigo:

    IF FIRST-OF(int-centro-custo.cc-codigo) THEN DO:
        IF VALID-HANDLE(p-acomp) THEN
            RUN pi-acompanhar IN p-acomp (INPUT "Est.:" + int-centro-custo.cod-estabel + " - CCusto: " + int-centro-custo.cc-codigo).

        CASE int-centro-custo.cod-estabel:
            WHEN "101" THEN
                ASSIGN v-empresa = "Matriz 101".
            WHEN "103" THEN
                ASSIGN v-empresa = "Minas 103".
            WHEN "104" THEN
                ASSIGN v-empresa = "FabricaII 104".
            WHEN "105" THEN
                ASSIGN v-empresa = "Manaus 105".
            OTHERWISE
                NEXT.
        END CASE.

        ASSIGN v-cc-codigo = CAPS(TRIM(int-centro-custo.cod-unid-negoc)) + TRIM(SUBSTRING(int-centro-custo.cc-codigo, 4)).

        FIND FIRST centro-custo
            WHERE centro-custo.cc-codigo = int-centro-custo.cc-codigo NO-LOCK NO-ERROR.

        IF NOT AVAILABLE centro-custo THEN
            NEXT.

        IF int-centro-custo.log-excecao THEN
            ASSIGN v-cod-usuario = int-centro-custo.cod_usuario.
        ELSE
            ASSIGN v-cod-usuario = int-centro-custo.cod_diretor.

        FIND FIRST usuar_mestre
            WHERE usuar_mestre.cod_usuario = v-cod-usuario NO-LOCK NO-ERROR.

        IF NOT AVAILABLE usuar_mestre         OR
           usuar_mestre.dat_fim_valid < TODAY THEN NEXT.

        IF p-ccusto THEN DO:
            IF NOT CAN-FIND(FIRST tt-centro-custo
                            WHERE tt-centro-custo.empresa      = v-empresa
                              AND tt-centro-custo.centro-custo = v-cc-codigo) THEN DO:
                CREATE tt-centro-custo.
                ASSIGN tt-centro-custo.empresa      = v-empresa
                       tt-centro-custo.centro-custo = v-cc-codigo
                       tt-centro-custo.desc-c-custo = TRIM(centro-custo.descricao)
                       tt-centro-custo.pais         = "BR".
            END.
        END.

        IF p-ap-ccusto THEN DO:
            IF NOT CAN-FIND(FIRST tt-aprov-centro-custo
                            WHERE tt-aprov-centro-custo.empresa      = v-empresa
                              AND tt-aprov-centro-custo.centro-custo = v-cc-codigo) THEN DO:
                CREATE tt-aprov-centro-custo.
                ASSIGN tt-aprov-centro-custo.empresa      = v-empresa
                       tt-aprov-centro-custo.centro-custo = v-cc-codigo
                       tt-aprov-centro-custo.tp-aprovacao = "NIR"
                       tt-aprov-centro-custo.tp-estrutura = "U"
                       tt-aprov-centro-custo.login-aprov  = LC(usuar_mestre.cod_usuario)
                       tt-aprov-centro-custo.nome-aprov   = TRIM(usuar_mestre.nom_usuario)
                       tt-aprov-centro-custo.email-aprov  = IF AVAILABLE usuar_mestre THEN LC(TRIM(usuar_mestre.cod_e_mail_local)) ELSE "".
            END.
        END.
    END.
END.

RETURN "OK".

