

/***********************************************************************
**  Programa..: ESP\FTP\esftp051RP.P
**  Autor.....: Anderson Cenci
**  Data......: Julho/2008
**  Descricao.: Relatorio de Notas Geradas Diariamente
**  Vers’o....: 001 15/07/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esftp051 2.04.00.002}

/****************************  Definitions  ****************************/
{esp/ftp/esftp051tt.i}
/****************************  Variaveis    ****************************/
/* DEFINE BUFFER bfam-comerc FOR fam-comerc. */

def var da-data          as DATE COLUMN-LABEL "Data Emiss’o" FORMAT "99/99/9999".
def var da-data-ini      like nota-fiscal.dt-emis-nota.
def var da-data-fim      like nota-fiscal.dt-emis-nota.

DEF VAR de-vl-total      AS DECIMAL COLUMN-LABEL "Valor Total " FORMAT ">>>>,>>>,>>9.99".
DEF VAR i-nr-volumes     AS INTEGER COLUMN-LABEL "Nr.Volumes" FORMAT ">>>9".
DEF VAR i-nr-notas       AS INTEGER COLUMN-LABEL "Nr.Notas" format ">>>9" .

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 
OVERLAY(tt-param.arquivo, LENGTH(tt-param.arquivo) - 2, 3) = "csv".
{include/i-rpvar.i}

def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec­ficos Intelbras"
       c-titulo-relat = "Notas Fiscais por Dia"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "esftp051"
       c-versao       = "2.04"
       c-revisao      = "001".


/* ***************************  Main Block  *************************** */

