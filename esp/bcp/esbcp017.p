/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP017 2.00.00.016 } /*** 010016 ***/
{include/i-license-manager.i BC9018 MBC}
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */

/* Definicao global do nome da transacao ---                */
&global-define ProgramName ESBCP017
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{esp/bcp/esbcp017.i " "}
{esp/bcp/esbcp017.i1 "New"}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

Create ttWork.

DEFINE VARIABLE vnr-pedcli              AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vnome-abrev             AS CHARACTER FORMAT 'x(12)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vcod-item               AS CHARACTER FORMAT 'x(16)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE vdes-item               AS CHARACTER FORMAT 'x(18)':U     INIT ''  NO-UNDO. 
DEFINE VARIABLE c-desc-item             AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE cod-estab-roteiriz LIKE ttWm-box-movto-idx-picking.cod-estabel  NO-UNDO.
DEFINE VARIABLE cod-local-roteiriz LIKE ttWm-box-movto-idx-picking.cod-local    NO-UNDO.
DEFINE VARIABLE id-movto-roteiriz  LIKE ttWm-box-movto-idx-picking.id-movto     NO-UNDO.
DEFINE VARIABLE c-etiq-separa      AS CHARACTER FORMAT 'X(30)' VIEW-AS FILL-IN SIZE 19 BY 1 NO-UNDO.
DEFINE VARIABLE l-primeiro         AS LOGICAL INIT YES    NO-UNDO.
DEFINE VARIABLE i-vol   AS INTEGER     NO-UNDO.

DEFINE NEW SHARED VARIABLE wgeswmpapi002               AS WIDGET-HANDLE                 NO-UNDO.

Define Temp-table tt-mostra-locais NO-UNDO
    Field num-seq           As Integer
    Field des-local         As Character Format 'X(19)':U
    FIELD cod-bloco         like wm-box.cod-bloco
    FIELD cod-rua           like wm-box.cod-rua
    FIELD cod-nivel         like wm-box.cod-nivel
    FIELD cod-coluna        like wm-box.cod-coluna
    Field rowid-box-movto   As Rowid
        Index ID num-seq.

DEFINE TEMP-TABLE tt-serial NO-UNDO
       FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
       FIELD id-movto             LIKE wm-movto.id-movto
       INDEX idx-serial  AS PRIMARY /*UNIQUE*/ id-etiqueta.

Define Query qry-wm-box-movto For tt-mostra-locais.

Define Browse brw-wm-box-movto Query qry-wm-box-movto No-lock
             Display 
              tt-mostra-locais.des-local
                    With No-box No-labels Size 20 By 2.5 No-scrollbar-vertical.


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking Flow Rack'        At Row 01 Col 01          ~
                             '--------------------'     At Row 02 Col 01          ~
                             'Usr:'                     At Row 03 Col 01          ~
                             ttWork.cod-usuario         At Row 03 Col 05 No-label ~
                             'Sen:'                     AT ROW 04 COL 01          ~
                             vcod-senha                 AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                     At Row 05 Col 01          ~
                             ttWork.cod-coletor         At Row 05 Col 05 No-label ~
                             'Equ:'                     At Row 06 Col 01          ~
                             ttWork.cod-equipamento     At Row 06 Col 05 No-label ~
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking Flow Rack'        At Row 01 Col 01          ~
                             '--------------------'     At Row 02 Col 01          ~
                             'Zona Ini:'                At Row 03 Col 01          ~
                             ttWork.cod-zona-ini        At Row 03 Col 12 No-Label ~
                             'Zona Fim:'                At Row 04 Col 01          ~
                             ttWork.cod-zona-fim        At Row 04 Col 12 No-Label ~
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking Flow Rack'        At Row 01 Col 01          ~
                             '--------------------'     At Row 02 Col 01          ~
                             'Etiqueta Separaá∆o: '     At Row 03 Col 01          ~
                             c-etiq-separa              At Row 04 Col 01 NO-LABEL ~

