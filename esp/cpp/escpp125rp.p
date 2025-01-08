/***********************************************************************
**  Programa..: ESP\CCP\ESCCP125RP.P
**  Autor.....: Vitor Inoue
**  Data......: FEVEREIRO/2023 - Desenvolvimento
**  Descricao.: Atualizar Estrutra MQA
**  Vers∆o....: 001 10/02/2023
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP125 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cpp/escpp125tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
DEFINE TEMP-TABLE tt-estrutura-mqa-old NO-UNDO
    LIKE estrutura-mqa.

DEFINE TEMP-TABLE tt-estrutura-mqa-new NO-UNDO
    LIKE estrutura-mqa.
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/
/****************************  Functions    ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
         empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Relat¢rio de Produá∆o do Per°odo"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCPP125"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
/*DEF STREAM s-teste.
OUTPUT STREAM s-teste TO 'c:\temp\vitor\teste.csv'.*/
   
do on stop undo, leave:
    {include/i-rpcab.i}    
    {include/i-rpout.i}
    
    run utp/ut-acomp.p persistent set h-acomp.      
    run pi-inicializar in h-acomp (input "Imprimindo...").        

    FOR EACH  item-mqa NO-LOCK
        WHERE item-mqa.cod-prod    >= tt-param.i-item-ini
          AND item-mqa.cod-prod    <= tt-param.i-item-fim
          AND item-mqa.cod-estabel >= tt-param.c-estab-ini
          AND item-mqa.cod-estabel <= tt-param.c-estab-fim
          AND NOT item-mqa.log-1. /* Desativado */        

        EMPTY TEMP-TABLE tt-estrutura-mqa-new.
        EMPTY TEMP-TABLE tt-estrutura-mqa-old.

        FOR EACH  estrutura-mqa NO-LOCK
            WHERE estrutura-mqa.cod-prod    = item-mqa.cod-prod
              AND estrutura-mqa.cod-estabel = item-mqa.cod-estabel.

            CREATE tt-estrutura-mqa-old.
            BUFFER-COPY estrutura-mqa TO tt-estrutura-mqa-old.

            /*EXPORT STREAM s-teste DELIMITER ";"                
                "1"
                estrutura-mqa.cod-estabel
                estrutura-mqa.cod-prod
                estrutura-mqa.local-montag
                estrutura-mqa.es-codigo.*/

        END.
        
        RUN criaEstrutura (INPUT item-mqa.cod-prod,
                           INPUT item-mqa.it-ref,
                           INPUT item-mqa.cod-estabel).

        FOR EACH  tt-estrutura-mqa-old
            WHERE tt-estrutura-mqa-old.cod-prod    = item-mqa.cod-prod
              AND tt-estrutura-mqa-old.cod-estabel = item-mqa.cod-estabel.

            IF NOT CAN-FIND(FIRST tt-estrutura-mqa-new
                            WHERE tt-estrutura-mqa-new.cod-prod     = item-mqa.cod-prod
                              AND tt-estrutura-mqa-new.local-montag = tt-estrutura-mqa-old.local-montag
                              AND tt-estrutura-mqa-new.cod-estabel  = item-mqa.cod-estabel) THEN DO:

                FOR FIRST estrutura-mqa EXCLUSIVE-LOCK
                    WHERE estrutura-mqa.cod-prod     = tt-estrutura-mqa-old.cod-prod
                      AND estrutura-mqa.local-montag = tt-estrutura-mqa-old.local-montag
                      AND estrutura-mqa.cod-estabel  = tt-estrutura-mqa-old.cod-estabel.

                    /*EXPORT STREAM s-teste DELIMITER ";"
                        "2"
                         estrutura-mqa.cod-estabel
                         estrutura-mqa.cod-prod
                         estrutura-mqa.local-montag
                         estrutura-mqa.es-codigo.*/

                    DELETE estrutura-mqa.
                END.
            END.
        END.

        FOR EACH  tt-estrutura-mqa-new
            WHERE tt-estrutura-mqa-new.cod-prod    = item-mqa.cod-prod
              AND tt-estrutura-mqa-new.cod-estabel = item-mqa.cod-estabel.

            FOR FIRST estrutura-mqa EXCLUSIVE-LOCK
                WHERE estrutura-mqa.cod-prod     = tt-estrutura-mqa-new.cod-prod
                  AND estrutura-mqa.local-montag = tt-estrutura-mqa-new.local-montag
                  AND estrutura-mqa.cod-estabel  = tt-estrutura-mqa-new.cod-estabel:
            END.            
            IF NOT AVAIL estrutura-mqa THEN DO:

                /*EXPORT STREAM s-teste DELIMITER ";"
                    "3"
                    tt-estrutura-mqa-new.cod-estabel
                    tt-estrutura-mqa-new.cod-prod
                    tt-estrutura-mqa-new.local-montag
                    tt-estrutura-mqa-new.es-codigo.*/
                
                CREATE estrutura-mqa.
                ASSIGN estrutura-mqa.cod-prod     = tt-estrutura-mqa-new.cod-prod
                       estrutura-mqa.local-montag = tt-estrutura-mqa-new.local-montag
                       estrutura-mqa.cod-estabel  = tt-estrutura-mqa-new.cod-estabel.                                                    
            END.

            ASSIGN estrutura-mqa.es-codigo = tt-estrutura-mqa-new.es-codigo.

            RELEASE estrutura-mqa NO-ERROR.

            RUN criaIndiceQualidade (INPUT tt-estrutura-mqa-new.es-codigo,
                                     INPUT tt-estrutura-mqa-new.cod-estabel).

        END.
    END.
    
    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".   
