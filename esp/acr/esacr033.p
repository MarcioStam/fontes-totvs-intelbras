/*****************************************************************************
** Programa: esp/acr/esacr033.p
** VersÆo..: 1.00
** Data....: 29/08/2011
** Autor...: Estevan Krger - Exponencial TI
** Obs.....: Programa para Exportar os dados dos Emitentes cadastrados, seguindo
**           o layout proposto pelo SupplierCard (Carga de Clientes)
*****************************************************************************/

/*--- Defini‡Æo das Vari veis ---*/
{esp/acr/esacr035.i}

DEFINE INPUT  PARAMETER p-cod-gr-cob AS CHARACTER   NO-UNDO.

/* DEFINE VARIABLE c-lista AS CHARACTER   NO-UNDO. */
DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.


/*
Grupos de Cobran‡a que serÆo enviados (Atualizar na vari vel c-lista):
01 - Castilho
02 - Prioritario
22 - Revenda Soho
23 - Revenda Corporativa
24 - Dealer
34 - Dealer de Inform tica
36 - RMC Plus
37 - Revenda de Seguran‡a
38 - Dealer de Seguran‡a
40 - Integrador Premium
41 - Integrador Standart
50 - Maxcom Distribuidor
*/
/* ASSIGN c-lista = "01,02,22,23,24,34,36,37,38,40,41,50". */


/*--- Bloco Principal ---*/
FOR EACH   emitente NO-LOCK
    WHERE  /*emitente.cod-emitente >= 258911
    AND    emitente.cod-emitente <= 258911
    AND*/    emitente.natureza  = 2 /* Pessoa Jur¡dica */
    AND   (emitente.identific = 1 /* Cliente */ OR
           emitente.identific = 3 /* Ambos */),
    FIRST  int-emitente NO-LOCK
    WHERE  int-emitente.cod-emitente = emitente.cod-emitente
    AND    int-emitente.id-ativo:

/*     IF  LOOKUP(STRING(int-emitente.cod-gr-cob, "99"), c-lista) = 0 THEN */
/*         NEXT.                                                           */
    IF p-cod-gr-cob                                                 <> "":U AND
       LOOKUP(STRING(int-emitente.cod-gr-cob, "99":U), p-cod-gr-cob) = 0    THEN
        NEXT.

    CREATE tt-emitente-supcard.
    ASSIGN tt-emitente-supcard.raiz-cnpj           = SUBSTRING(emitente.cgc,1,8)
           tt-emitente-supcard.nome-matriz         = emitente.nome-matriz
           tt-emitente-supcard.tipo-solicitacao    = 0
           tt-emitente-supcard.val-limite-sugerido = 0. /* NÆo utiliza este campo para o Layout 8.1 */

    /*ASSIGN i-cont = i-cont + 1.*/
END.

/*MESSAGE "Terminou a cria‡Æo da tt-emitente-supcard - " i-cont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

RUN esp/acr/esacr035.p (INPUT "8.1", /* Layout */
                        INPUT /*c-linha*/ p-cod-gr-cob,
                        INPUT TABLE tt-emitente-supcard).

