/***********************************************************************
**  Programa..: esp/wmp/eswmp026rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Dezembro/2021 - Desenvolvimento
**  Descricao.: Relatorio de entradas, sa¡das e ressuprimentos
**  Versao....: 001 07/12/2021
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.
{include/i-prgvrs.i ESWMP026RP 2.00.00.000}

/****************************  Definitions  ****************************/

{esp/wmp/eswmp026.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

DEFINE STREAM str-excel.

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpvar.i}
{esp/es0018.i}

/****************************  Variables  ****************************/
DEFINE VARIABLE h-acomp    AS HANDLE     NO-UNDO.
DEFINE VARIABLE c-excel    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-retorno  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pEndereco  AS CHARACTER  NO-UNDO.

/****************************  Temp-Tables  ****************************/
DEF BUFFER b-Wm-equipamento FOR Wm-equipamento.

FUNCTION fnCalculaTempo RETURNS CHARACTER
  ( data-ini AS DATE   ,  
    data-fim AS DATE   ,
    hora-ini AS INTEGER,  
    hora-fim AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  fnCalculaTempo
    Notes:  Retorna o tempo no formato "HH:MM:SS".
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dias     AS INTEGER NO-UNDO.
    DEFINE VARIABLE horas    AS INTEGER NO-UNDO.
    DEFINE VARIABLE minutos  AS INTEGER NO-UNDO.
    DEFINE VARIABLE segundos AS INTEGER NO-UNDO.
    DEFINE VARIABLE tempo    AS INTEGER NO-UNDO.

    IF data-fim > data-ini THEN DO:

        ASSIGN dias = data-fim - data-ini
               dias = dias * 86400. /*Necessario transformar o dia em segundos */

        IF hora-fim < hora-ini THEN DO:
            ASSIGN tempo = (hora-ini - hora-fim)
                   tempo = 86400 - tempo.
            IF dias > 86400 THEN
                ASSIGN tempo = (tempo + dias) - 86400.
        END.
        ELSE DO:
            IF hora-ini = hora-fim THEN
                ASSIGN tempo = 86400.
            ELSE 
                ASSIGN tempo = (hora-fim - hora-ini) + 86400.

            IF dias > 86400 THEN
                ASSIGN tempo = (tempo + dias) - 86400.

        END.
    END.
    ELSE DO:

        IF data-ini = data-fim THEN
            ASSIGN dias  = 0
                   tempo = (hora-fim - hora-ini).

    END.

    /* Calculo dos segundos */
    ASSIGN segundos = tempo MOD 60
           tempo    = (tempo - segundos) / 60. 

    /* Calculo dos minutos */
    ASSIGN minutos     = tempo MOD 60.

    /* Calculo das horas */
    ASSIGN horas     = (tempo - minutos) / 60.
           IF horas < 0 THEN ASSIGN horas = 0.

    ASSIGN c-retorno = STRING(horas,"999") + ":" + STRING(minutos,"99") + ":" + STRING(segundos,"99").

    RETURN c-retorno.   

END FUNCTION.

IF OPSYS = "UNIX":U THEN DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-UNIX":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "~\":U, "/":U).
    END.

    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "/":U THEN
    ASSIGN c-excel = c-excel + "/":U + TRIM(tt-param.usuario) + "/":U.
END.
ELSE DO:
    EMPTY TEMP-TABLE tt-prog-ponto.
    RUN esp/es0018p.p (INPUT  "SPOOL-WIN":U,
                       INPUT  1,
                       INPUT  0,
                       INPUT  "":U,
                       OUTPUT TABLE tt-prog-ponto).
    FOR FIRST tt-prog-ponto:
        ASSIGN c-excel = REPLACE(tt-prog-ponto.conteudo, "/":U, "~\":U).
                           
    END.
    IF SUBSTRING(c-excel, LENGTH(c-excel), 1) <> "~\":U THEN
    ASSIGN c-excel = c-excel + "~\":U + TRIM(tt-param.usuario) + "~\":U.
END.

OS-CREATE-DIR VALUE(c-excel).
ASSIGN c-excel = c-excel + "ESWMP026-" + STRING(TIME) + ".csv":U.

/* **************************** Frames ********************************* */

{include/i-rpout.i}
{include/i-rpcab.i}

FOR FIRST tt-param:
END.

ASSIGN  c-programa 	    = "ESWMP026"
	    c-versao	    = "2.00"
	    c-revisao	    = ".00.000"
	    c-empresa       = "Intelbras"
	    c-sistema	    = "WMP"
	    c-titulo-relat  = "Listagem de Entradas, Sa¡das e Ressuprimentos WMS".

/* para nÆo visualizar cabe‡alho/rodap‚ em sa¡da RTF */

OUTPUT STREAM str-excel TO VALUE(c-excel) CONVERT TARGET SESSION:CHARSET.
/* ***************************  Main Block  *************************** */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Listando_Movimentos *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

PUT STREAM str-excel
    "Id. Docto;Numero Docto;Dt. Implantacao;Tipo Transacao;Origem Docto;Seq. item;Id. Movto;Item;Quantidade;Usuario;Cod. Equipamento;Descricao Equipamento;Cod. Coletor;Descricao Coletor;Tp Equipamento;Descr. Tipo Equipamento;Status Tarefa;Dt Conv Tarefa;Data Criacao;Hora Criacao;Dt Inicio Tarefa;Dt Fim Tarefa;Hora Conv;Hora Inicio;Hora Fim;Tempo;Prioridade;Pick;Endereco;Descricao Item" 
    SKIP.

FOR EACH  wm-docto USE-INDEX idx-docto2 
    WHERE wm-docto.cod-estabel      = tt-param.cod-estabel 
      AND wm-docto.cod-local        = tt-param.cod-local   
      AND wm-docto.dt-implan-docto >= tt-param.DataIni     
      AND wm-docto.dt-implan-docto <= tt-param.DataFim     
      AND wm-docto.ind-tipo-trans  >= 1                   
      AND wm-docto.ind-tipo-trans  <= 3               
          NO-LOCK:
    
    run pi-acompanhar in h-acomp (input 'Data:' + STRING(wm-docto.dt-implan-docto)).

    FOR EACH wm-tarefa-docto WHERE
             wm-tarefa-docto.cod-estabel = wm-docto.cod-estabel  
         AND wm-tarefa-docto.cod-local   = wm-docto.cod-local    
         AND wm-tarefa-docto.id-docto    = wm-docto.id-docto 
             NO-LOCK,
        EACH wm-tarefa-docto-itens OF wm-tarefa-docto 
             NO-LOCK,
       FIRST wm-box-movto 
       WHERE wm-box-movto.cod-estabel = wm-tarefa-docto-itens.cod-estabel
         AND wm-box-movto.cod-local   = wm-tarefa-docto-itens.cod-local  
         AND wm-box-movto.id-movto    = wm-tarefa-docto-itens.id-movto
         AND wm-box-movto.ind-tipo-movto = wm-tarefa-docto-itens.ind-tipo-movto
             NO-LOCK:

        IF wm-tarefa-docto-itens.ind-status-tarefa-itens > 3 THEN NEXT.
        
        FIND FIRST Wm-equipamento WHERE 
                   Wm-equipamento.cod-equipamento = wm-tarefa-docto-itens.cod-equipamento 
                   NO-LOCK NO-ERROR.
        
        FIND FIRST b-Wm-equipamento WHERE 
                   b-Wm-equipamento.cod-equipamento = wm-tarefa-docto-itens.cod-coletor 
                   NO-LOCK NO-ERROR.
        
        FIND FIRST wm-tipo-equipamento 
             WHERE wm-tipo-equipamento.cdn-tipo-equipamento = wm-tarefa-docto-itens.cdn-tipo-equipamento 
                   NO-LOCK NO-ERROR.
        
        FIND FIRST wm-box
             WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel AND
                   wm-box.cod-local   = wm-box-movto.cod-local   AND
                   wm-box.id-box      = wm-box-movto.id-box      
                   NO-LOCK NO-ERROR.
        
        IF AVAIL wm-box THEN DO:
            IF wm-box.cod-bloco <> "" THEN
                ASSIGN pEndereco = STRING(wm-box.cod-bloco) + "/" +
                                   STRING(wm-box.cod-rua)   + "/" +
                                   STRING(wm-box.cod-nivel) + "/" +
                                   STRING(wm-box.cod-coluna).
            ELSE
                ASSIGN pEndereco = STRING(wm-box.cod-rua)   + "/" +
                                   STRING(wm-box.cod-nivel) + "/" +
                                   STRING(wm-box.cod-coluna).
        END.
        ELSE ASSIGN pEndereco = "".
        
        FIND FIRST wm-item WHERE 
                   wm-item.cod-item = wm-box-movto.cod-item 
                   NO-LOCK NO-ERROR.
        
        PUT STREAM str-excel UNFORMATTED
                   wm-tarefa-docto-itens.id-docto          ";"
                   wm-docto.num-docto                      ";"
                   wm-docto.dt-implan-docto                ";"
                   {scinc/i01sc038.i 04 wm-docto.ind-tipo-trans} ";" //wm-tarefa-docto-itens.tipo-transacao    ";"
                   {scinc/i03sc038.i 04 wm-docto.ind-origem-docto} ";" //wm-tarefa-docto-itens.origem-docto      ";"
                   wm-tarefa-docto-itens.num-seq-item      ";"
                   wm-tarefa-docto-itens.id-movto          ";"
                   wm-box-movto.cod-item                   ";"
                   (wm-box-movto.qtd-item * wm-box-movto.qti-embalagem) ";" //fnQtdItem() @ d-qtd-item    COLUMN-LABEL "Quantidade"
                   wm-tarefa-docto-itens.cod-usuario       ";"
                   wm-tarefa-docto-itens.cod-equipamento   ";" //    tt-tarefa-docto-itens.cod-equipamento
                   IF AVAIL Wm-equipamento THEN Wm-equipamento.des-equipamento ELSE "" ";" //    fnGetDesEquipamento(tt-tarefa-docto-itens.cod-equipamento) @ c-des-equipamento      
                   wm-tarefa-docto-itens.cod-coletor ";" //    tt-tarefa-docto-itens.cod-coletor
                   IF AVAIL b-Wm-equipamento THEN b-Wm-equipamento.des-equipamento ELSE "" ";" //    fnGetDesEquipamento(tt-tarefa-docto-itens.cod-coletor) @ c-des-coletor COLUMN-LABEL "Descri»’o Coletor":U
                   wm-tarefa-docto-itens.cdn-tipo-equipamento ";" //    tt-tarefa-docto-itens.cdn-tipo-equipamento
                   IF AVAIL wm-tipo-equipamento THEN wm-tipo-equipamento.des-tipo-equipamento ELSE "" ";" //    fnGetTipoEquipamento(tt-tarefa-docto-itens.cdn-tipo-equipamento)@ c-cdn-tipo-equipamento
                   {scinc/i01sc095.i 04 wm-tarefa-docto-itens.ind-status-tarefa-itens} ";" //    fnGetStatusTarefaDocto(tt-tarefa-docto-itens.ind-status-tarefa-itens) @ c-status-tarefa
                   wm-tarefa-docto-itens.dat-conv-ativa ";"  //        tt-tarefa-docto-itens.dat-conv-ativa  COLUMN-LABEL "Dt Conv Tarefa":U
                   wm-tarefa-docto-itens.dat-criacao ";"  //    tt-tarefa-docto-itens.dat-criacao
                   STRING(wm-tarefa-docto-itens.cdn-hora-criac,"HH:MM:SS") ";"  //    fnHoras(tt-tarefa-docto-itens.cdn-hora-criac) @ c-horas-criacao
                   wm-tarefa-docto-itens.dt-inicio-tarefa ";" //    tt-tarefa-docto-itens.dt-inicio-tarefa
                   wm-tarefa-docto-itens.dt-fim-tarefa ";"  //    tt-tarefa-docto-itens.dt-fim-tarefa
                   STRING(wm-tarefa-docto-itens.num-hora-conv-ativa,"HH:MM:SS") ";"   //        fnHoras(tt-tarefa-docto-itens.num-hora-conv-ativa) @ c-horas-convoc COLUMN-LABEL "Hora Conv":U
                   STRING(wm-tarefa-docto-itens.hr-inicio-tarefa,"HH:MM:SS") ";" //    fnHoras(tt-tarefa-docto-itens.hr-inicio-tarefa) @ c-horas-inicio
                   STRING(wm-tarefa-docto-itens.hr-fim-tarefa,"HH:MM:SS") ";" //    fnHoras(tt-tarefa-docto-itens.hr-fim-tarefa) @ c-horas-fim
                   fnCalculaTempo(wm-tarefa-docto-itens.dt-inicio-tarefa, wm-tarefa-docto-itens.dt-fim-tarefa, wm-tarefa-docto-itens.hr-inicio-tarefa, wm-tarefa-docto-itens.hr-fim-tarefa) ";" //    fnCalculaTempo(tt-tarefa-docto-itens.dt-inicio-tarefa, tt-tarefa-docto-itens.dt-fim-tarefa, tt-tarefa-docto-itens.hr-inicio-tarefa, tt-tarefa-docto-itens.hr-fim-tarefa) @ c-tempo
                   wm-tarefa-docto-itens.val-prioridade ";"  //    tt-tarefa-docto-itens.val-prioridade
                   wm-box-movto.log-picking ";"  //    fnLogPicking() @ l-picking
                   pEndereco  ";"  //    fnEndereco()   @ c-endereco
                   IF AVAIL wm-item THEN wm-item.des-item ELSE "" ";"  //    fnDesItem()    @ c-desc-item 
                   SKIP .

    END.
END.   

OUTPUT STREAM str-excel CLOSE.

IF tt-param.destino = 3 THEN
DOS SILENT START excel value(c-excel).

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.

