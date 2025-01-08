/***********************************************************************
**  Programa..: ESP\FTP\escdp065RP.P
**  VersÆo....: 001 05/05/2016

************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i escdp065 2.04.00.002}
 
/****************************  Definitions  ****************************/
{esp/cdp/escdp065tt.i}


{include/i-rpvar.i}
 

/*****************************  Frames       ****************************/
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
 
create tt-param.
raw-transfer raw-param to tt-param.

 
def var h-acomp      as handle no-undo.
DEF VAR c-acomp      AS CHAR FORMAT "x(100)" NO-UNDO.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
 
assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Declara‡äes ZFM"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "escdp065"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    /*{include/i-rpcab.i}*/
    {include/i-rpout.i &pagesize="0"}
    /*
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    */
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.
RETURN "OK":U.
 
/* **********************  Internal Procedures  *********************** */
 
 
PROCEDURE piImprimeRelat:
   

    PUT UNFORMATTED "Codigo;CNPJ;Raiz;Nome;Tipo Declara‡Æo;Data C¢pia;Ord Arq;Tributa‡Æo;Motivo Libera‡Æo;Usu rio" SKIP.
    IF (tt-param.da-data-ini = 01/01/2000 OR
        tt-param.da-data-fim = 12/31/2999) THEN  DO:
        FOR EACH int-emitente-trib NO-LOCK
            WHERE int-emitente-trib.raiz-cnpj           >= tt-param.c-raiz-ini
              AND int-emitente-trib.raiz-cnpj           <= tt-param.c-raiz-fim
              AND int-emitente-trib.ordem-arq           >= string(tt-param.i-ordem-ini)
              AND int-emitente-trib.ordem-arq           <= string(tt-param.i-ordem-fim)
              AND int-emitente-trib.cod-usuario         >= tt-param.c-usuario-ini
              AND int-emitente-trib.cod-usuario         <= tt-param.c-usuario-fim,
            EACH emitente NO-LOCK
            WHERE  SUBSTRING(emitente.cgc,1,8) = int-emitente-trib.raiz-cnpj
            AND emitente.cod-emitente >= tt-param.i-cod-cli-ini
            AND emitente.cod-emitente <= tt-param.i-cod-cli-fim:
            RUN pi-imprime.
        END.               
    END.
    ELSE DO:
        FOR EACH int-emitente-trib NO-LOCK
            WHERE int-emitente-trib.raiz-cnpj           >= tt-param.c-raiz-ini
              AND int-emitente-trib.raiz-cnpj           <= tt-param.c-raiz-fim
              AND int-emitente-trib.ordem-arq           >= string(tt-param.i-ordem-ini)
              AND int-emitente-trib.ordem-arq           <= string(tt-param.i-ordem-fim)
              AND int-emitente-trib.cod-usuario         >= tt-param.c-usuario-ini
              AND int-emitente-trib.cod-usuario         <= tt-param.c-usuario-fim
              AND int-emitente-trib.dt-copia-declaracao >= tt-param.da-data-ini 
              AND int-emitente-trib.dt-copia-declaracao <= tt-param.da-data-fim,
            EACH emitente NO-LOCK
            WHERE  SUBSTRING(emitente.cgc,1,8) = int-emitente-trib.raiz-cnpj
            AND emitente.cod-emitente >= tt-param.i-cod-cli-ini
            AND emitente.cod-emitente <= tt-param.i-cod-cli-fim:
            RUN pi-imprime.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-imprime:
        
        
        ASSIGN c-acomp = "Selecionando dados na Data " + string(int-emitente-trib.dt-copia-declaracao,"99/99/9999").
        IF  c-acomp <> ? THEN
            RUN pi-acompanhar IN h-acomp (INPUT c-acomp ).
        FIND FIRST int-emitente 
             WHERE int-emitente.cod-emitente         = emitente.cod-emitente NO-LOCK NO-ERROR.

                      
        IF tt-param.i-tipo = int-emitente-trib.ind-tipo-declaracao OR
           tt-param.i-tipo = 3 THEN DO:
            PUT emitente.cod-emitente       ";"
                emitente.cgc                ";"
                int-emitente-trib.raiz-cnpj ";"
                emitente.nome-emit          ";".
            IF int-emitente-trib.ind-tipo-declaracao = 1 THEN
                PUT "Original"              ";".
            ELSE
                PUT "Copia"                 ";".
            PUT int-emitente-trib.dt-copia-declaracao ";"
                int-emitente-trib.ordem-arq           ";".



            IF  AVAIL int-emitente THEN
                CASE int-emitente.ind-forma-tributo:
                    WHEN 1 THEN PUT "NÆo Cumulativo;" .
                    WHEN 2 THEN PUT "Cumulativo todo ou em parte;".
                    WHEN 3 THEN PUT "Simples;".
                    WHEN 4 THEN PUT "Nenhum;".
                    WHEN 5 THEN PUT "Isento;".
                    OTHERWISE PUT "Nenhum;".
                END CASE.

            FIND FIRST int-emitente-arquivo NO-LOCK
                WHERE  int-emitente-arquivo.raiz-cnpj = int-emitente-trib.raiz-cnpj NO-ERROR.
            IF  AVAIL  int-emitente-arquivo THEN
                PUT int-emitente-arquivo.motivo-lib ";".
            ELSE
                PUT ";".

           PUT int-emitente-trib.cod-usuario SKIP.
        END.
END PROCEDURE.

