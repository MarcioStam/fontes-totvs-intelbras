DEFINE INPUT  PARAMETER pLayout    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pSaida     AS CHARACTER NO-UNDO.

DEF VAR c-msg-rpw AS CHAR FORMAT "x(1000)".
DEF VAR c-msg-nfe AS CHAR FORMAT "x(1000)".
DEF VAR c-tit-geral AS CHAR FORMAT "x(200)".
DEF VAR c-tit-rpw   AS CHAR FORMAT "x(200)".
DEF VAR c-msg-geral AS CHAR FORMAT "x(1000)".
DEF VAR c-tit-nfe   AS CHAR FORMAT "x(1000)".
DEF VAR i-cont-nfe AS INT.
DEF STREAM s-arquivo.

DEF VAR i-rpw1       AS INT INIT 1 NO-UNDO.
DEF VAR i-rpw2       AS INT INIT 1 NO-UNDO.
DEF VAR i-rpw3       AS INT INIT 1 NO-UNDO.
DEF VAR i-rpw4       AS INT INIT 1 NO-UNDO.
DEF VAR i-rpw5       AS INT INIT 1 NO-UNDO.
DEF VAR i-rpwMEDIO   AS INT INIT 1 NO-UNDO.
DEF VAR i-rpwSPED    AS INT INIT 1 NO-UNDO.
DEF VAR i-rpwTIC     AS INT INIT 1 NO-UNDO.
DEF VAR i-rpwWin1    AS INT INIT 1 NO-UNDO.
DEF VAR i-rpwWin2    AS INT INIT 1 NO-UNDO.
DEF VAR i-rpwTimeout AS INT INIT 1 NO-UNDO.

DEF TEMP-TABLE tt-arquivo
        FIELD linha AS INT
        FIELD conteudo AS CHAR FORMAT "x(1000)".

DEF TEMP-TABLE tt-rpw
        FIELD c-rpw AS CHAR
        FIELD linha AS INT
        FIELD conteudo AS CHAR FORMAT "x(1000)".

DEF TEMP-TABLE tt-nfe
        FIELD cod-estabel AS CHAR
        FIELD linha AS INT
        FIELD conteudo AS CHAR FORMAT "x(1000)".

RUN pi-gera-informacoesRPW.
RUN pi-gera-informacoesNotas.
RUN pi-gera-informacoesGeral.
RUN pi-importa.
RUN pi-altera-campos.
RUN pi-exporta.

PROCEDURE pi-gera-informacoesGeral:

    /*
    DEF VAR i-num-usuarios AS INT NO-UNDO.

    FOR EACH dictdb._connect no-lock
       WHERE dictdb._connect._connect-name <> ?:
        ASSIGN i-num-usuarios = i-num-usuarios + 1.
    END.
    
    ASSIGN c-msg-geral = "Usuários conectados: " + string(i-num-usuarios).
    */

END.

DEF VAR msg   AS CHAR NO-UNDO.
DEF VAR i-msg AS INT NO-UNDO.
ASSIGN msg = "OK"
       i-msg = 1.

DEF VAR l-entrou AS LOG NO-UNDO.

