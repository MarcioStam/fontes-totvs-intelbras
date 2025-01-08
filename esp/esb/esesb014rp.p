{include/i-prgvrs.i esesb005RP 2.00.00.000}  
    
/*----------------------------------------------------------------*/
/*        DEFINIÄÂES ESPEC÷FICAS PARA INTEGRAÄ«O COM O APB        */
/*----------------------------------------------------------------*/
DEFINE VARIABLE v_hdl_aux AS HANDLE     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE v_des_contdo_prog_valid_dtsul AS CHARACTER   NO-UNDO FORMAT "x(40)":U.

v_des_contdo_prog_valid_dtsul = "esesb005rp".

/*Define variaveis*/
def var p_num_vers_integr_api as integer format ">>>>,>>9" no-undo. 
def var v_cod_matriz_trad_org_ext as character format "x(8)" no-undo. 
def var v_int as i no-undo.

DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

{esapi/esapi015tt.i}

{utp/utapi009.i}
/* {esbo/boes455.i tt-vpc} */
DEFINE TEMP-TABLE tt-vpc NO-UNDO LIKE vpc
FIELD r-Rowid AS ROWID.
/* {esbo/boes456.i tt-pagto-vpc} */

{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/************************  FIM DEFINIÄÂES APB  ***********************/

/*-------------------------------------------------*/
/*    D E F I N I Ä « O   T E M P - T A B L E S    */
/*-------------------------------------------------*/
define temp-table tt-param no-undo
    FIELD destino     AS INTEGER
    FIELD arquivo     AS CHAR format "x(35)"
    FIELD usuario     AS CHAR format "x(12)"
    FIELD data-exec   AS DATE
    FIELD hora-exec   AS INTEGER.

/* Temp-table tt-beneficio */
{esp/esb/esesbapi004-benef.i}

/*Temp-tables com os dados do faturamento/devoluá‰es*/
{esp/esb/esesbapi002.i} /* tt-canal; tt-fat-mensal; tt-fat-mensal-det */

DEF TEMP-TABLE tt-cc-benef NO-UNDO LIKE int-cc-benef.

def temp-table tt-raw-digita 
    FIELD raw-digita	as raw.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo   AS INTEGER
    FIELD mensagem AS CHAR FORMAT "X(500)"
    FIELD ajuda    AS CHAR FORMAT "X(500)".

DEF TEMP-TABLE tt-erro-benef NO-UNDO LIKE tt-erro.

/* Carregada no .w, caso o usu†rio tenha optado por digitar os canais individualmente */
define temp-table tt-digita 
    FIELD canal-central     AS INTEGER
        INDEX idx-canal IS PRIMARY UNIQUE canal-central.


/*************** PAR∂METROS ***************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE for tt-raw-digita.
 
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-freeac.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{include/tt-edit.i}
{include/pi-edit.i}
{utp/ut-glob.i}


/* Definiá∆o da tt-central */                       
{esp/esb/esesbapi005.i}

/*{esapi/esapi015tt.i}*/

/* bloco principal do programa */
ASSIGN c-programa     = "esesb009"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Sincronizaá∆o de Benef°cios Canais Intelbras"
       c-titulo-relat = "Sincronizaá∆o de Benef°cios Canais Intelbras".

/************ DEFINIÄ«O DE VARIµVEIS **************/
DEFINE VARIABLE h-acomp                   AS HANDLE                 NO-UNDO.
DEF VAR c-arq-benef AS CHAR NO-UNDO.
DEF VAR c-arq-centrais AS CHAR NO-UNDO.

DEF VAR c-label AS CHAR NO-UNDO.
DEF STREAM exp1.
DEF STREAM exp2.
DEF STREAM exp3.
DEF STREAM exp1-det.
DEF STREAM exp4.

DEF STREAM s1.
DEF STREAM s2.


/*-------------------*/
/*   F U N Ä Â E S   */
/*-------------------*/
FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT) FORWARD.

/*------------------------------------------------------*/
/*    I N ÷ C I O  -   B L O C O   P R I N C I P A L    */
/*------------------------------------------------------*/
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

