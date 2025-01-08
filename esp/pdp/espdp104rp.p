/************************************************************************************************************
*      Programa .....: ESACR087RP                                                                           *
*      Data .........: 29 de Maio de 2023                                                                   *
*      Empresa ......: IDBA                                                                                 *
*      Cliente ......: Intelbras                                                                            *
*      Programador ..: Bruno Joaquim                                                                        *
*      Objetivo .....: Inativa itens das tabelas de preco                                                   *
*************************************************************************************************************
*  VERSAO       DATA        RESPONSAVEL              MOTIVO                                                 *
*  1.00.00.000  19/05/2023  Bruno Joaquim           Desenvolvimento                                         *
************************************************************************************************************/
/***********************************************************************************************************/
/***********************************************************************************************************/
/*************************** TEMP-TABLES *******************************************************************/
/***********************************************************************************************************/
// 123
{include/i-prgvrs.i espdp104 2.00.00.000} 

{esp/es0018.i} .

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.
 
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHARACTER FORMAT "x(35)":U
    FIELD usuario     AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER
    FIELD diretorio   AS CHARACTER
    FIELD tp-execucao AS INT.

DEFINE TEMP-TABLE tt-lista
    FIELD nr-tabpre LIKE preco-item.nr-tabpre
    FIELD it-codigo LIKE preco-item.it-codigo
    FIELD dt-inival LIKE preco-item.dt-inival 
    FIELD iCont     AS   INT.

DEFINE TEMP-TABLE tt-listas-liberadas
    FIELD nr-tabpre LIKE preco-item.nr-tabpre .

DEFINE TEMP-TABLE tt-inativados
    FIELD nr-tabpre LIKE preco-item.nr-tabpre 
    FIELD it-codigo LIKE preco-item.it-codigo 
    FIELD dt-inival LIKE preco-item.dt-inival .
                                         
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.


/********************************************************************************************/
/*************************** Variaveis  *****************************************************/
/********************************************************************************************/
DEFINE VARIABLE h-acomp         AS HANDLE           NO-UNDO.
DEFINE VARIABLE listCont        AS INT.
DEFINE VARIABLE n               AS INT.
DEFINE VARIABLE l-continua      AS LOG.
/********************************************************************************************/
/*************************** INCLUDES  *****************************************************/
/********************************************************************************************/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}
{btb/btb912zb.i}

/********************************************************************************************/
/*************************** FUNCOES  *******************************************************/
/********************************************************************************************/
FUNCTION ViraMes RETURNS LOGICAL:

    DEFINE VAR aData AS DATE INITIAL TODAY.
    DEFINE VAR bData AS DATE INITIAL TODAY.

    ASSIGN aData = aData +  1 .

    IF MONTH(aData) <> MONTH(bData) THEN 
        RETURN TRUE.
    ELSE 
        RETURN FALSE.

END FUNCTION.


/*--- Processamento Principal ---*/
IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Inciando").

IF ViraMes() = YES THEN DO:
    //Testa se Ç o ultimo dia do mes, caso seja inativa todas as listas ativas
    RUN inativaTodos.
END.
ELSE DO:
    RUN pi-inativa-duplicados . 
END.

RUN pi-finalizar in h-acomp.

RETURN "OK":U. //Return Final 

PROCEDURE pi-inativa-duplicados:

    EMPTY TEMP-TABLE tt-listas-liberadas.
    
    DO WHILE l-continua <> TRUE :
        EMPTY TEMP-TABLE tt-prog-ponto.
            RUN esp/es0018p.p (INPUT  "espdp046":U,
                               INPUT  1,
                               INPUT  n,
                               INPUT  "":U,
                               OUTPUT TABLE tt-prog-ponto).
            FIND FIRST tt-prog-ponto  NO-ERROR.
            IF AVAIL tt-prog-ponto THEN DO:
                CREATE tt-listas-liberadas.
                ASSIGN tt-listas-liberadas.nr-tabpre = conteudo .
    
                ASSIGN n = n + 1 .
    
            END.
            ELSE DO:
                ASSIGN l-continua = TRUE.
            END.
    END.


    FOR EACH preco-item FIELDS (preco-item.dt-inival 
                                preco-item.situacao 
                                preco-item.nr-tabpre 
                                preco-item.preco-venda 
                                preco-item.situacao
                                preco-item.it-codigo )
        WHERE preco-item.situacao =  1 :
        
        /*AND (preco-item.nr-tabpre = "D-14039"
            or preco-item.nr-tabpre = "D-14030"
            or preco-item.nr-tabpre = "D-11011"
            or preco-item.nr-tabpre = "VAREG-SP"
            or preco-item.nr-tabpre = "AT-TI-SP"
            or preco-item.nr-tabpre = "PAP INF"
            or preco-item.nr-tabpre = "PSD-SP"
            or preco-item.nr-tabpre = "PSCF-SP"
            or preco-item.nr-tabpre = "PARCE-SP"
            or preco-item.nr-tabpre = "PRERE-SP"
            or preco-item.nr-tabpre = "PREVE-SP"
            or preco-item.nr-tabpre = "PROVE-SP"
            or preco-item.nr-tabpre = "SOLPR-SP") :*/
    
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando itens duplicados " + string(preco-item.nr-tabpre) +  " ID:" + STRING(listCont)).

        IF NOT CAN-FIND(tt-listas-liberadas WHERE preco-item.nr-tabpre BEGINS(tt-listas-liberadas.nr-tabpre) ) THEN NEXT.
        
        ASSIGN listCont = listCont + 1 .
    
        FIND FIRST tt-lista WHERE tt-lista.nr-tabpre = preco-item.nr-tabpre
                              AND tt-lista.it-codigo = preco-item.it-codigo NO-ERROR.
        IF NOT AVAIL tt-lista THEN DO:
            CREATE tt-lista.
            ASSIGN tt-lista.nr-tabpre  = preco-item.nr-tabpre  
                   tt-lista.it-codigo  = preco-item.it-codigo  
                   tt-lista.dt-inival  = preco-item.dt-inival  
                   tt-lista.iCont      = 1 .     
        END.
        ELSE DO:
            ASSIGN tt-lista.iCont = iCont + 1 .
            IF preco-item.dt-inival > tt-lista.dt-inival THEN DO:
               ASSIGN tt-lista.dt-inival = preco-item.dt-inival.
            END.
        END.
    
    END.
    
    ASSIGN listCont =  0.
    
    FOR EACH tt-lista WHERE tt-lista.iCont > 1 :
    
        FOR EACH preco-item WHERE preco-item.nr-tabpre = tt-lista.nr-tabpre 
                              AND preco-item.it-codigo = tt-lista.it-codigo 
                              AND preco-item.dt-inival < tt-lista.dt-inival
                              AND preco-item.situacao =  1 EXCLUSIVE-LOCK:
    
    
            CREATE tt-inativados.
            ASSIGN tt-inativados.nr-tabpre = preco-item.nr-tabpre
                   tt-inativados.it-codigo = preco-item.it-codigo
                   tt-inativados.dt-inival = preco-item.dt-inival.
        
            RUN pi-acompanhar IN h-acomp (INPUT "Inativando precos " + string(preco-item.nr-tabpre) +  " ID:" + STRING(listCont)).
    
            ASSIGN listCont = listCont + 1 .
                ASSIGN preco-item.situacao = 2 . 
            END.
    
    END.
    
    
    FOR EACH tt-inativados:
        PUT UNFORMATTED "LISTA : " +  tt-inativados.nr-tabpre + " ITEM: " + tt-inativados.it-codigo + " DATA: " +  STRING(tt-inativados.dt-inival) SKIP.
    END.

END PROCEDURE.


PROCEDURE inativaTodos:

    FOR EACH preco-item WHERE preco-item.situacao =  1 EXCLUSIVE-LOCK:
        ASSIGN preco-item.situacao = 2 . 
    END.

END PROCEDURE.
