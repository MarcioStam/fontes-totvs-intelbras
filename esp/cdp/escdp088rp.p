/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCDP088RP 2.00.00.000}
/*------------------------------------------------------------------------
    File        : XX9999RP.P
    Purpose     : <none>
    Syntax      : <none>
    Description : <none>

    Author(s)   : <none>
    Created     : <none>
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF BUFFER bint-portaria-movto FOR int-portaria-movto.

/* Preprocessor Definitions ---                                         */

&GLOBAL-DEFINE PRINT-PARAM  YES

/* Include Definitions ---                                              */

/* Defini»’o das temp-tables tt-param, tt-digita e tt-raw-digita */
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field item-ini           as char
    field item-fim           as char
    field familia-ini        as char
    field familia-fim        as char
    field familia-com-ini    as char
    field familia-com-fim    as char
    field portaria-ppb-ini   as char
    field portaria-ppb-fim   as char
    field portaria-atual-ini as char
    field portaria-atual-fim as char
    field ncm-ini            as char
    field ncm-fim            as char
    field estab-ini          as char
    field estab-fim          as char
    field data-ini           as DATE
    field data-fim           as DATE
    FIELD classif            AS INT
    FIELD ppb                AS LOG
    FIELD hab-prov           as log
    FIELD hab-def            as log
    FIELD bem                as log
    /*Alterado 15/02/2005 - tech1007 - Criado campo l½gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-int-portaria-movto
    field it-codigo        like item.it-codigo       
    field cod-estabel      like item.cod-estabel     
    field desc-item        like item.desc-item       
    field desc-mctic       like int-portaria-item.desc-mctic      
    field fm-codigo        like item.fm-codigo       
    field fm-cod-com       like item.fm-cod-com      
    field class-fiscal     like item.class-fiscal    
    field codigo-orig      like item.codigo-orig     
    field ind-item-fat     AS CHAR
    field aliquota-ipi     like item.aliquota-ipi    
    field cod-unid-negoc   like item.cod-unid-negoc      
    field classif-atual    LIKE int-portaria-movto.classificacao
    field ncm-base         like int-portaria-item.ncm-base
    field produto-base     like int-portaria-item.produto-base
    field portaria-atual   AS CHAR
    field dt-ini-atual     AS CHAR
    field dt-fim-atual     AS CHAR
    field portaria-ppb     AS CHAR
    field dt-ini-ppb       AS CHAR
    field dt-fim-ppb       AS CHAR
    field portaria-prov    AS CHAR
    field dt-ini-prov      AS CHAR
    field dt-fim-prov      AS CHAR
    field portaria-def     AS CHAR
    field dt-portaria      AS CHAR
    field dt-ini-def       AS CHAR
    field dt-fim-def       AS CHAR
    field portaria-bem     AS CHAR
    field dt-ini-bem       AS CHAR
    field dt-fim-bem       AS CHAR
    field portaria-hab-prov AS CHAR
    field portaria-hab-def AS CHAR
    field aliq-ext-conv1   like int-portaria-perc.aliq-ext-conv1   
    field aliq-ext-conv2a  like int-portaria-perc.aliq-ext-conv2a  
    field aliq-ext-conv2b  like int-portaria-perc.aliq-ext-conv2b  
    field aliq-ext-fndct   like int-portaria-perc.aliq-ext-fndct   
    field aliq-int         like int-portaria-perc.aliq-int         
    field aliq-adic        like int-portaria-perc.aliq-adic        
    field aliq-cred-hab    like int-portaria-perc.aliq-cred-hab    
    field aliq-cred-bem    like int-portaria-perc.aliq-cred-bem
    FIELD seq              LIKE int-portaria-movto.seq.

{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* Local Temp-Table Definitions ---                                     */

DEFINE VARIABLE h-acomp   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO.
DEFINE STREAM str-excel.

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

DO ON ERROR UNDO, RETURN ERROR
   ON STOP  UNDO, RETURN ERROR:
    //{include/i-rpcab.i &STREAM="str-rp"}
    //{include/i-rpout.i &STREAM="STREAM str-rp"}

    //VIEW STREAM str-rp FRAME f-cabec.
    //VIEW STREAM str-rp FRAME f-rodape.

    IF NOT VALID-HANDLE(h-acomp)               OR
       h-acomp:TYPE      <> "PROCEDURE":U      OR
       h-acomp:FILE-NAME <> "utp/ut-acomp.p":U THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-inicializar IN h-acomp (INPUT "":U).

    RUN pi-lista IN THIS-PROCEDURE.
    RUN pi-imprime IN THIS-PROCEDURE.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.

    //{include/i-rpclo.i &STREAM="STREAM str-rp"}

    IF VALID-HANDLE(h-acomp) THEN
        DELETE PROCEDURE h-acomp.

    ASSIGN h-acomp = ?.