IF  NOT VALID-HANDLE(h-acomp) THEN                                  
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                      
                                                                    
    ASSIGN c-label = "MOVTO;CANAL;UNID NEG;TP BENEF;CATEGORIA;CLASSIFICAÄ«O;PER INI;PER FIM;SALDO ANT;BASE-CALC;% CUSTO;% PREV META;% BENEF÷CIO;SALDO CALC ATUAL;DT TRANS;DT VENCTO;STATUS;USUARIO;CLASSIFICAÄ«O;GUID BENEF CANAL;GUID BENEF;GUID-CANAL".
    
    ASSIGN c-arq-benef = c-dir-arquivo-session + "log-prov-benef_"  + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    OUTPUT STREAM exp3 TO VALUE(c-arq-benef) CONVERT TARGET "iso8859-1".

    ASSIGN c-arq-centrais = c-dir-arquivo-session + "log-prov-centrais_" + c-seg-usuario + "_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    OUTPUT STREAM exp2 TO VALUE(c-arq-centrais) CONVERT TARGET "iso8859-1".
                                                                                                                                                                                                                               

RUN PI-PRINCIPAL.


/* Retornou erro */
IF  CAN-FIND (FIRST tt-erro) OR RETURN-VALUE <> "OK" THEN DO:
    PUT "Erro       Mensagem" SKIP
        "---------- -------------------------------------------------------------------------------------------------------------------------" SKIP(1).

    FOR EACH tt-erro:
    
        /*Imprime a mensagem tabulada*/    
        EMPTY TEMP-TABLE tt-editor.
        run pi-print-editor (tt-erro.mensagem, 80).
        FOR EACH tt-editor:
            PUT tt-erro.codigo TO 10 tt-editor.conteudo AT 12 SKIP.     
        END.   
        IF  NOT CAN-FIND (FIRST tt-editor) THEN
            PUT tt-erro.codigo TO 10 tt-erro.mensagem  AT 12 SKIP.

        /*Imprime o Help tabulado*/
        EMPTY TEMP-TABLE tt-editor.
        run pi-print-editor (tt-erro.ajuda, 80).
        FOR EACH tt-editor:
            PUT tt-editor.conteudo AT 12 SKIP.     
        END.   
        IF  NOT CAN-FIND (FIRST tt-editor) THEN
            PUT tt-erro.ajuda  AT 12 SKIP.
        PUT SKIP (1).

    END.
    
END.
ELSE
    DISP SKIP(2) "    Sincronizaá∆o de benef°cios executada com sucesso!".


OUTPUT STREAM exp2      CLOSE.
OUTPUT STREAM exp3      CLOSE.

ASSIGN v_des_contdo_prog_valid_dtsul = "".

{include/i-rpclo.i}

if valid-handle(h-acomp) then    
    RUN pi-finalizar IN h-acomp. 
                                 
RETURN "OK".             

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                  P R O C E D U R E S  I N T E R N A S                                                           */
/*-------------------------------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE PI-PRINCIPAL:

    /*-------------------------*/
    /* CANAIS A SEREM APURADOS */
    /*-------------------------*/
    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-inicializar IN h-acomp (INPUT "Sincronizaá∆o de Benef°cios").

    IF  VALID-HANDLE(h-acomp) THEN                                      
        RUN pi-acompanhar IN h-acomp (INPUT "Buscando canais centrais...").

    /* S‡ CONSIDERA OS CANAIS QUE O USUµRIO ESCOLHEU NO PROGRAMA */
    IF  CAN-FIND (FIRST tt-digita) THEN DO:
        FOR EACH tt-digita:

            /* CANAIS ESTRUTURA CENTRAL - FILIAL COM BASE NA DIGITAÄ«O DO USUµRIO*/
            RUN esp/esb/esesbapi005.p (INPUT string(tt-digita.canal-central),
                                       OUTPUT TABLE tt-central,
                                       OUTPUT TABLE tt-erro).
    
            IF  RETURN-VALUE <> "OK" 
            OR  CAN-FIND (FIRST tt-erro) THEN
                RETURN "NOK".

            FIND FIRST tt-central NO-LOCK NO-ERROR.
            IF  AVAIL tt-central THEN DO:
                CREATE tt-canal.
                ASSIGN tt-canal.canal       = tt-central.canal-central
                       tt-canal.guid-canal  = tt-central.guid-canal-central
                       tt-canal.guid-class  = tt-central.guid-class-central.
            END.
            PUT STREAM exp2 "Central;Ades∆o Central;CLASS Central; NomeAb Central; Nome Central; NomeMatriz Central;Filial;NomeAb Filial;Nome Filial;Matriz Filial;Ades∆o Filial;GUID CLASS Filial;Centralizada;Exclusiva" SKIP.
            RUN pi-exporta-centrais.
            
        END.
    END.
    ELSE DO:
        /* TODOS OS CANAIS DENTRO DA ESTRUTURA CENTRAL - FILIAL*/
        RUN esp/esb/esesbapi005.p (INPUT "",
                                   OUTPUT TABLE tt-central,
                                   OUTPUT TABLE tt-erro).

        IF  RETURN-VALUE <> "OK" 
        OR  CAN-FIND (FIRST tt-erro) THEN
            RETURN "NOK".

        RUN pi-carrega-canais.
    END.

    /*---------------------------*/
    /*  APURAÄ«O DOS BENEF÷CIOS  */
    /*---------------------------*/
    RUN pi-busca-beneficios-canal.
    
    IF  RETURN-VALUE <> "OK" THEN
        RETURN "NOK".

    /* TRANSAÄ«O PRINCIPAL */
    bloco:
    DO TRANS ON ENDKEY UNDO bloco, LEAVE bloco ON ERROR UNDO bloco, LEAVE bloco:
    
        RUN pi-grava-beneficio.

        IF  RETURN-VALUE <> "OK" THEN DO:
            UNDO bloco , RETURN "NOK".
        END.

    END.

    RUN pi-exporta-beneficios.


    RETURN "OK".
