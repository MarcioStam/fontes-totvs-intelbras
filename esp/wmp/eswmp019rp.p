{include/i-freeac.i}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG.

DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.

DEFINE input parameter raw-param as raw no-undo.
DEFINE input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

DEF VAR c-arquivo1 AS CHAR NO-UNDO.
DEF VAR c-arquivo2 AS CHAR NO-UNDO.
DEF VAR c-time-atu AS CHAR NO-UNDO.
DEF VAR c-estabel  AS CHAR NO-UNDO.
DEF VAR c-local    AS CHAR NO-UNDO.
DEF VAR c-dia-verm AS CHAR NO-UNDO.
DEF VAR c-dia-amar AS CHAR NO-UNDO.
DEF VAR c-dia-verd AS CHAR NO-UNDO.

DEF VAR i-dias     AS INTE NO-UNDO.
DEF VAR c-nome-it  AS CHAR NO-UNDO.

DEF VAR i-reg-verm AS INTE NO-UNDO.
DEF VAR i-reg-amar AS INTE NO-UNDO.
DEF VAR i-reg-verd AS INTE NO-UNDO.

DEF VAR d-percentual    AS DECIMAL   NO-UNDO.
DEF VAR i-concluidas    AS INTEGER   NO-UNDO.
DEF VAR i-total         AS INTEGER   NO-UNDO.
DEF VAR c-description   AS CHARACTER NO-UNDO.

