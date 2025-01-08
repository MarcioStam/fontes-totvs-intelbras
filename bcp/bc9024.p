/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024 2.00.00.028 } /*** 010028 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9024.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Invent rio WMS                   **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-recebe-wms.                                                      **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame03, etc.                                     **
** Frame99Defs          - Definicoes da tela onde a mesma deve conter:                            **
**                        .Titulo da Tela quando necessario.                                      **
**                        .Campos com a opcao no-label e sua localizacao Ex. At Row x Col y.      **
**                        .Literais que substituem os labels dos campos e sua localizacao.        **
**                        .Instrucoes de Navegacao quando houver espaco livre para o mesmo.       **
**                        Ex. "F4=Sair","ESC=Voltar","F2=Gravar" etc.                             **
** Frame99Repeat        - Indica se a tela tem caracteristica de repeticao. O Valor YES indica    **
**                        que ha repeticao e o valor NO indica que nao ha repeticao.              **
** Update99Fields       - Relaciona os campos que serao solicitados na tela.                      **
**                        OBS. Nao deve conter formatacao. Ex. ttWork.it-codigo no-label.         **
** TriggerBeforeFrame99 - Gatilho para ser executado antes da execucao da tela. Neste gatilho     **
**                        devem ser colocadas chamadas as procedures de inicializacao dos campos  **
**                        da tela.                                                                **
** TriggerAfterFrame99  - Gatilho para ser executado apos a execucao da tela. Neste gatilho       **
**                        dever ser colocada a chamada a procedures que devera armazenar  na      **
**                        temp-table {&TempTable} os campos da ttWork, que sao os campos          **
**                        solicitados em tela. Neste gatilho tambem, quando o mesmo se referir a  **
**                        ultima tela de entrada de dados, devera existir uma chamada a procedure **
**                        que executa a procedure _GenerateDCTransaction que eï responsavel por   **
**                        gerar a transacao no Coleta de Dados.                                   **
** UserTriggers         - Este pro-processador destina-se as triggers customizadas do usuario.    **
**                        Ex: Alimentar um campo da dela conforme o informado em outro campo.     **
**                            On Leave of ttWork.cod-depos in Frame Frame02                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9024
&global-define MessageBell YES
/************************************************************/
{upc/btb910za-upc.i} /* Defini‡Æo da vari vel New Global Shared "v_cod_estab_usuar" */

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i}

DEFINE VARIABLE id-box-contar LIKE wm-box.id-box   NO-UNDO.
Define Temp-table ttWork NO-UNDO Like {&TempTable}.

Create ttWork.

Define Temp-table ttInventario No-undo Like wm-inventario.

Define Temp-table ttContagem No-undo
    Fields vNrContagem As Integer.

Define Query qryInventario       For ttInventario.       

Define Query qryContagem         For ttContagem.

Define Browse brwInventario Query qryInventario No-lock
             Display 
              ttInventario.num-seq-invent
              '-':U
              ttInventario.dt-inventario
                    With No-box No-labels Size 20 By 5 No-scrollbar-vertical.


Define Browse brwContagem Query qryContagem No-lock
             Display 
              ttContagem.vNrContagem
              With No-box No-labels Size 20 By 5 No-scrollbar-vertical.

DEFINE VARIABLE i-num-box-aux LIKE ttWork.num-box NO-UNDO.
DEFINE VARIABLE vpause AS CHARACTER FORMAT 'x(15)' NO-UNDO. 
DEFINE VARIABLE intvLado AS INTEGER NO-UNDO. 
DEFINE VARIABLE c-cod-estab-user AS CHAR FORMAT "x(18)".
DEFINE VARIABLE c-cod-estabelecimento AS CHARACTER FORMAT "x(03)"  NO-UNDO.

DEFINE VARIABLE vleitura AS CHARACTER FORMAT 'x(2)' NO-UNDO. 
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Invent rio WMS'                                   At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Est:'                                             AT ROW 05 COL 01          ~
                             c-cod-estabelecimento                              AT ROW 05 COL 05 NO-LABEL ~
                             'Legenda Serial:   '                               AT ROW 06 COL 01          ~
                             '555555 -End. Vazio'                               AT ROW 07 COL 01          ~
                             vpause                                             AT ROW 08 COL 01 NO-LABEL ~
&global-define Frame01Repeat NO 

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Invent rio WMS'                                   At Row 01 Col 01          ~
                             c-cod-estab-user NO-LABELS                         At Row 02 Col 01          ~
                             'Invent rios Pend.:'                               At Row 03 Col 01          ~
                             brwInventario                                      At Row 04 Col 01
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Invent rio WMS'                                   At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Contagens:'                                       At Row 03 Col 01          ~
                             brwContagem                                        At Row 04 Col 01          
