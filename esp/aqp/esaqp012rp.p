/* include de controle de versÆo */
{include/i-prgvrs.i ESAQP012RP 1.00.00.000}

/* pr‚processador para ativar ou nÆo a sa¡da para RTF */
&global-define RTF no

/* defini‡Æo das temp-tables para recebimento de parƒmetros */
{esp/aqp/esaqp012tt.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/* recebimento de parƒmetros */
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
define variable v_des_lin_prod          as char      format "x(40)"      no-undo.
define variable v_des_produto           as char      format "x(40)"      no-undo.
define variable v_des_tipo_teste        as char      format "x(05)"      no-undo.
define variable c-des-teste             as char      format "x(60)"      no-undo.

/* executando de forma persistente o utilit rio de acompanhamento */
run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Imprimindo *}
run pi-inicializar in h-acomp (input return-value).

if tt-param.destino = 3 or
   tt-param.destino = 1 then
    assign v_des_destino = string(c-dir-arquivo-session + "ESAQP012" + string (time) + ".csv").
else
    assign v_des_destino = string(tt-param.arquivo).

output to value(v_des_destino) CONVERT TARGET "iso8859-1".

RUN pi-imprime-cab.

/** L¢gica para impressÆo das informa‡äes **/
for EACH auditoria-geral no-lock
   WHERE auditoria-geral.dt-amostragem >= tt-param.dat-adic-ini
     AND auditoria-geral.dt-amostragem <= tt-param.dat-adic-fim
     AND (IF tt-param.cod-estabel <> "" THEN auditoria-geral.cod-estabel = tt-param.cod-estabel ELSE YES)
     AND (IF tt-param.it-codigo <> ""   THEN auditoria-geral.it-codigo   = tt-param.it-codigo   ELSE YES)
     AND (IF tt-param.nr-linha <> 0     THEN auditoria-geral.nr-linha    = tt-param.nr-linha    ELSE YES)
     AND (IF tt-param.auditor  <> ""    THEN auditoria-geral.des-auditor = tt-param.auditor     ELSE YES)
    , EACH auditoria-adicional no-lock
       WHERE auditoria-adicional.nr-seq-auditoria  = auditoria-geral.nr-seq-auditoria
         AND auditoria-adicional.nr-seq-teste     >= tt-param.sit-teste-ini
         AND auditoria-adicional.nr-seq-teste     <= tt-param.sit-teste-fim
         BREAK BY auditoria-adicional.nr-seq-teste:

        //IF  tt-param.auditor <> "" AND auditoria-geral.des-auditor <> tt-param.auditor THEN
        //    NEXT.

        IF  FIRST-OF(auditoria-adicional.nr-seq-teste) THEN DO:
            FIND FIRST aq-teste NO-LOCK
                WHERE aq-teste.nr-seq-teste = auditoria-adicional.nr-seq-teste NO-ERROR.
            IF  AVAIL aq-teste THEN
                ASSIGN c-des-teste = STRING(auditoria-adicional.nr-seq-teste) + " - " + aq-teste.des-teste.
            ELSE
                ASSIGN c-des-teste = STRING(auditoria-adicional.nr-seq-teste).
            
            run pi-acompanhar in h-acomp (input "Processando Teste: " + string(auditoria-adicional.nr-seq-teste)).
            RUN pi-imprime-linha-csv ("", "", "", "", "", "", "", "", "", "", "", "").
            RUN pi-imprime-linha-csv ("TIPO TESTE: " + c-des-teste, "", "", ""  , ""  , ""  , ""  , ""  , ""  , ""  , ""  , "").
            RUN pi-imprime-linha-csv ("PRODUTO", "DESCRI€ÇO", "DATA", "RESPONSµVEL", "HABILITA NS", "RASTREABILIDADE", aq-teste.auditoria[1], aq-teste.auditoria[2], aq-teste.auditoria[3], aq-teste.auditoria[4], aq-teste.auditoria[5] , aq-teste.auditoria[6] ).
        END.
        
    
        find first item no-lock
            where item.it-codigo = auditoria-geral.it-codigo no-error.
        if avail item then
          assign v_des_produto = item.desc-item.

        find first aq-teste no-lock
             where aq-teste.nr-seq-teste = auditoria-adicional.nr-seq-teste no-error.
        IF  avail aq-teste THEN
            RUN pi-imprime-linha-csv (input auditoria-geral.it-codigo             ,
                                      input v_des_produto                         ,
                                      input string(auditoria-geral.dt-amostragem) ,
                                      input string(auditoria-geral.des-auditor)   ,
                                      input string(auditoria-adicional.log-habilita-ns,"Sim/NÆo")  ,
                                      input string(auditoria-adicional.nr-serie)  ,
                                      input " " + auditoria-adicional.narrativa[1], 
                                      input " " + auditoria-adicional.narrativa[2], 
                                      input " " + auditoria-adicional.narrativa[3], 
                                      input " " + auditoria-adicional.narrativa[4], 
                                      input " " + auditoria-adicional.narrativa[5], 
                                      input " " + auditoria-adicional.narrativa[6]).

