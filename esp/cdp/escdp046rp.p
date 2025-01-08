/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: Relat¢rio Dep¢sito Localizaá∆o em Branco
**  Objetivo.: Relat¢rio.
**  Criaá∆o..: 23/05/2011
**  Vers∆o...: Silvio Ferrari (SQL Works).
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCDP046RP 2.00.00.000}
{utp/ut-glob.i}
{include/i-rpvar.i}

/* Includes Definitions ---                                             */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as INTEGER
    FIELD dep-ini          AS CHAR
    FIELD dep-fim          AS CHAR
    FIELD estab-ini        AS CHAR
    FIELD estab-fim        AS CHAR.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita  AS RAW.

/* Local Variables Definitions ---                                      */
DEFINE VARIABLE h-acomp         AS HANDLE       NO-UNDO.
DEFINE VARIABLE l-liberado      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE c-descricao     LIKE tipo-local.descricao    NO-UNDO.
DEFINE STREAM s-imp.

DEFINE BUFFER b-saldo-estoq FOR saldo-estoq.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relat¢rio Localizaá∆o em Branco"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCDP046"
       c-versao       = "2.00"
       c-revisao      = "001".

FORM SKIP(1)
     "SELEÄ«O":U AT 13 SKIP(1)
     tt-param.estab-ini FORMAT "x(3)":U         LABEL "Estabelecimento":U COLON 40
     " |< >| ":U AT 59
     tt-param.estab-fim FORMAT "x(3)":U         NO-LABEL SKIP
     tt-param.dep-ini      FORMAT "x(3)":U      LABEL "Dep¢sito":U COLON 40 
     " |< >| ":U AT 59                                                    
     tt-param.dep-fim      FORMAT "x(3)":U      NO-LABEL SKIP           
     SKIP(1)
     "IMPRESS«O":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu†rio":U           COLON 40 SKIP
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

form local.cod-estabel                  column-label "Est"            
     local.cod-depos                    column-label "Dep"       
     local.localizacao                  column-label "Localizaá∆o"
     local.cod-tipo                     column-label "Tipo"
     c-descricao                        column-label "Descriá∆o"
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-localizacao.

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    RUN pi-executar.

    RUN pi-finalizar in h-acomp.

    PAGE.

    DISP tt-param.dep-ini    
         tt-param.dep-fim
         tt-param.estab-ini 
         tt-param.estab-fim 
         tt-param.arquivo
         tt-param.usuario
         WITH FRAME f-impressao.

   {include/i-rpclo.i}
END.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK".

PROCEDURE pi-executar:

    for each local no-lock
       where local.loc-unica = no
         and local.cod-estabel >= tt-param.estab-ini
         AND local.cod-estabel <= tt-param.estab-fim
         AND local.cod-depos   >= tt-param.dep-ini
         AND local.cod-depos   <= tt-param.dep-fim:

        FIND FIRST tipo-local 
             WHERE tipo-local.cod-estabel = local.cod-estabel 
               AND tipo-local.cod-tipo = local.cod-tipo NO-LOCK NO-ERROR.

        FIND FIRST saldo-estoq use-index dep-estabel
             where saldo-estoq.cod-estabel = local.cod-estabel
               and saldo-estoq.cod-depos   = local.cod-depos 
               and saldo-estoq.cod-localiz = local.localizacao
               and saldo-estoq.qtidade-atu > 0 no-lock no-error.
        if not avail saldo-estoq then do:
            assign l-liberado = yes.
    
            for each b-saldo-estoq use-index dep-estabel
                where b-saldo-estoq.cod-estabel = local.cod-estabel
                  and b-saldo-estoq.cod-depos   = local.cod-depos 
                  and b-saldo-estoq.cod-localiz = local.localizacao no-lock:

                RUN pi-acompanhar IN h-acomp (INPUT "Estab: " + b-saldo-estoq.cod-estabel + " Dep: " + b-saldo-estoq.cod-depos + " Local: " + local.localizacao).
                        
                find FIRST int-saldo-estoq 
                     where int-saldo-estoq.cod-estabel = b-saldo-estoq.cod-estabel
                       and int-saldo-estoq.cod-depos   = b-saldo-estoq.cod-depos
                       and int-saldo-estoq.it-codigo   = b-saldo-estoq.it-codigo
                       and int-saldo-estoq.cod-localiz = b-saldo-estoq.cod-localiz
                       and not int-saldo-estoq.log-baixado no-lock no-error.
                     
                if avail int-saldo-estoq then
                    assign l-liberado = no.
            end.

            IF AVAIL tipo-local THEN
                ASSIGN c-descricao = tipo-local.descricao.
            ELSE
                ASSIGN c-descricao = "".
    
            IF l-liberado THEN DO:
                DISP local.cod-estabel
                     local.cod-depos    
                     local.localizacao  
                     local.cod-tipo     
                     c-descricao WITH FRAME f-localizacao.     
                     DOWN WITH FRAME f-localizacao.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.