END.

/*-------------------------------------------------------------------*/
/*        B U S C A R   B E N E F ÷ C I O S   D O   C A N A L        */
/*-------------------------------------------------------------------*/
PROCEDURE pi-busca-beneficios-canal:
    
    /*------------------------------------------------------------------------------*/
    /*  API QUE RETORA OS BENEF÷CIOS DO CANAL, COM OS %(s) PARA PROVIS«O E CµLCULO  */
    /*------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-erro-benef.
    EMPTY TEMP-TABLE tt-beneficio.
    
    RUN esp/esb/esesbapi004-benef.p (INPUT  NO,   /* Indica que Ç provisionamento, logo n∆o busca o stock rotation tambÇm */
                                     INPUT  YES,  /* Buscar msg0111 com o % global de cada benef°cio   */
                                     INPUT  YES,  /* Buscar msg0142, parÉmetros financeiros e provis∆o */
                                     INPUT  ?,    /* (?) para buscar todas as unidades, ou informar uma unidade espec°fica */
                                     INPUT  ?,    /* (?) para buscar todas os benef°cios, ou informar uma benef°cio espec°fico */
                                     INPUT  TABLE tt-canal,
                                     OUTPUT TABLE tt-erro-benef,
                                     OUTPUT TABLE tt-beneficio).
    IF  RETURN-VALUE <> "OK" 
    OR  CAN-FIND (FIRST tt-erro-benef) THEN DO:
        FOR EACH tt-erro-benef:
            CREATE tt-erro.
            BUFFER-COPY tt-erro-benef TO tt-erro.
        END.
        RETURN "NOK".
    END.


    RUN pi-exporta-beneficios.
    
    RETURN "OK".
END.

