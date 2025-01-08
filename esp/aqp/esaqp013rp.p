/* include de controle de vers∆o */
{include/i-prgvrs.i ESAQP013RP 1.00.00.000}

/* prÇprocessador para ativar ou n∆o a sa°da para RTF */
&global-define RTF no

/* definiá∆o das temp-tables para recebimento de parÉmetros */
{esp/aqp/esaqp013tt.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/* recebimento de parÉmetros */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/**************************** Variaveis ****************************************/
define variable chExcel                 as component-handle              no-undo.
define variable chArquivo               as component-handle              no-undo.
define variable chPlanilha              as component-handle              no-undo.
define variable c-path-excel            as character format "x(256)"     no-undo.
define variable i-acomp                 as int                           no-undo.
define variable h-acomp                 as handle                        no-undo.
define variable v_des_destino           as char      format "x(30)"      no-undo.
define variable i-cont                  as int                           no-undo.
define variable v_des_orig_prob         as char      format "x(40)"      no-undo.
define variable v_des_produto           as char      format "x(40)"      no-undo.
define variable v_des_problema          as char      format "x(40)"      no-undo.
define variable i-lote-corren           as int       initial 0           no-undo.
DEFINE VARIABLE d-data AS DATE        NO-UNDO.

DEFINE BUFFER b-reinsp FOR auditoria-geral.
DEFINE BUFFER b-corrente FOR auditoria-geral.

FUNCTION fn-saneamento-campo RETURNS CHAR
    (p-campo AS CHAR) FORWARD.
FUNCTION fn-turno RETURNS CHAR
    (p-campo AS INT) FORWARD.

/* executando de forma persistente o utilit†rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(c-dir-arquivo-session + "ESAQP013" + string (time) + ".csv").
else
    assign v_des_destino = string(tt-param.arquivo).

output to value(v_des_destino) CONVERT TARGET "iso8859-1".

DO d-data = tt-param.dat-adic-ini TO tt-param.dat-adic-fim:
    /** L¢gica para impress∆o das informaá‰es **/
    for each auditoria-geral USE-INDEX dt no-lock
       where auditoria-geral.dt-amostragem   = d-data:
        /*
         AND ((tt-param.lotes-diarios-revisados and auditoria-geral.ind-amostragem   = 1 /and auditoria-geral.log-revisado) OR
              (tt-param.lotes-reinspecionados   AND auditoria-geral.ind-amostragem   = 2) OR auditoria-geral.log-bloqueio):

        IF  NOT tt-param.log-bloqueado 
        AND auditoria-geral.log-bloqueio THEN
            NEXT.*/

        IF auditoria-geral.cod-turno < tt-param.i-turno-ini OR
           auditoria-geral.cod-turno > tt-param.i-turno-fim THEN NEXT.

        IF auditoria-geral.sigla     < tt-param.sigla-ini OR
           auditoria-geral.sigla     > tt-param.sigla-fim THEN NEXT.

        IF auditoria-geral.log-bloqueio <> tt-param.log-bloqueado THEN NEXT.

        IF tt-param.lotes-diarios-revisados = NO AND auditoria-geral.ind-amostragem = 1 THEN NEXT.
        IF tt-param.lotes-reinspecionados   = NO AND auditoria-geral.ind-amostragem = 2 THEN NEXT.

/*         IF tt-param.lotes-diarios-revisados AND auditoria-geral.ind-amostragem <> 1 THEN NEXT. */
/*         IF tt-param.lotes-diarios-revisados AND auditoria-geral.log-revisado = NO THEN NEXT.   */

/*         IF tt-param.lotes-reinspecionados AND auditoria-geral.ind-amostragem <> 2 THEN NEXT. */

        IF tt-param.lotes-diarios-revisados = NO AND
           tt-param.lotes-reinspecionados   = NO AND
           tt-param.log-bloqueado           = NO THEN DO:
            IF auditoria-geral.ind-amostragem <> 1 THEN NEXT.
            IF auditoria-geral.log-revisado    = YES THEN NEXT.
        END.


        if tt-param.tip-lote <> 0 and 
           auditoria-geral.nr-seq-tipo-lote <> tt-param.tip-lote then
            next.

        IF tt-param.cod-estabel <> "" AND
            tt-param.cod-estabel <> auditoria-geral.cod-estabel THEN
            NEXT.

        if tt-param.it-codigo <> "" and /** C¢digo produto n∆o informado **/
           tt-param.it-codigo <> auditoria-geral.it-codigo then
            next.

        if tt-param.it-codigo = "" and 
           tt-param.nr-linha  <> 0 and /** Linha de produá∆o n∆o informada **/
           tt-param.nr-linha  <> auditoria-geral.nr-linha then
            next.

        if tt-param.it-codigo = "" and
           tt-param.cod-uneg <> "" and
           auditoria-geral.cod-unid-negoc <> tt-param.cod-uneg then
            next.

        IF  tt-param.auditor <> "" AND auditoria-geral.des-auditor <> tt-param.auditor THEN
            NEXT.


        run pi-acompanhar in h-acomp (input string(auditoria-geral.dt-amostragem)).

        assign i-lote-corren = 0.

        IF auditoria-geral.ind-amostragem   = 1 THEN DO:

            FOR FIRST b-corrente
                WHERE b-corrente.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria:
            END.

        END.
        ELSE DO:

            FOR FIRST b-corrente
                WHERE b-corrente.nr-seq-auditoria = auditoria-geral.cod-audit-origem:
            END.

        END.

        IF NOT can-find(FIRST auditoria-visual
                        WHERE auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria
                          AND auditoria-visual.log-revisao      = YES) THEN NEXT.

        FOR FIRST b-reinsp NO-LOCK
            WHERE b-reinsp.cod-audit-origem = auditoria-geral.nr-seq-auditoria:
        END.

        

        for each auditoria-visual no-lock
           where auditoria-visual.nr-seq-auditoria = auditoria-geral.nr-seq-auditoria:

            /* Comentado conforme solicitado por Janaina Koerich no chamado 126144
            IF auditoria-visual.log-revisao = NO THEN NEXT. */

            assign i-acomp = i-acomp + 1.
            run pi-acompanhar in h-acomp (input string(i-acomp)).

            find first aq-origem-prob no-lock
                 where aq-origem-prob.nr-seq-orig-prob = auditoria-visual.nr-seq-orig-prob no-error.
            if avail aq-origem-prob then
                assign v_des_orig_prob = aq-origem-prob.des-orig-prob.
            else
                assign v_des_orig_prob = "".

            find first item no-lock
                where item.it-codigo = b-corrente.it-codigo no-error.
            if avail item then
              assign v_des_produto = item.desc-item.

            find first aq-problema no-lock
                 where aq-problema.nr-seq-problema = auditoria-visual.nr-seq-problema no-error.
            if avail aq-problema then
                assign v_des_problema = aq-problema.des-problema.
            else
                assign v_des_problema = "".

            if b-corrente.nr-seq-tipo-lote = i-lote-corren then do:
                put ";;;;;;".
            END.
            ELSE DO:

                put b-corrente.it-codigo                              ";"
                    v_des_produto                                     ";"
                    b-corrente.qt-prod-lote                           ";"
                    b-corrente.qtd-prod-bloq                          ";"
                    auditoria-geral.qt-problema                       ";"
                    auditoria-geral.dt-amostragem                     ";".

                assign i-lote-corren = b-corrente.nr-seq-tipo-lote.

            END.

            PUT UNFORMATTED b-corrente.dt-amostragem                               ";"
                            trim(fn-saneamento-campo(v_des_problema))              ";"
                            trim(fn-saneamento-campo(auditoria-visual.obs-causa))  ";"
                            auditoria-visual.nr-cartao                             ";"
                            trim(fn-saneamento-campo(v_des_orig_prob))             ";"  
                            auditoria-visual.sigla                                 ";"
                            trim(fn-turno(auditoria-geral.cod-turno))              ";"
                            trim(fn-saneamento-campo(auditoria-visual.des-serie))  ";"
                            trim(fn-saneamento-campo(auditoria-geral.descricao))   ";"
                            trim(auditoria-geral.cod-unid-negoc)                   ";". 

            FIND fam-comerc NO-LOCK
                 WHERE fam-comerc.fm-cod-com = item.fm-cod-com NO-ERROR.
            IF  AVAIL fam-comerc THEN DO:
                FIND FIRST fam-com-item NO-LOCK
                     WHERE fam-com-item.unidade  = SUBSTRING(fam-comerc.fm-cod-com,1,2)
                       AND fam-com-item.segmento = SUBSTRING(fam-comerc.fm-cod-com,3,2)
                       AND fam-com-item.familia1 = "" NO-ERROR.
                IF   AVAIL fam-com-item THEN 
                     PUT UNFORMATTED fam-com-item.descricao ";".
                ELSE
                     PUT  UNFORMATTED ";".
            END.
            ELSE
                PUT  UNFORMATTED ";".

            FIND FIRST aq-categoria NO-LOCK
                 WHERE aq-categoria.nr-seq-categoria = auditoria-visual.nr-seq-categoria NO-ERROR.

            PUT UNFORMATTED auditoria-geral.nr-seq-auditoria            ";" 
                            auditoria-geral.sigla                       ";"
                            aq-categoria.des-categoria                  ";" SKIP.

            

        end.
    end.


END.

output close.

create "Excel.Application":U chExcel connect no-error.
if error-status:error then 
    create "Excel.Application":U chExcel.

assign chArquivo  = chExcel:WorkBooks:Open(v_des_destino)
       chPlanilha = chArquivo:Sheets:Item(1).

chPlanilha:SaveAs(replace(v_des_destino, ".csv", ".xlsx"),"51",,,,,) no-error.
os-delete silent value(v_des_destino).

chExcel:Rows("1:1"):Select.
chExcel:Selection:RowHeight = 15.
chExcel:Selection:Insert. 

chExcel:Range("A1"):select.
chExcel:selection:value = "Produto".

chExcel:Range("B1"):select.
chExcel:selection:value = "Descriá∆o".

chExcel:Range("C1"):select.
chExcel:selection:value = "Qtd Revisada".

chExcel:Range("D1"):select.
chExcel:selection:value = "Qtd Bloqueada".

chExcel:Range("E1"):select.
chExcel:selection:value = "Problemas Reinspeá∆o".

chExcel:Range("F1"):select.
chExcel:selection:value = "Data Reinspeá∆o".

chExcel:Range("G1"):select.
chExcel:selection:value = "Data Amostragem".

chExcel:Range("H1"):select.
chExcel:selection:value = "Problema".

chExcel:Range("I1"):select.
chExcel:selection:value = "Causa".

chExcel:Range("J1"):select.
chExcel:selection:value = "Nr Cart∆o".

chExcel:Range("K1"):select.
chExcel:selection:value = "Origem".

chExcel:Range("L1"):select.
chExcel:selection:value = "CÇlula".

chExcel:Range("M1"):select.
chExcel:selection:value = "Turno".

chExcel:Range("N1"):select.
chExcel:selection:value = "Nr SÇrie".

chExcel:Range("O1"):select.
chExcel:selection:value = "Soluá∆o Amostragem".

chExcel:Range("P1"):select.
chExcel:selection:value = "Unidade Neg¢cio".

chExcel:Range("Q1"):select.
chExcel:selection:value = "Segmento".

chExcel:Range("R1"):select.
chExcel:selection:value = "Nr Amostra".

chExcel:Range("S1"):select.
chExcel:selection:value = "CÇlula".

chExcel:Range("T1"):select.
chExcel:selection:value = "Categoria".

chExcel:Range("A1:T1"):select.
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

chExcel:Columns('A:S'):EntireColumn:Autofit NO-ERROR.

chPlanilha:Activate().

chArquivo:Save.

case tt-param.destino:
    when 1 then do:
        chExcel:visible = true.
    end.
    when 2 then do: 
        assign tt-param.arquivo = REPLACE(tt-param.arquivo,"/","~\")
               v_des_destino    = string(tt-param.arquivo).

        if search(v_des_destino) <> ? then 
            os-delete silent value(v_des_destino) .
        chArquivo:SaveAs(v_des_destino, {&xlNormal}, "", "", False, False, False).
        chArquivo:Close().
        chExcel:Quit().
    end.
    /* Quando tt-param.destino = 3 ("Terminal"), ao final da execuÓ“o do programa, serŸ mostrado o arquivo em Excel. */
    when 3 then do:
        chExcel:visible = true.
    end.
end case.

release object chExcel.
release object chArquivo.
release object chPlanilha  no-error.

assign chPlanilha = ?
       chArquivo  = ?
       chExcel    = ?.

/*fechamento do output do relat¢rio*/
run pi-finalizar in h-acomp.
return "OK":U.


FUNCTION fn-saneamento-campo RETURNS CHAR
    (p-campo AS CHAR):
    

    ASSIGN p-campo = REPLACE( trim(replace(p-campo, CHR(10), "")), CHR(13), "")
           p-campo = REPLACE(p-campo, ";", ",").

    RETURN p-campo.
END FUNCTION.

FUNCTION fn-turno RETURNS CHAR
    ( pTurno as int ) :

    CASE pTurno:
        WHEN 0 THEN RETURN "Geral".
        WHEN 1 THEN RETURN "1ß Turno".
        WHEN 2 THEN RETURN "2ß Turno".
        WHEN 3 THEN RETURN "3ß Turno".
    END CASE.

END FUNCTION.