FOR EACH ponto-programa WHERE
         ponto-programa.nome-programa = "eswmp019"
         NO-LOCK.

    ASSIGN c-arquivo1 = ""
           c-time-atu = ""
           c-estabel  = ""
           c-local    = ""
           c-dia-verm = ""
           c-dia-amar = ""
           c-dia-verd = ""
           c-arquivo2 = ""
           i-reg-verm = 0
           i-reg-amar = 0
           i-reg-verd = 0.

    FOR EACH conteudo-programa NO-LOCK
       WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF conteudo-programa.sequencia = 0 THEN assign c-arquivo1 = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 1 THEN assign c-time-atu = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 2 THEN assign c-estabel  = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 3 THEN assign c-local    = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 4 THEN assign c-dia-verm = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 5 THEN assign c-dia-amar = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 6 THEN assign c-dia-verd = conteudo-programa.conteudo.
        IF conteudo-programa.sequencia = 7 THEN assign c-arquivo2 = conteudo-programa.conteudo.

    END.

    IF c-arquivo1 = "" OR 
       c-arquivo2 = "" THEN NEXT.

    //Come‡o do primeiro arquivo
    OUTPUT TO VALUE(c-arquivo1).    
       PUT UNFORMATTED 
           '<!doctype html>'                                                                                           SKIP
           '<html>'                                                                                                    SKIP
           '<head> <meta http-equiv="refresh" content="' + STRING(c-time-atu) + ';URL=' + string(c-arquivo1) + '"> </head>' SKIP
           '<head>'                                                                                                    SKIP

           '<table width="100%" border="0px" >' SKIP
           '  <tr>' SKIP
           '    <td width="20%" height="20" bgcolor="white" align="left">Atualizado: ' + string(TODAY,"99/99/9999") + ' - ' + string(TIME,"HH:MM") + ' Hs</td>' SKIP
           '    <td width="50%" height="20" bgcolor="white" align="center">Monitor de Tarefas Pendentes</td>' SKIP
           '    <td width="30%" height="20" bgcolor="white" align="right">Estab: ' + STRING(c-estabel) + ' / Local: ' + STRING(c-local) + '</td>' SKIP
           '  </tr>' SKIP
           '</table>' SKIP

           '<table width="100%" border="0px" >' SKIP
           '  <tr>' SKIP

           '    <td width="33%" height="20" bgcolor="red" align="center">Mais de '  + STRING(c-dia-verm) + ' dias</td>'  SKIP
           '    <td width="33%" height="20" bgcolor="yellow" align="center">Entre ' + STRING(c-dia-amar) + ' e ' + STRING(c-dia-verm) + ' dias</td>'  SKIP
           '    <td width="34%" height="20" bgcolor="green" align="center">Menos de ' + STRING(c-dia-amar) + ' dias</td>'  SKIP
           '  </tr>' SKIP
           '</table>' SKIP


           '<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>'                   SKIP
           '<script type="text/javascript">'                                                                           SKIP
           "google.charts.load('current', " + "~{" + "'packages':['table']" + "~}" + ");"                              SKIP
           "google.charts.setOnLoadCallback(drawTable);"                                                               SKIP
           "function drawTable()" + " ~{"                                                                            SKIP
           "var data = new google.visualization.DataTable();"                                                          SKIP

           "    data.addColumn('string', 'Estabelecimento');" SKIP
           "    data.addColumn('string', 'Local');" SKIP
           "    data.addColumn('string', 'Numero Docto');" SKIP
           "    data.addColumn('string', 'Tipo Transacao');" SKIP
           "    data.addColumn('string', 'Descricao Tarefa');" SKIP
           "    data.addColumn('string', 'Status Tarefa');" SKIP
           "    data.addColumn('date', 'Data Inicio Tarefa'); " SKIP
           "    data.addColumn('string', 'Hora Inicio Tarefa'); " SKIP
           "    data.addColumn('string', 'Dias'); " SKIP
           "    data.addColumn('number', 'Percentual');" SKIP
           "    data.addRows([" SKIP.

       FOR EACH wm-tarefa-docto WHERE
                wm-tarefa-docto.cod-estabel = c-estabel       AND
                wm-tarefa-docto.cod-local   = c-local         AND
             //   wm-tarefa-docto.id-docto = 155948 AND
               (wm-tarefa-docto.ind-status-tarefa-docto = 1 OR //NÆo Iniciada
                wm-tarefa-docto.ind-status-tarefa-docto = 2)   //Em processo
                NO-LOCK
           BREAK BY wm-tarefa-docto.dt-inicio-tarefa.
       
           FIND FIRST wm-docto NO-LOCK
                WHERE wm-docto.cod-estabel = wm-tarefa-docto.cod-estabel
                  AND wm-docto.cod-local   = wm-tarefa-docto.cod-local
                  AND wm-docto.id-docto    = wm-tarefa-docto.id-docto NO-ERROR.      
           IF AVAIL wm-docto 
           THEN DO:
       
               ASSIGN i-concluidas = 0
                      i-total      = 0
                      d-percentual = 0.
       
               FOR EACH wm-tarefa-docto-itens OF wm-tarefa-docto NO-LOCK:
       
                   ASSIGN i-total = i-total + 1.
       
                   IF wm-tarefa-docto-itens.ind-status-tarefa-itens = 3 
                   THEN ASSIGN i-concluidas = i-concluidas + 1.
       
               END.
       
               IF i-total <> 0 THEN 
                  ASSIGN d-percentual = (i-concluidas / i-total) * 100.
               ELSE 
                  ASSIGN d-percentual = 0.
       
               ASSIGN c-description = "".
       
               FIND FIRST Wm-tarefa WHERE 
                          Wm-tarefa.cod-tarefa = wm-tarefa-docto.cod-tarefa
                          NO-LOCK NO-ERROR.
       
               IF AVAIL Wm-tarefa 
               THEN ASSIGN c-description = Wm-tarefa.des-tarefa.

               PUT UNFORMATTED
                  "['" + STRING(wm-tarefa-docto.cod-estabel) + "', " + 
                  "'"  + STRING(wm-tarefa-docto.cod-local)   + "', " + 
                  "'"  + STRING(wm-docto.num-docto)          + "', " + 
                  "'"  + STRING(fn-free-accent({scinc/i01sc038.i 04 wm-docto.ind-tipo-trans})) + "', " + 
                  "'"  + STRING(fn-free-accent(c-description))               + "', " + 
                  "'"  + STRING(fn-free-accent({scinc/i01sc095.i 04 wm-tarefa-docto.ind-status-tarefa-docto})) + "', " + 
                  "new Date(" + string(YEAR(wm-tarefa-docto.dt-inicio-tarefa)) + ", " + string(MONTH(wm-tarefa-docto.dt-inicio-tarefa) - 1,"99") + ", " + STRING(DAY(wm-tarefa-docto.dt-inicio-tarefa),"99") + ")" + ", " +
                  "'"  + string(wm-tarefa-docto.hr-inicio-tarefa,"HH:MM:SS")   + "', " + 
                  "'"  + STRING(TODAY - wm-tarefa-docto.dt-inicio-tarefa) + "', " +
                  "~{" + "v: " + STRING(int(d-percentual)) + ", f: '" + STRING(d-percentual,">>9.99") + "'" + "~}" + 
                  " ],"   SKIP.
               
                //tratamento de totais aqui
               IF wm-tarefa-docto.dt-inicio-tarefa < TODAY - INT(c-dia-verm) 
               THEN ASSIGN i-reg-verm = i-reg-verm + 1.
               
               IF wm-tarefa-docto.dt-inicio-tarefa <= TODAY - INT(c-dia-amar) AND
                  wm-tarefa-docto.dt-inicio-tarefa >= TODAY - INT(c-dia-verm)
               THEN ASSIGN i-reg-amar = i-reg-amar + 1.
               
               IF wm-tarefa-docto.dt-inicio-tarefa <= TODAY - INT(c-dia-verd) AND
                  wm-tarefa-docto.dt-inicio-tarefa > TODAY - INT(c-dia-amar)
               THEN ASSIGN i-reg-verd = i-reg-verd + 1.
               
           END.
       END.

       PUT UNFORMATTED
           "    ]);" SKIP
           "    var table = new google.visualization.Table(document.getElementById('colorformat_div'));" SKIP

           "var formatter = new google.visualization.ColorFormat();" SKIP
           "formatter.addRange(" + string(int(c-dia-verm) + 1) + ", 9999999, 'white', 'red');" SKIP
           "formatter.addRange(" + string(c-dia-amar) + ", " + string(int(c-dia-verm) + 1) + ", 'black', 'yellow');" SKIP
           "formatter.addRange(" + string(c-dia-verd) + ", " + string(c-dia-amar) + ", 'white', 'green');" SKIP
           "formatter.format(data, 8);"  SKIP

           'var monthYearFormatter = new google.visualization.DateFormat(' + '~{' + ' pattern: "dd/MM/yyy" ' +
               '~}' + ');' SKIP
           "monthYearFormatter.format(data, 6);" SKIP

               "    table.draw(data, " + "~{ allowHtml: true, " + "showRowNumber: true, width: '100%', height: '100%'" + "~}" + ");" SKIP
               "  ~}" SKIP
               "</script>" SKIP
             "</head>"     SKIP
             "<body>"      SKIP
             '  <div id="colorformat_div"></div>' SKIP
             "</body>"    SKIP

           "</html>   "  SKIP 
           .

    OUTPUT CLOSE.

END.

RETURN "".



