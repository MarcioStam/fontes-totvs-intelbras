{include/i-prgvrs.i ESFTP044 2.04.00.002}
/***********************************************************************
**  Programa..: ESP\FTP\ESFTP044DRP.P
**  Autor.....: Anderson Cenci
**  Data......: Mar‡o/2008 - Desenvolvimento
**  Descricao.: INDICE DE ATRASO EM MANUTENCAO
**  VersÆo....: 001 04/04/2008
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ftp/esftp044d.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/

def var i-cont                as integer no-undo.
def var c-mes as char  extent 12 initial ["Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"] format "x(20)".
{utp/utapi019.i}
{upc\btb910za-upc.i}

/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.
def temp-table tt-cat
    field mes                as integer
    field qtd-manutencao     as integer
    field qtd-manut-atrasada as integer
    field percentual         as integer
    index ch-principal mes.

create tt-param.
raw-transfer raw-param to tt-param.
{include/tt-edit.i}
{include/pi-edit.i}

def buffer b-emitente for emitente.
def var h-acomp      as handle no-undo.
FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "INDICE DE ATRASO EM MANUTENCAO"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESFTP044D"
       c-versao       = "2.04"
       c-revisao      = "001".

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

/* **********************  Internal Procedures  *********************** */
 

PROCEDURE piImprimeRelat:
   find estabelec
        where estabelec.cod-estabel = v_cod_estab_usuar
        no-lock no-error.
   find b-emitente
        where b-emitente.cod-emitente = estabelec.cod-emitente
        no-lock no-error.
   for each cat no-lock
       where cat.dt-cat >= DATE("01/01/" + TRIM(tt-param.c-ano))
         and cat.dt-cat <= DATE("31/12/" + TRIM(tt-param.c-ano))
       break by cat.dt-cat:
             
        RUN pi-acompanhar IN h-acomp (INPUT "Lendo CAT:" + string(cat.nr-cat)).
        
        find first tt-cat
             where tt-cat.mes = month(cat.dt-cat) no-lock no-error.
        if not avail tt-cat then do:
           create tt-cat.
           assign tt-cat.mes = month(cat.dt-cat).
        end.
        assign tt-cat.qtd-manutencao = tt-cat.qtd-manutencao + 1.
        IF cat.dt-conserto = ? THEN DO:
           IF cat.dt-encerramento = ? THEN DO:
              if TODAY - cat.dt-cat          > 5 THEN DO:
                 assign tt-cat.qtd-manut-atrasada = tt-cat.qtd-manut-atrasada + 1.        
              END.
           END.
           ELSE DO:
           
               if cat.dt-encerramento - cat.dt-cat          > 5 THEN DO:
                  assign tt-cat.qtd-manut-atrasada = tt-cat.qtd-manut-atrasada + 1.        
               END.
           END.
        END.
        ELSE
            if cat.dt-conserto - cat.dt-cat          > 5 then
               assign tt-cat.qtd-manut-atrasada = tt-cat.qtd-manut-atrasada + 1.        
   end.
   put "MAXCOM - Indice de Atraso em Manuten‡Æo - IAM " tt-param.c-ano skip(2)
       "PROCESSOS: ASSISTÒNCIA TCNICA/LABORATàRIO - ATM/LAB" skip(2)
           "                        Mˆs       Jan       Fev       Mar       Abr       Mai       Jun       Jul       Ago       Set       Out       Nov       Dez" skip.
       put "          Prazo(dias £teis)         5         5         5         5         5         5         5         5         5         5         5         5" skip.
       put "   Qtde total de manuten‡Æo".
   for each tt-cat
       break by tt-cat.mes:
       put tt-cat.qtd-manutencao at 23 + 10 * tt-cat.mes format ">>>>9".
       
       assign tt-cat.percentual = tt-cat.qtd-manut-atrasada / tt-cat.qtd-manutencao * 100.
   end.

   put skip "      Manuten‡äes Atrasadas".
   for each tt-cat
       break by tt-cat.mes:
       put tt-cat.qtd-manut-atrasada  at 23 + 10 * tt-cat.mes format ">>>>9".
   end.   

   put skip "                % Em atraso".   
   for each tt-cat
       break by tt-cat.mes:
       put tt-cat.percentual          at 22 + 10 * tt-cat.mes format ">>>>9"
           "%".
   end.      
   put skip "                       Meta       20%       20%       20%       20%       20%       20%       20%       20%       20%       20%       20%       20%" skip.
   
END PROCEDURE.