&global-define Frame03Repeat NO

/* Definicao da Frame04 ---                               */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Invent rio WMS'                                  At Row 01 Col 01                         ~
                             '--------------------'                            At Row 02 Col 01                         ~
                             'Box:'                                            At Row 03 Col 01                         ~
                             ttWork.num-box                                    At Row 04 Col 01 No-label                ~
                             'Bloco:'                                          At Row 05 Col 01                         ~
                             vCodBloco                                         At Row 05 Col 08 No-label                ~
                             'Rua:'                                            At Row 06 Col 01                         ~
                             vCodRua                                           At Row 06 Col 08 No-label                ~
                             'N¡vel:'                                          At Row 07 Col 01                         ~
                             vCodNivel                                         At Row 07 Col 08 No-label                ~
                             'Coluna:'                                         At Row 08 Col 01                         ~
                             vCodColuna                                        At Row 08 Col 08 No-label                ~
                             'Lado:'                                           At Row 08 Col 12                         ~
                             vLado                                             At Row 08 Col 17 No-label                ~
&global-define Frame04Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              c-cod-estabelecimento vpause
&global-define Update02Fields brwInventario
&global-define Update03Fields brwContagem 
&global-define Update04Fields ttWork.num-box 
                                 
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      If vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. If  Return-value = 'OK':U Then Return Return-value.
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'ESC':U OF Frame Frame01    ~
                            DO:                            ~
                                ASSIGN vlogerro = YES      ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES  ~
                                       vLogCancela = YES.  ~
                                Return 'NOK':U.            ~
                            END. ~
                            ON 'Return':U        OF brwInventario       In Frame {&Frame02Name}     ~
                            DO:                                                                     ~
                               Apply 'Go' To This-procedure.                                        ~
                            END.                                                                    ~
                            ON 'Return':U        OF brwContagem In Frame {&Frame03Name}             ~
                            DO:                                                                     ~
                               Apply 'Go' To This-procedure.                                        ~
                            END.              ~
                                
/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc117
&global-define ActiveObject3 wgbosc118
&global-define ActiveObject4 wgbosc030

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */

{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1             **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    ASSIGN vpause = '999999 -Encerra'.
    ASSIGN vpause:READ-ONLY IN FRAME frame01 = YES.    
    If  RETURN-VALUE = 'NOK':U Then Do:
        ASSIGN vlogerro = YES     
               vLogSai  = YES      
               vLogFinaliza = YES
               vLogCancela = YES. 
        HIDE ALL NO-PAUSE.
        RETURN ERROR.
    End.
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    FOR EACH ttWork:
        DELETE ttWork.
    END.
    Create ttWork.
    IF v_cod_usuar_corren <> '' THEN DO: 
        assign vcod-senha:blank in frame frame01 = NO.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
               ttWork.cod-usuario                               = v_cod_usuar_corren
               vcod-senha                                       = '****************':U /* login autom tico */
               vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
    END.
    ELSE DO:
        assign vcod-senha:blank in frame frame01 = YES.
        ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
               ttWork.cod-usuario = ''
               vcod-senha = ''  
               vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
    END.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO. 
    Empty Temp-table ttInventario.
    IF NOT VALID-HANDLE(wgbosc117)  THEN DO:
       Run scbo/bosc117.p Persistent Set wgbosc117.
       Run openQueryStatic In wgbosc117 (Input "Main":U) No-error.
    END.

    Run getInventario In wgbosc117 (output Table  ttInventario).

    Open Query qryInventario For Each ttInventario
                                WHERE ttInventario.cod-estabel = c-cod-estabelecimento
                                 By ttInventario.dt-inventario 
                                 By ttInventario.num-seq-invent.

    c-cod-estab-user:SCREEN-VALUE IN FRAME Frame02 = ' ------ ' + trim(c-cod-estabelecimento) + ' -------'.

    IF RECID(ttInventario) = ? THEN DO:
        {bcp/bc9105.i "100" "NÆo existem invent rios para serem realizados (WMS)"}
        Assign vLogErro = Yes.
        Return Error.
    END.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    FOR EACH ttContagem:
        DELETE ttContagem.
    END.
    IF NOT VALID-HANDLE(wgbosc118)  THEN DO:
       Run scbo/bosc118.p Persistent Set wgbosc118.
       Run openQueryStatic In wgbosc118 (Input "Main":U) No-error.
    END.

    Run getNumeroContagem In wgbosc118 (input ttInventario.cod-estabel,
                                  input ttInventario.cod-local        ,
                                  input ttInventario.dt-inventario    ,
                                  input ttInventario.num-seq-invent   ,
                                  output Table ttContagem).

    Open Query qryContagem For Each ttContagem.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:

   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO
          vCodBloco    = ""
          vCodRua      = ""
          vCodNivel    = ""
          vCodColuna   = "".
       
       
       .
    /* Pegar Informacoes Box */

   
    IF ttWork.num-box <> 0 THEN
        Assign i-num-box-aux  = ttWork.num-box.
    
    ASSIGN ttWork.num-box = 0.
    
    FIND FIRST Wm-param NO-LOCK NO-ERROR.
    
    IF Wm-param.log-gera-rotei-invent = YES  THEN DO:
    
        IF i-num-box-aux <> 0 AND NOT AVAIL RowErrors THEN DO:
           
            /* Sugere endere‡o para inventariar */
            IF NOT VALID-HANDLE(wgbosc118)  THEN DO:
                Run scbo/bosc118.p Persistent Set wgbosc118.
                Run openQueryStatic In wgbosc118 (Input "Main":U) No-error.
            END.
            
            RUN emptyRowErrors IN wgbosc118.
        
            RUN retornaEndereco IN wgbosc118(INPUT ttWork.cod-estabel,
                                               INPUT ttWork.cod-local,     
                                               INPUT ttWork.dat-inventario, 
                                               INPUT ttWork.num-seq-invent,
                                               INPUT i-num-box-aux,  
                                               INPUT ttWork.num-contagem,      
                                               INPUT ttWork.cod-usuario,   
                                               OUTPUT id-box-contar,
                                               OUTPUT TABLE RowErrors).
            .
            IF CAN-FIND(FIRST RowErrors) THEN DO:
                
                For Each RowErrors:
                    Assign vLogErro = Yes.
                    ASSIGN ErrorDescription = ErrorDescription + " para (WMS)":U.
                    {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
                End.
                IF vLogErro = YES THEN RETURN Error.
                
            END.                        
    
            FIND FIRST wm-box NO-LOCK
                WHERE  wm-box.cod-estabel = ttWork.cod-estabel
                AND    wm-box.cod-local   = ttWork.cod-local 
                AND    wm-box.id-box      = id-box-contar NO-ERROR.
            IF AVAIL wm-box THEN DO:
        
                ASSIGN vCodBloco  = wm-box.cod-bloco
                       vCodRua    = wm-box.cod-rua
                       vCodNivel  = wm-box.cod-nivel
                       vCodColuna = wm-box.cod-coluna.
                       IF wm-box.ind-posicao-box=1 THEN DO:
                            ASSIGN vLado = "E".
                       END.
                       ELSE DO:
                            ASSIGN vLado = "D".
                       END.
                       
            END.
        END.
        /* Sugere endere‡o para inventariar */
    END.
    DISP vCodBloco vCodRua vCodNivel vCodColuna vLado With Frame frame04.
    
    Pause 0 No-message.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    /* Validacoes Frame 01 Inicio --- */
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
           vLogControlaLogin = NO.

    /* VALIDA€AO USUµRIO */
    If  input Frame Frame01 ttWork.cod-usuario = '' Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "201" "Usu rio Inv lido!(DC)"}
    End. 
    If vLogErro = Yes Then Return Error.
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
          {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
          Assign vLogErro           = Yes
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
             {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est ÿcorreta!(DC)"} 
              Assign vLogErro           = Yes
                     v_cod_usuar_corren = ''.
              RETURN ERROR.
          END.
       END.
       ASSIGN vLogControlaLogin = YES.
    END.

    IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
       Run scbo/bosc079.p Persistent Set wgbosc079.
       Run openQueryStatic In wgbosc079 (Input "Main":U) No-error.
    END.
    Run validaUsuario In wgbosc079 (Input input Frame Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
    If Return-value <> 'OK':U Then Do:
        IF vLogControlaLogin = YES THEN
        ASSIGN v_cod_usuar_corren  = ''
               v2_cod_usuar_corren = ''.
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
        END.                                           
        Assign vLogErro = Yes.
    End.
    IF vLogUtilizaColetor = NO THEN DO:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
        ASSIGN v_cod_usuar_corren  = ''
               v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
    END.
    If vLogErro = Yes Then Return Error.

    If   vLogErro = Yes Then Return Error.

    /*
    ASSIGN vpause:READ-ONLY IN FRAME frame01 = YES.    
    UPDATE vpause WITH FRAME frame01.
    */

    Return Return-value.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:
    ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
    If Not Avail ttInventario Then Return Error.

    Assign  ttWork.cod-estabel    = ttInventario.cod-estabel 
            ttWork.cod-local      = ttInventario.cod-local 
            ttWork.dat-inventario = ttInventario.dt-inventario 
            ttWork.num-seq-invent = ttInventario.num-seq-invent.
    Assign vLogErro = No vLogSai = No vLogFinaliza = No. 
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:
    ASSIGN vLogErro     = NO
           vLogsai      = NO
           vLogfinaliza = NO.
    If  Not Avail ttContagem Then Return Error.

    Assign ttWork.num-contagem = ttContagem.vNrContagem.

    Assign vLogErro = No vLogSai = No vLogFinaliza = No.  
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:

    Assign vLogErro = No vLogSai = No vLogFinaliza = No.

    IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
       Run scbo/bosc030.p Persistent Set wgbosc030.
       Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.
    END.

    If  ttWork.num-box = 0 Then Do:
        Hide All No-pause.

        
        Run bcp/bc9024f.p  (input  ttWork.cod-estabel,
                            input  ttWork.cod-Local  ,
                            Output ttWork.num-box) .

        Hide All No-pause.


        IF vLogErro = YES OR ttWork.num-box = 0 THEN DO:
            ASSIGN vLogerro = YES.
            Return Error.
        END.

        View Frame frame04.
        Pause 0 No-message.
        Disp  ttWork.num-box With Frame frame04.
        Pause 0 No-message.
    End.

    /* IF id-box-contar <> 0 AND id-box-contar <> ? THEN DO:
       IF(ttWork.num-box <> id-box-contar) THEN DO: 
           
           ASSIGN vLogerro       = YES
                   ttWork.num-box = 0.
            {bcp/bc9105.i "202" "Box nÆo confere com endere‡o a contar."}
            Return Error.  
          
        END.         
        
    END. */
                                       
    Run emptyRowErrors In wgbosc118.

    Run ValidaEnderecoInventario  In wgbosc118 (input  ttWork.cod-estabel, 
                                                Input  ttWork.cod-local,   
                                                Input  ttWork.dat-inventario,
                                                Input  ttWork.num-seq-invent,
                                                Input  ttWork.num-contagem,
                                                Input  ttWork.num-box,                                        
                                                Output ttWork.log-existe-end).

    If  Return-value <> 'OK' Then Do:
       
        Run getRowErrors In wgbosc118(Output Table RowErrors).
        For Each RowErrors:
            ASSIGN ErrorDescription = "box incompativel":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription) }
        End.
        Assign vLogErro = Yes.
        Return Error.
    End. /* Return-value <> 'OK' */

    Run emptyRowErrors In wgbosc030.

    Run GoToKey  In wgbosc030 (input  ttWork.cod-estabel,
                               Input  ttWork.cod-local,   
                               Input  ttWork.num-box).


    RUN getIntField IN wgbosc030 (INPUT "ind-posicao-box", OUTPUT intvLado).

    Run GetKey  In wgbosc030 (Output ttWork.cod-estabel,
                              Output ttWork.cod-local,                         
                              Output vCodBloco,
                              Output vCodRua,
                              Output vCodNivel,
                              Output vCodColuna).

    If  Return-value <> 'OK' Then Do:
        
        Run getRowErrors In wgbosc030(Output Table RowErrors).
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
        End.
        Assign vLogErro = Yes.
        Return Error.
    End. /* Return-value <> 'OK' */

    
    IF intvLado=1 THEN DO:
        ASSIGN vLado = "E".
    END.
    ELSE DO:
        ASSIGN vLado = "D".
    END.


    Assign vDesEndereco = trim(vCodBloco) + '/' + trim(vCodRua) + '/' + trim(vCodNivel) + '/' +  trim(vCodColuna) + '/' + TRIM(vLado).

    Disp vCodBloco vCodRua vCodNivel vCodColuna vLado With Frame frame04.
    Pause 0 No-message.

    If Not ttWork.log-existe-end Then Do:

        Hide All.
        Pause 0 No-message.
        Hide Frame frame04.
        Pause 0 No-message.

        Assign vLogOk = Yes.
        bc9024:
            DO on error  undo bc9024, leave bc9024
            on quit   undo bc9024, leave bc9024
            on stop   undo bc9024, leave bc9024
            on endkey undo bc9024, leave bc9024:

            /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
            DEFINE VARIABLE c-lbl-liter-inventario-wms AS CHARACTER FORMAT "X(16)" NO-UNDO.
            {utp/ut-liter.i "Invent rio_WMS" *}
            ASSIGN c-lbl-liter-inventario-wms = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-box-nao-pertence AS CHARACTER FORMAT "X(18)" NO-UNDO.
            {utp/ut-liter.i "Box_nÆo_pertence" *}
            ASSIGN c-lbl-liter-box-nao-pertence = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-ao-inventario AS CHARACTER FORMAT "X(18)" NO-UNDO.
            {utp/ut-liter.i "ao_invent rio" *}
            ASSIGN c-lbl-liter-ao-inventario = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-deseja-inclui-lo AS CHARACTER FORMAT "X(19)" NO-UNDO.
            {utp/ut-liter.i "Deseja_inclu¡-lo?" *}
            ASSIGN c-lbl-liter-deseja-inclui-lo = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(13)" NO-UNDO.
            {utp/ut-liter.i "1=Sim_2=NÆo" *}
            ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
            Disp c-lbl-liter-inventario-wms        At Row 01 Col 01 NO-LABEL    
                 '------------------'              At Row 02 Col 01
                 c-lbl-liter-box-nao-pertence      At Row 03 Col 01 NO-LABEL                                             
                 c-lbl-liter-ao-inventario + ':  ' At Row 04 Col 01 NO-LABEL                                             
                 vDesEndereco                      At Row 05 Col 01 No-label Format 'x(10)':U
                 c-lbl-liter-deseja-inclui-lo      At Row 06 Col 01 NO-LABEL
                 c-lbl-liter-1sim-2nao             At Row 07 Col 01 NO-LABEL With Frame f-conf Font 2 Size 20 By 8 No-box.


             ON 'ESC':U OF Frame f-conf /* colocado p nÆo ocorrer erro progress de frame nÆo definida */
             DO:                                                    
                ASSIGN vlogerro = YES.  
                Return 'ESC':U.           
             END. 
             Disp vDesEndereco With Frame f-conf.
             Pause 0 No-message.
             Update vLogOk At Row 07 Col 13 No-label Format '1/2':U With Frame f-conf Font 2 Size 20 By 8.
        END.
        Hide All.
        Pause 0 No-message.
        View Frame frame04.
        Pause 0 No-message.
        If Not vLogOk OR RETURN-VALUE = 'ESC':U Then Do:
            Assign vLogErro = Yes.
            Return Error.
        End.
        ELSE DO:       
            RUN createEnderecoInventarioColetor IN wgbosc118(INPUT ttWork.cod-estabel,   
                                                             INPUT ttWork.cod-local,     
                                                             INPUT ttWork.dat-inventario, 
                                                             INPUT ttWork.num-seq-invent,
                                                             INPUT ttWork.num-box,
                                                             OUTPUT TABLE RowErrors).
            ASSIGN ttWork.log-existe-end = YES.
            IF CAN-FIND(FIRST RowErrors) THEN DO:  
                For Each RowErrors:
                    ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                    Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                End.
                RETURN Error.
            END.  
        END.
    End.
    /* Valida se usuario pode realizar contagem */
    RUN emptyRowErrors IN wgbosc118.

    RUN validaContagem IN wgbosc118(INPUT ttWork.cod-estabel,   
                                      INPUT ttWork.cod-local,     
                                      INPUT ttWork.dat-inventario, 
                                      INPUT ttWork.num-seq-invent,
                                      INPUT ttWork.num-box,        
                                      INPUT ttWork.cod-usuario,
                                      OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors) THEN DO:  
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
        End.
        RETURN Error.
    END.  

    /* Valida se usuario pode realizar contagem */

    
    IF NOT VALID-HANDLE(wgbc9024j)  THEN DO:
       Run bcp/bc9024j.p Persistent Set wgbc9024j.
    END.

    /* a tt-invent rio possuir  os registros j  lidos, afim de valida‡Æo */
    RUN pi-popula-temp-table-inventario IN wgbc9024j (INPUT ttWork.cod-usuario,
                                                      INPUT ttWork.cod-estabel,
                                                      INPUT ttWork.cod-local,
                                                      INPUT ttWork.dat-inventario,
                                                      INPUT ttWork.num-contagem,
                                                      INPUT ttWork.num-box,
                                                      OUTPUT TABLE tt-inventario-wms-bkp).

    Hide All No-pause. 

    Run bcp/bc9024g.p (input vDesEndereco, 
                             INPUT-OUTPUT TABLE tt-inventario-wms-bkp,
                             input-output Table ttWork).

    Hide All No-pause.

    View Frame frame04.
    Pause 0 No-message.

    Find First ttWork NO-ERROR.
End Procedure.

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif

