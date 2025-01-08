/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP089RP 2.00.00.000}

/* ***************************  Definitions  ************************** */

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini»’o das temp-tables tt-param, tt-digita e tt-raw-digita */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    FIELD tp-execucao      AS INTEGER
    FIELD c-arq-import     AS CHARACTER
    FIELD tipo             AS INT.


define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita         FOR tt-digita.
DEFINE BUFFER bint-portaria-item  FOR int-portaria-item.
DEFINE BUFFER bint-portaria-movto FOR int-portaria-movto.
DEFINE BUFFER bint-portaria-perc  FOR int-portaria-perc.

def temp-table tt-raw-digita
   field raw-digita      as raw.

DEF TEMP-TABLE tt-registro-item
    FIELD it-codigo    like int-portaria-item.it-codigo   
    FIELD cod-estabel  like int-portaria-item.cod-estabel 
    FIELD ncm-base     like int-portaria-item.ncm-base    
    FIELD produto-base like int-portaria-item.produto-base
    FIELD desc-mctic   like int-portaria-item.desc-mctic.

DEF TEMP-TABLE tt-registro-movto NO-UNDO
    FIELD classificacao LIKE int-portaria-movto.classificacao
    FIELD it-codigo     LIKE int-portaria-movto.it-codigo    
    FIELD cod-estabel   LIKE int-portaria-movto.cod-estabel  
    FIELD codigo        LIKE int-portaria-movto.codigo       
    FIELD dt-publicacao LIKE int-portaria-movto.dt-publicacao
    FIELD dt-portaria   LIKE int-portaria-movto.dt-portaria
    FIELD dt-ini        LIKE int-portaria-movto.dt-ini       
    FIELD dt-fim        LIKE int-portaria-movto.dt-fim       
    FIELD observacao    LIKE int-portaria-movto.observacao.

DEF TEMP-TABLE tt-registro-perc NO-UNDO
    FIELD it-codigo       LIKE int-portaria-perc.it-codigo      
    FIELD cod-estabel     LIKE int-portaria-perc.cod-estabel    
    FIELD dt-ini          LIKE int-portaria-perc.dt-ini         
    FIELD dt-fim          LIKE int-portaria-perc.dt-fim         
    FIELD aliq-ext-conv1  LIKE int-portaria-perc.aliq-ext-conv1 
    FIELD aliq-ext-conv2a LIKE int-portaria-perc.aliq-ext-conv2a
    FIELD aliq-ext-conv2b LIKE int-portaria-perc.aliq-ext-conv2b
    FIELD aliq-ext-fndct  LIKE int-portaria-perc.aliq-ext-fndct 
    FIELD aliq-int        LIKE int-portaria-perc.aliq-int       
    FIELD aliq-adic       LIKE int-portaria-perc.aliq-adic      
    FIELD aliq-cred-hab   LIKE int-portaria-perc.aliq-cred-hab  
    FIELD aliq-cred-bem   LIKE int-portaria-perc.aliq-cred-bem.

DEF TEMP-TABLE tt-arquivo
    FIELD c-linha           AS INT
    FIELD it-codigo         LIKE int-portaria-item.it-codigo   
    FIELD cod-estabel       LIKE int-portaria-item.cod-estabel 
    FIELD ncm-base          LIKE int-portaria-item.ncm-base    
    FIELD produto-base      LIKE int-portaria-item.produto-base
    FIELD desc-mctic        LIKE int-portaria-item.desc-mctic  
    FIELD codigo-ppb        LIKE int-portaria-movto.codigo       
    FIELD dt-publicacao-ppb LIKE int-portaria-movto.dt-publicacao
    FIELD dt-ini-ppb        LIKE int-portaria-movto.dt-ini       
    FIELD dt-fim-ppb        LIKE int-portaria-movto.dt-fim       
    FIELD observacao-ppb    LIKE int-portaria-movto.observacao  
    FIELD codigo-prov       LIKE int-portaria-movto.codigo       
    FIELD dt-ini-prov       LIKE int-portaria-movto.dt-ini       
    FIELD dt-fim-prov       LIKE int-portaria-movto.dt-fim       
    FIELD observacao-prov   LIKE int-portaria-movto.observacao
    FIELD codigo-def        LIKE int-portaria-movto.codigo    
    FIELD dt-ini-def        LIKE int-portaria-movto.dt-ini    
    FIELD dt-fim-def        LIKE int-portaria-movto.dt-fim    
    FIELD observacao-def    LIKE int-portaria-movto.observacao
    FIELD codigo-bem        LIKE int-portaria-movto.codigo   
    FIELD dt-portaria-def   LIKE int-portaria-movto.dt-portaria
    FIELD dt-ini-bem        LIKE int-portaria-movto.dt-ini    
    FIELD dt-fim-bem        LIKE int-portaria-movto.dt-fim    
    FIELD observacao-bem    LIKE int-portaria-movto.observacao
    FIELD dt-ini            LIKE int-portaria-perc.dt-ini         
    FIELD dt-fim            LIKE int-portaria-perc.dt-fim         
    FIELD aliq-ext-conv1    LIKE int-portaria-perc.aliq-ext-conv1 
    FIELD aliq-ext-conv2a   LIKE int-portaria-perc.aliq-ext-conv2a
    FIELD aliq-ext-conv2b   LIKE int-portaria-perc.aliq-ext-conv2b
    FIELD aliq-ext-fndct    LIKE int-portaria-perc.aliq-ext-fndct 
    FIELD aliq-int          LIKE int-portaria-perc.aliq-int       
    FIELD aliq-adic         LIKE int-portaria-perc.aliq-adic      
    FIELD aliq-cred-hab     LIKE int-portaria-perc.aliq-cred-hab  
    FIELD aliq-cred-bem     LIKE int-portaria-perc.aliq-cred-bem  
    .

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* Local Temp-Table Definitions ---                                     */

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-linha   AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE i-cont-movto-ppb  AS INT NO-UNDO.
DEFINE VARIABLE i-cont-movto-prov AS INT NO-UNDO.
DEFINE VARIABLE i-cont-movto-def  AS INT NO-UNDO.
DEFINE VARIABLE i-cont-movto-bem  AS INT NO-UNDO.
DEFINE VARIABLE i-cont-perc       AS INT NO-UNDO.

/* Stream Definitions ---                                               */

//DEFINE STREAM str-rp.

/* Form Definitions ---                                                 */

/* ************************  Function Prototypes ********************** */

FUNCTION fn-function RETURNS CHARACTER
  (  )  FORWARD.


/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST mgcad.empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE "":U
       c-titulo-relat = "":U
       c-sistema      = "":U.

ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.

FIND FIRST tt-param NO-ERROR.

IF NOT VALID-HANDLE(h-acomp)               OR
   h-acomp:TYPE      <> "PROCEDURE":U      OR
   h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U).

/* IMPORTAR */
IF tt-param.tipo = 1 THEN DO:
    RUN pi-le-arquivo.
    RUN pi-cria-registros.
END.
ELSE DO:
/* EXPORTAR */
    RUN pi-le-registros.
    RUN pi-exportar.
END.



IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

//{include/i-rpclo.i &STREAM="STREAM str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

RETURN "OK":U.

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-le-arquivo:

    /*ASSIGN i-cont  = 0
           i-linha = 0.*/

    RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivo...").

    INPUT FROM VALUE(tt-param.c-arq-import) CONVERT SOURCE "iso8859-1".
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        
        IF c-linha = "" THEN NEXT.
        IF c-linha BEGINS "Item" THEN NEXT.
        IF ENTRY(1, c-linha, ";") = "" THEN NEXT.

        FIND FIRST tt-registro-item
             WHERE tt-registro-item.it-codigo    = TRIM(ENTRY(1, c-linha, ";"))
               AND tt-registro-item.cod-estabel  = TRIM(ENTRY(2, c-linha, ";")) NO-ERROR.
        IF NOT AVAIL tt-registro-item THEN DO:
            CREATE tt-registro-item.
            ASSIGN tt-registro-item.it-codigo    = TRIM(ENTRY(1, c-linha, ";"))
                   tt-registro-item.cod-estabel  = TRIM(ENTRY(2, c-linha, ";"))
                   tt-registro-item.ncm-base     = TRIM(ENTRY(3, c-linha, ";"))
                   tt-registro-item.produto-base = TRIM(ENTRY(4, c-linha, ";"))
                   tt-registro-item.desc-mctic   = TRIM(ENTRY(5, c-linha, ";")).
        END.
        IF ENTRY(6, c-linha, ";") <> "" THEN DO:
            FIND FIRST tt-registro-movto
                 WHERE tt-registro-movto.it-codigo    = TRIM(ENTRY(1, c-linha, ";"))
                   AND tt-registro-movto.cod-estabel  = TRIM(ENTRY(2, c-linha, ";"))
                   AND tt-registro-movto.codigo       = TRIM(ENTRY(6, c-linha, ";"))
                   AND tt-registro-movto.classificacao = "PPB" NO-ERROR.
            IF NOT AVAIL tt-registro-movto THEN DO:
                CREATE tt-registro-movto.
                ASSIGN tt-registro-movto.classificacao = "PPB"
                       tt-registro-movto.it-codigo     = TRIM(ENTRY(1, c-linha, ";"))
                       tt-registro-movto.cod-estabel   = TRIM(ENTRY(2, c-linha, ";"))
                       tt-registro-movto.codigo        = TRIM(ENTRY(6, c-linha, ";"))
                       tt-registro-movto.dt-publicacao = DATE(TRIM(ENTRY(7, c-linha, ";")))
                       tt-registro-movto.dt-ini        = DATE(TRIM(ENTRY(8, c-linha, ";")))
                       tt-registro-movto.dt-fim        = DATE(TRIM(ENTRY(9, c-linha, ";")))
                       tt-registro-movto.observacao    = TRIM(ENTRY(10, c-linha, ";")).
            END.
        END.
        IF ENTRY(11, c-linha, ";") <> "" THEN DO:
            FIND FIRST tt-registro-movto
                 WHERE tt-registro-movto.it-codigo    = TRIM(ENTRY(1, c-linha, ";"))
                   AND tt-registro-movto.cod-estabel  = TRIM(ENTRY(2, c-linha, ";"))
                   AND tt-registro-movto.codigo       = TRIM(ENTRY(11, c-linha, ";"))
                   AND tt-registro-movto.classificacao = "PROV" NO-ERROR.
            IF NOT AVAIL tt-registro-movto THEN DO:
                CREATE tt-registro-movto.
                ASSIGN tt-registro-movto.classificacao = "PROV"
                       tt-registro-movto.it-codigo     = TRIM(ENTRY(1, c-linha, ";"))
                       tt-registro-movto.cod-estabel   = TRIM(ENTRY(2, c-linha, ";"))
                       tt-registro-movto.codigo        = TRIM(ENTRY(11, c-linha, ";"))
                       tt-registro-movto.dt-ini        = DATE(TRIM(ENTRY(12, c-linha, ";")))
                       tt-registro-movto.dt-fim        = DATE(TRIM(ENTRY(13, c-linha, ";")))
                       tt-registro-movto.observacao    = TRIM(ENTRY(14, c-linha, ";")).
            END.
        END.
        IF ENTRY(15, c-linha, ";") <> "" THEN DO:
            FIND FIRST tt-registro-movto
                 WHERE tt-registro-movto.it-codigo    = TRIM(ENTRY(1, c-linha, ";"))
                   AND tt-registro-movto.cod-estabel  = TRIM(ENTRY(2, c-linha, ";"))
                   AND tt-registro-movto.codigo       = TRIM(ENTRY(15, c-linha, ";"))
                   AND tt-registro-movto.classificacao = "DEF" NO-ERROR.
            IF NOT AVAIL tt-registro-movto THEN DO:
                CREATE tt-registro-movto.
                ASSIGN tt-registro-movto.classificacao = "DEF"
                       tt-registro-movto.it-codigo     = TRIM(ENTRY(1, c-linha, ";"))
                       tt-registro-movto.cod-estabel   = TRIM(ENTRY(2, c-linha, ";"))
                       tt-registro-movto.codigo        = TRIM(ENTRY(15, c-linha, ";"))
                       tt-registro-movto.dt-portaria   = DATE(TRIM(ENTRY(16, c-linha, ";")))
                       tt-registro-movto.dt-ini        = DATE(TRIM(ENTRY(17, c-linha, ";")))                           
                       tt-registro-movto.dt-fim        = DATE(TRIM(ENTRY(18, c-linha, ";")))                           
                       tt-registro-movto.observacao    = TRIM(ENTRY(19, c-linha, ";")).
            END.
        END.
        IF ENTRY(20, c-linha, ";") <> "" THEN DO:
            FIND FIRST tt-registro-movto
                 WHERE tt-registro-movto.it-codigo    = TRIM(ENTRY(1, c-linha, ";"))
                   AND tt-registro-movto.cod-estabel  = TRIM(ENTRY(2, c-linha, ";"))
                   AND tt-registro-movto.codigo       = TRIM(ENTRY(20, c-linha, ";"))
                   AND tt-registro-movto.classificacao = "BEM" NO-ERROR.
            IF NOT AVAIL tt-registro-movto THEN DO:
                CREATE tt-registro-movto.
                ASSIGN tt-registro-movto.classificacao = "BEM"
                       tt-registro-movto.it-codigo     = TRIM(ENTRY(1, c-linha, ";"))
                       tt-registro-movto.cod-estabel   = TRIM(ENTRY(2, c-linha, ";"))
                       tt-registro-movto.codigo        = TRIM(ENTRY(20, c-linha, ";"))
                       tt-registro-movto.dt-ini        = DATE(TRIM(ENTRY(21, c-linha, ";")))                           
                       tt-registro-movto.dt-fim        = DATE(TRIM(ENTRY(22, c-linha, ";")))                           
                       tt-registro-movto.observacao    = TRIM(ENTRY(23, c-linha, ";")).
            END.
        END.

        IF ENTRY(24, c-linha, ";") <> "" THEN DO:

            FIND FIRST tt-registro-perc
                 WHERE tt-registro-perc.it-codigo   = TRIM(ENTRY(1, c-linha, ";"))
                   AND tt-registro-perc.cod-estabel = TRIM(ENTRY(2, c-linha, ";"))
                   AND tt-registro-perc.dt-ini      = DATE(TRIM(ENTRY(24,c-linha, ";")))
                   AND tt-registro-perc.dt-fim      = DATE(TRIM(ENTRY(25,c-linha, ";"))) NO-ERROR.
            IF NOT AVAIL tt-registro-perc THEN DO:

                CREATE tt-registro-perc.
                ASSIGN tt-registro-perc.it-codigo       = TRIM(ENTRY(1,  c-linha, ";"))
                       tt-registro-perc.cod-estabel     = TRIM(ENTRY(2,  c-linha, ";"))
                       tt-registro-perc.dt-ini          = DATE(TRIM(ENTRY(24,c-linha, ";")))
                       tt-registro-perc.dt-fim          = DATE(TRIM(ENTRY(25,c-linha, ";")))
                       tt-registro-perc.aliq-ext-conv1  = DEC(TRIM(ENTRY(26, c-linha, ";")))
                       tt-registro-perc.aliq-ext-conv2a = DEC(TRIM(ENTRY(27, c-linha, ";")))
                       tt-registro-perc.aliq-ext-conv2b = DEC(TRIM(ENTRY(28, c-linha, ";")))
                       tt-registro-perc.aliq-ext-fndct  = DEC(TRIM(ENTRY(29, c-linha, ";")))
                       tt-registro-perc.aliq-int        = DEC(TRIM(ENTRY(30, c-linha, ";")))
                       tt-registro-perc.aliq-adic       = DEC(TRIM(ENTRY(31, c-linha, ";")))
                       tt-registro-perc.aliq-cred-hab   = DEC(TRIM(ENTRY(32, c-linha, ";")))
                       tt-registro-perc.aliq-cred-bem   = DEC(TRIM(ENTRY(33, c-linha, ";"))).
            END.
        END.
    END.
    
    INPUT CLOSE.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cria-registros:

    FOR EACH tt-registro-item:

        IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-registro-item.it-codigo) THEN NEXT.
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = tt-registro-item.cod-estabel) THEN NEXT.

        FIND FIRST int-portaria-item EXCLUSIVE-LOCK
             WHERE int-portaria-item.it-codigo   = tt-registro-item.it-codigo  
               AND int-portaria-item.cod-estabel = tt-registro-item.cod-estabel NO-ERROR.
        IF NOT AVAIL int-portaria-item OR int-portaria-item.it-codigo = "" THEN DO:
            CREATE int-portaria-item.

            FIND LAST bint-portaria-item NO-LOCK
                WHERE bint-portaria-item.it-codigo   = tt-registro-item.it-codigo  
                  AND bint-portaria-item.cod-estabel = tt-registro-item.cod-estabel NO-ERROR.
            IF AVAIL bint-portaria-item THEN
                ASSIGN int-portaria-item.seq = bint-portaria-item.seq + 1.
            ELSE 
                ASSIGN int-portaria-item.seq = 1.
        END.

        ASSIGN int-portaria-item.it-codigo    = tt-registro-item.it-codigo   
               int-portaria-item.cod-estabel  = tt-registro-item.cod-estabel 
               int-portaria-item.ncm-base     = tt-registro-item.ncm-base    
               int-portaria-item.produto-base = tt-registro-item.produto-base
               int-portaria-item.desc-mctic   = tt-registro-item.desc-mctic.

    END.

    FOR EACH tt-registro-movto:

        IF tt-registro-movto.it-codigo = "" THEN NEXT.
        IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-registro-movto.it-codigo) THEN NEXT.
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = tt-registro-movto.cod-estabel) THEN NEXT.
        IF NOT CAN-FIND(FIRST int-portaria-item NO-LOCK
                        WHERE int-portaria-item.it-codigo   = tt-registro-movto.it-codigo  
                          AND int-portaria-item.cod-estabel = tt-registro-movto.cod-estabel
                          AND int-portaria-item.seq         = 1) THEN NEXT.

        FIND FIRST int-portaria-movto EXCLUSIVE-LOCK
             WHERE int-portaria-movto.it-codigo   = tt-registro-movto.it-codigo
               AND int-portaria-movto.cod-estabel = tt-registro-movto.cod-estabel
               AND int-portaria-movto.seq         = 1
               AND int-portaria-movto.codigo      = tt-registro-movto.codigo NO-ERROR.
        IF NOT AVAIL int-portaria-movto THEN
            CREATE int-portaria-movto.

        FIND LAST bint-portaria-movto NO-LOCK
            WHERE bint-portaria-movto.it-codigo   = tt-registro-movto.it-codigo  
              AND bint-portaria-movto.cod-estabel = tt-registro-movto.cod-estabel
              AND bint-portaria-movto.seq         = 1 NO-ERROR.
        IF AVAIL bint-portaria-movto THEN
            ASSIGN int-portaria-movto.seq-movto = bint-portaria-movto.seq-movto + 1.
        ELSE 
            ASSIGN int-portaria-movto.seq-movto = 1.

        ASSIGN int-portaria-movto.it-codigo     = tt-registro-movto.it-codigo    
               int-portaria-movto.cod-estabel   = tt-registro-movto.cod-estabel  
               int-portaria-movto.seq           = 1
               int-portaria-movto.classificacao = tt-registro-movto.classificacao
               int-portaria-movto.codigo        = tt-registro-movto.codigo       
               int-portaria-movto.dt-publicacao = tt-registro-movto.dt-publicacao
               int-portaria-movto.dt-portaria   = tt-registro-movto.dt-portaria
               int-portaria-movto.dt-ini        = tt-registro-movto.dt-ini       
               int-portaria-movto.dt-fim        = tt-registro-movto.dt-fim       
               int-portaria-movto.observacao    = tt-registro-movto.observacao.

    END.

    FOR EACH tt-registro-perc:

        IF tt-registro-perc.it-codigo = "" THEN NEXT.
        IF NOT CAN-FIND(FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = tt-registro-perc.it-codigo) THEN NEXT.
        IF NOT CAN-FIND(FIRST estabelec NO-LOCK
                        WHERE estabelec.cod-estabel = tt-registro-perc.cod-estabel) THEN NEXT.
        IF NOT CAN-FIND(FIRST int-portaria-item NO-LOCK
                        WHERE int-portaria-item.it-codigo   = tt-registro-perc.it-codigo  
                          AND int-portaria-item.cod-estabel = tt-registro-perc.cod-estabel
                          AND int-portaria-item.seq         = 1) THEN NEXT.
        IF NOT CAN-FIND(FIRST int-portaria-movto NO-LOCK
                        WHERE int-portaria-movto.it-codigo   = tt-registro-perc.it-codigo  
                          AND int-portaria-movto.cod-estabel = tt-registro-perc.cod-estabel
                          AND (int-portaria-movto.classificacao = "PROV"
                           OR  int-portaria-movto.classificacao = "DEF")
                          AND int-portaria-movto.dt-ini <= tt-registro-perc.dt-ini) THEN NEXT.

        FIND FIRST int-portaria-perc EXCLUSIVE-LOCK
             WHERE int-portaria-perc.it-codigo   = tt-registro-perc.it-codigo
               AND int-portaria-perc.cod-estabel = tt-registro-perc.cod-estabel
               AND int-portaria-perc.seq         = 1
               AND int-portaria-perc.dt-ini      = tt-registro-perc.dt-ini NO-ERROR.
        IF NOT AVAIL int-portaria-perc THEN
            CREATE int-portaria-perc.

        FIND LAST bint-portaria-perc NO-LOCK
            WHERE bint-portaria-perc.it-codigo   = tt-registro-perc.it-codigo  
              AND bint-portaria-perc.cod-estabel = tt-registro-perc.cod-estabel
              AND bint-portaria-perc.seq         = 1 NO-ERROR.
        IF AVAIL bint-portaria-perc THEN
            ASSIGN int-portaria-perc.seq-perc = bint-portaria-perc.seq-perc + 1.
        ELSE 
            ASSIGN int-portaria-perc.seq-perc = 1.

        ASSIGN int-portaria-perc.it-codigo       = tt-registro-perc.it-codigo      
               int-portaria-perc.cod-estabel     = tt-registro-perc.cod-estabel    
               int-portaria-perc.seq             = 1
               int-portaria-perc.dt-ini          = tt-registro-perc.dt-ini         
               int-portaria-perc.dt-fim          = tt-registro-perc.dt-fim         
               int-portaria-perc.aliq-ext-conv1  = tt-registro-perc.aliq-ext-conv1 
               int-portaria-perc.aliq-ext-conv2a = tt-registro-perc.aliq-ext-conv2a
               int-portaria-perc.aliq-ext-conv2b = tt-registro-perc.aliq-ext-conv2b
               int-portaria-perc.aliq-ext-fndct  = tt-registro-perc.aliq-ext-fndct 
               int-portaria-perc.aliq-int        = tt-registro-perc.aliq-int       
               int-portaria-perc.aliq-adic       = tt-registro-perc.aliq-adic      
               int-portaria-perc.aliq-cred-hab   = tt-registro-perc.aliq-cred-hab  
               int-portaria-perc.aliq-cred-bem   = tt-registro-perc.aliq-cred-bem.
        
    END.

END PROCEDURE.

PROCEDURE pi-le-registros:

    RUN pi-acompanhar IN h-acomp (INPUT "Importando arquivo...").

    FOR EACH int-portaria-item NO-LOCK:
        CREATE tt-registro-item.
        ASSIGN tt-registro-item.it-codigo    = int-portaria-item.it-codigo   
               tt-registro-item.cod-estabel  = int-portaria-item.cod-estabel 
               tt-registro-item.ncm-base     = int-portaria-item.ncm-base    
               tt-registro-item.produto-base = int-portaria-item.produto-base
               tt-registro-item.desc-mctic   = int-portaria-item.desc-mctic.  
    END.
    FOR EACH int-portaria-movto NO-LOCK:
        CREATE tt-registro-movto.
        ASSIGN tt-registro-movto.classificacao = int-portaria-movto.classificacao
               tt-registro-movto.it-codigo     = int-portaria-movto.it-codigo    
               tt-registro-movto.cod-estabel   = int-portaria-movto.cod-estabel  
               tt-registro-movto.codigo        = int-portaria-movto.codigo       
               tt-registro-movto.dt-publicacao = int-portaria-movto.dt-publicacao
               tt-registro-movto.dt-portaria   = int-portaria-movto.dt-portaria
               tt-registro-movto.dt-ini        = int-portaria-movto.dt-ini       
               tt-registro-movto.dt-fim        = int-portaria-movto.dt-fim       
               tt-registro-movto.observacao    = int-portaria-movto.observacao.
    END.
    FOR EACH int-portaria-perc NO-LOCK:
        CREATE tt-registro-perc.
        ASSIGN tt-registro-perc.it-codigo       = int-portaria-perc.it-codigo      
               tt-registro-perc.cod-estabel     = int-portaria-perc.cod-estabel    
               tt-registro-perc.dt-ini          = int-portaria-perc.dt-ini         
               tt-registro-perc.dt-fim          = int-portaria-perc.dt-fim         
               tt-registro-perc.aliq-ext-conv1  = int-portaria-perc.aliq-ext-conv1 
               tt-registro-perc.aliq-ext-conv2a = int-portaria-perc.aliq-ext-conv2a
               tt-registro-perc.aliq-ext-conv2b = int-portaria-perc.aliq-ext-conv2b
               tt-registro-perc.aliq-ext-fndct  = int-portaria-perc.aliq-ext-fndct 
               tt-registro-perc.aliq-int        = int-portaria-perc.aliq-int       
               tt-registro-perc.aliq-adic       = int-portaria-perc.aliq-adic      
               tt-registro-perc.aliq-cred-hab   = int-portaria-perc.aliq-cred-hab  
               tt-registro-perc.aliq-cred-bem   = int-portaria-perc.aliq-cred-bem.  
    END.

    FOR EACH tt-registro-item NO-LOCK:

        CREATE tt-arquivo.
        ASSIGN tt-arquivo.c-linha       = 1
               tt-arquivo.it-codigo     = tt-registro-item.it-codigo        
               tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel      
               tt-arquivo.ncm-base      = tt-registro-item.ncm-base         
               tt-arquivo.produto-base  = tt-registro-item.produto-base     
               tt-arquivo.desc-mctic    = tt-registro-item.desc-mctic.      

        ASSIGN i-cont-movto-ppb  = 0
               i-cont-movto-prov = 0
               i-cont-movto-def  = 0
               i-cont-movto-bem  = 0
               i-cont-perc       = 0.

        FOR EACH tt-registro-movto
           WHERE tt-registro-movto.it-codigo   = tt-registro-item.it-codigo  
             AND tt-registro-movto.cod-estabel = tt-registro-item.cod-estabel
             AND tt-registro-movto.classificacao = "PPB":

            ASSIGN i-cont-movto-ppb = i-cont-movto-ppb + 1.

            FIND FIRST tt-arquivo
                 WHERE tt-arquivo.c-linha       = i-cont-movto-ppb                
                   AND tt-arquivo.it-codigo     = tt-registro-item.it-codigo  
                   AND tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel NO-ERROR.
            IF NOT AVAIL tt-arquivo THEN
                CREATE tt-arquivo.

            ASSIGN tt-arquivo.c-linha           = i-cont-movto-ppb
                   tt-arquivo.it-codigo         = tt-registro-item.it-codigo        
                   tt-arquivo.cod-estabel       = tt-registro-item.cod-estabel      
                   tt-arquivo.ncm-base          = tt-registro-item.ncm-base         
                   tt-arquivo.produto-base      = tt-registro-item.produto-base     
                   tt-arquivo.desc-mctic        = tt-registro-item.desc-mctic      
                   tt-arquivo.codigo-ppb        = tt-registro-movto.codigo       
                   tt-arquivo.dt-publicacao-ppb = tt-registro-movto.dt-publicacao
                   tt-arquivo.dt-ini-ppb        = tt-registro-movto.dt-ini       
                   tt-arquivo.dt-fim-ppb        = tt-registro-movto.dt-fim       
                   tt-arquivo.observacao-ppb    = tt-registro-movto.observacao.
        END.

        FOR EACH tt-registro-movto
           WHERE tt-registro-movto.it-codigo   = tt-registro-item.it-codigo  
             AND tt-registro-movto.cod-estabel = tt-registro-item.cod-estabel
             AND tt-registro-movto.classificacao = "PROV":

            ASSIGN i-cont-movto-prov = i-cont-movto-prov + 1.

            FIND FIRST tt-arquivo
                 WHERE tt-arquivo.c-linha       = i-cont-movto-prov                
                   AND tt-arquivo.it-codigo     = tt-registro-item.it-codigo  
                   AND tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel NO-ERROR.
            IF NOT AVAIL tt-arquivo THEN
                CREATE tt-arquivo.

            ASSIGN tt-arquivo.c-linha       = i-cont-movto-prov
                   tt-arquivo.it-codigo     = tt-registro-item.it-codigo        
                   tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel      
                   tt-arquivo.ncm-base      = tt-registro-item.ncm-base         
                   tt-arquivo.produto-base  = tt-registro-item.produto-base     
                   tt-arquivo.desc-mctic    = tt-registro-item.desc-mctic      
                   tt-arquivo.codigo-prov     = tt-registro-movto.codigo       
                   tt-arquivo.dt-ini-prov     = tt-registro-movto.dt-ini       
                   tt-arquivo.dt-fim-prov     = tt-registro-movto.dt-fim       
                   tt-arquivo.observacao-prov = tt-registro-movto.observacao.
        END.

        FOR EACH tt-registro-movto
           WHERE tt-registro-movto.it-codigo   = tt-registro-item.it-codigo  
             AND tt-registro-movto.cod-estabel = tt-registro-item.cod-estabel
             AND tt-registro-movto.classificacao = "DEF":

            ASSIGN i-cont-movto-def = i-cont-movto-def + 1.

            FIND FIRST tt-arquivo
                 WHERE tt-arquivo.c-linha       = i-cont-movto-def                
                   AND tt-arquivo.it-codigo     = tt-registro-item.it-codigo  
                   AND tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel NO-ERROR.
            IF NOT AVAIL tt-arquivo THEN
                CREATE tt-arquivo.

            ASSIGN tt-arquivo.c-linha         = i-cont-movto-def
                   tt-arquivo.it-codigo       = tt-registro-item.it-codigo        
                   tt-arquivo.cod-estabel     = tt-registro-item.cod-estabel      
                   tt-arquivo.ncm-base        = tt-registro-item.ncm-base         
                   tt-arquivo.produto-base    = tt-registro-item.produto-base     
                   tt-arquivo.desc-mctic      = tt-registro-item.desc-mctic      
                   tt-arquivo.codigo-def      = tt-registro-movto.codigo
                   tt-arquivo.dt-portaria-def = tt-registro-movto.dt-portaria
                   tt-arquivo.dt-ini-def      = tt-registro-movto.dt-ini       
                   tt-arquivo.dt-fim-def      = tt-registro-movto.dt-fim       
                   tt-arquivo.observacao-def  = tt-registro-movto.observacao.
        END.

        FOR EACH tt-registro-movto
           WHERE tt-registro-movto.it-codigo   = tt-registro-item.it-codigo  
             AND tt-registro-movto.cod-estabel = tt-registro-item.cod-estabel
             AND tt-registro-movto.classificacao = "BEM":

            ASSIGN i-cont-movto-bem = i-cont-movto-bem + 1.

            FIND FIRST tt-arquivo
                 WHERE tt-arquivo.c-linha       = i-cont-movto-bem                
                   AND tt-arquivo.it-codigo     = tt-registro-item.it-codigo  
                   AND tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel NO-ERROR.
            IF NOT AVAIL tt-arquivo THEN
                CREATE tt-arquivo.

            ASSIGN tt-arquivo.c-linha       = i-cont-movto-bem
                   tt-arquivo.it-codigo     = tt-registro-item.it-codigo        
                   tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel      
                   tt-arquivo.ncm-base      = tt-registro-item.ncm-base         
                   tt-arquivo.produto-base  = tt-registro-item.produto-base     
                   tt-arquivo.desc-mctic    = tt-registro-item.desc-mctic      
                   tt-arquivo.codigo-bem     = tt-registro-movto.codigo       
                   tt-arquivo.dt-ini-bem     = tt-registro-movto.dt-ini       
                   tt-arquivo.dt-fim-bem     = tt-registro-movto.dt-fim       
                   tt-arquivo.observacao-bem = tt-registro-movto.observacao.
        END.

        FOR EACH tt-registro-perc
           WHERE tt-registro-perc.it-codigo   = tt-registro-item.it-codigo  
             AND tt-registro-perc.cod-estabel = tt-registro-item.cod-estabel:

            ASSIGN i-cont-perc = i-cont-perc + 1.

            FIND FIRST tt-arquivo
                 WHERE tt-arquivo.c-linha       = i-cont-perc                
                   AND tt-arquivo.it-codigo     = tt-registro-item.it-codigo  
                   AND tt-arquivo.cod-estabel   = tt-registro-item.cod-estabel NO-ERROR.
            IF NOT AVAIL tt-arquivo THEN
                CREATE tt-arquivo.
            
            ASSIGN tt-arquivo.c-linha         = i-cont-perc
                   tt-arquivo.it-codigo       = tt-registro-item.it-codigo        
                   tt-arquivo.cod-estabel     = tt-registro-item.cod-estabel      
                   tt-arquivo.ncm-base        = tt-registro-item.ncm-base         
                   tt-arquivo.produto-base    = tt-registro-item.produto-base     
                   tt-arquivo.desc-mctic      = tt-registro-item.desc-mctic  
                   tt-arquivo.it-codigo       = tt-registro-perc.it-codigo      
                   tt-arquivo.cod-estabel     = tt-registro-perc.cod-estabel    
                   tt-arquivo.dt-ini          = tt-registro-perc.dt-ini         
                   tt-arquivo.dt-fim          = tt-registro-perc.dt-fim         
                   tt-arquivo.aliq-ext-conv1  = tt-registro-perc.aliq-ext-conv1 
                   tt-arquivo.aliq-ext-conv2a = tt-registro-perc.aliq-ext-conv2a
                   tt-arquivo.aliq-ext-conv2b = tt-registro-perc.aliq-ext-conv2b
                   tt-arquivo.aliq-ext-fndct  = tt-registro-perc.aliq-ext-fndct 
                   tt-arquivo.aliq-int        = tt-registro-perc.aliq-int       
                   tt-arquivo.aliq-adic       = tt-registro-perc.aliq-adic      
                   tt-arquivo.aliq-cred-hab   = tt-registro-perc.aliq-cred-hab  
                   tt-arquivo.aliq-cred-bem   = tt-registro-perc.aliq-cred-bem.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-exportar:

    OUTPUT TO VALUE(tt-param.c-arq-import) CONVERT TARGET "iso8859-1".
    PUT UNFORMATTED "Item;Estabel;NCM Base;Produto Base;Descri‡Æo MCTIC;Portaria PPB;Dt Publi PPB;Valid Ini PPB;Valid Fim PPB;Observ PPB;Portaria Prov;Valid Ini Prov;Valid Fim Prov;Observ Prov;Portaria Def;Dt Portaria Def;Valid Ini Def;Valid Fim Def;Observ Def;Portaria Bem;Valid Ini Bem;Valid Fim Bem;Observ Bem;Valid Ini Perc;Valid Fim Perc;Conv 1;Conv 2a;Conv 2b;FNDCT;Interno;Adiciona;Cred Prod Hab;Cred Bem Desenv" SKIP.

    FOR EACH tt-arquivo
       BREAK BY tt-arquivo.it-codigo
             BY tt-arquivo.cod-estabel
             BY tt-arquivo.c-linha:

       

        PUT UNFORMATTED
            tt-arquivo.it-codigo         ";"
            tt-arquivo.cod-estabel       ";"
            tt-arquivo.ncm-base          ";"
            tt-arquivo.produto-base      ";"
            trim(REPLACE(REPLACE(tt-arquivo.desc-mctic,CHR(13),""),CHR(10),"")) ";"
            tt-arquivo.codigo-ppb        ";"
            tt-arquivo.dt-publicacao-ppb ";"
            tt-arquivo.dt-ini-ppb        ";"
            tt-arquivo.dt-fim-ppb        ";"
            trim(REPLACE(REPLACE(tt-arquivo.observacao-ppb,CHR(13),""),CHR(10),"")) ";"
            tt-arquivo.codigo-prov       ";"
            tt-arquivo.dt-ini-prov       ";"
            tt-arquivo.dt-fim-prov       ";"
            trim(REPLACE(REPLACE(tt-arquivo.observacao-prov,CHR(13),""),CHR(10),"")) ";"
            tt-arquivo.codigo-def        ";"
            tt-arquivo.dt-portaria       ";"
            tt-arquivo.dt-ini-def        ";"
            tt-arquivo.dt-fim-def        ";"
            trim(REPLACE(REPLACE(tt-arquivo.observacao-def,CHR(13),""),CHR(10),"")) ";"
            tt-arquivo.codigo-bem        ";"
            tt-arquivo.dt-ini-bem        ";"
            tt-arquivo.dt-fim-bem        ";"
            trim(REPLACE(REPLACE(tt-arquivo.observacao-bem,CHR(13),""),CHR(10),"")) ";"
            tt-arquivo.dt-ini            ";"
            tt-arquivo.dt-fim            ";"
            tt-arquivo.aliq-ext-conv1    ";"
            tt-arquivo.aliq-ext-conv2a   ";"
            tt-arquivo.aliq-ext-conv2b   ";"
            tt-arquivo.aliq-ext-fndct    ";"
            tt-arquivo.aliq-int          ";"
            tt-arquivo.aliq-adic         ";"
            tt-arquivo.aliq-cred-hab     ";"
            tt-arquivo.aliq-cred-bem     ";"
            SKIP.                          


       /* PUT UNFORMATTED
            tt-arquivo.it-codigo         ";"
            tt-arquivo.cod-estabel       ";"
            tt-arquivo.ncm-base          ";"
            tt-arquivo.produto-base      ";"
            trim(REPLACE(REPLACE(tt-arquivo.desc-mctic,CHR(13),""),CHR(10),"")) ";".

        IF tt-arquivo.codigo-ppb <> "" THEN
            PUT UNFORMATTED
                tt-arquivo.codigo-ppb        ";"
                tt-arquivo.dt-publicacao-ppb ";"
                tt-arquivo.dt-ini-ppb        ";"
                tt-arquivo.dt-fim-ppb        ";"
                trim(REPLACE(REPLACE(tt-arquivo.observacao-ppb,CHR(13),""),CHR(10),"")) ";".
        ELSE
            PUT UNFORMATTED
                ";;;;;".

        IF tt-arquivo.codigo-prov <> "" THEN
            PUT UNFORMATTED
                tt-arquivo.codigo-prov       ";"
                tt-arquivo.dt-ini-prov       ";"
                tt-arquivo.dt-fim-prov       ";"
                trim(REPLACE(REPLACE(tt-arquivo.observacao-prov,CHR(13),""),CHR(10),"")) ";".
        ELSE
            PUT UNFORMATTED
                ";;;;".

        IF tt-arquivo.codigo-def <> "" THEN
            PUT UNFORMATTED
                tt-arquivo.codigo-def        ";"
                tt-arquivo.dt-portaria       ";"
                tt-arquivo.dt-ini-def        ";"
                tt-arquivo.dt-fim-def        ";"
                trim(REPLACE(REPLACE(tt-arquivo.observacao-def,CHR(13),""),CHR(10),"")) ";".
        ELSE
            PUT UNFORMATTED
                ";;;;;".

        IF tt-arquivo.codigo-bem <> "" THEN
            PUT UNFORMATTED
                tt-arquivo.codigo-bem        ";"
                tt-arquivo.dt-ini-bem        ";"
                tt-arquivo.dt-fim-bem        ";"
                trim(REPLACE(REPLACE(tt-arquivo.observacao-bem,CHR(13),""),CHR(10),"")) ";".
        ELSE
            PUT UNFORMATTED
                ";;;;".

        IF tt-arquivo.dt-ini <> ? THEN
            PUT UNFORMATTED
                tt-arquivo.dt-ini            ";"
                tt-arquivo.dt-fim            ";"
                tt-arquivo.aliq-ext-conv1    ";"
                tt-arquivo.aliq-ext-conv2a   ";"
                tt-arquivo.aliq-ext-conv2b   ";"
                tt-arquivo.aliq-ext-fndct    ";"
                tt-arquivo.aliq-int          ";"
                tt-arquivo.aliq-adic         ";"
                tt-arquivo.aliq-cred-hab     ";"
                tt-arquivo.aliq-cred-bem     ";"
                SKIP.
        ELSE
            PUT UNFORMATTED
                ";;;;;;;;;;".*/ 
            
    END.

    OUTPUT CLOSE.

END PROCEDURE.