&global-define Frame03Repeat No
/************************************************************/

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Picking Flow Rack'        At Row 01 Col 01          ~
                             brw-wm-box-movto           At Row 02 Col 01          ~
                             'Ped:'                     AT ROW 05 COL 01          ~
                             vnr-pedcli                 At Row 05 Col 06 No-label ~
                             'Cli:'                     AT ROW 06 COL 01          ~
                             vnome-abrev                AT ROW 06 COL 06 NO-LABEL ~
                             'It:'                      AT ROW 07 COL 01          ~
                             vcod-item                  AT ROW 07 COL 03 NO-LABEL ~
                             vdes-item                  AT ROW 08 COL 01 NO-LABEL ~
                             
&global-define Frame04Repeat YES
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&global-define Update02Fields ttWork.cod-zona-ini ttWork.cod-zona-fim
&global-define Update03Fields c-etiq-separa
&global-define Update04Fields brw-wm-box-movto

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. Empty Temp-table tt-mostra-locais. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
                            DO:                                                    ~
                                IF v_cod-coletor_corren     <> '' AND              ~
                                   v_cod-equipamento_corren <> '' THEN DO:         ~
                                    IF l-menu-padrao = YES THEN DO:                ~
                                        ASSIGN l-menu-padrao = NO.                 ~
                                        APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    ELSE DO:                                       ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    RETURN NO-APPLY.                                   ~
                                END.                                               ~
                            END.                                                   ~
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                Find ttWm-box-movto-idx-picking                                                  ~
                                    Where Rowid(ttWm-box-movto-idx-picking) = tt-mostra-locais.rowid-box-movto   ~
                                           No-error.                                                             ~
                                If  Not Available ttWm-box-movto-idx-picking Then Return No-apply.               ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttWm-box-movto-idx-picking.cod-estabel,  ~
                                                                    Input ttWm-box-movto-idx-picking.cod-local,    ~
                                                                    Input ttWm-box-movto-idx-picking.id-docto,     ~
                                                                    Input ttWm-box-movto-idx-picking.num-seq-item, ~
                                                                    Output Table ttwm-docto-itens ).               ~
                                Find First ttwm-docto-itens.                                                                             ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item). /* Vari†vel ou Campo com o c¢digo do Item */ ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                                        ~
	                                RUN getCharField IN wgbosc044 (INPUT "des-item":U,                                                   ~
                                                                   OUTPUT c-desc-item). /* Vari†vel ou Campo com a descriá∆o do Item */  ~
                                    ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame04 = TRIM(SUBSTRING(c-desc-item,1,18)).                ~
                                END.                                                                                                     ~
                                ELSE DO:                                                                                                 ~
	                                ASSIGN vdes-item:SCREEN-VALUE   IN FRAME Frame04 = ''.                                               ~
                                END.                                                                                                     ~
                                ASSIGN vcod-item:SCREEN-VALUE   IN FRAME Frame04 = TRIM(ttwm-docto-itens.cod-item)                       ~
                                       vnr-pedcli:screen-value  In Frame Frame04 = trim(ttWm-box-movto-idx-picking.nr-pedcli)            ~
                                       vnome-abrev:screen-value In Frame Frame04 = trim(ttWm-box-movto-idx-picking.nome-abrev).          ~
                            END. ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define TriggersCloseProgram RUN piFinalizaObjetos.

&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */


/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    ASSIGN vLogErro = NO
           vLogCancela = NO.
    /* caso tenha sido startado login autom†tico */
    IF v_cod_usuar_corren <> '' THEN DO: 
        assign vcod-senha:blank in frame frame01 = NO.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
               ttWork.cod-usuario                               = v_cod_usuar_corren
               vcod-senha                                       = '****************':U /* login autom†tico */
               vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom†tico */
        IF v_cod-coletor_corren     <> '' AND 
           v_cod-equipamento_corren <> '' THEN DO:
            ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                   ttWork.cod-coletor     = v_cod-coletor_corren
                   ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                   ttWork.cod-equipamento = v_cod-equipamento_corren.
       END.
    END.
    ELSE DO:
        assign vcod-senha:blank in frame frame01 = YES.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
               ttWork.cod-usuario = ''
               vcod-senha = ''  
               vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
    END.

End Procedure.

Procedure InicializaCamposFrame02:
    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.

    IF v_cod_usuar_corren = '' THEN RETURN ERROR.

    IF l-primeiro THEN
        ASSIGN ttWork.cod-zona-ini = ""
               ttWork.cod-zona-fim = "ZZZZZ"
               l-primeiro          = NO.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:

    ASSIGN vLogErro = NO
           vLogCancela = NO
           vLogSai = NO.

    ASSIGN c-etiq-separa = "".

End Procedure.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:

    ASSIGN vLogErro        = NO
           vLogCancela     = NO
           vLogEmProcesso  = NO.

    RUN GetTasks.

    IF vLogerro = YES THEN RETURN ERROR. 

    IF NOT VALID-HANDLE(wgbosc044) THEN DO:
        Run scbo/bosc044.p Persistent Set wgbosc044       No-error.
        Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
    END.

    Empty Temp-table tt-mostra-locais.

    Assign vNumSeq = 0.

    wm-boxm:
    For Each ttWm-box-movto-idx-picking
        Where ttWm-box-movto-idx-picking.ind-tipo-movto = 2
            BREAK By ttWm-box-movto-idx-picking.nr-pedcli
            By ttWm-box-movto-idx-picking.nome-abrev
            By ttWm-box-movto-idx-picking.val-prioridade:

        /* Pegar Informacoes Box */
        Run SetConstraintBoxes  In wgbosc030 (Input ttWm-box-movto-idx-picking.cod-estabel,
                                              Input ttWm-box-movto-idx-picking.cod-local,
                                              Input ttWm-box-movto-idx-picking.id-box,
                                              Input ttWm-box-movto-idx-picking.id-box).

        Run openQueryStatic In wgbosc030 (Input 'Boxes':U).

        Run getBatchRecords IN wgbosc030 (Input   ?,
                                          Input  NO,
                                          Input  ?,
                                          Output vNumCont,
                                          Output Table ttwm-box).

        Find First ttwm-box No-error.

        If Not Avail ttwm-box Then Next wm-boxm.

        Assign vNumSeq = vNumSeq + 1.

        Create tt-mostra-locais.
        Assign tt-mostra-locais.num-seq           = vNumSeq
               tt-mostra-locais.cod-bloco         = ttwm-box.cod-bloco
               tt-mostra-locais.cod-rua           = ttwm-box.cod-rua
               tt-mostra-locais.cod-nivel         = ttwm-box.cod-nivel
               tt-mostra-locais.cod-coluna        = ttwm-box.cod-coluna
               tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                    ttwm-box.cod-rua              + '/':U +
                                                    ttwm-box.cod-nivel            + '/':U +
                                                    ttwm-box.cod-coluna           + '/':U +
                                                    If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'.
               tt-mostra-locais.rowid-box-movto   = Rowid(ttWm-box-movto-idx-picking).                                                                                   


        IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
            ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.

    End. /*For Each ttWm-box-movto-idx-picking:*/

    FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
    IF RECID(tt-mostra-locais) = ? THEN DO:
        CREATE tt-mostra-locais.
        ASSIGN tt-mostra-locais.num-seq   = 999
               tt-mostra-locais.des-local = 'N∆o existem tarefas (WMS)'.
    END.
    Open Query qry-wm-box-movto For Each tt-mostra-locais 
        By tt-mostra-locais.cod-bloco
        By tt-mostra-locais.cod-rua
        By tt-mostra-locais.cod-nivel
        By tt-mostra-locais.cod-coluna DESC.

    Apply 'value-changed':U To brw-wm-box-movto In Frame {&Frame04Name}.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:


    Assign vLogErro          = No
           vLogControlaLogin = NO.

    /* valida usuario mestre contra mguni do EMS */
    IF ttWork.cod-usuario = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Usu†rio Inv†lido (DC)"}
    END.

    IF v2_cod_usuar_corren = ''  THEN DO:
       FOR each tt-erros:
           DELETE tt-erros.
       END.
       login:
       do on error  undo login, leave login
       on quit   undo login, leave login
       on stop   undo login, leave login
       on endkey undo login, leave login: 
          run btb/btapi910za.p (input INPUT FRAME frame01 ttWork.cod-usuario, 
                                INPUT INPUT FRAME frame01 vCod-Senha, 
                                output table tt-erros) NO-ERROR.        
       end. 
       IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
          {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado!(DC)"}
          Assign vLogErro           = Yes
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
             {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta!(DC)"} 
              Assign vLogErro           = Yes
                     v_cod_usuar_corren = ''.
              RETURN ERROR.
          END.
       END.
       ASSIGN vLogControlaLogin = YES.
    END.

    /* executa-se neste ponto devido ao login */
    IF NOT VALID-HANDLE(wgbosc030) THEN DO:
        Run scbo/bosc030.p Persistent Set wgbosc030       No-error.
        Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc096) THEN DO:
        Run scbo/bosc096.p Persistent Set wgbosc096       No-error.
        Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
        Run scbo/bosc032.p Persistent Set wgbosc032       No-error.
        Run openQueryStatic In wgbosc032 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc044) THEN DO:
        Run scbo/bosc044.p Persistent Set wgbosc044       No-error.
        Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
        Run scbo/bosc079.p Persistent Set wgbosc079.
        Run openQueryStatic In wgbosc079 (Input "Main":U) No-error.
    END.

    IF NOT VALID-HANDLE(wgbosc135)  THEN DO:
        Run scbo/bosc135.p Persistent Set wgbosc135.
        Run openQueryStatic In wgbosc135 (Input "Main":U) No-error.
    END.

    /* Valida se usu†rio tem permiss∆o para executar a tarefa. */
    RUN validaUsuarioTarefa In wgbosc135 (Input ttWork.cod-usuario,
                                          INPUT 07).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = YES.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "100" "Usu†rio sem permiss∆o para executar Picking (WMS)"}
        Return Error.
    END.

    Run validaUsuario In wgbosc079 (Input input Frame Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    If Return-value <> 'OK':U Then Do:
       Assign vLogErro = YES.
       IF vLogControlaLogin = YES THEN
          ASSIGN v_cod_usuar_corren  = ''
                 v2_cod_usuar_corren = ''.
       Run getrowErrors In wgbosc079 (output Table RowErrors).
       For Each RowErrors:
           ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
           {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
       END.                                           
    End.

    IF  vLogUtilizaColetor = NO THEN DO:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "101" "Usu†rio sem permiss∆o para utilizar Coletor (WMS)"}
        Return Error.
    END.


    IF ttWork.cod-coletor = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Coletor Inv†lido (WMS)"}
    END.

    If  ttWork.cod-equipamento = '' Then Do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "103" "Equipamento Inv†lido (WMS)"}
    End.

    If vLogErro = Yes Then Return Error.

    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       Run scbo/bosc092.p Persistent Set wgbosc092 No-error.
       Run EmptyRowErrors In wgbosc092.
    END.

    Run validaEquipColetor In wgbosc092  (Input  ttWork.cod-coletor,
                                          Output vCodTipoEquip,
                                          Output vLogAtivo,
                                          Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "103" "Coletor Inv†lido (WMS)"}
    End.

    If   vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
    End.

    If vLogErro = Yes Then Return Error.

    Run validaEquipTransportador In wgbosc092  (Input  ttWork.cod-equipamento,
                                                Output vCodTipoEquip,
                                                Output vLogAtivo,
                                                Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "104" "Equipamento Inv†lido (WMS)"}
    End.

    If   vLogAtivo = No Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
    End.
    If vLogErro = Yes Then Return Error.

    Assign  {&TempTable}.cod-usuario     = ttWork.cod-usuario 
            {&TempTable}.cod-coletor     = ttWork.cod-coletor
            {&TempTable}.cod-equipamento = ttWork.cod-equipamento.

End Procedure.

Procedure GravaCamposFrame02:
    Assign vLogErro = No.

    If input Frame  Frame02 ttWork.cod-zona-ini > input Frame  Frame02 ttWork.cod-zona-fim
    Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "201" "Zona final maior que zona inicial"}
    End.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:
    ASSIGN vLogErro = NO.

    DEFINE VARIABLE i-etiq-aux AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE i-tam AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-nr-nf AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-serie AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-estab AS CHARACTER   NO-UNDO.

    ASSIGN i-etiq-aux = DEC(c-etiq-separa) NO-ERROR.

    IF i-etiq-aux = ?
    OR i-etiq-aux = 0 THEN DO:
        {bcp/bc9105.i "305" "Etiqueta inv†lida."}
        RETURN ERROR.
    END.

    /* validar etiqueta */
    ASSIGN i-tam = LENGTH(c-etiq-separa).

    IF i-tam = 0 
    OR c-etiq-separa = ""
    OR i-tam < 21 THEN DO:
       {bcp/bc9105.i "301" "Etiqueta inv†lida."}
       RETURN ERROR.
    END.

    ASSIGN c-estab = SUBSTR(c-etiq-separa,1,i-tam - 18)
           c-serie = SUBSTR(c-etiq-separa,i-tam - 17,3)
           c-nr-nf = SUBSTR(c-etiq-separa,i-tam - 14,7)
           i-vol   = INT(SUBSTR(c-etiq-separa,i-tam - 7,4)).

    FOR FIRST nota-fiscal NO-LOCK
        WHERE nota-fiscal.cod-estabel = c-estab
          AND nota-fiscal.serie       = c-serie
          AND nota-fiscal.nr-nota-fis = c-nr-nf:
    END.

    IF NOT AVAIL nota-fiscal THEN DO:
        ASSIGN c-serie = TRIM(STRING(INT(c-serie))).

        FOR FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = c-estab
              AND nota-fiscal.serie       = c-serie
              AND nota-fiscal.nr-nota-fis = c-nr-nf:
        END.
    END.

    IF NOT AVAIL nota-fiscal THEN DO:
        {bcp/bc9105.i "302" "N∆o encontrada nota fiscal para etiqueta informada."}
        RETURN ERROR.
    END.

    FOR FIRST pre-fatur NO-LOCK
        WHERE pre-fatur.cdd-embarq = nota-fiscal.cdd-embarq
          AND pre-fatur.nr-resumo  = nota-fiscal.nr-resumo:
    END.

    IF NOT AVAIL pre-fatur THEN DO:
        {bcp/bc9105.i "303" "N∆o encontrado dados do embarque para nota informada."}
        RETURN ERROR.
    END.
 
    FOR FIRST integra-mft-wms-notas NO-LOCK
        WHERE integra-mft-wms-notas.cod-estabel = nota-fiscal.cod-estabel
          AND integra-mft-wms-notas.serie       = nota-fiscal.serie
          AND integra-mft-wms-notas.nr-nota-fis = nota-fiscal.nr-nota-fis:
    END.

    IF NOT AVAIL integra-mft-wms-notas THEN DO:
        {bcp/bc9105.i "304" "N∆o encontrados dados de integraá∆o do embarque ao WMS."}
        RETURN ERROR.
    END.

    FOR FIRST wm-docto USE-INDEX idx-docto5 NO-LOCK
        WHERE wm-docto.cod-estabel = integra-mft-wms-notas.cod-estabel
          AND wm-docto.num-docto   = integra-mft-wms-notas.cod-integra:
    END.

    IF NOT AVAIL wm-docto THEN DO:
        {bcp/bc9105.i "305" "N∆o encontrado documento WMS."}
        RETURN ERROR.
    END.

    FOR FIRST volume-nf NO-LOCK
        WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
          AND volume-nf.serie       = nota-fiscal.serie
          AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
          AND volume-nf.nr-volume   = i-vol:
    END.

    IF NOT AVAIL volume-nf THEN DO:
        {bcp/bc9105.i "306" "N£mero do volume Ç inv†lido para nota fiscal."}
        RETURN ERROR.
    END.

    Assign vLogIniciado = No.

    Assign ttWork.qtd-embal-lidas  = 0
           ttWork.des-seriais      = ''
           ttWork.num-box-lido     = 0
           ttWork.num-doca         = 0
           ttWork.qtd-embal-lidas  = 0
           ttWork.qtd-item-digit   = 0.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:

    Assign vLogErro = NO
           vLogSai = No 
           vLogFinaliza = NO.

    If Not Avail ttWm-box-movto-idx-picking Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "401" "Movimento Inv†lido. (WMS)"}
         Return Error.
    End.                     

    If  ttWork.opcao = 4 Then Do:
        Assign vLogEmProcesso = Yes.
    End.

    /*If  vLogEmProcesso = No Then Do:
        Run inicializaTarefaMovtoOK In wgbosc096
                                     (Input ttWm-box-movto-idx-picking.id-docto,
                                      Input 07,     
                                      Input ttWork.cod-usuario,              
                                      Input ttWork.cod-equipamento,          
                                      Input ttWork.cod-coletor,              
                                      Input ttWm-box-movto-idx-picking.id-movto,         
                                      Input ttWm-box-movto-idx-picking.num-seq-item).

        If  Return-value <> 'OK' Then Do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "302" "Movimento Expirado ou J† Alocado (WMS)"}
            Return Error.
        End.
        Assign vLogEmProcesso = Yes.
    End.*/

    Assign vLogErro = No.
    If Not Avail ttWm-box-movto-idx-picking Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "402" "Movimento Inv†lido (WMS)"}
         Return Error.
    End.

    Hide All.

    Assign vLogFinaliza = No
           vLogSai      = No.

    find first ttWork no-error.

    ASSIGN ttWork.qtd-embal-lidas = 0. 

    Hide All No-pause.
    ASSIGN cod-estab-roteiriz = ttWm-box-movto-idx-picking.cod-estabel
           cod-local-roteiriz = ttWm-box-movto-idx-picking.cod-local
           id-movto-roteiriz  = ttWm-box-movto-idx-picking.id-movto.
    RUN esp/bcp/esbcp017h.p (INPUT ROWID(ttWm-box-movto-idx-picking)).
    Hide All No-pause.
    IF ttWork.opcao = 2 THEN DO:
        RUN wmp/wm9043.p (INPUT cod-estab-roteiriz,
                          INPUT cod-local-roteiriz,
                          INPUT id-movto-roteiriz).
    END.

    FIND FIRST ttWork NO-ERROR.
    RETURN RETURN-VALUE.

End Procedure.

/*************************************************************************************************** 
** Esta procedure ir† obter a lista das tarefas para a transaá∆o de picking                       **
****************************************************************************************************/
PROCEDURE GetTasks:

    DEFINE VARIABLE hDBOEquipAcesso AS HANDLE      NO-UNDO.

    Assign vLogCancela  = NO
           vLogErro = NO.
    Empty Temp-table ttWm-box-movto-idx-picking.
        
    IF NOT VALID-HANDLE (hDBOEquipAcesso) THEN
        RUN scbo/bosc097.p PERSISTENT SET hDBOEquipAcesso.
    RUN openQueryStatic IN hDBOEquipAcesso (INPUT "Main":U) NO-ERROR.

    FOR EACH integra-mft-wms-notas NO-LOCK
        WHERE integra-mft-wms-notas.cod-estabel = nota-fiscal.cod-estabel
          AND integra-mft-wms-notas.serie       = nota-fiscal.serie
          AND integra-mft-wms-notas.nr-nota-fis = nota-fiscal.nr-nota-fis,
        FIRST wm-docto USE-INDEX idx-docto5 NO-LOCK
            WHERE wm-docto.cod-estabel = integra-mft-wms-notas.cod-estabel
              AND wm-docto.num-docto   = integra-mft-wms-notas.cod-integra
        BREAK BY integra-mft-wms-notas.cod-integra:

        IF FIRST-OF(integra-mft-wms-notas.cod-integra) THEN DO: /* por documento WMS */

            FOR EACH wm-tarefa-docto-itens USE-INDEX idx-tarefa-itens5
                WHERE wm-tarefa-docto-itens.id-docto                = wm-docto.id-docto
                  AND wm-tarefa-docto-itens.cod-tarefa              = 7
                  AND wm-tarefa-docto-itens.ind-status-tarefa-itens <> 3 /* N∆o iniciado / em processo*/ 
                  AND wm-tarefa-docto-itens.cdn-tipo-equipamento    = INT(vCodTipoEquip)
                  AND (   wm-tarefa-docto-itens.cod-usuario         = ""
                       OR wm-tarefa-docto-itens.cod-usuario         = ttWork.cod-usuario)
                  AND (   wm-tarefa-docto-itens.cod-equipamento     = ""
                       OR wm-tarefa-docto-itens.cod-equipamento     = ttWork.cod-equipamento),
                EACH wm-box-movto NO-LOCK 
                  WHERE wm-box-movto.id-docto     = wm-tarefa-docto-itens.id-docto
                    AND wm-box-movto.id-movto     = wm-tarefa-docto-itens.id-movto
                    AND wm-box-movto.num-seq-item = wm-tarefa-docto-itens.num-seq-item
                    AND wm-box-movto.ind-tipo-movto = 2 /* saida */
                    AND CAN-FIND(FIRST zona-separa-box NO-LOCK
                                 WHERE zona-separa-box.cod-estabel = wm-box-movto.cod-estabel  /* so o que sai de zona separacao */
                                   AND zona-separa-box.cod-local   = wm-box-movto.cod-local
                                   AND zona-separa-box.id-box      = wm-box-movto.id-box
                                   AND zona-separa-box.cod-zona   >= ttWork.cod-zona-ini
                                   AND zona-separa-box.cod-zona   <= ttWork.cod-zona-fim),
                FIRST wm-box NO-LOCK
                    WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                      AND wm-box.cod-local   = wm-box-movto.cod-local
                      AND wm-box.id-box      = wm-box-movto.id-box:
        
                /* somente itens do volume lido */
                IF NOT CAN-FIND(FIRST volume-nf NO-LOCK
                                WHERE volume-nf.cod-estabel = nota-fiscal.cod-estabel
                                  AND volume-nf.serie       = nota-fiscal.serie
                                  AND volume-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                                  AND volume-nf.nr-volume   = i-vol
                                  AND volume-nf.it-codigo   = wm-box-movto.cod-item) THEN 
                    NEXT.

                IF  wm-box-movto.int-2  <> 0
                AND (   wm-box-movto.int-2  <> i-vol  /* sugestao para o volume conforme UPC wm9020 */
                     OR wm-box-movto.char-2 <> nota-fiscal.nr-nota-fis) THEN
                    NEXT.

                RUN validaAcessoEquip1Box IN hDBOEquipAcesso (INPUT ttWork.cod-equipamento,
                                                              INPUT wm-box.cod-rua,
                                                              INPUT wm-box.cod-nivel,
                                                              INPUT wm-box.cod-estabel,
                                                              INPUT wm-box.cod-local,
                                                              INPUT wm-box.cod-bloco).
        
                IF RETURN-VALUE = "NOK":U THEN NEXT.
                    
                CREATE ttWm-box-movto-idx-picking.
                BUFFER-COPY wm-box-movto TO ttWm-box-movto-idx-picking 
                    ASSIGN ttWm-box-movto-idx-picking.val-prioridade = wm-tarefa-docto-itens.val-prioridade
                           ttWm-box-movto-idx-picking.nr-pedcli      = integra-mft-wms-notas.nr-pedcli
                           ttWm-box-movto-idx-picking.nome-abrev     = integra-mft-wms-notas.nome-abrev.
            END.
        END. /* first-of */
    END.

    IF VALID-HANDLE(hDBOEquipAcesso) THEN 
        RUN DESTROY IN hDBOEquipAcesso.

    RETURN 'OK':U.