PROCEDURE pi-gera-informacoesRPW:

    DEF VAR i-linha-rpw  AS INT  NO-UNDO.
    
    ASSIGN i-linha-rpw = 1.
    
    FOR EACH servid_exec NO-LOCK:
    
        IF servid_exec.cod_servid_exec = "teste"
        OR servid_exec.cod_servid_exec = "homologa"
        OR servid_exec.cod_servid_exec = "ticdev" THEN NEXT.
    
        ASSIGN msg   = "OK"
               i-msg = 1.

        ASSIGN l-entrou = NO.
    
        bloco-ped:
        FOR EACH ped_exec 
          FIELDS (cod_usuario dat_exec_ped_exec hra_exec_ped_exec hra_ult_atualiz_servid_exec cod_servid_exec ind_sit_ped_exec log_exec_prog_depend num_ped_exec_pai num_ped_exec cdn_estil_dwb dat_ult_atualiz_servid_exec cod_prog_dtsul cod_release_prog_dtsul) NO-LOCK
           WHERE  ped_exec.cod_servid_exec    = servid_exec.cod_servid_exec
             and (ped_exec.ind_sit_ped_exec   = "1"
              OR  ped_exec.ind_sit_ped_exec   = "2")
             AND (ped_exec.dat_exec_ped_exec  < TODAY
              or (ped_exec.dat_exec_ped_exec  = TODAY
             and  ped_exec.hra_exec_ped_exec <= REPLACE(STRING(TIME,'hh:mm:ss'),":","")))
        BREAK BY  ped_exec.cod_servid_exec
              BY  ped_exec.dat_exec_ped_exec
              BY  ped_exec.hra_exec_ped_exec
              BY  ped_exec.num_ped_exec: 

            ASSIGN msg   = "OK"
                   i-msg = 1.

            IF ped_exec.dat_exec_ped_exec > TODAY THEN NEXT bloco-ped.
            /*IF ped_exec.log_exec_prog_depend = YES THEN NEXT bloco-ped.*/


            
            IF FIRST-OF(ped_exec.cod_servid_exec) THEN DO:

                ASSIGN msg   = "EXECUTANDO"
                       i-msg = 2.
					   
				/* TIMEOUT */
				IF l-entrou = NO
                AND ped_exec.hra_ult_atualiz_servid_exec <> ""
				AND servid_exec.cod_servid_exec = "timeout"
                AND REPLACE(STRING(TIME - 1800,"HH:MM:SS"),":","") > ped_exec.hra_ult_atualiz_servid_exec THEN DO:
                    ASSIGN msg   = "PARADO?"
                           i-msg = 4
						   i-rpwTimeout = i-msg.

                    ASSIGN l-entrou = YES.
                END.

                IF l-entrou = NO
                AND ped_exec.dat_exec_ped_exec < TODAY THEN DO:
                    ASSIGN msg   = "PARADO?"
                           i-msg = 4.

                    ASSIGN l-entrou = YES.

                END.
            
                IF l-entrou = NO
                AND ped_exec.hra_ult_atualiz_servid_exec <> ""
                AND REPLACE(STRING(TIME - 900,"HH:MM:SS"),":","") > ped_exec.hra_ult_atualiz_servid_exec THEN DO:
                    ASSIGN msg   = "PARADO?"
                           i-msg = 4.

                    ASSIGN l-entrou = YES.

                END.

                IF l-entrou = NO
                AND ped_exec.hra_ult_atualiz_servid_exec = ""
                AND REPLACE(STRING(TIME - 900,"HH:MM:SS"),":","") > ped_exec.hra_exec_ped_exec THEN DO:
                    ASSIGN msg   = "PARADO?"
                           i-msg = 4.

                    ASSIGN l-entrou = YES.
                END.
        
                IF l-entrou = NO
                AND ped_exec.hra_ult_atualiz_servid_exec <> ""
                AND REPLACE(STRING(TIME - 900,"HH:MM:SS"),":","") > ped_exec.hra_ult_atualiz_servid_exec THEN DO:
                    ASSIGN msg   = "ATRASADO?"
                           i-msg = 3.

                    ASSIGN l-entrou = YES.
                END.

                CASE servid_exec.cod_servid_exec:            
                    WHEN "rpw1"      THEN i-rpw1        = i-msg. 
                    WHEN "rpw2"      THEN i-rpw2        = i-msg. 
                    WHEN "rpw3"      THEN i-rpw3        = i-msg. 
                    WHEN "rpw4"      THEN i-rpw4        = i-msg. 
                    WHEN "rpw5"      THEN i-rpw5        = i-msg. 
                    WHEN "rpwMEDIO"  THEN i-rpwMEDIO    = i-msg. 
                    WHEN "rpwSPED"   THEN i-rpwSPED     = i-msg. 
                    WHEN "rpwTIC"    THEN i-rpwTIC      = i-msg. 
                    WHEN "rpwWin"    THEN i-rpwWin1     = i-msg. 
                    WHEN "rpwWin2"   THEN i-rpwWin2     = i-msg.                     
                END CASE. 

            END.
        
            FIND FIRST usuar_mestre NO-LOCK
                 WHERE usuar_mestre.cod_usuario = ped_exec.cod_usuario NO-ERROR.

            CREATE tt-rpw.
            ASSIGN tt-rpw.c-rpw    = ped_exec.cod_servid_exec
                   tt-rpw.linha    = i-linha-rpw
                   tt-rpw.conteudo = "<tr class='" + "" + "'><td>" +
                                     STRING(ped_exec.dat_exec_ped_exec) + 
                                     "</td><td>" +
                                     STRING(ped_exec.hra_exec_ped_exec,"99:99:99") + 
                                     "</td><td>" +
                                     STRING(ped_exec.cod_servid_exec) + 
                                     "</td><td>" +
                                     STRING(ped_exec.cod_prog_dtsul) + 
                                     "</td><td>" +
                                     STRING(ped_exec.cod_usuario) + " - " + STRING(usuar_mestre.nom_usuario) +
                                     "</td><td>" +
                                     (IF ped_exec.dat_ult_atualiz_servid_exec <> ? THEN STRING(ped_exec.dat_ult_atualiz_servid_exec) ELSE "") +
                                     "</td><td>" +
                                     STRING(ped_exec.hra_ult_atualiz_servid_exec,"99:99:99") +
                                     "</td></tr>".
            ASSIGN i-linha-rpw = i-linha-rpw + 1.
            
        END.
    END.

END PROCEDURE.


PROCEDURE pi-gera-informacoesNotas:

    DEF VAR c-cor AS CHAR INITIAL "" NO-UNDO.
    DEF VAR i-linha-nfe  AS INT  NO-UNDO.

    ASSIGN i-linha-nfe = 1.

    FOR EACH nota-fiscal no-lock
       WHERE nota-fiscal.dt-emis-nota >= TODAY - 60
         AND LOOKUP(STRING(nota-fiscal.idi-sit-nf-eletro), "1,2,5,12,13") > 0
          BY nota-fiscal.idi-sit-nf-eletro DESC:

        IF NOT CAN-FIND(FIRST ser-estab 
                        WHERE ser-estab.cod-estabel = nota-fiscal.cod-estabel 
                          AND ser-estab.serie       = nota-fiscal.serie    
                          AND ser-estab.log-nf-eletro) THEN NEXT.		

        ASSIGN c-cor = "".

        IF nota-fiscal.idi-sit-nf-eletro = 2
        AND STRING(TIME - 600,"HH:MM") > STRING(nota-fiscal.hr-atualiza) THEN
            ASSIGN c-cor = "yellow".

        IF nota-fiscal.idi-sit-nf-eletro = 2
        AND STRING(TIME - 900,"HH:MM") > STRING(nota-fiscal.hr-atualiza) THEN
            ASSIGN c-cor = "red-bold".

        IF nota-fiscal.dt-emis-nota < TODAY THEN
            ASSIGN c-cor = "red-bold".

        IF nota-fiscal.idi-sit-nf-eletro = 2
        AND STRING(TIME - 1800,"HH:MM") > STRING(nota-fiscal.hr-atualiza) THEN
            ASSIGN c-cor = "black-bold".

        CREATE tt-nfe.                                                    
        ASSIGN tt-nfe.cod-estabel = nota-fiscal.cod-estabel
               tt-nfe.linha       = i-linha-nfe                              
               tt-nfe.conteudo    = "<tr class='" + c-cor + "'><td>" +
                                    STRING(nota-fiscal.cod-estabel) + 
                                    "</td><td>" + 
                                    STRING(nota-fiscal.serie) + 
                                    "</td><td>" + 
                                    STRING(nota-fiscal.nr-nota-fis) + 
                                    "</td><td>".
        
        CASE nota-fiscal.idi-sit-nf-eletro:
		    WHEN 1  THEN ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + "NF-e não gerada".                
            WHEN 2  THEN ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + "Em processamento".                
            WHEN 5  THEN ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + "Documento Rejeitado".             
            WHEN 12 THEN ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + "NF-e em Processo de Cancelamento".
            WHEN 13 THEN ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + "NF-e em Processo de Inutilização".
        END CASE.

        FOR LAST integr-totvs-colab NO-LOCK 
           WHERE /*integr-totvs-colab.cod-edi   >= "170" 
             AND integr-totvs-colab.cod-edi   <= "172" 
             AND*/ integr-totvs-colab.cod-origem = 1
             AND integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro: END.

        IF NOT AVAIL integr-totvs-colab THEN DO:
            ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + 
                                     "</td><td>" + 
                                     STRING(nota-fiscal.dt-atualiza) + 
                                     "</td><td>" + 
                                     STRING(nota-fiscal.hr-atualiza) + 
                                     "</td>".
        END.
        ELSE DO:
            ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + 
                                     "</td><td>" + 
                                     STRING(integr-totvs-colab.dat-reg) + 
                                     "</td><td>" + 
                                     STRING(integr-totvs-colab.hra-reg) + 
                                     "</td>".
        END.

        IF nota-fiscal.idi-sit-nf-eletro <> 2 THEN DO:
            FIND LAST ret-nf-eletro NO-LOCK
                WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
    		      AND ret-nf-eletro.cod-serie   = nota-fiscal.serie  
    			  AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.
            IF AVAIL ret-nf-eletro THEN
                ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + 
                                         "<td><a data-toggle='tooltip' title='" +
    									 TRIM(ret-nf-eletro.cod-livre-2) + 
    									 "'>Msg</a></td></tr>".
            ELSE
                ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + 
                                         "<td></td></tr>".
        END.
        ELSE 
            ASSIGN tt-nfe.conteudo = tt-nfe.conteudo + 
                                         "<td></td></tr>".

        ASSIGN i-cont-nfe  = i-cont-nfe + 1.
        ASSIGN i-linha-nfe = i-linha-nfe + 1.
    
    END.
    
    ASSIGN c-tit-nfe   = '          <h4 class="sub-header">Notas Fiscais (' + STRING(i-cont-nfe) + ')</h4>'.
    ASSIGN c-tit-geral = '          <a class="navbar-brand" href="#">Atualizado: ' + STRING(TIME,"HH:MM:SS") + '</a>'.
    