end.

output close.

IF  OPSYS <> "unix" THEN
    DOS SILENT START excel VALUE(v_des_destino).

PROCEDURE pi-retira-caracter-enter:
    DEF INPUT-OUTPUT PARAM c-campo AS CHAR NO-UNDO.

    ASSIGN c-campo = REPLACE (c-campo, CHR(13), " ").
           c-campo = REPLACE (c-campo, CHR(10), " ").

END.

PROCEDURE pi-imprime-linha-csv:
    DEF INPUT PARAM p-campo01  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo02  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo03  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo04  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo05  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo051 AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo06  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo07  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo08  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo09  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo10  AS CHAR NO-UNDO.
    DEF INPUT PARAM p-campo11  AS CHAR NO-UNDO.

    RUN pi-retira-caracter-enter (INPUT-OUTPUT p-campo07). 
    RUN pi-retira-caracter-enter (INPUT-OUTPUT p-campo08). 
    RUN pi-retira-caracter-enter (INPUT-OUTPUT p-campo09). 
    RUN pi-retira-caracter-enter (INPUT-OUTPUT p-campo10). 
    RUN pi-retira-caracter-enter (INPUT-OUTPUT p-campo11). 

    PUT UNFORMATTED p-campo01  ";"
                    p-campo02  ";"
                    p-campo03  ";"
                    p-campo04  ";"
                    p-campo05  ";"
                    p-campo051 ";"
                    p-campo06  ";"
                    " " p-campo07 ";"
                    " " p-campo08 ";"
                    " " p-campo09 ";"
                    " " p-campo10 ";"
                    " " p-campo11 ";" SKIP.
END.


PROCEDURE pi-imprime-cab:

    find first lin-prod no-lock
        where lin-prod.cod-estabel = tt-param.cod-estabel 
          AND lin-prod.nr-linha    = tt-param.nr-linha no-error.
    if avail lin-prod then
        assign v_des_lin_prod = lin-prod.descricao.
    else
        assign v_des_lin_prod = "".

    RUN pi-imprime-linha-csv ("LINHA PRODU€ÇO: " + v_des_lin_prod, "", "", "", "", "", "", "", "", "", "", "").

    RUN pi-imprime-linha-csv ("PERÖODO: " +  STRING(tt-param.dat-adic-ini) +  " |<    >| " + string(tt-param.dat-adic-fim) , "", "", "", "", "", "", "", "", "", "", "").
    
END.

PROCEDURE WinExec EXTERNAL "kernel32.dll":
  DEF INPUT  PARAM prg_name                          AS CHARACTER.
  DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.