do on stop undo, leave:
   {include/i-rpcab.i}
   {include/i-rpout.i &pagesize="64"}
    
   
   
    
   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.
   
   PAGE.

   PUT "Selecao " SKIP
       "Estabelecimento : " tt-param.cod-estabel-ini " <> " AT 30
       tt-param.cod-estabel-fim                           SKIP
       "    Dt. Saida   : " tt-param.dt-saida-ini  " <> " AT 30
       tt-param.dt-saida-fim                            SKIP
       "    Dt. Emissao : " tt-param.dt-emissao-ini  " <> " AT 30
       tt-param.dt-emissao-fim                            SKIP

       "   Cod.Emitente : " tt-param.cod-cli-ini     " <> " AT 30
       tt-param.cod-cli-fim                               SKIP
       "Lista notas Sem data de Saida : " tt-param.tb-notas-sem-data-saida FORMAT "Sim/Nao" SKIP
       "Lista Notas : " tt-param.tb-notas FORMAT "Sim/Nao".
   {include/i-rpclo.i}
   run pi-finalizar in h-acomp.
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:
 FIND FIRST estabelec NO-LOCK NO-ERROR.
       
   IF tt-param.cod-transp-ini = tt-param.cod-transp-fim THEN DO:
       FIND transporte
            WHERE transporte.cod-transp = tt-param.cod-transp-ini
           NO-LOCK NO-ERROR.
       PUT "Transportadora : " transporte.cod-transp " - " transporte.nome SKIP(2).
   END.
   IF tt-param.tb-notas-sem-data-saida = YES THEN DO:
       ASSIGN   c-titulo-relat = "Notas Sem Data de Saida".
       IF tt-param.tb-notas = yes THEN DO:
          PUT  "Data Emis.;Nota Fiscal;Nr.Vol;Total Nota;Transportador;Estabelecimento;Data Saida;Cod.Cliente;Po Cliente" SKIP.
       END.
       ELSE DO:
          PUT  "Data Emis.;Nr.Notas;Nr.Vol;Total Nota;Estabelecimento" SKIP.
       END.

      FOR EACH nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini
           AND   nota-fiscal.cod-estabel <= tt-param.cod-estabel-fim
           AND   nota-fiscal.dt-emis-nota >= tt-param.dt-emissao-ini
           AND   nota-fiscal.dt-emis-nota <= tt-param.dt-emissao-fim
           AND   nota-fiscal.cod-emitente >= tt-param.cod-cli-ini
           AND   nota-fiscal.cod-emitente <= tt-param.cod-cli-fim
           AND   nota-fiscal.dt-cancel    = ?
           AND   nota-fiscal.dt-saida = ?,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
           AND   natur-oper.tipo = 2,
           first transporte
           WHERE transporte.nome-abrev = nota-fiscal.nome-transp 
             AND transporte.cod-transp >= tt-param.cod-transp-ini 
             AND transporte.cod-transp <= tt-param.cod-transp-fim NO-LOCK
           BREAK BY nota-fiscal.dt-emis-nota:
    
           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Faturamento data:" + string(nota-fiscal.dt-saida,"99/99/9999")).

           IF nota-fiscal.cdd-embarq = 0 AND tt-param.tb-embarque = YES THEN NEXT.
    
           IF NOT AVAIL estabelec OR
              estabelec.cod-estabel <> nota-fiscal.cod-estabel THEN
              FIND estabelec
                       WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel
                       NO-LOCK NO-ERROR.
               
          ASSIGN de-vl-total  = de-vl-total   + nota-fiscal.vl-tot-nota
                 i-nr-volumes = i-nr-volumes + int(nota-fiscal.nr-volumes)
                 i-nr-notas   = i-nr-notas   + 1.

          IF tt-param.cod-atendente-ini <> 0 OR
             tt-param.cod-atendente-fim <> 99 THEN DO:
              FIND FIRST ped-venda NO-LOCK
               WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                 AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
              IF AVAIL ped-venda THEN DO:
                  FIND FIRST atendente NO-LOCK
                  WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                     AND atendente.cd-oper >= tt-param.cod-atendente-ini
                     AND atendente.cd-oper <= tt-param.cod-atendente-fim NO-ERROR.
                  FIND FIRST int-ped-venda NO-LOCK
                      WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                        AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
                  
                  IF AVAIL atendente THEN DO:
                      IF tt-param.tb-notas = YES THEN DO:
                      
                          PUT UNFORMATTED nota-fiscal.dt-saida     ";"
                                          nota-fiscal.nr-nota-fis  ";"
                                          nota-fiscal.nr-volumes   ";"
                                          nota-fiscal.vl-tot-nota  ";"
                                          nota-fiscal.nome-transp  ";"
                                          nota-fiscal.cod-estabel  ";"
                                          nota-fiscal.dt-emis-nota ";"
                                          nota-fiscal.cod-emitente ";".

                          IF AVAIL int-ped-venda THEN
                              PUT UNFORMATTED SUBSTRING(int-ped-venda.char-1,53,12).

                          PUT SKIP.
                      END.
                      
                      IF LAST-OF(nota-fiscal.dt-emis-nota) THEN DO: 
                          IF tt-param.tb-notas = no THEN DO:
                              PUT UNFORMATTED nota-fiscal.dt-emis-nota    ";"   
                                              i-nr-notas                  ";"
                                              i-nr-volumes FORMAT ">>>>9" ";"
                                              de-vl-total                 ";"
                                              nota-fiscal.cod-estabel     ";" SKIP.
                          END.
                          ELSE DO:
                              PUT "TOTAL "   ";"
                                  i-nr-notas ";" 
                                  "Notas"
                                  i-nr-volumes FORMAT ">>>>9" ";"
                                  de-vl-total                 ";" SKIP.
                              
                              PUT "" SKIP.
                          END.
                          ASSIGN de-vl-total  = 0
                                 i-nr-volumes = 0
                                 i-nr-notas   = 0.
                  
                      END. 
                  END.
              END.
          END.
          ELSE DO:
              IF tt-param.tb-notas = YES THEN DO:
              
                  PUT UNFORMATTED nota-fiscal.dt-saida     ";"
                                  nota-fiscal.nr-nota-fis  ";"
                                  nota-fiscal.nr-volumes   ";"
                                  nota-fiscal.vl-tot-nota  ";"
                                  nota-fiscal.nome-transp  ";"
                                  nota-fiscal.cod-estabel  ";"
                                  nota-fiscal.dt-emis-nota ";"
                                  nota-fiscal.cod-emitente ";".
              
              FIND FIRST int-ped-venda NO-LOCK
                  WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                    AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.

              IF AVAIL int-ped-venda THEN
                  PUT UNFORMATTED SUBSTRING(int-ped-venda.char-1,53,12).
              PUT SKIP.

              END.

              IF LAST-OF(nota-fiscal.dt-emis-nota) THEN DO: 
                  IF tt-param.tb-notas = no THEN DO:
                 
                      PUT UNFORMATTED     ";"  
                                      i-nr-notas                  ";"
                                      i-nr-volumes FORMAT ">>>>9" ";"
                                      de-vl-total                 ";"
                                      nota-fiscal.cod-estabel     ";" SKIP.

                  END.
                  ELSE DO:
                      PUT "TOTAL "   ";"
                          i-nr-notas ";" 
                          "Notas"
                          i-nr-volumes FORMAT ">>>>9" ";"
                          de-vl-total                 ";" SKIP.

                      PUT "" SKIP.
                  END.

                  ASSIGN de-vl-total  = 0
                         i-nr-volumes = 0
                         i-nr-notas   = 0.

              END. 
          END.                              
      END.
   END.
   ELSE DO:
       IF tt-param.tb-notas = no THEN
           PUT  "Data Saida;Nr.Notas;Nr.Vol;Total Nota;Estabelecimento" SKIP.
       ELSE
           PUT  "Data Saida;Nota Fiscal;Nr.Vol;Total Nota;Transportador;Estabelecimento;Data EmissÆo;Cod.Cliente;Po Cliente" SKIP.
       FOR EACH  nota-fiscal NO-LOCK
           WHERE nota-fiscal.cod-estabel  >= tt-param.cod-estabel-ini
           AND   nota-fiscal.cod-estabel  <= tt-param.cod-estabel-fim
           AND   nota-fiscal.cod-emitente >= tt-param.cod-cli-ini
           AND   nota-fiscal.cod-emitente <= tt-param.cod-cli-fim
           AND   nota-fiscal.dt-emis-nota >= tt-param.dt-emissao-ini
           AND   nota-fiscal.dt-emis-nota <= tt-param.dt-emissao-fim
           AND   nota-fiscal.dt-saida >= tt-param.dt-saida-ini
           AND   nota-fiscal.dt-saida <= tt-param.dt-saida-fim
           AND   nota-fiscal.dt-cancel    = ?,
           FIRST natur-oper NO-LOCK
           WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao
           AND   natur-oper.tipo = 2,
           first transporte
           WHERE transporte.nome-abrev = nota-fiscal.nome-transp
             AND transporte.cod-transp >= tt-param.cod-transp-ini
             AND transporte.cod-transp <= tt-param.cod-transp-fim NO-LOCK
           BREAK BY nota-fiscal.dt-saida:

           RUN pi-acompanhar IN h-acomp (INPUT "Selecionando Faturamento data:" + string(nota-fiscal.dt-saida,"99/99/9999")).

           IF nota-fiscal.cdd-embarq = 0 AND tt-param.tb-embarque = YES THEN NEXT.
           
           
           IF NOT AVAIL estabelec OR
              estabelec.cod-estabel <> nota-fiscal.cod-estabel THEN
              FIND estabelec
                       WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel
                       NO-LOCK NO-ERROR.
          
          ASSIGN de-vl-total  = de-vl-total   + nota-fiscal.vl-tot-nota
                 i-nr-volumes = i-nr-volumes + int(nota-fiscal.nr-volumes)
                 i-nr-notas   = i-nr-notas   + 1.

          IF tt-param.cod-atendente-ini <> 0 OR
             tt-param.cod-atendente-fim <> 99 THEN DO:

              FIND FIRST ped-venda NO-LOCK
               WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                 AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

              FIND int-ped-venda
                  WHERE int-ped-venda.nr-pedido = ped-venda.nr-pedido
                    AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-LOCK NO-ERROR.
              
              IF AVAIL ped-venda THEN DO:
                  FIND FIRST atendente NO-LOCK
                  WHERE atendente.cd-oper = int(ped-venda.tp-pedido)
                     AND atendente.cd-oper >= tt-param.cod-atendente-ini
                     AND atendente.cd-oper <= tt-param.cod-atendente-fim NO-ERROR.
                  
		  IF AVAIL atendente THEN DO:
                  IF tt-param.tb-notas = YES THEN DO:

                      PUT UNFORMATTED nota-fiscal.dt-saida     ";"
                                      nota-fiscal.nr-nota-fis  ";"
                                      nota-fiscal.nr-volumes   ";"
                                      nota-fiscal.vl-tot-nota  ";"
                                      nota-fiscal.nome-transp  ";"
                                      nota-fiscal.cod-estabel  ";"
                                      nota-fiscal.dt-emis-nota ";"
                                      nota-fiscal.cod-emitente ";".
                      
                      IF AVAIL int-ped-venda THEN
                          PUT SUBSTRING(int-ped-venda.char-1,53,12).
                      
                      PUT SKIP.
                  END.
                  
                  IF LAST-OF(nota-fiscal.dt-saida) THEN DO: 
                      IF tt-param.tb-notas = no THEN
                         PUT UNFORMATTED nota-fiscal.dt-saida        ";"
                                         i-nr-notas                  ";"
                                         i-nr-volumes FORMAT ">>>>9" ";"
                                         de-vl-total                 ";"
                                         nota-fiscal.cod-estabel     ";".
                      ELSE
                          PUT UNFORMATTED "TOTAL "                    ";"
                                          i-nr-notas                  ";" 
                                          "Notas"
                                          i-nr-volumes FORMAT ">>>>9" ";"
                                          de-vl-total                 ";" .

                      PUT SKIP.

                      IF tt-param.tb-notas = YES THEN
                         PUT "" SKIP.
                      ASSIGN de-vl-total  = 0
                             i-nr-volumes = 0
                             i-nr-notas   = 0.
                  END. 
              END.
          END.
       END.
       ELSE DO:
           
           FIND FIRST ped-venda NO-LOCK
               WHERE ped-venda.nome-abrev = nota-fiscal.nome-ab-cli
                 AND ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.

           FIND int-ped-venda NO-LOCK
               WHERE int-ped-venda.nr-pedido   = ped-venda.nr-pedido
                 AND int-ped-venda.cod-estabel = ped-venda.cod-estabel NO-ERROR.
           
           IF tt-param.tb-notas = YES THEN DO:
               
               PUT UNFORMATTED nota-fiscal.dt-saida     ";"
                               nota-fiscal.nr-nota-fis  ";"
                               nota-fiscal.nr-volumes   ";"
                               nota-fiscal.vl-tot-nota  ";"
                               nota-fiscal.nome-transp  ";"
                               nota-fiscal.cod-estabel  ";"
                               nota-fiscal.dt-emis-nota ";"
                               nota-fiscal.cod-emitente ";".

               IF AVAIL int-ped-venda THEN
                   PUT SUBSTRING(int-ped-venda.char-1,53,12).

               PUT SKIP.
           END.
           
          IF LAST-OF(nota-fiscal.dt-saida) THEN DO: 
               IF tt-param.tb-notas = no THEN
                  PUT UNFORMATTED nota-fiscal.dt-saida        ";"
                                  i-nr-notas                  ";"
                                  i-nr-volumes FORMAT ">>>>9" ";"
                                  de-vl-total                 ";"
                                  nota-fiscal.cod-estabel     ";" .
               ELSE
                  PUT UNFORMATTED "TOTAL "                    ";"
                                  i-nr-notas                  ";" 
                                  "Notas"
                                  i-nr-volumes FORMAT ">>>>9" ";"
                                  de-vl-total                 ";".

               PUT SKIP.
               
               IF tt-param.tb-notas = YES THEN
                     PUT "" SKIP.
                  ASSIGN de-vl-total  = 0
                         i-nr-volumes = 0
                         i-nr-notas   = 0.
          END. 
       END.
   END.
END.
END PROCEDURE.





