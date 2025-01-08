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

{include/i-prgvrs.i ESCDP098ARP 2.00.00.000}

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
    FIELD Cep-ini          AS CHAR
    FIELD Cep-fim          AS CHAR
    FIELD transp-ini       AS INT
    FIELD transp-fim       AS INT.

DEFINE TEMP-TABLE tt-digita LIKE int-logistica-ecommerce
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
       c-titulo-relat = "Relat¢rio Eliminaá∆o Definiá∆o de Sigla Transportadora"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCDP042"
       c-versao       = "2.00"
       c-revisao      = "001".

FORM SKIP(1)
     "SELEÄ«O":U AT 13 SKIP(1)
     tt-param.transp-ini LABEL "Transportadora":U COLON 40
     " |< >| ":U AT 59
     tt-param.transp-fim FORMAT ">>>>>>>>9" NO-LABEL SKIP

     tt-param.estab-ini  FORMAT "x(16)":U LABEL "Estabelecimento Origem":U COLON 40 
     " |< >| ":U AT 59                                                
     tt-param.estab-fim  FORMAT "x(16)":U NO-LABEL SKIP      

     tt-param.uf-ini FORMAT "x(12)":U LABEL "Estado Destino":U COLON 40
     " |< >| ":U AT 59
     tt-param.uf-fim FORMAT "x(12)":U NO-LABEL SKIP

     tt-param.Cep-ini FORMAT "x(12)":U LABEL "Faixa de CEP ":U COLON 40
     " |< >| ":U AT 59
     tt-param.Cep-fim FORMAT "x(12)":U  NO-LABEL SKIP

     tt-param.cidade-ini FORMAT "x(12)":U LABEL "Cidade Destino":U COLON 40
     " |< >| ":U AT 59
     tt-param.cidade-fim FORMAT "x(12)":U NO-LABEL SKIP

     SKIP(1)
     "IMPRESS«O":U AT 13 SKIP(1)
     tt-param.arquivo       FORMAT "x(80)":U      LABEL "Destino":U           COLON 40 SKIP
     tt-param.usuario       FORMAT "x(12)":U      LABEL "Usu†rio":U           COLON 40 SKIP
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

form  tt-digita.cod-transp                    column-label "Transportadora"
      tt-digita.cod-estabel                   column-label "Estabelecimento Origem"            
      tt-digita.estado                        column-label "Estado Destino"       
      tt-digita.cep-inicial                   column-label "Cep Inicial"
      tt-digita.cep-final                     column-label "Cep Final"
      tt-digita.cidade        FORMAT "x(40)"  column-label "Cidade Destino"
      tt-digita.sigla-transp  FORMAT "x(12)"  column-label "Sigla Transp"             
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

    DISP tt-param.transp-ini  
         tt-param.transp-fim  
         tt-param.estab-ini   
         tt-param.estab-fim   
         tt-param.Cep-Ini 
         tt-param.Cep-Fim 
         tt-param.uf-ini      
         tt-param.uf-fim      
         tt-param.cidade-ini  
         tt-param.cidade-fim  
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

        FOR FIRST int-logistica-ecommerce 
             WHERE int-logistica-ecommerce.cod-transp     = tt-digita.cod-transp
               AND int-logistica-ecommerce.cod-estabel    = tt-digita.cod-estabel   
               AND int-logistica-ecommerce.estado         = tt-digita.estado        
               AND int-logistica-ecommerce.cep-inicial    = tt-digita.cep-inicial   
               AND int-logistica-ecommerce.cep-final      = tt-digita.cep-final 
               AND int-logistica-ecommerce.cidade         = tt-digita.cidade EXCLUSIVE-LOCK:

            RUN pi-acompanhar IN h-acomp (INPUT "Transportadora: " + STRING(int-logistica-ecommerce.cod-transp)).

            DELETE int-logistica-ecommerce.

        END.

        DISP tt-digita.cod-trans
             tt-digita.cod-estabel
             tt-digita.estado
             tt-digita.cep-inicial
             tt-digita.cep-final
             tt-digita.cidade 
             tt-digita.sigla-transp WITH FRAME f-item.
             DOWN WITH FRAME f-item.
    END.

    RETURN "OK":U.
END PROCEDURE.

