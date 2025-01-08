{include/i-prgvrs.i esofp004 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\FTP\esofp004RP.P
**  Autor.....: Anderson Cenci
**  Data......: 13/05/09
**  Descricao.: Controle de ativo Permanente
************************************************************************/
 
/****************************  Definitions  ****************************/
{esp/ofp/esofp004tt.i}
    
{include/i-rpvar.i}
 
/****************************  Frames       ****************************/
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
DEFINE VARIABLE c-alterado       AS CHARACTER FORMAT "x(14)"  NO-UNDO.
DEFINE VARIABLE i-cont           AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-parcela        AS INTEGER     NO-UNDO.
DEFINE VARIABLE da-data          AS DATE        NO-UNDO.
DEFINE VARIABLE i-parcela-ultima AS INTEGER     NO-UNDO.
DEFINE VARIABLE da-data-ultima   AS DATE        NO-UNDO.
DEFINE VARIABLE de-total-vl-icms-com   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-total-vl-parcelado  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-descricao     AS CHARACTER FORMAT "x(60)"  NO-UNDO.
create tt-param.
raw-transfer raw-param to tt-param.
 
for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
 
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.
 
assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Controle de ativo Permanente"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "esofp004"
       c-versao       = "2.04"
       c-revisao      = "001".
 
FORM doc-fiscal.nr-doc-fis
     doc-fiscal.dt-docto
     it-doc-fisc.it-codigo
     it-doc-fisc.descricao-db
     doc-fiscal.vl-icms-com
     movto-estoq.ct-codigo
     movto-estoq.sc-codigo
     c-alterado                                     COLUMN-LABEL "Alterado"
    WITH FRAME f-detalhe WIDTH 232 64 DOWN STREAM-IO NO-ATTR-SPACE.
FORM ativo-permanente.cod-estabel    FORMAT "x(03)" COLUMN-LABEL "Est"
    ativo-permanente.serie           FORMAT "x(03)" COLUMN-LABEL "Ser"
    ativo-permanente.nr-doc-fis      FORMAT "x(07)" COLUMN-LABEL "Docto"
    ativo-permanente.nat-operacao    FORMAT "x(08)" COLUMN-LABEL "NOP"
    ativo-permanente.dt-docto                       COLUMN-LABEL "Dt.Docto"
    ativo-permanente.vl-icms-com    
    ativo-permanente.vl-parcelado   
    ativo-permanente.parcela[1]    
    ativo-permanente.dt-parcela[1] 
WITH FRAME f-detalhe2 WIDTH 232 64 DOWN STREAM-IO NO-ATTR-SPACE.


/* ***************************  Main Block  *************************** */

do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i &pagesize="0"}
    
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.
 
PROCEDURE piImprimeRelat:

    FIND param-estoq NO-LOCK NO-ERROR.

    PUT "Data do Ultimo Fechamento: " param-estoq.ult-fech-dia SKIP.
         
    PUT "" skip
        "Atualiza‡Æo:" SKIP 
        "-----------" SKIP.

    FOR EACH tt-digita NO-LOCK,
        EACH doc-fiscal exclusive-LOCK
        WHERE doc-fiscal.nat-operacao  = tt-digita.nat-operacao
          AND doc-fiscal.dt-docto     >= tt-param.da-data-ini
          AND doc-fiscal.dt-docto     <= tt-param.da-data-fim
          AND doc-fiscal.cod-estabel  >= tt-param.c-cod-estabel-ini 
          AND doc-fiscal.cod-estabel  <= tt-param.c-cod-estabel-fim
          AND doc-fiscal.vl-icms-com  <> 0,
        EACH it-doc-fisc OF doc-fiscal NO-LOCK:

       find movto-estoq                  
            WHERE movto-estoq.cod-estabel  = doc-fiscal.cod-estabel
              AND movto-estoq.it-codigo    = it-doc-fisc.it-codigo
              AND movto-estoq.nro-docto    = doc-fiscal.nr-doc-fis
              AND movto-estoq.cod-emitente = doc-fiscal.cod-emitente
              AND movto-estoq.nat-operacao = doc-fiscal.nat-operacao
              AND movto-estoq.esp-docto    = 14
              AND movto-estoq.tipo-trans   = 1        EXCLUSIVE-LOCK NO-ERROR.
       DISP doc-fiscal.nr-doc-fis
             doc-fiscal.dt-docto
             it-doc-fisc.it-codigo
             it-doc-fisc.descricao-db
             doc-fiscal.vl-icms-com
        WITH FRAME f-detalhe.
        
        IF AVAIL movto-estoq THEN
           DISP movto-estoq.ct-codigo
                movto-estoq.sc-codigo
          WITH FRAME f-detalhe.

        
       ASSIGN c-alterado = "".
       IF doc-fiscal.vl-icms-com > 0 and
          AVAIL movto-estoq and
          doc-fiscal.dt-impl > param-estoq.ult-fech-dia and
          tt-digita.conta-origem   <> "" AND
          tt-digita.conta-destino  <> "" AND
          tt-digita.ccusto-origem  <> "" AND
          tt-digita.ccusto-destino <> "" AND
          tt-digita.conta-origem    = movto-estoq.ct-codigo AND
          tt-digita.ccusto-origem   = movto-estoq.sc-codigo
       THEN DO:
              ASSIGN movto-estoq.ct-codigo = tt-digita.conta-destino
                     movto-estoq.sc-codigo = tt-digita.ccusto-destino. 
              DISP "Conta Alterada" @ c-alterado 
                    WITH FRAME f-detalhe.
              

              FIND ativo-permanente
                   WHERE ativo-permanente.cod-estabel  = doc-fiscal.cod-estabel
                     AND ativo-permanente.serie        = doc-fiscal.serie
                     AND ativo-permanente.nr-doc-fis   = doc-fiscal.nr-doc-fis