END PROCEDURE.

PROCEDURE piFinalizaObjetos:

    IF VALID-HANDLE(wgbosc030) THEN
        RUN destroy IN wgbosc030.

    IF VALID-HANDLE(wgbosc032) THEN
        RUN destroy IN wgbosc032.

    IF VALID-HANDLE(wgbosc038) THEN
        RUN destroy IN wgbosc038.

    IF VALID-HANDLE(wgbosc044) THEN
        RUN destroy IN wgbosc044.

    IF VALID-HANDLE(wgbosc074) THEN
        RUN destroy IN wgbosc074.

    IF VALID-HANDLE(wgbosc092) THEN
        RUN destroy IN wgbosc092.

    IF VALID-HANDLE(wgbosc096) THEN
        RUN destroy IN wgbosc096.

    IF VALID-HANDLE(wgbosc079) THEN
        RUN destroy IN wgbosc079.

    IF VALID-HANDLE(wgbosc135) THEN
        RUN destroy IN wgbosc135.

    IF VALID-HANDLE(wgbc9018f) THEN
        DELETE PROCEDURE wgbc9018f NO-ERROR.

    IF VALID-HANDLE(wgeswmpapi002) THEN
        DELETE PROCEDURE wgeswmpapi002 NO-ERROR.

    RETURN "OK".
END PROCEDURE.