END.

RETURN "OK":U.


/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-lista:
     IF tt-param.classif = 1 THEN DO:
         FOR EACH int-portaria-item NO-LOCK                                                    
            WHERE int-portaria-item.it-codigo   >= tt-param.item-ini                           
              AND int-portaria-item.it-codigo   <= tt-param.item-fim                           
              AND int-portaria-item.cod-estabel >= tt-param.estab-ini                          
              AND int-portaria-item.cod-estabel <= tt-param.estab-fim,                         
            FIRST item NO-LOCK                                                                 
            WHERE item.it-codigo     = int-portaria-item.it-codigo                             
              AND item.fm-codigo    >= tt-param.familia-ini                                    
              AND item.fm-codigo    <= tt-param.familia-fim                                    
              AND item.fm-cod-com   >= tt-param.familia-com-ini                                
              AND item.fm-cod-com   <= tt-param.familia-com-fim                                
              AND item.class-fiscal >= tt-param.ncm-ini                                        
              AND item.class-fiscal <= tt-param.ncm-fim,
             EACH int-portaria-movto NO-LOCK                                                   
            WHERE int-portaria-movto.it-codigo   = int-portaria-item.it-codigo                 
              AND int-portaria-movto.cod-estabel = int-portaria-item.cod-estabel               
              AND int-portaria-movto.seq         = int-portaria-item.seq                       
              AND int-portaria-movto.codigo     >= tt-param.portaria-ppb-ini                   
              AND int-portaria-movto.codigo     <= tt-param.portaria-ppb-fim                   
              AND int-portaria-movto.codigo     >= tt-param.portaria-atual-ini                 
              AND int-portaria-movto.codigo     <= tt-param.portaria-atual-fim                 
              AND int-portaria-movto.dt-ini     >= tt-param.data-ini                           
              AND int-portaria-movto.dt-ini     <= tt-param.data-fim:

             IF tt-param.ppb      = NO AND int-portaria-movto.classificacao = "PPB"  THEN NEXT.
             IF tt-param.hab-prov = NO AND int-portaria-movto.classificacao = "PROV" THEN NEXT.
             IF tt-param.hab-def  = NO AND int-portaria-movto.classificacao = "DEF"  THEN NEXT.
             IF tt-param.bem      = NO AND int-portaria-movto.classificacao = "BEM"  THEN NEXT.
             
             IF int-portaria-movto.dt-fim = ? THEN DO:

                CREATE tt-int-portaria-movto.                                                                                                              
                ASSIGN tt-int-portaria-movto.it-codigo         = int-portaria-movto.it-codigo                                                              
                       tt-int-portaria-movto.cod-estabel       = int-portaria-movto.cod-estabel                                                            
                       tt-int-portaria-movto.desc-item         = IF item.it-codigo <> "" THEN ITEM.desc-item ELSE "Produto Base Beneficiado"               
                       tt-int-portaria-movto.desc-mctic        = TRIM(int-portaria-item.desc-mctic)                                                        
                       tt-int-portaria-movto.fm-codigo         = ITEM.fm-codigo                                                                            
                       tt-int-portaria-movto.fm-cod-com        = ITEM.fm-cod-com                                                                           
                       tt-int-portaria-movto.class-fiscal      = ITEM.class-fiscal                                                                         
                       tt-int-portaria-movto.ncm-base          = int-portaria-item.ncm-base                                                                
                       tt-int-portaria-movto.produto-base      = int-portaria-item.produto-base                                                            
                       tt-int-portaria-movto.codigo-orig       = ITEM.codigo-orig                                                                          
                       tt-int-portaria-movto.ind-item-fat      = STRING(ITEM.ind-item-fat,"Sim/Nao")                                                       
                       tt-int-portaria-movto.aliquota-ipi      = ITEM.aliquota-ipi                                                                         
                       tt-int-portaria-movto.cod-unid-negoc    = ITEM.cod-unid-negoc                                                                       
                       tt-int-portaria-movto.classif-atual     = IF AVAIL int-portaria-movto THEN int-portaria-movto.classificacao ELSE ""               
                       tt-int-portaria-movto.portaria-ppb      = IF int-portaria-movto.classificacao = "PPB"  THEN int-portaria-movto.codigo ELSE ""       
                       tt-int-portaria-movto.portaria-hab-prov = IF int-portaria-movto.classificacao = "PROV" THEN int-portaria-movto.codigo ELSE ""       
                       tt-int-portaria-movto.portaria-hab-def  = IF int-portaria-movto.classificacao = "DEF"  THEN int-portaria-movto.codigo ELSE ""       
                       tt-int-portaria-movto.portaria-bem      = IF int-portaria-movto.classificacao = "BEM"  THEN int-portaria-movto.codigo ELSE ""       
                       tt-int-portaria-movto.portaria-atual    = IF AVAIL int-portaria-movto THEN int-portaria-movto.codigo            ELSE ""           
                       tt-int-portaria-movto.dt-portaria       = IF int-portaria-movto.dt-portaria <> ? THEN STRING(int-portaria-movto.dt-portaria) ELSE ""
                       tt-int-portaria-movto.dt-ini-atual      = IF int-portaria-movto.dt-ini <> ? THEN STRING(int-portaria-movto.dt-ini) ELSE ""        
                       tt-int-portaria-movto.dt-fim-atual      = IF int-portaria-movto.dt-fim <> ? THEN STRING(int-portaria-movto.dt-fim) ELSE "".
                       

                FIND LAST bint-portaria-movto NO-LOCK
                      WHERE bint-portaria-movto.it-codigo     = int-portaria-movto.it-codigo  
                        AND bint-portaria-movto.cod-estabel   = int-portaria-movto.cod-estabel
                        AND bint-portaria-movto.seq           = int-portaria-movto.seq
                        AND bint-portaria-movto.classificacao = "PPB" NO-ERROR.
                IF AVAIL bint-portaria-movto THEN
                    ASSIGN tt-int-portaria-movto.portaria-ppb = bint-portaria-movto.codigo
                           tt-int-portaria-movto.dt-ini-ppb   = IF bint-portaria-movto.dt-ini <> ? THEN STRING(bint-portaria-movto.dt-ini) ELSE ""              
                           tt-int-portaria-movto.dt-fim-ppb   = IF bint-portaria-movto.dt-fim <> ? THEN STRING(bint-portaria-movto.dt-fim) ELSE "".             
                ELSE 
                    ASSIGN tt-int-portaria-movto.portaria-ppb = ""
                           tt-int-portaria-movto.dt-ini-ppb   = ""
                           tt-int-portaria-movto.dt-fim-ppb   = "".

                FIND LAST bint-portaria-movto NO-LOCK
                    WHERE bint-portaria-movto.it-codigo     = int-portaria-movto.it-codigo  
                      AND bint-portaria-movto.cod-estabel   = int-portaria-movto.cod-estabel
                      AND bint-portaria-movto.seq           = int-portaria-movto.seq
                      AND bint-portaria-movto.classificacao = "PROV" NO-ERROR.
                IF AVAIL bint-portaria-movto THEN
                    ASSIGN tt-int-portaria-movto.portaria-prov = bint-portaria-movto.codigo
                           tt-int-portaria-movto.dt-ini-prov   = IF bint-portaria-movto.dt-ini <> ? THEN STRING(bint-portaria-movto.dt-ini) ELSE ""        
                           tt-int-portaria-movto.dt-fim-prov   = IF bint-portaria-movto.dt-fim <> ? THEN STRING(bint-portaria-movto.dt-fim) ELSE "".       

                FIND LAST bint-portaria-movto NO-LOCK
                    WHERE bint-portaria-movto.it-codigo     = int-portaria-movto.it-codigo  
                      AND bint-portaria-movto.cod-estabel   = int-portaria-movto.cod-estabel
                      AND bint-portaria-movto.seq           = int-portaria-movto.seq
                      AND bint-portaria-movto.classificacao = "DEF" NO-ERROR.
                IF AVAIL bint-portaria-movto THEN
                    ASSIGN tt-int-portaria-movto.portaria-def = bint-portaria-movto.codigo
                           tt-int-portaria-movto.dt-portaria  = IF bint-portaria-movto.dt-portaria <> ? THEN STRING(bint-portaria-movto.dt-portaria) ELSE ""
                           tt-int-portaria-movto.dt-ini-def   = IF bint-portaria-movto.dt-ini <> ? THEN STRING(bint-portaria-movto.dt-ini) ELSE ""        
                           tt-int-portaria-movto.dt-fim-def   = IF bint-portaria-movto.dt-fim <> ? THEN STRING(bint-portaria-movto.dt-fim) ELSE "".

                FIND LAST bint-portaria-movto NO-LOCK
                    WHERE bint-portaria-movto.it-codigo     = int-portaria-movto.it-codigo  
                      AND bint-portaria-movto.cod-estabel   = int-portaria-movto.cod-estabel
                      AND bint-portaria-movto.seq           = int-portaria-movto.seq
                      AND bint-portaria-movto.classificacao = "BEM" NO-ERROR.
                IF AVAIL bint-portaria-movto THEN
                    ASSIGN tt-int-portaria-movto.portaria-bem = bint-portaria-movto.codigo
                           tt-int-portaria-movto.dt-ini-bem   = IF bint-portaria-movto.dt-ini <> ? THEN STRING(bint-portaria-movto.dt-ini) ELSE ""        
                           tt-int-portaria-movto.dt-fim-bem   = IF bint-portaria-movto.dt-fim <> ? THEN STRING(bint-portaria-movto.dt-fim) ELSE "".
             END.

             FOR FIRST int-portaria-perc NO-LOCK
                 WHERE int-portaria-perc.it-codigo   = int-portaria-item.it-codigo  
                   AND int-portaria-perc.cod-estabel = int-portaria-item.cod-estabel
                   AND int-portaria-perc.seq         = int-portaria-item.seq:

                   ASSIGN tt-int-portaria-movto.aliq-ext-conv1    = IF AVAIL int-portaria-perc THEN int-portaria-perc.aliq-ext-conv1  ELSE 0
                          tt-int-portaria-movto.aliq-ext-conv2a   = IF AVAIL int-portaria-perc THEN int-portaria-perc.aliq-ext-conv2a ELSE 0    
                          tt-int-portaria-movto.aliq-ext-conv2b   = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-ext-conv2b ELSE 0   
                          tt-int-portaria-movto.aliq-ext-fndct    = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-ext-fndct  ELSE 0   
                          tt-int-portaria-movto.aliq-int          = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-int        ELSE 0   
                          tt-int-portaria-movto.aliq-adic         = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-adic       ELSE 0   
                          tt-int-portaria-movto.aliq-cred-hab     = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-cred-hab   ELSE 0   
                          tt-int-portaria-movto.aliq-cred-bem     = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-cred-bem   ELSE 0.
             END.
         END.
     END.
     ELSE DO:
         FOR EACH int-portaria-item NO-LOCK                                                    
            WHERE int-portaria-item.it-codigo   >= tt-param.item-ini                           
              AND int-portaria-item.it-codigo   <= tt-param.item-fim                           
              AND int-portaria-item.cod-estabel >= tt-param.estab-ini                          
              AND int-portaria-item.cod-estabel <= tt-param.estab-fim,                         
            FIRST item NO-LOCK                                                                 
            WHERE item.it-codigo     = int-portaria-item.it-codigo                             
              AND item.fm-codigo    >= tt-param.familia-ini                                    
              AND item.fm-codigo    <= tt-param.familia-fim                                    
              AND item.fm-cod-com   >= tt-param.familia-com-ini                                
              AND item.fm-cod-com   <= tt-param.familia-com-fim                                
              AND item.class-fiscal >= tt-param.ncm-ini                                        
              AND item.class-fiscal <= tt-param.ncm-fim,
             EACH int-portaria-movto NO-LOCK                                                   
            WHERE int-portaria-movto.it-codigo   = int-portaria-item.it-codigo                 
              AND int-portaria-movto.cod-estabel = int-portaria-item.cod-estabel               
              AND int-portaria-movto.seq         = int-portaria-item.seq                       
              AND int-portaria-movto.codigo     >= tt-param.portaria-ppb-ini                   
              AND int-portaria-movto.codigo     <= tt-param.portaria-ppb-fim                   
              AND int-portaria-movto.codigo     >= tt-param.portaria-atual-ini                 
              AND int-portaria-movto.codigo     <= tt-param.portaria-atual-fim                 
              AND int-portaria-movto.dt-ini     >= tt-param.data-ini                           
              AND int-portaria-movto.dt-ini     <= tt-param.data-fim:

             IF tt-param.ppb      = NO AND int-portaria-movto.classificacao = "PPB"  THEN NEXT.
             IF tt-param.hab-prov = NO AND int-portaria-movto.classificacao = "PROV" THEN NEXT.
             IF tt-param.hab-def  = NO AND int-portaria-movto.classificacao = "DEF"  THEN NEXT.
             IF tt-param.bem      = NO AND int-portaria-movto.classificacao = "BEM"  THEN NEXT.

             
             CREATE tt-int-portaria-movto.                                                                                                              
             ASSIGN tt-int-portaria-movto.it-codigo         = int-portaria-movto.it-codigo                                                              
                    tt-int-portaria-movto.cod-estabel       = int-portaria-movto.cod-estabel                                                            
                    tt-int-portaria-movto.desc-item         = IF item.it-codigo <> "" THEN ITEM.desc-item ELSE "Produto Base Beneficiado"               
                    tt-int-portaria-movto.desc-mctic        = TRIM(int-portaria-item.desc-mctic)                                                        
                    tt-int-portaria-movto.fm-codigo         = ITEM.fm-codigo                                                                            
                    tt-int-portaria-movto.fm-cod-com        = ITEM.fm-cod-com                                                                           
                    tt-int-portaria-movto.class-fiscal      = ITEM.class-fiscal                                                                         
                    tt-int-portaria-movto.ncm-base          = int-portaria-item.ncm-base                                                                
                    tt-int-portaria-movto.produto-base      = int-portaria-item.produto-base                                                            
                    tt-int-portaria-movto.codigo-orig       = ITEM.codigo-orig                                                                          
                    tt-int-portaria-movto.ind-item-fat      = STRING(ITEM.ind-item-fat,"Sim/Nao")                                                       
                    tt-int-portaria-movto.aliquota-ipi      = ITEM.aliquota-ipi                                                                         
                    tt-int-portaria-movto.cod-unid-negoc    = ITEM.cod-unid-negoc                                                                       
                    tt-int-portaria-movto.classif-atual     = IF AVAIL int-portaria-movto THEN int-portaria-movto.classificacao ELSE ""               
                    tt-int-portaria-movto.portaria-ppb      = IF int-portaria-movto.classificacao = "PPB"  THEN int-portaria-movto.codigo ELSE ""       
                    tt-int-portaria-movto.portaria-hab-prov = IF int-portaria-movto.classificacao = "PROV" THEN int-portaria-movto.codigo ELSE ""       
                    tt-int-portaria-movto.portaria-hab-def  = IF int-portaria-movto.classificacao = "DEF"  THEN int-portaria-movto.codigo ELSE ""       
                    tt-int-portaria-movto.portaria-bem      = IF int-portaria-movto.classificacao = "BEM"  THEN int-portaria-movto.codigo ELSE ""       
                    tt-int-portaria-movto.portaria-atual    = IF AVAIL int-portaria-movto THEN int-portaria-movto.codigo            ELSE ""           
                    tt-int-portaria-movto.dt-portaria       = IF int-portaria-movto.dt-portaria <> ? THEN STRING(int-portaria-movto.dt-portaria) ELSE ""
                    tt-int-portaria-movto.dt-ini-atual      = IF int-portaria-movto.dt-ini <> ? THEN STRING(int-portaria-movto.dt-ini) ELSE ""        
                    tt-int-portaria-movto.dt-fim-atual      = IF int-portaria-movto.dt-fim <> ? THEN STRING(int-portaria-movto.dt-fim) ELSE "".


             FOR FIRST int-portaria-perc NO-LOCK                                                     
                 WHERE int-portaria-perc.it-codigo   = int-portaria-item.it-codigo                   
                   AND int-portaria-perc.cod-estabel = int-portaria-item.cod-estabel                    
                   AND int-portaria-perc.seq         = int-portaria-item.seq:                        
                                                                                                     
                   ASSIGN tt-int-portaria-movto.aliq-ext-conv1    = IF AVAIL int-portaria-perc THEN int-portaria-perc.aliq-ext-conv1  ELSE 0 
                          tt-int-portaria-movto.aliq-ext-conv2a   = IF AVAIL int-portaria-perc THEN int-portaria-perc.aliq-ext-conv2a ELSE 0 
                          tt-int-portaria-movto.aliq-ext-conv2b   = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-ext-conv2b ELSE 0 
                          tt-int-portaria-movto.aliq-ext-fndct    = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-ext-fndct  ELSE 0 
                          tt-int-portaria-movto.aliq-int          = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-int        ELSE 0 
                          tt-int-portaria-movto.aliq-adic         = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-adic       ELSE 0 
                          tt-int-portaria-movto.aliq-cred-hab     = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-cred-hab   ELSE 0 
                          tt-int-portaria-movto.aliq-cred-bem     = IF AVAIL int-portaria-perc then int-portaria-perc.aliq-cred-bem   ELSE 0.
             END.                                                                                    
         END.
     END.
     