/*
create "Excel.Application":U chExcel connect no-error.
if error-status:error then 
    create "Excel.Application":U chExcel.

assign chArquivo  = chExcel:WorkBooks:Open(v_des_destino)
       chPlanilha = chArquivo:Sheets:Item(1).

chPlanilha:SaveAs(replace(v_des_destino, ".csv", ".xlsx"),"51",,,,,) no-error.
os-delete silent value(v_des_destino).

do i-cont = 1 to 4:
    chExcel:Rows(string(i-cont) + ":" + string(i-cont)):Select.
    chExcel:Selection:RowHeight = 15.
    chExcel:Selection:Insert. 
end.


chExcel:Range("A1"):select.
chExcel:selection:value = "Linha Produ‡Æo".
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

find first lin-prod no-lock
     where lin-prod.nr-linha = tt-param.nr-linha no-error.
if avail lin-prod then
    assign v_des_lin_prod = lin-prod.descricao.
else
    assign v_des_lin_prod = "".

chExcel:Range("B1"):select.
chExcel:selection:value = tt-param.nr-linha.

chExcel:Range("C1"):select.
chExcel:selection:value = v_des_lin_prod.

chExcel:Range("A2"):select.
chExcel:selection:value = "Per¡odo".
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

chExcel:Range("B2"):select.
chExcel:selection:value = string(tt-param.dat-adic-ini) + " |<>| " + string(tt-param.dat-adic-fim).

chExcel:Range("D2"):select.
chExcel:selection:value = "Tipo Teste".
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

find first aq-teste no-lock
     where aq-teste.nr-seq-teste = tt-param.sit-teste no-error.
if avail aq-teste then do:
    assign v_des_tipo_teste = aq-teste.des-teste.

    chExcel:Range("G4"):select.
    chExcel:selection:value = aq-teste.auditoria[1].
    chExcel:Columns("G"):ColumnWidth = 40.
    
    chExcel:Range("H4"):select.
    chExcel:selection:value = aq-teste.auditoria[2].
    chExcel:Columns("H"):ColumnWidth = 40.
    
    chExcel:Range("I4"):select.
    chExcel:selection:value = aq-teste.auditoria[3].
    chExcel:Columns("I"):ColumnWidth = 40.

    chExcel:Range("J4"):select.
    chExcel:selection:value = aq-teste.auditoria[4].
    chExcel:Columns("J"):ColumnWidth = 40.
    
    chExcel:Range("K4"):select.
    chExcel:selection:value = aq-teste.auditoria[5].
    chExcel:Columns("K"):ColumnWidth = 40.
    
    chExcel:Range("L4"):select.
    chExcel:selection:value = aq-teste.auditoria[6].
    chExcel:Columns("L"):ColumnWidth = 40.
end.
else
    assign v_des_tipo_teste = "".

chExcel:Range("E2"):select.
chExcel:selection:value = v_des_tipo_teste.

chExcel:Range("A4"):select.
chExcel:selection:value = "Produto".

chExcel:Range("B4"):select.
chExcel:selection:value = "Descri‡Æo".

chExcel:Range("C4"):select.
chExcel:selection:value = "Data".

chExcel:Range("D4"):select.
chExcel:selection:value = "Qtd Aparelhos".

chExcel:Range("E4"):select.
chExcel:selection:value = "Respons vel".

chExcel:Range("F4"):select.
chExcel:selection:value = "Nr S‚rie".

chExcel:Range("A4:L4"):select.
chExcel:selection:Font:Bold           = True.
chExcel:selection:Interior:ColorIndex = 20.
chExcel:selection:Borders({&xlEdgeLeftTopBottomRight}):LineStyle = 1.

chExcel:Columns('A:F'):EntireColumn:Autofit NO-ERROR.

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
    /* Quando tt-param.destino = 3 ("Terminal"), ao final da execuîÒo do programa, serÙ mostrado o arquivo em Excel. */
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
*/
/*fechamento do output do relat¢rio*/
run pi-finalizar in h-acomp.
return "OK":U.
