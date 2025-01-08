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

DEF VAR c-arquivo1  AS CHAR NO-UNDO.
DEF VAR c-arquivo2  AS CHAR NO-UNDO.
DEF VAR c-time-atu  AS CHAR NO-UNDO.
DEF VAR c-estabel   AS CHAR NO-UNDO.
DEF VAR c-local     AS CHAR NO-UNDO.
DEF VAR c-dia-verm  AS CHAR NO-UNDO.
DEF VAR c-dia-amar  AS CHAR NO-UNDO.
DEF VAR c-dia-verd  AS CHAR NO-UNDO.
DEF VAR c-endereco  AS CHAR NO-UNDO.
DEF VAR i-dias      AS INTE NO-UNDO.
DEF VAR c-nome-it   AS CHAR NO-UNDO.
DEF VAR c-documento AS CHAR NO-UNDO.
DEF VAR c-ori-docto AS CHAR NO-UNDO.
DEF VAR c-stat-sal  AS CHAR NO-UNDO.
DEF VAR d-id-carga  LIKE wm-docto.id-carga NO-UNDO.

DEF VAR i-reg-verm  AS INTE NO-UNDO.
DEF VAR i-reg-amar  AS INTE NO-UNDO.
DEF VAR i-reg-verd  AS INTE NO-UNDO.

