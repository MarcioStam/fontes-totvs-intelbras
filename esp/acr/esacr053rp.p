/*********************************************************************************
** Programa: esp/acr/esacr053rp.p
** Vers∆o..: 1.00
** Data....: 26/03/2012
** Autor...: Estevan KrÅger - Exponencial TI
** Obs.....: Programa para 
*********************************************************************************/
{include/i-prgvrs.i ESACR053RP 2.00.00.001}  /*** 010001 ***/
  

/*--- Definiá∆o das Vari†veis Locais ---*/
DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-ano          AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-dif-ano      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-ano-aux      AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-anos         AS INTEGER     NO-UNDO EXTENT 10.
DEFINE VARIABLE de-tot-acr     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-ap      AS DECIMAL     NO-UNDO.




/*--- Definiá∆o de Temp-Tables e Buffers ---*/
{esp/acr/esacr053.i}




/*--- Definiá∆o dos ParÉmetros de Entrada ---*/
DEFINE INPUT  PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-ERROR.




/*--- Bloco Principal ---*/
RUN esp/acr/esacr053rpa.p (INPUT  TABLE tt-param,
                           OUTPUT TABLE tt-cliente,
                           OUTPUT TABLE tt-valores-cli).


FIND FIRST tt-param NO-ERROR.

IF  NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "Imprimindo Dados").


ASSIGN i-ano-aux = 0
       i-dif-ano = (YEAR(tt-param.dt-final) - YEAR(tt-param.dt-inicial)) + 1.


OUTPUT TO VALUE(tt-param.arquivo) NO-CONVERT.

/* Imprime o cabeáalho, com os anos da faixa de data */
PUT UNFORMATTED "Cliente;;Contas a Receber;" FILL(";",i-dif-ano - 1) ";;Contas a Pagar;" SKIP
                "C¢d Cliente;Nome Cliente;".

/* Imprime o cabeáalho para o CONTAS A RECEBER */
DO  i-ano = YEAR(tt-param.dt-inicial) TO YEAR(tt-param.dt-final):
    PUT UNFORMATTED "Ano " i-ano ";".
    ASSIGN i-ano-aux         = i-ano-aux + 1
           i-anos[i-ano-aux] = i-ano.
END.

PUT UNFORMATTED "Total;;".

/* Imprime o cabeáalho para o CONTAS A PAGAR */
DO  i-ano = YEAR(tt-param.dt-inicial) TO YEAR(tt-param.dt-final):
    PUT UNFORMATTED "Ano " i-ano ";".
END.


PUT UNFORMATTED "Total;Diferenáa;" SKIP.


/* Imprime as informaá‰es dos cliente, com cada valor na sua respectiva data */
ASSIGN de-tot-acr = 0
       de-tot-ap  = 0.

FOR EACH tt-cliente NO-LOCK
    BY   tt-cliente.cod-cliente:

    RUN pi-acompanhar IN h-acomp (INPUT "Cliente: " + STRING(tt-cliente.cod-cliente)).

    PUT UNFORMATTED tt-cliente.cod-cliente ";"
                    tt-cliente.nom-cliente ";".

    
    /* Imprime as informaá‰es do CONTAS A RECEBER */
    ASSIGN de-tot-acr = 0.
    FOR EACH  tt-valores-cli NO-LOCK
        WHERE tt-valores-cli.cod-cliente = tt-cliente.cod-cliente
        BY    tt-valores-cli.ano:
        PUT UNFORMATTED tt-valores-cli.tot-ano-acr ";".

        ASSIGN de-tot-acr = de-tot-acr + tt-valores-cli.tot-ano-acr.
    END.

    
    PUT UNFORMATTED de-tot-acr ";;".


    /* Imprime as informaá‰es do CONTAS A PAGAR */
    ASSIGN de-tot-ap = 0.
    FOR EACH  tt-valores-cli NO-LOCK
        WHERE tt-valores-cli.cod-cliente = tt-cliente.cod-cliente
        BY    tt-valores-cli.ano:
        PUT UNFORMATTED tt-valores-cli.tot-ano-ap ";".

        ASSIGN de-tot-ap = de-tot-ap + tt-valores-cli.tot-ano-ap.
    END.


    PUT UNFORMATTED de-tot-ap ";" (de-tot-acr - de-tot-ap) SKIP.
END.

OUTPUT CLOSE.




/*--- Finalizaá∆o das Informaá‰es ---*/
IF  VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

