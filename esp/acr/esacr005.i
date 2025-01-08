FORM tt_port.nome-regiao      AT 01 
     tt_port.cod_portador     AT 21 
     tt_port.cod_cart_bcia    AT 27 
     emscad.portador.nom_abrev  AT 33 
     tt_port.Ve-05            TO 61 
     tt_port.Ve-06-30         TO 74 
     tt_port.Ve-31-60         TO 87 
     tt_port.Ve-61-90         TO 100 
     tt_port.Ve-91-180        TO 113
     tt_port.Ve-180           TO 126
     tt_port.Tot-Venc         TO 140
     perc-tot-venc            TO 147
     tt_port.Av-30            TO 161
     tt_port.Av-31-60         TO 174
     tt_port.Av-61-90         TO 187
     tt_port.Av-90            TO 200
     tt_port.Tot-A-Venc       TO 214
     perc-tot-a-venc          TO 221
     tt_port.Total            TO 235
    WITH FRAME f-imprime OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM tt_port.nome-regiao      AT 01 
     c-cod-grp-rep            AT 21 
     c-des-grp-rep            AT 29 FORMAT "x(15)"
     tt_port.Ve-05            TO 61 
     tt_port.Ve-06-30         TO 74 
     tt_port.Ve-31-60         TO 87 
     tt_port.Ve-61-90         TO 100 
     tt_port.Ve-91-180        TO 113
     tt_port.Ve-180           TO 126
     tt_port.Tot-Venc         TO 140
     perc-tot-venc            TO 147
     perc-ve06                TO 156
     tt_port.Av-30            TO 169
     tt_port.Av-31-60         TO 182
     tt_port.Av-61-90         TO 195
     tt_port.Av-90            TO 209
     tt_port.Tot-A-Venc       TO 223
     perc-tot-a-venc          TO 230
     tt_port.Total            TO 244
    WITH FRAME f-impr-grp-rep OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM tot-ve-05      TO 61 
     tot-ve-06-30   TO 74 
     tot-ve-31-60   TO 87 
     tot-ve-61-90   TO 100 
     tot-ve-91-180  TO 113
     tot-ve-180     TO 126
     tot-tot-venc   TO 140
     tot-av-30      TO 161
     tot-av-31-60   TO 174
     tot-av-61-90   TO 187
     tot-av-90      TO 200
     tot-tot-a-venc TO 214
     tot-total      TO 235
     " TOTAL"
    WITH FRAME f-tot-impr OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM tot-ve-05-dir      TO 61 
     tot-ve-06-30-dir   TO 74 
     tot-ve-31-60-dir   TO 87 
     tot-ve-61-90-dir   TO 100
     tot-ve-91-180-dir  TO 113
     tot-ve-180-dir     TO 126
     tot-tot-venc-dir   TO 140
     tot-av-30-dir      TO 161
     tot-av-31-60-dir   TO 174
     tot-av-61-90-dir   TO 187
     tot-av-90-dir      TO 200
     tot-tot-a-venc-dir TO 214
     tot-total-dir      TO 235
     " TOTAL DIRETORIA"
    WITH FRAME f-tot-dir OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM tot-ve-05-dir      TO 61 
     tot-ve-06-30-dir   TO 74 
     tot-ve-31-60-dir   TO 87 
     tot-ve-61-90-dir   TO 100
     tot-ve-91-180-dir  TO 113
     tot-ve-180-dir     TO 126
     tot-tot-venc-dir   TO 140
     tot-av-30-dir      TO 169
     tot-av-31-60-dir   TO 182
     tot-av-61-90-dir   TO 195
     tot-av-90-dir      TO 209
     tot-tot-a-venc-dir TO 223
     tot-total-dir      TO 244
     " TOTAL DIR"
    WITH FRAME f-tot-grp-rep-dir OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM t-ve-05      TO 61 
     t-ve-06-30   TO 74 
     t-ve-31-60   TO 87 
     t-ve-61-90   TO 100
     t-ve-91-180  TO 113
     t-ve-180     TO 126
     t-tot-venc   TO 140
     t-av-30      TO 161
     t-av-31-60   TO 174
     t-av-61-90   TO 187
     t-av-90      TO 200
     t-tot-a-venc TO 214
     t-total      TO 235
    " TOTAL GERAL"
    WITH FRAME f-total OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM t-ve-05       TO 61 
     t-ve-06-30    TO 74 
     t-ve-31-60    TO 87 
     t-ve-61-90    TO 100 
     t-ve-91-180   TO 113
     t-ve-180      TO 126
     t-tot-venc    TO 140
     t-av-30       TO 169
     t-av-31-60    TO 182
     t-av-61-90    TO 195
     t-av-90       TO 209
     t-tot-a-venc  TO 223
     t-total       TO 244
     " TOTAL"         
    WITH FRAME f-tot-grp-rep OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM tot-ve-05      TO 61 
     tot-ve-06-30   TO 74 
     tot-ve-31-60   TO 87 
     tot-ve-61-90   TO 100 
     tot-ve-91-180  TO 113
     tot-ve-180     TO 126
     tot-tot-venc   TO 140
     tot-av-30      TO 169
     tot-av-31-60   TO 182
     tot-av-61-90   TO 195
     tot-av-90      TO 209
     tot-tot-a-venc TO 223
     tot-total      TO 244
     " TOTAL GER"
    WITH FRAME f-tot-grp-rep-impr OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.

FORM "Representante: "         AT 01
     representante.cdn_repres  AT 17
     representante.nom_pessoa  AT 25
    WITH FRAME f-repres OVERLAY WIDTH 255 NO-BOX STREAM-IO DOWN NO-LABELS.