/*                      AND ativo-permanente.cod-emitente = doc-fiscal.cod-emitente */
                     AND ativo-permanente.nat-operacao = doc-fiscal.nat-operacao
                   NO-LOCK NO-ERROR.
              IF NOT AVAIL ATivo-permanente THEN DO:
                  CREATE ativo-permanente.
                  ASSIGN ativo-permanente.cod-estabel   = doc-fiscal.cod-estabel     
                         ativo-permanente.serie         = doc-fiscal.serie           
                         ativo-permanente.nr-doc-fis    = doc-fiscal.nr-doc-fis      
/*                          ativo-permanente.cod-emitente  = doc-fiscal.cod-emitente */
                         ativo-permanente.nat-operacao  = doc-fiscal.nat-operacao  
                         ativo-permanente.dt-docto      = doc-fiscal.dt-docto
                         ativo-permanente.vl-icms-com   = doc-fiscal.vl-icms-com
                         ativo-permanente.vl-parcelado  = doc-fiscal.vl-icms-com / 48
                         ativo-permanente.parcela[1]    = 1
                         ativo-permanente.dt-parcela[1] = doc-fiscal.dt-docto.
              
                  ASSIGN doc-fiscal.vl-icms-com = 0.
              END.
       END.
       DOWN WITH FRAME f-detalhe.

    END.

    PAGE.
    PUT "" skip
        "Acompanhamento:" SKIP 
        "--------------" SKIP
        ""               SKIP
        "Est. Serie Docto     Nat.Oper  Data Docto   Valor Icms Complementar Valor Parcelado Parcela Data Parcela" SKIP
        "---  ----- -------   --------  ----------   ----------------------- --------------- ------- ------------" SKIP.

    FOR EACH ativo-permanente
        BREAK BY ativo-permanente.dt-docto
              BY ativo-permanente.nr-doc-fis:
        IF ativo-permanente.parcela[48] <> 0 THEN NEXT.
        
       PUT  ativo-permanente.cod-estabel    
            ativo-permanente.serie          AT 6 
            ativo-permanente.nr-doc-fis     FORMAT "x(7)"  AT 12
            ativo-permanente.nat-operacao   AT 24
            ativo-permanente.dt-docto       AT 32
            ativo-permanente.vl-icms-com    AT 54
            ativo-permanente.vl-parcelado   AT 70.
        
        ASSIGN de-total-vl-icms-com  = de-total-vl-icms-com + ativo-permanente.vl-icms-com    
               de-total-vl-parcelado = de-total-vl-parcelado + ativo-permanente.vl-parcelado   .
        ASSIGN i-parcela = 1
               da-data = ativo-permanente.dt-docto.
               
        DO i-cont = 1 TO 48:

           IF da-data > tt-param.da-data-fim THEN LEAVE.

           ASSIGN ativo-permanente.parcela[i-parcela]    = i-parcela
                  ativo-permanente.dt-parcela[i-parcela] = da-data.
                  
           ASSIGN da-data-ultima                          = da-data
                  i-parcela-ultima                        = i-parcela
                  da-data                                 = ativo-permanente.dt-docto + (i-cont * 30)
                  i-parcela                               = i-parcela + 1.
           
        END.
        PUT  i-parcela-ultima   FORMAT "99" AT 90
             da-data-ultima     AT 93 SKIP.

        FOR EACH it-doc-fisc NO-LOCK
            WHERE /* it-doc-fisc.cod-emitente = ativo-permanente.cod-emitente
              AND */ it-doc-fisc.cod-estabel  = ativo-permanente.cod-estabel
              AND it-doc-fisc.serie        = ativo-permanente.serie
              AND it-doc-fisc.nr-doc-fis   = ativo-permanente.nr-doc-fis
              AND it-doc-fisc.nat-operacao = ativo-permanente.nat-operacao:
            disp it-doc-fisc.it-codigo    AT 15 NO-LABEL
                it-doc-fisc.descricao-db NO-LABEL WITH FRAME f-det2 WIDTH 500.
        END.
    END.
    PUT  "" skip
         "Total : "              AT 32
         de-total-vl-icms-com    AT 58
         de-total-vl-parcelado   AT 74 SKIP.

END PROCEDURE.