END PROCEDURE.

PROCEDURE pi-importa:

    DEF VAR c-arquivo AS CHAR FORMAT "x(150)" NO-UNDO.
    DEF VAR i-linha  AS INT  NO-UNDO.

    IF SEARCH(pLayout) <> ? THEN DO:
        
        INPUT STREAM s-arquivo FROM VALUE(pLayout).
        
        ASSIGN i-linha = 0.
        
        REPEAT:
            IMPORT STREAM s-arquivo UNFORMATTED c-arquivo NO-ERROR.
        
            ASSIGN i-linha = i-linha + 1.
            
            CREATE tt-arquivo.
            ASSIGN tt-arquivo.linha    = i-linha
                   tt-arquivo.conteudo = c-arquivo.
        
        END.

    END.

END PROCEDURE.

PROCEDURE pi-altera-campos:

    DEF VAR c-rpw1       AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpw2       AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpw3       AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpw4       AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpw5       AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpwMEDIO   AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpwSPED    AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpwTIC     AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpwWin1    AS CHAR INIT "btn btn-info" NO-UNDO.
    DEF VAR c-rpwWin2    AS CHAR INIT "btn btn-info" NO-UNDO.
	DEF VAR c-rpwTimeout AS CHAR INIT "btn btn-info" NO-UNDO.

    CASE i-rpw1:
        WHEN 1 THEN c-rpw1 = "btn btn-success". 
        WHEN 2 THEN c-rpw1 = "btn btn-info".
        WHEN 3 THEN c-rpw1 = "btn btn-warning".
        WHEN 4 THEN c-rpw1 = "btn btn-danger".
        WHEN 5 THEN c-rpw1 = "btn btn-dark".
    END CASE.
    CASE i-rpw2:
        WHEN 1 THEN c-rpw2 = "btn btn-success".         
        WHEN 2 THEN c-rpw2 = "btn btn-info".            
        WHEN 3 THEN c-rpw2 = "btn btn-warning".         
        WHEN 4 THEN c-rpw2 = "btn btn-danger".          
        WHEN 5 THEN c-rpw2 = "btn btn-dark".            
    END CASE.
    CASE i-rpw3:
        WHEN 1 THEN c-rpw3 = "btn btn-success".         
        WHEN 2 THEN c-rpw3 = "btn btn-info".            
        WHEN 3 THEN c-rpw3 = "btn btn-warning".         
        WHEN 4 THEN c-rpw3 = "btn btn-danger".          
        WHEN 5 THEN c-rpw3 = "btn btn-dark".            
    END CASE.
    CASE i-rpw4:
        WHEN 1 THEN c-rpw4 = "btn btn-success".         
        WHEN 2 THEN c-rpw4 = "btn btn-info".            
        WHEN 3 THEN c-rpw4 = "btn btn-warning".         
        WHEN 4 THEN c-rpw4 = "btn btn-danger".          
        WHEN 5 THEN c-rpw4 = "btn btn-dark".            
    END CASE.
    CASE i-rpw5:
        WHEN 1 THEN c-rpw5 = "btn btn-success".         
        WHEN 2 THEN c-rpw5 = "btn btn-info".            
        WHEN 3 THEN c-rpw5 = "btn btn-warning".         
        WHEN 4 THEN c-rpw5 = "btn btn-danger".          
        WHEN 5 THEN c-rpw5 = "btn btn-dark".            
    END CASE.
    CASE i-rpwMEDIO:
        WHEN 1 THEN c-rpwMEDIO = "btn btn-success".         
        WHEN 2 THEN c-rpwMEDIO = "btn btn-info".            
        WHEN 3 THEN c-rpwMEDIO = "btn btn-warning".         
        WHEN 4 THEN c-rpwMEDIO = "btn btn-danger".          
        WHEN 5 THEN c-rpwMEDIO = "btn btn-dark".            
    END CASE.
    CASE i-rpwSPED:
        WHEN 1 THEN c-rpwSPED = "btn btn-success".         
        WHEN 2 THEN c-rpwSPED = "btn btn-info".            
        WHEN 3 THEN c-rpwSPED = "btn btn-warning".         
        WHEN 4 THEN c-rpwSPED = "btn btn-danger".          
        WHEN 5 THEN c-rpwSPED = "btn btn-dark".            
    END CASE.
    CASE i-rpwTIC:
        WHEN 1 THEN c-rpwTIC = "btn btn-success".         
        WHEN 2 THEN c-rpwTIC = "btn btn-info".            
        WHEN 3 THEN c-rpwTIC = "btn btn-warning".         
        WHEN 4 THEN c-rpwTIC = "btn btn-danger".          
        WHEN 5 THEN c-rpwTIC = "btn btn-dark".            
    END CASE.
    CASE i-rpwWin1:
        WHEN 1 THEN c-rpwWin1 = "btn btn-success".         
        WHEN 2 THEN c-rpwWin1 = "btn btn-info".            
        WHEN 3 THEN c-rpwWin1 = "btn btn-warning".         
        WHEN 4 THEN c-rpwWin1 = "btn btn-danger".          
        WHEN 5 THEN c-rpwWin1 = "btn btn-dark".            
    END CASE.
    CASE i-rpwWin2:
        WHEN 1 THEN c-rpwWin2 = "btn btn-success".         
        WHEN 2 THEN c-rpwWin2 = "btn btn-info".            
        WHEN 3 THEN c-rpwWin2 = "btn btn-warning".         
        WHEN 4 THEN c-rpwWin2 = "btn btn-danger".          
        WHEN 5 THEN c-rpwWin2 = "btn btn-dark".            
    END CASE.
    CASE i-rpwTimeout:
        WHEN 1 THEN c-rpwTimeout = "btn btn-success".         
        WHEN 2 THEN c-rpwTimeout = "btn btn-info".            
        WHEN 3 THEN c-rpwTimeout = "btn btn-warning".         
        WHEN 4 THEN c-rpwTimeout = "btn btn-danger".          
        WHEN 5 THEN c-rpwTimeout = "btn btn-dark".            
    END CASE.

    FOR EACH tt-arquivo:

        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#titulo-geral",c-tit-geral).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#titulo-nfe"  ,c-tit-nfe).
		
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#msg-geral",c-msg-geral).        

        DEF VAR i-cont-reg AS INT NO-UNDO.

        FOR EACH tt-rpw
           BREAK BY tt-rpw.c-rpw:

            IF FIRST-OF(tt-rpw.c-rpw) THEN
                ASSIGN i-cont-reg = 0.

            ASSIGN i-cont-reg = i-cont-reg + 1.

            IF  LAST-OF(tt-rpw.c-rpw)
            AND i-cont-reg > 5 THEN DO:
                CASE tt-rpw.c-rpw:                                                                                                                                                               
                    WHEN "rpw1"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw1"    ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpw2"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw2"    ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpw3"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw3"    ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpw4"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw4"    ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpw5"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw5"    ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpwMEDIO" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwMEDIO","<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpwSPED"  THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwSPED" ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpwTIC"   THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwTIC"  ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpwWin"   THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwWin1" ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "rpwWin2"  THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwWin2" ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                    WHEN "timeout"  THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-timeout" ,"<tr class='red-bold'><td>+ " + STRING(i-cont-reg - 5) + "</td><td>pedidos</td><td>" + tt-rpw.c-rpw + "</td><td></td><td></td><td></td><td></td></tr>" + CHR(13)).                    
                END CASE.  
            END.
            
            IF i-cont-reg > 5 THEN
                NEXT.

            IF i-cont-reg <= 5 THEN DO:
                CASE tt-rpw.c-rpw:
                    WHEN "rpw1"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw1"    ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpw1"    ).
                    WHEN "rpw2"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw2"    ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpw2"    ).
                    WHEN "rpw3"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw3"    ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpw3"    ).
                    WHEN "rpw4"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw4"    ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpw4"    ).
                    WHEN "rpw5"     THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw5"    ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpw5"    ).
                    WHEN "rpwMEDIO" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwMEDIO",tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpwMEDIO").
                    WHEN "rpwSPED"  THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwSPED" ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpwSPED" ).
                    WHEN "rpwTIC"   THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwTIC"  ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpwTIC"  ).
                    WHEN "rpwWin"   THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwWin1" ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpwWin1" ).
                    WHEN "rpwWin2"  THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwWin2" ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-rpwWin2" ).
                    WHEN "timeout"  THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-timeout" ,tt-rpw.conteudo + CHR(13) + "#tabela-rpw-timeout" ).
                END CASE.
            END.

        
        END.

        FOR EACH tt-nfe
           BREAK BY tt-nfe.cod-estabel
                 BY tt-nfe.linha:
            
            CASE tt-nfe.cod-estabel:
                WHEN "101" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-101",tt-nfe.conteudo + CHR(10) + "#tabela-nfe-101").
                WHEN "103" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-103",tt-nfe.conteudo + CHR(10) + "#tabela-nfe-103").
                WHEN "104" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-104",tt-nfe.conteudo + CHR(10) + "#tabela-nfe-104").
                WHEN "105" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-105",tt-nfe.conteudo + CHR(10) + "#tabela-nfe-105").
                WHEN "108" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-108",tt-nfe.conteudo + CHR(10) + "#tabela-nfe-108").
                WHEN "109" THEN ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-109",tt-nfe.conteudo + CHR(10) + "#tabela-nfe-109").
            END CASE.
        END.
        
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw1"    ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw2"    ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw3"    ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw4"    ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpw5"    ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwMEDIO","").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwSPED" ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwTIC"  ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwWin1" ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-rpwWin2" ,"").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-rpw-timeout" ,"").
        
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-101","").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-103","").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-104","").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-105","").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-108","").
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#tabela-nfe-109","").

        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btn1"      ,c-rpw1      ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btn2"      ,c-rpw2      ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btn3"      ,c-rpw3      ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btn4"      ,c-rpw4      ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btn5"      ,c-rpw5      ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btnMEDIO"  ,c-rpwMEDIO  ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btnSPED"   ,c-rpwSPED   ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btnTIC"    ,c-rpwTIC    ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btnWin1"   ,c-rpwWin1   ).
        ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btnWin2"   ,c-rpwWin2   ).
		ASSIGN tt-arquivo.conteudo = REPLACE(tt-arquivo.conteudo,"#btnTimeout",c-rpwTimeout   ).

    END.

END PROCEDURE.

PROCEDURE pi-exporta:

    OUTPUT TO VALUE(pSaida).
    FOR EACH tt-arquivo
          BY tt-arquivo.linha:
        PUT UNFORMATTED tt-arquivo.conteudo SKIP.
    END.
    OUTPUT CLOSE.
    
END PROCEDURE.

RETURN "OK".