END PROCEDURE.

PROCEDURE pi-imprime :
/*------------------------------------------------------------------------------
  Purpose:     <none>
  Parameters:  <none>
  Notes:       <none>
------------------------------------------------------------------------------*/

    DEF VAR c-arq-excel AS CHAR NO-UNDO.
    DEF VAR c-dir-saida AS CHAR NO-UNDO.

    ASSIGN c-arq-excel = "escdp088-" + STRING(TIME) + ".csv":U.

    IF  OPSYS = "unix" THEN DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-UNIX":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arq-excel).
    END. 
    ELSE DO:
        EMPTY TEMP-TABLE tt-prog-ponto.
    
        RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                           INPUT 1,
                           INPUT 0,
                           INPUT "":U,
                           OUTPUT TABLE tt-prog-ponto).
    
        FOR FIRST tt-prog-ponto:
            ASSIGN c-dir-saida = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
        END. 

        ASSIGN c-dir-saida =  c-dir-saida + "/":U + c-seg-usuario + "/":U.
        OS-CREATE-DIR VALUE(c-dir-saida).
        ASSIGN c-arq-excel = c-dir-saida + TRIM(c-arq-excel).
    END.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-seta-titulo IN h-acomp (INPUT "Relat¢rio...":U).

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT "Acompanhando...":U).

    OUTPUT TO VALUE(c-arq-excel) CONVERT TARGET "iso8859-1".

    IF tt-param.classif = 1 THEN DO:

        PUT UNFORMATTED "Item;Estab;Desc Item;Desc MCTIC;Familia;Familia Coml;NCM;NCM Base;Origem;Item Faturavel;Aliq IPI;Unid Negoc;Classif Atual;Port Atual;Dt/Val Ini Port Atual;Valid Fim Atual;Port PPB;Dt Ini PPB;Dt Fim PPB;Port Prov;Dt Ini Prov;Dt Fim Prov;Port Def;Produto Base;Dt Portaria Def;Dt Ini Def;Dt Fim Def;Port Bem;Dt Ini Bem;Dt Fim Bem;Ext Conv1;Ext Conv2a;Ext Conv2b;Ext FNDCT;Int;Adic;Cred Hab;Cred Bem" SKIP.
        
        FOR EACH tt-int-portaria-movto:
    
            PUT UNFORMATTED
                tt-int-portaria-movto.it-codigo      ";"      
                tt-int-portaria-movto.cod-estabel    ";"      
                tt-int-portaria-movto.desc-item      ";"      
                tt-int-portaria-movto.desc-mctic     ";"
                tt-int-portaria-movto.fm-codigo      ";"      
                tt-int-portaria-movto.fm-cod-com     ";"      
                tt-int-portaria-movto.class-fiscal   ";" 
                tt-int-portaria-movto.ncm-base       ";" 
                tt-int-portaria-movto.codigo-orig    ";"      
                tt-int-portaria-movto.ind-item-fat   ";"      
                tt-int-portaria-movto.aliquota-ipi   ";"      
                tt-int-portaria-movto.cod-unid-negoc ";"
                tt-int-portaria-movto.classif-atual  ";"
                tt-int-portaria-movto.portaria-atual ";"
                tt-int-portaria-movto.dt-ini-atual   ";"      
                tt-int-portaria-movto.dt-fim-atual   ";"
                tt-int-portaria-movto.portaria-ppb   ";"
                tt-int-portaria-movto.dt-ini-ppb     ";"      
                tt-int-portaria-movto.dt-fim-ppb     ";"
                tt-int-portaria-movto.portaria-prov  ";"
                tt-int-portaria-movto.dt-ini-prov    ";"      
                tt-int-portaria-movto.dt-fim-prov    ";"
                tt-int-portaria-movto.portaria-def   ";"
                tt-int-portaria-movto.produto-base   ";" 
                tt-int-portaria-movto.dt-portaria    ";"
                tt-int-portaria-movto.dt-ini-def     ";"      
                tt-int-portaria-movto.dt-fim-def     ";"
                tt-int-portaria-movto.portaria-bem   ";"
                tt-int-portaria-movto.dt-ini-bem     ";"      
                tt-int-portaria-movto.dt-fim-bem     ";"
                tt-int-portaria-movto.aliq-ext-conv1  ";"
                tt-int-portaria-movto.aliq-ext-conv2a ";"
                tt-int-portaria-movto.aliq-ext-conv2b ";"
                tt-int-portaria-movto.aliq-ext-fndct  ";"
                tt-int-portaria-movto.aliq-int        ";"
                tt-int-portaria-movto.aliq-adic       ";"
                tt-int-portaria-movto.aliq-cred-hab   ";"
                tt-int-portaria-movto.aliq-cred-bem   ";"
                SKIP.
    
        END.

    END.
    ELSE DO:

        PUT UNFORMATTED "Item;Estab;Desc Item;Desc MCTIC;Familia;Familia Coml;NCM;NCM Base;Origem;Item Faturavel;Aliq IPI;Unid Negoc;Classif Atual;Port Atual;Port PPB;Port Hab Prov;Port Hab Def;Produto Base;Port Bem;Dt Portaria Def;Valid Ini;Valid Fim;Ext Conv1;Ext Conv2a;Ext Conv2b;Ext FNDCT;Int;Adic;Cred Hab;Cred Bem" SKIP.
        //PUT UNFORMATTED "Item;Estab;Desc Item;Desc MCTIC;Familia;Familia Coml;NCM;NCM Base;Origem;Item Faturavel;Aliq IPI;Unid Negoc;Classif;Port PPB;Port Hab Prov;Port Hab Def;Produto Base;Port Bem;Dt Portaria Def;Valid Ini;Valid Fim;Ext Conv1;Ext Conv2a;Ext Conv2b;Ext FNDCT;Int;Adic;Cred Hab;Cred Bem" SKIP.
        FOR EACH tt-int-portaria-movto:
    
            PUT UNFORMATTED
                tt-int-portaria-movto.it-codigo         ";"
                tt-int-portaria-movto.cod-estabel       ";"
                tt-int-portaria-movto.desc-item         ";"
                tt-int-portaria-movto.desc-mctic        ";"
                tt-int-portaria-movto.fm-codigo         ";"
                tt-int-portaria-movto.fm-cod-com        ";"
                tt-int-portaria-movto.class-fiscal      ";"
                tt-int-portaria-movto.ncm-base          ";" 
                tt-int-portaria-movto.codigo-orig       ";"
                tt-int-portaria-movto.ind-item-fat      ";"
                tt-int-portaria-movto.aliquota-ipi      ";"
                tt-int-portaria-movto.cod-unid-negoc    ";"
                tt-int-portaria-movto.classif-atual     ";"
                tt-int-portaria-movto.portaria-atual    ";"
                tt-int-portaria-movto.portaria-ppb      ";"
                tt-int-portaria-movto.portaria-hab-prov ";"
                tt-int-portaria-movto.portaria-hab-def  ";"
                tt-int-portaria-movto.produto-base      ";" 
                tt-int-portaria-movto.portaria-bem      ";"
                tt-int-portaria-movto.dt-portaria       ";"
                tt-int-portaria-movto.dt-ini-atual      ";"
                tt-int-portaria-movto.dt-fim-atual      ";"
                tt-int-portaria-movto.aliq-ext-conv1    ";"
                tt-int-portaria-movto.aliq-ext-conv2a   ";"
                tt-int-portaria-movto.aliq-ext-conv2b   ";"
                tt-int-portaria-movto.aliq-ext-fndct    ";"
                tt-int-portaria-movto.aliq-int          ";"
                tt-int-portaria-movto.aliq-adic         ";"
                tt-int-portaria-movto.aliq-cred-hab     ";"
                tt-int-portaria-movto.aliq-cred-bem     ";"
                SKIP.
    
        END.
    END.

    OUTPUT CLOSE.

    IF NOT OPSYS = "unix" THEN DO:
        DOS SILENT START excel VALUE(c-arq-excel).
    END.

    RETURN "OK":U.

END PROCEDURE.