PROCEDURE pi-grava-beneficio:

    DEF BUFFER b-hist FOR int-beneficio-hist.

    DO TRANS:

        /*Copia para base hist¢rica, caso haja modificaá∆o*/
        FOR EACH int-beneficio
            ,FIRST tt-canal
                WHERE tt-canal.canal = int-beneficio.canal:
            FIND LAST b-hist
                 WHERE b-hist.canal          = int-beneficio.canal
                   AND b-hist.unid-neg       = int-beneficio.unid-neg  
                   AND b-hist.tipo-beneficio = int-beneficio.tipo-beneficio NO-LOCK NO-ERROR.

            IF  NOT AVAIL b-hist THEN DO:
                CREATE b-hist.
                ASSIGN b-hist.dt-trans = DATETIME( TODAY, MTIME )
                       b-hist.id-status = int-beneficio.id-status.
                BUFFER-COPY int-beneficio EXCEPT id-status TO b-hist.

            END.
            ELSE IF  int-beneficio.guid-categoria       <> b-hist.guid-categoria       
                 or  int-beneficio.guid-beneficio       <> b-hist.guid-beneficio       
                 or  int-beneficio.tipo-beneficio       <> b-hist.tipo-beneficio       
                 or  int-beneficio.tipo-categoria       <> b-hist.tipo-categoria       
                 or  int-beneficio.guid-class           <> b-hist.guid-class           
                 or  int-beneficio.nome-class           <> b-hist.nome-class           
                 or  int-beneficio.exclusividade        <> b-hist.exclusividade        
                 or  int-beneficio.id-status            <> b-hist.id-status            
                 or  int-beneficio.calcula-verba        <> b-hist.calcula-verba        
                 or  int-beneficio.perc-global          <> b-hist.perc-global          
                 or  int-beneficio.conta-contab         <> b-hist.conta-contab         
                 or  int-beneficio.centro-custo         <> b-hist.centro-custo         
                 or  int-beneficio.cod-estabel          <> b-hist.cod-estabel          
                 or  int-beneficio.cod-especie          <> b-hist.cod-especie          
                 or  int-beneficio.tipo-fluxo           <> b-hist.tipo-fluxo           
                 or  int-beneficio.perc-custo           <> b-hist.perc-custo           
                 or  int-beneficio.perc-prov-meta       <> b-hist.perc-prov-meta       
                 or  int-beneficio.guid-beneficio-canal <> b-hist.guid-beneficio-canal THEN DO:

                    CREATE int-beneficio-hist.
                    ASSIGN int-beneficio-hist.dt-trans = DATETIME( TODAY, MTIME )
                           int-beneficio-hist.id-status = int-beneficio.id-status.
                    BUFFER-COPY int-beneficio EXCEPT id-status TO int-beneficio-hist.

                END.

            DELETE int-beneficio.
        END.

        FOR EACH tt-beneficio:
    
            CREATE int-beneficio.    
            ASSIGN int-beneficio.canal                  = tt-beneficio.canal                
                   int-beneficio.guid-canal             = tt-beneficio.guid-canal           
                   int-beneficio.unid-neg               = tt-beneficio.unid-neg
                   int-beneficio.guid-categoria         = tt-beneficio.guid-categoria       
                   int-beneficio.guid-beneficio         = tt-beneficio.guid-beneficio       
                   int-beneficio.tipo-beneficio         = tt-beneficio.tipo-beneficio       
                   int-beneficio.tipo-categoria         = tt-beneficio.tipo-categoria       
                   int-beneficio.guid-class             = tt-beneficio.guid-class           
                   int-beneficio.nome-class             = tt-beneficio.nome-class           
                   int-beneficio.exclusividade          = tt-beneficio.exclusividade        
                   int-beneficio.id-status              = tt-beneficio.id-status            
                   int-beneficio.calcula-verba          = tt-beneficio.calcula-verba        
                   int-beneficio.perc-global            = tt-beneficio.perc-global          
                   int-beneficio.conta-contab           = tt-beneficio.conta-contab         
                   int-beneficio.centro-custo           = tt-beneficio.centro-custo         
                   int-beneficio.cod-estabel            = tt-beneficio.cod-estabel          
                   int-beneficio.cod-especie            = tt-beneficio.cod-especie          
                   int-beneficio.tipo-fluxo             = tt-beneficio.tipo-fluxo           
                   int-beneficio.perc-custo             = tt-beneficio.perc-custo           
                   int-beneficio.perc-prov-meta         = tt-beneficio.perc-prov-meta       
                   int-beneficio.guid-beneficio-canal   = tt-beneficio.guid-beneficio-canal. 

        END.
    END.


/*     OUTPUT STREAM s1 TO "/opt/totvs/spool/ve888002/int-beneficio.d".      */
/*     FOR EACH int-beneficio NO-LOCK:                                       */
/*         EXPORT STREAM s1 DELIMITER ";" int-beneficio .                    */
/*     END.                                                                  */
/*     OUTPUT STREAM s1 CLOSE.                                               */
/*                                                                           */
/*     OUTPUT STREAM s2 TO "/opt/totvs/spool/ve888002/int-beneficio-hist.d". */
/*     FOR EACH int-beneficio-hist NO-LOCK:                                  */
/*         EXPORT STREAM s2 DELIMITER ";" int-beneficio-hist .               */
/*     END.                                                                  */
/*     OUTPUT STREAM s2 CLOSE.                                               */
/*                                                                           */
/*                                                                           */

    RETURN "OK".

