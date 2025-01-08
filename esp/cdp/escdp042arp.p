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
**  Programa.: Relat¢rio de Eliminaá∆o Definiá∆o Transportadora
**  Objetivo.: Relat¢rio.
**  Criaá∆o..: 01/05/2011
**  Vers∆o...: Silvio Ferrari (SQL Works).
**
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCDP042aRP 2.00.00.000}

{utp/ut-glob.i}
{include/i-rpvar.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as INTEGER
    FIELD estab-ini        AS CHAR
    FIELD estab-fim        AS CHAR
    FIELD uf-ini           AS CHAR
    FIELD uf-fim           AS CHAR
    FIELD cidade-ini       AS CHAR
    FIELD cidade-fim       AS CHAR
    FIELD cliente-ini      AS CHAR
    FIELD cliente-fim      AS CHAR
    FIELD unid-comerc-ini  AS INT
    FIELD unid-comerc-fim  AS INT
    FIELD transp-ini       AS INT
    FIELD transp-fim       AS INT.

DEFINE TEMP-TABLE tt-digita LIKE def-transportes
    FIELD l-marca AS LOGICAL.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita  AS RAW.

/* Local Variables Definitions ---                                      */
DEFINE VARIABLE h-acomp         AS HANDLE             NO-UNDO.
DEFINE VARIABLE c-arquivo-csv   AS CHARACTER          NO-UNDO.

DEFINE STREAM s-imp.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri: END.

FIND FIRST tt-param NO-ERROR.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relat¢rio Eliminaá∆o Definiá∆o Transportadora"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCDP042"
       c-versao       = "2.00"
       c-revisao      = "001".

FORM SKIP(1)
     "SELEÄ«O":U AT 13 SKIP(1)
     tt-param.estab-ini      FORMAT "x(16)":U      LABEL "Estabelecimento Origem":U COLON 40 
     " |< >| ":U AT 59                                                    
     tt-param.estab-fim      FORMAT "x(16)":U      NO-LABEL SKIP           
     tt-param.uf-ini FORMAT "x(12)":U      LABEL "Estado Destino":U COLON 40
     " |< >| ":U AT 59
     tt-param.uf-fim FORMAT "x(12)":U      NO-LABEL SKIP
     tt-param.cidade-ini FORMAT "x(12)":U      LABEL "Cidade Destino":U COLON 40
     " |< >| ":U AT 59
     tt-param.cidade-fim FORMAT "x(12)":U      NO-LABEL SKIP
     tt-param.cliente-ini FORMAT "x(12)":U      LABEL "Cliente Destino":U COLON 40
     " |< >| ":U AT 59
     tt-param.cliente-fim FORMAT "x(12)":U      NO-LABEL SKIP
     tt-param.unid-comerc-ini FORMAT ">>9":U    LABEL "Unid Comercial":U COLON 40
     " |< >| ":U AT 59
     tt-param.unid-comerc-fim FORMAT ">>9":U    NO-LABEL SKIP
     tt-param.transp-ini       LABEL "Transportadora":U COLON 40
     " |< >| ":U AT 59
     tt-param.transp-fim       NO-LABEL SKIP
     SKIP(1)
     "IMPRESS«O":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu†rio":U           COLON 40 SKIP
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

form  tt-digita.cod-estabel                   column-label "Estabelecimento Origem"            
      tt-digita.cod-uf                        column-label "Estado Destino"       
      tt-digita.cod-cidade                    column-label "Cidade Destino"
      tt-digita.cod-cliente                   column-label "Cliente Destino"
      tt-digita.cd-unid-comerc                column-label "Unid Comercial"
      tt-digita.cod-trans                     column-label "Transportadora"
      tt-digita.sigla-trans                   column-label "Sigla Transportadora"             
     WITH STREAM-IO NO-ATTR-SPACE NO-BOX DOWN WIDTH 132 FRAME f-item.

DO ON STOP UNDO, LEAVE:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

    RUN utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Eliminando...").

    RUN pi-executar.

    RUN pi-finalizar in h-acomp.

    PAGE.

    DISP tt-param.estab-ini   
         tt-param.estab-fim   
         tt-param.uf-ini      
         tt-param.uf-fim      
         tt-param.cidade-ini  
         tt-param.cidade-fim  
         tt-param.cliente-ini 
         tt-param.cliente-fim 
         tt-param.unid-comerc-ini
         tt-param.unid-comerc-fim
         tt-param.transp-ini  
         tt-param.transp-fim  
         tt-param.arquivo
         tt-param.usuario
         WITH FRAME f-impressao.

   {include/i-rpclo.i}
END.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK".


PROCEDURE pi-executar:
    FOR EACH tt-digita WHERE
        tt-digita.l-marca = YES:

        FOR FIRST def-transportes WHERE
            def-transportes.cod-estabel    = tt-digita.cod-estabel   AND
            def-transportes.cod-uf         = tt-digita.cod-uf        AND
            def-transportes.cod-cidade     = tt-digita.cod-cidade    AND
            def-transportes.cod-cliente    = tt-digita.cod-cliente   AND
            def-transportes.cd-unid-comerc = tt-digita.cd-unid-comer AND
            def-transportes.cod-trans      = tt-digita.cod-trans   EXCLUSIVE-LOCK:

            RUN pi-acompanhar IN h-acomp (INPUT "Transportadora: " + STRING(def-transportes.cod-trans)).

            DELETE def-transportes.

        END.

        DISP tt-digita.cod-estabel
             tt-digita.cod-uf
             tt-digita.cod-cidade
             tt-digita.cod-cliente
             tt-digita.cd-unid-comerc
             tt-digita.cod-trans
             tt-digita.sigla-trans WITH FRAME f-item.
             DOWN WITH FRAME f-item.
    END.

    RETURN "OK":U.
END PROCEDURE.

