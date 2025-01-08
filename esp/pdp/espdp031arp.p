 /*********************************************************************************
** Programa: esp/pdp/espdp031arp.p
** VersÆo..: 1.00
** Data....: 16/12/2013
** Autor...: Estevan Krger - Sensus
** Obs.....: Cria‡Æo do pedido de venda conforme planilha importada
             01/09/2014 - Alterado para adaptar ao template relat¢rio.
             
*********************************************************************************/

{include/i-prgvrs.i espdp031arp 2.00.00.000}  
{esp/esb/esesb000.i}
define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

def temp-table tt-raw-digita
    field raw-digita       as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD tp-execucao      AS INTEGER
    FIELD c-arquivo        AS CHARACTER.
    

DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

    FIND LAST param-global NO-LOCK NO-ERROR.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.
/*------------------------*/
/*     I N C L U D E S    */
/*------------------------*/
/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}
{include/i-rpout.i}
{include/i-rpcab.i}
{utp/ut-glob.i}


/* bloco principal do programa */
ASSIGN c-programa     = "espdp031a"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = "Intelbras"
       c-sistema      = "Pedidos"
       c-titulo-relat = "Importa‡Æo Comissoes".



   
        INPUT FROM value(tt-param.c-arquivo) CONVERT SOURCE "iso8859-1".
        
        run utp/ut-acomp.p persistent set h-acomp.  

        RUN pi-inicializar in h-acomp (input "Imprimindo...").
        
        REPEAT:
               IMPORT UNFORMATTED c-linha.
               RUN pi-acompanhar in h-acomp (input "Codigo"  + string(ENTRY(2, c-linha, ";") ) ).
                        
               DO TRANS:
                    FIND comissoes-faixa
                        WHERE comissoes-faixa.cod-rep    = INT(string(ENTRY(2, c-linha, ";") ))
                          AND comissoes-faixa.dt-inicial = DATE(string(ENTRY(3, c-linha, ";") ))
                          AND comissoes-faixa.dt-final   = DATE(string(ENTRY(4, c-linha, ";") ))
                          AND comissoes-faixa.vl-inicial = Dec(string(ENTRY(5, c-linha, ";") ))
                          AND comissoes-faixa.vl-Final = DEC(string(ENTRY(6, c-linha, ";") ))
                        EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL comissoes-faixa THEN DO:
                        IF string(ENTRY(1, c-linha, ";")) = "E" THEN DO:
                            PUT "INFORMA€ÇO ELIMINADA "  comissoes-faixa.cod-rep         " ; "
                                                         comissoes-faixa.dt-inicial      " ; "
                                                         comissoes-faixa.dt-final        " ; "
                                                         comissoes-faixa.vl-inicial      " ; "
                                                         comissoes-faixa.vl-final      " ; "
                                                         comissoes-faixa.vl-percentual  SKIP.
                            DELETE comissoes-faixa.      
                        END.
                        ELSE DO:
                            ASSIGN comissoes-faixa.vl-percentual = DEC(string(ENTRY(7, c-linha, ";") )).
                            PUT "INFORMA€ÇO ATUALIZADA " comissoes-faixa.cod-rep         " ; "
                                                         comissoes-faixa.dt-inicial      " ; "
                                                         comissoes-faixa.dt-final        " ; "
                                                         comissoes-faixa.vl-inicial      " ; "
                                                         comissoes-faixa.vl-final      " ; "
                                                         comissoes-faixa.vl-percentual  SKIP.
                        END.
                    END.
                    ELSE DO:
                        IF string(ENTRY(1, c-linha, ";")) = "I" THEN DO:
                            FIND repres
                                WHERE repres.cod-rep = INT(string(ENTRY(2, c-linha, ";") ))      
                                NO-LOCK NO-ERROR.
                            IF NOT AVAIL repres THEN DO:
                                PUT "Representante nao encontrado, registro nao incluido "  INT(string(ENTRY(2, c-linha, ";") ))   " ; "
                                                                                            DATE(string(ENTRY(3, c-linha, ";") ))  " ; " 
                                                                                            DATE(string(ENTRY(4, c-linha, ";") ))  " ; " 
                                                                                            Dec(string(ENTRY(5, c-linha, ";") ))  " ; "  
                                                                                            DEC(string(ENTRY(6, c-linha, ";") ))  " ; " SKIP.   
                                NEXT.
                            END.
                            IF  DATE(string(ENTRY(3, c-linha, ";") )) > DATE(string(ENTRY(4, c-linha, ";") ))   THEN DO:
                                PUT "Data Inicial maior que data FINAL registro nao incluido "  INT(string(ENTRY(2, c-linha, ";") ))   " ; "
                                                                                            DATE(string(ENTRY(3, c-linha, ";") ))  " ; " 
                                                                                            DATE(string(ENTRY(4, c-linha, ";") ))  " ; " 
                                                                                            Dec(string(ENTRY(5, c-linha, ";") ))  " ; "  
                                                                                            DEC(string(ENTRY(6, c-linha, ";") ))  " ; " SKIP.   
                                NEXT.

                            END.

                            IF   Dec(string(ENTRY(5, c-linha, ";") )) > DEC(string(ENTRY(6, c-linha, ";") ))    THEN DO:
                                PUT "Valor Inicial maior que Valor FINAL registro nao incluido "  INT(string(ENTRY(2, c-linha, ";") ))   " ; "
                                                                                            DATE(string(ENTRY(3, c-linha, ";") ))  " ; " 
                                                                                            DATE(string(ENTRY(4, c-linha, ";") ))  " ; " 
                                                                                            Dec(string(ENTRY(5, c-linha, ";") ))  " ; "  
                                                                                            DEC(string(ENTRY(6, c-linha, ";") ))  " ; " SKIP.   
                                NEXT.

                            END.


                            CREATE COMISSOES-FAIXA.                                                             
                            ASSIGN  comissoes-faixa.cod-rep         = INT(string(ENTRY(2, c-linha, ";") ))      
                                    comissoes-faixa.dt-inicial      = DATE(string(ENTRY(3, c-linha, ";") ))     
                                    comissoes-faixa.dt-final        = DATE(string(ENTRY(4, c-linha, ";") ))     
                                    comissoes-faixa.vl-inicial      = Dec(string(ENTRY(5, c-linha, ";") ))      
                                    comissoes-faixa.vl-final      = DEC(string(ENTRY(6, c-linha, ";") )).
                                    
                            ASSIGN comissoes-faixa.vl-percentual = DEC(string(ENTRY(7, c-linha, ";") )).
                            PUT "INFORMA€ÇO INCLUIDA   " comissoes-faixa.cod-rep         " ; "
                                                         comissoes-faixa.dt-inicial      " ; "
                                                         comissoes-faixa.dt-final        " ; "
                                                         comissoes-faixa.vl-inicial      " ; "
                                                         comissoes-faixa.vl-final      " ; "
                                                         comissoes-faixa.vl-percentual  SKIP.


                        END.
                        ELSE DO:
                        PUT "Exclusao para registro nao encontrado, desconsiderado "  INT(string(ENTRY(2, c-linha, ";") ))   " ; "
                                                                                            DATE(string(ENTRY(3, c-linha, ";") ))  " ; " 
                                                                                            DATE(string(ENTRY(4, c-linha, ";") ))  " ; " 
                                                                                            Dec(string(ENTRY(5, c-linha, ";") ))  " ; "  
                                                                                            DEC(string(ENTRY(6, c-linha, ";") ))  " ; " SKIP.   
                        END.
                    END.
        
                    
               END.
           END.
           INPUT CLOSE.

           RUN pi-finalizar in h-acomp.
        
        

           {include/i-rpclo.i}

       RETURN "OK":U.

    