FOR EACH ponto-programa WHERE
         ponto-programa.nome-programa = "eswmp018"
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
           '<head> <meta http-equiv="refresh" content="' + STRING(c-time-atu) + ';URL=' + string(c-arquivo2) + '"> </head>' SKIP
           '<head>'                                                                                                    SKIP
       
           '<table width="100%" border="0px" >' SKIP
           '  <tr>' SKIP
           '    <td width="20%" height="20" bgcolor="white" align="left">Atualizado: ' + string(TODAY,"99/99/9999") + ' - ' + string(TIME,"HH:MM") + ' Hs</td>' SKIP
           '    <td width="50%" height="20" bgcolor="white" align="center">Monitor de Saldos Destinados</td>' SKIP
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
           "    data.addColumn('string', 'Item');" SKIP
           "    data.addColumn('string', 'Endereco');" SKIP
           "    data.addColumn('string', 'Documento');" SKIP
           "    data.addColumn('string', 'Origem Docto');" SKIP
           "    data.addColumn('string', 'Status Saldo');" SKIP
           "    data.addColumn('string', 'ID Carga');" SKIP
           "    data.addColumn('string', 'Embalagem');" SKIP
           "    data.addColumn('string', 'Lote');" SKIP
           "    data.addColumn('date', 'Data Trans'); " SKIP
           "    data.addColumn('string', 'Dias'); " SKIP
           "    data.addColumn('number', 'Quantidade');" SKIP
           "    data.addRows([" SKIP.
       
       FOR EACH wm-box-saldo WHERE
                wm-box-saldo.cod-estabel      = c-estabel AND
                wm-box-saldo.cod-local        = c-local   AND
               (wm-box-saldo.ind-status-saldo = 2         OR  /* Destinado */
                wm-box-saldo.ind-status-saldo = 6)        AND /* CQ - Destinado */
                wm-box-saldo.cod-cliente      = 0
                NO-LOCK
                BREAK BY wm-box-saldo.dt-transacao.
       
           FIND FIRST ITEM WHERE
                      ITEM.it-codigo = wm-box-saldo.cod-item
                      NO-LOCK NO-ERROR.
       
           FIND FIRST Wm-box
                WHERE Wm-box.cod-estabel = wm-box-saldo.cod-estabel AND
                      Wm-box.cod-local   = wm-box-saldo.cod-local   AND
                      Wm-box.id-box      = wm-box-saldo.id-box      
                      NO-LOCK NO-ERROR.
       
           IF AVAIL Wm-box THEN
               ASSIGN c-endereco = Wm-box.cod-bloco + "/" + Wm-box.cod-rua + "/" + Wm-box.cod-nivel + "/" + Wm-box.cod-coluna.

           ASSIGN c-documento = ""
                  c-ori-docto = ""
                  c-stat-sal  = ""
                  d-id-carga  = 0.

           FOR EACH wm-box-movto WHERE
                    wm-box-movto.cod-estabel    = wm-box-saldo.cod-estabel   AND
                    wm-box-movto.cod-local      = wm-box-saldo.cod-local     AND
                    wm-box-movto.id-docto       = wm-box-saldo.id-docto      AND
                    wm-box-movto.num-seq-item   = wm-box-saldo.num-seq-item  AND
                    wm-box-movto.id-box         = wm-box-saldo.id-box        AND
                    wm-box-movto.cod-embalagem  = wm-box-saldo.cod-embalagem AND 
                    wm-box-movto.ind-tipo-movto = 1
                    NO-LOCK,
              FIRST wm-docto WHERE
                    wm-docto.cod-estabel  = wm-box-movto.cod-estabel          AND
                    wm-docto.cod-local    = wm-box-movto.cod-local           AND
                    wm-docto.id-docto     = wm-box-saldo.id-docto 
                    NO-LOCK
           BREAK BY wm-docto.dt-implan-docto
                 BY wm-docto.id-docto
                 BY wm-box-movto.id-movto:

               IF FIRST-OF(wm-box-movto.id-movto) THEN DO:
                   ASSIGN c-documento = wm-docto.num-docto
                          c-ori-docto = {scinc/i03sc038.i 04 wm-docto.ind-origem-docto}
                          d-id-carga  = wm-docto.id-carga.
               END.
           
           END.

           //ASSIGN c-stat-sal = {scinc/i01sc035.i 04 wm-box-saldo.ind-status-saldo}.
           IF wm-box-saldo.ind-status-saldo = 2 
           THEN ASSIGN c-stat-sal = "Destinado".

           IF wm-box-saldo.ind-status-saldo = 6
           THEN ASSIGN c-stat-sal = "CQ - Destinado".
       
           PUT UNFORMATTED
              "['" + STRING(wm-box-saldo.cod-estabel) + "', " + 
              "'"  + STRING(wm-box-saldo.cod-local)   + "', " + 
              "'"  + STRING(wm-box-saldo.cod-item)    + " - " + replace(fn-free-accent(item.desc-item),"'"," ") + "', " + 
              "'"  + STRING(c-endereco) + "', " +
              "'"  + STRING(c-documento) + "', " +
              "'"  + STRING(fn-free-accent(c-ori-docto)) + "', " +
              "'"  + STRING(fn-free-accent(c-stat-sal)) + "', " +
              "'"  + STRING(fn-free-accent(string(d-id-carga))) + "', " +
              "'"  + STRING(wm-box-saldo.cod-embalagem) + "', " + 
              "'"  + STRING(wm-box-saldo.cod-lote) + "', " + 
              "new Date(" + string(YEAR(wm-box-saldo.dt-transacao)) + ", " + string(MONTH(wm-box-saldo.dt-transacao) - 1,"99") + ", " + STRING(DAY(wm-box-saldo.dt-transacao),"99") + ")" + ", " +
              "'"  + STRING(TODAY - wm-box-saldo.dt-transacao) + "', " +
              "~{" + "v: " + STRING(int(wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq)) + ", f: '" + STRING(wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq,">>>,>>>,>>9.99") + "'" + "~}" + 
              " ],"   SKIP.

           //tratamento de totais aqui
           IF wm-box-saldo.dt-transacao < TODAY - INT(c-dia-verm) 
           THEN ASSIGN i-reg-verm = i-reg-verm + 1.
           
           IF wm-box-saldo.dt-transacao <= TODAY - INT(c-dia-amar) AND
              wm-box-saldo.dt-transacao >= TODAY - INT(c-dia-verm)
           THEN ASSIGN i-reg-amar = i-reg-amar + 1.
           
           IF wm-box-saldo.dt-transacao <= TODAY - INT(c-dia-verd) AND
              wm-box-saldo.dt-transacao > TODAY - INT(c-dia-amar)
           THEN ASSIGN i-reg-verd = i-reg-verd + 1.
       
       END.
       
       PUT UNFORMATTED
           "    ]);" SKIP
           "    var table = new google.visualization.Table(document.getElementById('colorformat_div'));" SKIP
       
           "var formatter = new google.visualization.ColorFormat();" SKIP
           "formatter.addRange(" + string(int(c-dia-verm) + 1) + ", 9999999, 'white', 'red');" SKIP
           "formatter.addRange(" + string(c-dia-amar) + ", " + string(int(c-dia-verm) + 1) + ", 'black', 'yellow');" SKIP
           "formatter.addRange(" + string(c-dia-verd) + ", " + string(c-dia-amar) + ", 'white', 'green');" SKIP
           "formatter.format(data, 11);"  SKIP
           
           'var monthYearFormatter = new google.visualization.DateFormat(' + '~{' + ' pattern: "dd/MM/yyy" ' +
               '~}' + ');' SKIP
           "monthYearFormatter.format(data, 10);" SKIP
           
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

    //Come‡o do segundo arquivo
    OUTPUT TO VALUE(c-arquivo2).
       PUT UNFORMATTED
          '<!doctype html>' SKIP
          '<html>' SKIP
          '<head> <meta http-equiv="refresh" content="' + STRING(c-time-atu) + ';URL=' + string(c-arquivo1) + '"> </head>' SKIP
          
          '  <head>' SKIP
          '    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>' SKIP
          '  <script type="text/javascript">'
          '    google.charts.load("current", ' + '~{' + "packages:['corechart']" + "~});" SKIP
          '    google.charts.setOnLoadCallback(drawChart);' SKIP
          '    function drawChart() ' + '~{' SKIP
          '      var data = google.visualization.arrayToDataTable([' SKIP
          '        ["Element", "Quantidade", ' + '~{ role: "style" ' + '~} ],' SKIP
          '        ["Mais de ' + STRING(c-dia-verm) + ' dias", ' + STRING(i-reg-verm) + ', "red"],' SKIP
          '        ["Entre ' + STRING(c-dia-amar) + ' e ' + STRING(c-dia-verm) + ' dias", ' + STRING(i-reg-amar) + ', "yellow"],' SKIP
          '        ["Menos de ' + STRING(c-dia-amar) + ' dias", ' + STRING(i-reg-verd) + ', "green"],' SKIP
          
          '      ]);' SKIP
          
          '      var view = new google.visualization.DataView(data);' SKIP
          '      view.setColumns([0, 1,' SKIP
          '                       ~{ calc: "stringify",' SKIP
          '                         sourceColumn: 1,' SKIP
          '                             type: "string",' SKIP
          '                         role: "annotation" ' + '~},' SKIP
          '                       2]);' SKIP
          
          '      var options = ~{'
          '        title: "Totais de saldos destinados por dias",' SKIP
          '        width: 1200,' SKIP
          '        height: 800,' SKIP
          '        bar: ' + '~{' + 'groupWidth: "95%"' + '~},' SKIP
          '        legend: ' + '~{' + ' position: "none" ' + '~},' SKIP
          '      ~};' SKIP
          '      var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values"));' SKIP
          '      chart.draw(view, options);' SKIP
          '  ~}' SKIP
          '  </script>' SKIP
          '  </head>' SKIP
          ' <body>' SKIP
          '    <div id="columnchart_values" style="width: 100%; height: 100%;"></div>' SKIP
          '  </body> ' SKIP
          '</html>' SKIP.

    OUTPUT CLOSE.

END.

RETURN "".