END.

PROCEDURE pi-exporta-beneficios:

     PUT STREAM exp3 "Canal;Unidade;Beneficio;Categoria;Classificaá∆o;% Benef;% Custo;% Prov Meta;STATUS;Conta Contab;Centro Custo;Estabelec;EspÇcie;Tp Fluxo;Exclusiv;Calcula Verba;GUID Canal;GUID Benef;GUID Benef Canal;GUID Classificaá∆o;GUID Categoria" SKIP.
     
     FOR EACH tt-beneficio:
          EXPORT STREAM exp3 DELIMITER ";" tt-beneficio.canal                  
                                           tt-beneficio.unid-neg               
                                           fn-retorna-nome-beneficio(tt-beneficio.tipo-beneficio)
                                           tt-beneficio.tipo-categoria         
                                           tt-beneficio.nome-class             
                                           tt-beneficio.perc-global            
                                           tt-beneficio.perc-custo                                         
                                           tt-beneficio.perc-prov-meta         
                                           tt-beneficio.id-status              
                                           tt-beneficio.conta-contab           
                                           tt-beneficio.centro-custo           
                                           tt-beneficio.cod-estabel            
                                           tt-beneficio.cod-especie            
                                           tt-beneficio.tipo-fluxo             
                                           tt-beneficio.exclusividade             
                                           tt-beneficio.calcula-verba                                                
                                           tt-beneficio.guid-canal             
                                           tt-beneficio.guid-beneficio 
                                           tt-beneficio.guid-beneficio-canal   
                                           tt-beneficio.guid-class             
                                           tt-beneficio.guid-categoria.         
     END.                                                                      
END.                                                                               

PROCEDURE pi-exporta-centrais:
    
    FOR EACH tt-central:
        EXPORT STREAM exp2 DELIMITER ";"  tt-central.canal-central
                                          tt-central.dt-adesao-central
                                          tt-central.guid-class-central
                                          tt-central.nome-abrev-central
                                          tt-central.nome-emit-central
                                          tt-central.nome-matriz-central
                                          tt-central.canal-filial
                                          tt-central.nome-abrev-filial
                                          tt-central.nome-emit-filial
                                          tt-central.nome-matriz-filial
                                          tt-central.dt-adesao-filial
                                          tt-central.guid-class-filial
                                          tt-central.centralizada 
                                          tt-central.exclusividade.  
    END.
END.

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*                                                          F U N Ä Â E S   I N T E R N A S                                                                                */
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

PROCEDURE pi-carrega-canais:

    PUT STREAM exp2 "Central;Ades∆o Central;CLASS Central; NomeAb Central; Nome Central; NomeMatriz Central;Filial;NomeAb Filial;Nome Filial;Matriz Filial;Ades∆o Filial;GUID CLASS Filial;Centralizada;Exclusiva" SKIP.
    RUN pi-exporta-centrais.

    /* carrega os canais que ir∆o buscar os benef°cios */
    FOR EACH tt-central:

        IF  NOT CAN-FIND (tt-canal
                            WHERE tt-canal.canal = tt-central.canal-central) THEN DO:

            CREATE tt-canal.
            ASSIGN tt-canal.canal       = tt-central.canal-central
                   tt-canal.guid-canal  = tt-central.guid-canal-central
                   tt-canal.guid-class  = tt-central.guid-class-central.

        END.
    END.
END.

PROCEDURE pi-cria-erro:

    DEFINE INPUT PARAM p-erro     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-mensagem AS CHAR NO-UNDO.
    DEFINE INPUT PARAM p-ajuda    AS CHAR NO-UNDO.

    CREATE tt-erro.
    ASSIGN tt-erro.codigo   = p-erro
           tt-erro.mensagem = p-mensagem
           tt-erro.ajuda    = p-ajuda.

END.


FUNCTION fn-retorna-nome-beneficio RETURNS CHAR
    (p-beneficio AS INT):
    
    CASE p-beneficio:
        WHEN 21 THEN RETURN "VMC".
        WHEN 22 THEN RETURN "STOCK ROTATION".
        WHEN 37 THEN RETURN "REBATE".
        WHEN 66 THEN RETURN "REBATE P‡S-VENDA".
    END CASE.

    RETURN "".
END FUNCTION.