END.

/*OUTPUT STREAM s-teste CLOSE.*/


/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE criaEstrutura:
    /*:T------------------------------------------------------------------------------
  Purpose:     Valida√ß√µes pertinentes ao DBO
  Parameters:  recebe o tipo de valida√ß√£o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-cod-prod    AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER p-it-codigo   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO.

    DEFINE VARIABLE l-descer-nivel AS LOGICAL     NO-UNDO.

    DEF BUFFER estrutura FOR estrutura.
    DEF BUFFER b-estrut  FOR estrutura.

    FOR EACH estrutura NO-LOCK
        WHERE estrutura.it-codigo = p-it-codigo
          AND estrutura.data-inicio <= TODAY           
          AND estrutura.data-termino > TODAY:

        IF estrutura.local-montag <> "" THEN DO:            

            FOR EACH  int-local-montag NO-LOCK
                WHERE int-local-montag.it-codigo = estrutura.it-codigo
                  AND int-local-montag.sequencia = estrutura.sequencia
                  AND int-local-montag.es-codigo = estrutura.es-codigo:                    

                FOR FIRST tt-estrutura-mqa-new
                    WHERE tt-estrutura-mqa-new.cod-prod     = p-cod-prod
                    AND   tt-estrutura-mqa-new.local-montag = int-local-montag.local-montag
                    AND   tt-estrutura-mqa-new.cod-estabel  = p-cod-estabel:
                END.            
                IF NOT AVAIL tt-estrutura-mqa-new THEN DO:
                    
                    CREATE tt-estrutura-mqa-new.
                    ASSIGN tt-estrutura-mqa-new.cod-prod     = p-cod-prod
                           tt-estrutura-mqa-new.local-montag = int-local-montag.local-montag
                           tt-estrutura-mqa-new.cod-estabel  = p-cod-estabel
                           tt-estrutura-mqa-new.es-codigo    = estrutura.es-codigo.
                END.
            END.               
        END.
        
        ASSIGN l-descer-nivel = YES.
        
        FIND FIRST item-mqa NO-LOCK
             WHERE item-mqa.cod-estabel = p-cod-estabel
               AND item-mqa.cod-prod    = p-cod-prod NO-ERROR.
        IF AVAIL item-mqa THEN DO:

            IF item-mqa.log-copiar-apenas-nivel THEN
                ASSIGN l-descer-nivel = NO.
        END.

        IF l-descer-nivel THEN
            RUN criaEstrutura (INPUT p-cod-prod,
                               INPUT estrutura.es-codigo,
                               INPUT p-cod-estabel).

    END. //for each estrutura
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE criaIndiceQualidade:
    /*:T------------------------------------------------------------------------------
  Purpose:     Valida√ß√µes pertinentes ao DBO
  Parameters:  recebe o tipo de valida√ß√£o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-it-codigo   AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel AS CHAR NO-UNDO.

    IF NOT CAN-FIND(FIRST indice-qualid 
                    WHERE indice-qualid.cod-estabel = p-cod-estabel 
                      AND indice-qualid.it-codigo   = p-it-codigo) THEN DO:

        CREATE indice-qualid.
        ASSIGN indice-qualid.cod-estabel    = p-cod-estabel
               indice-qualid.it-codigo      = p-it-codigo
               indice-qualid.relat-atencao  = 0.5 
               indice-qualid.relat-problema = 1
               indice-qualid.absol-atencao  = 4
               indice-qualid.absol-problema = 10.
               
    END. //if not can-find
    
    RETURN "OK":U.

END PROCEDURE.
/**** Fim do programa ****/
