/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9029 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9029 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9029.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - abril/2005 - Paulo Eduardo Budal - Cria‡Æo do programa      **
**                                                                                         **
**                                                                                         **
********************************************************************************************/
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
**                        Ex: &global-define ActiveObject Hbosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9029
/************************************************************/

{utp/utapi009.i} /* login */
{utp/ut-glob.i}
{esp/es0018.i}

/* Definicao da temp-table de integracao ---                */

&global-define TEMPTABLE tt-storage-serial-wms
{bcp/bc9029.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */ 

DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-etiqueta-lida NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item.

Define Temp-table ttWork NO-UNDO like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/


/* ************************** Definitions ******************************** */
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE vNomeUsuario      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE vLogControlaLogin AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE vProcesso         AS LOGICAL INITIAL NO  NO-UNDO.
DEFINE VARIABLE l-menu-padrao     AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE c-cod-barras      AS CHAR FORMAT "X(14)" NO-UNDO.

DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

DEFINE VARIABLE Hbosc038   AS HANDLE.
DEFINE VARIABLE Hbosc109   AS HANDLE.
DEFINE VARIABLE Hbcapiwms  AS HANDLE.
DEFINE VARIABLE Hbcapi9029 AS HANDLE.
DEFINE VARIABLE Hbosc074   AS HANDLE.


/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Armaz. Serial WMS '                               At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
                             
&global-define Frame01Repeat NO 

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Armaz. Serial WMS '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Serial:'                                          AT ROW 03 COL 01          ~
                              ttWork.num-serial                                 AT ROW 04 COL 01 NO-LABEL ~
                             'It:'                                              AT ROW 05 COL 01          ~
                              ttWork.cod-item                                   AT ROW 05 COL 04 NO-LABEL FORMAT "x(10)"~
                              'EAN:'                                            AT ROW 06 COL 01          ~
                              c-cod-barras                                      AT ROW 06 COL 05 NO-LABEL ~
                              ttWork.des-endereco                               At Row 07 Col 01 NO-LABEL ~
                              'Box: '                                           At Row 08 Col 01          ~
                              ttWork.num-box-lido                               At Row 08 Col 05 No-label ~
&global-define Frame02Repeat YES

/* &global-define Frame03Name   Frame03                                                                        */
/* &global-define Frame03Defs   'Armaz. Serial WMS   '                             At Row 01 Col 01          ~ */
/*                              '--------------------'                             At Row 02 Col 01          ~ */
/*                              'Serial:'                                          AT ROW 03 COL 01          ~ */
/*                               ttWork.num-serial                                 AT ROW 04 COL 01 NO-LABEL ~ */
/*                              'Item:'                                            AT ROW 05 COL 01          ~ */
/*                               ttWork.cod-item                                   AT ROW 06 COL 01 NO-LABEL ~ */
/*                               ttWork.des-endereco                               At Row 07 Col 01 NO-LABEL ~ */
/*                               'Box: '                                           At Row 08 Col 01          ~ */
/*                               ttWork.num-box-lido                               At Row 08 Col 05 No-label ~ */
/* &global-define Frame03Repeat YES                                                                            */
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&global-define Update02Fields ttWork.num-serial 
/* &global-define Update03Fields ttWork.num-box-lido  */
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
/* &global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.  */
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
/* &global-define TriggerAfterFrame03  Run GravaCamposFrame03.  */

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
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES      ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES  ~
                                       vLogCancela = YES.  ~
                                Return 'NOK':U.            ~
                            END. ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END. ~
                            ON 'ESC':U OF c-cod-barras ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END. ~
/*                             ON 'ESC':U OF Frame Frame03 ~ */
/*                             DO:                         ~ */
/*                                 ASSIGN vlogerro = YES.  ~ */
/*                                 Return 'ESC':U.         ~ */
/*                             END.                          */
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 Hbcapiwms
&global-define ActiveObject2 Hbcapi9029
/* &global-define ActiveObject3 wgbosc047.  */
/* &global-define ActiveObject4 wgbosc095.  */
/* &global-define ActiveObject5 wgbosc092.  */
/* &global-define ActiveObject6 wgbcapi001. */
/* &global-define ActiveObject7 Hbosc038.  */
/* &global-define ActiveObject5 Hbosc109.  */

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

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:
    ASSIGN vLogErro     = NO                               
           vLogsai      = NO                               
           vLogfinaliza = NO.          

    EMPTY TEMP-TABLE tt-etiqueta-lida.

    IF v_cod_usuar_corren = '' THEN RETURN ERROR.

    FIND FIRST ttwork NO-ERROR.

    ASSIGN ttWork.num-serial    = 0                         
           ttWork.cod-item      = ""                         
           ttWork.des-endereco  = ""
           ttWork.num-box-lido  = 0
           ttWork.cod-livre-1   = ""
           ttWork.dec-livre-1   = 0
           c-cod-barras         = "".

    DISPLAY ttWork.num-serial  
            ttWork.cod-item    
            c-cod-barras
            ttWork.des-endereco
            ttWork.num-box-lido 
        WITH FRAME frame02.
/*
    IF NOT VALID-HANDLE(Hbosc038)  THEN DO:
       Run scbo/bosc038.p Persistent Set Hbosc038.
       Run openQueryStatic In Hbosc038 (Input "Main":U) No-error.
    END.

    if NOT valid-handle(Hbosc109) THEN DO:
        Run scbo/bosc109.p Persistent Set Hbosc109.
        Run openQueryStatic In Hbosc109 (Input "Main":U) No-error.
    END.
*/
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame04 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
********************************************************************
********************************/
/* Procedure InicializaCamposFrame03:                                                         */
/*                                                                                            */
/*     ASSIGN vLogErro     = NO                                                               */
/*            vLogsai      = NO                                                               */
/*            vLogfinaliza = NO.                                                              */
/*                                                                                            */
/*     FIND FIRST ttWork NO-LOCK NO-ERROR.                                                    */
/*     RUN GetAddressDescription IN Hbcapiwms (INPUT  ttWork.num-box,                         */
/*                                             INPUT  ttWork.cod-estabel,                     */
/*                                             INPUT  ttWork.cod-local,                       */
/*                                             OUTPUT ttWork.des-endereco).                   */
/*                                                                                            */
/*     If  RETURN-VALUE = 'NOK':U Then Do:                                                    */
/*         RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).                        */
/*         RETURN "NOK".                                                                      */
/*                                                                                            */
/*     End.                                                                                   */
/*                                                                                            */
/*     ASSIGN ttWork.num-box-lido = 0.                                                        */
/*                                                                                            */
/*     ASSIGN  ttwork.cod-item:SCREEN-VALUE IN FRAME frame03     = ttwork.cod-item            */
/*             ttwork.num-serial:SCREEN-VALUE IN FRAME frame03   = string(ttwork.num-serial)  */
/*             ttwork.des-endereco:SCREEN-VALUE IN FRAME frame03 = ttwork.des-endereco        */
/*             .                                                                              */
/*                                                                                            */
/*                                                                                            */
/*                                                                                            */
/* End Procedure.                                                                             */

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
Procedure GravaCamposFrame01:

     Assign vLogErro           = NO 
            vLogControlaLogin  = NO.

     FOR EACH tt-erro:
         DELETE tt-erro.
     END.
     
     /* valida usuario mestre contra mguni do EMS */
    IF ttWork.cod-usuario = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Usu rio Inv lido (DC)"}
    END.

    If vLogErro = Yes Then Return Error.
    IF NOT VALID-HANDLE(Hbcapiwms) THEN DO:
       Run bcp/bcapiwms.p Persistent Set Hbcapiwms       No-error.
    END.
    RUN loginuser IN Hbcapiwms (INPUT ttWork.cod-usuario,
                                 INPUT vcod-senha,
                                 OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> "OK" THEN DO:
       FOR EACH tt-erro NO-LOCK:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           vLogErro = YES.
       END.
    END.

    If vLogErro = Yes Then Return Error.

    RUN validateUser IN Hbcapiwms (INPUT ttWork.cod-usuario,
                                   INPUT 13,
                                   OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> "OK" THEN DO:
       FOR EACH tt-erro NO-LOCK:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           vLogErro = YES.
       END.
    END.

    If vLogErro = Yes Then Return Error.

    IF ttWork.cod-coletor = ''  THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
    END.

    If  ttWork.cod-equipamento = '' Then Do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
    End.


    RUN ValidateEquipament IN Hbcapiwms (INPUT ttWork.cod-coletor,
                                         INPUT ttWork.cod-equipamento,
                                         OUTPUT ttWork.tipo-equipamento,
                                         OUTPUT TABLE tt-erro).
    IF RETURN-VALUE <> "OK" THEN DO:
       FOR EACH tt-erro NO-LOCK:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
           vLogErro = YES.
       END.
    END.

    If vLogErro = Yes Then Return Error.

    Assign  {&TempTable}.cod-usuario      = ttWork.cod-usuario 
            {&TempTable}.cod-coletor      = ttWork.cod-coletor
            {&TempTable}.cod-equipamento  = ttWork.cod-equipamento
            {&TempTable}.tipo-equipamento = ttWork.tipo-equipamento.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-cod-barras AS LOGICAL NO-UNDO.

    ASSIGN vLogErro = NO.
        
    IF NOT VALID-HANDLE (Hbcapi9029) THEN DO:                             
        RUN bcp/bcapi9029.p PERSISTENT SET Hbcapi9029.  
    END.

    /*  */
    IF NOT VALID-HANDLE(Hbosc074) THEN DO:
       Run scbo/bosc074.p Persistent Set Hbosc074       No-error.
       Run openQueryStatic In Hbosc074 (Input "Main":U) No-error.
    END.

    EMPTY TEMP-TABLE rowerrors.
    EMPTY TEMP-TABLE tt-etiqueta-lida.

    RUN getInfoEtiqueta IN Hbosc074 (INPUT ttwork.num-serial,
                                     OUTPUT TABLE ttwm-etiqueta).

    IF RETURN-VALUE <> "OK":U THEN DO:

        Run getrowErrors In Hbosc074 (output Table RowErrors).
        FOR EACH Rowerrors NO-LOCK:
            RUN bcp/bc9115.p  (Rowerrors.ErrorNum, Rowerrors.ErrorDescription,8,20,3).
        END.
        RETURN ERROR.
    END.

    FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.

    IF ttwm-etiqueta.log-reporta = NO THEN DO:
        ASSIGN VlogErro = YES.
        {bcp/bc9105.i "201" "Etiqueta nao reportada "}
        RETURN ERROR.

    END.

    IF VALID-HANDLE(Hbosc074) THEN
        DELETE OBJECT Hbosc074.

    EMPTY TEMP-TABLE tt-erro.
     /*  */
    RUN GetSerialStorageTask IN Hbcapi9029 (INPUT-OUTPUT TABLE ttWork,
                                            OUTPUT TABLE tt-erro).

    IF RETURN-VALUE <> 'OK':U THEN DO:
       FIND FIRST tt-erro.
       IF AVAIL tt-erro AND tt-erro.cd-erro = 33931 THEN DO:
          FIND FIRST wm-movto-etiqueta WHERE wm-movto-etiqueta.id-etiqueta = ttwm-etiqueta.id-etiqueta
              NO-LOCK NO-ERROR.
          IF AVAIL wm-movto-etiqueta THEN DO:
              FIND FIRST wm-box-movto 
                  WHERE wm-box-movto.cod-estabel = wm-movto-etiqueta.cod-estabel
                  AND   wm-box-movto.cod-local   = wm-movto-etiqueta.cod-local
                  AND   wm-box-movto.id-movto    = wm-movto-etiqueta.id-movto NO-LOCK NO-ERROR.
              IF AVAIL wm-box-movto THEN DO:
                  FIND FIRST wm-box OF wm-box-movto NO-LOCK NO-ERROR.
                  IF AVAIL wm-box THEN DO:
                      RUN bcp/bc9115.p (10 , "Equipamento sem acesso." + CHR(13) + "Pallet destinadoRua:" + wm-box.cod-rua + "  Col:" + wm-box.cod-coluna,8,20,6).
                  END.
              END.
          END.
       END.
       ELSE DO:
           FOR EACH tt-erro
               WHERE tt-erro.cd-erro <> 3
                 AND tt-erro.cd-erro <> 8:
               RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).

           END.
       END.
       ASSIGN VlogErro = YES.
       RETURN ERROR.
    END.

    FIND FIRST ttwork NO-ERROR.

    FOR FIRST wm-box-movto NO-LOCK
        WHERE wm-box-movto.cod-estabel      = ttWork.cod-estabel
          AND wm-box-movto.cod-local        = ttWork.cod-local
          AND wm-box-movto.id-movto         = ttWork.id-movto
          AND wm-box-movto.ind-tipo-movto   = 1 /*entrada*/:
    END.

    IF NOT AVAIL wm-box-movto THEN DO:
        {bcp/bc9105.i "202" "Movimento da etiqueta nÆo foi encontrado."}
        ASSIGN vLogErro = YES.
        RETURN ERROR.
    END.

    /* Validando EAN */
    IF CAN-FIND(FIRST wm-item WHERE
                wm-item.cod-item   =  wm-box-movto.cod-item AND
                wm-item.cod-barras <> ""                    NO-LOCK) THEN DO:
        DO WHILE l-cod-barras = NO:
            ASSIGN c-cod-barras:SCREEN-VALUE IN FRAME Frame02 = "".
            UPDATE c-cod-barras WITH FRAME Frame02.
            IF INPUT FRAME Frame02 c-cod-barras = "" THEN DO:
               {bcp/bc9105.i "238" "EAN/DUN deve ser informado."}
               NEXT.
            END.
                
            IF NOT CAN-FIND(FIRST wm-item WHERE
                            wm-item.cod-barras = INPUT FRAME Frame02 c-cod-barras AND 
                            wm-item.cod-item   = wm-box-movto.cod-item            NO-LOCK) AND 
               NOT CAN-FIND(FIRST wm-item-embalagem-etiq WHERE
                            wm-item-embalagem-etiq.cod-barras = INPUT FRAME Frame02 c-cod-barras AND
                            wm-item-embalagem-etiq.cod-item   = wm-box-movto.cod-item            NO-LOCK) THEN DO:
                {bcp/bc9105.i "238" "EAN/DUN invalido para o Item da Etiqueta de Pallet."}
                NEXT.
            END.
            ASSIGN l-cod-barras = YES.
        END.
    END.

    IF wm-box-movto.qti-embalagem > 1 THEN DO:

        DO TRANSACTION ON ENDKEY UNDO, RETURN ERROR:

            RUN StartTask IN Hbcapiwms (INPUT ttwork.cod-usuario,
                                        INPUT ttwork.cod-coletor,
                                        INPUT ttwork.cod-equipamento,
                                        INPUT 13,
                                        INPUT ttwork.id-docto,
                                        INPUT ttwork.id-movto,
                                        INPUT ttwork.num-seq-item,
                                        OUTPUT TABLE tt-erro).
    
            IF RETURN-VALUE <> "OK" THEN DO:
               FOR EACH tt-erro:
                   RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
    
               END.
               ASSIGN VlogErro = YES.
               RETURN ERROR.
            END.
    
            ASSIGN ttWork.horario-inicio = TIME.
    
            CREATE tt-etiqueta-lida.
            ASSIGN tt-etiqueta-lida.id-etiqueta = ttwm-etiqueta.id-etiqueta
                   tt-etiqueta-lida.qtd-item    = ttwm-etiqueta.qtd-item.
    
            IF ttWork.cod-livre-1 = "" THEN
                ASSIGN ttWork.cod-livre-1 = STRING(ttWork.num-serial).
            ELSE
                ASSIGN ttWork.cod-livre-1 = ttWork.cod-livre-1 + ";" + STRING(ttWork.num-serial).
    
            ASSIGN ttWork.dec-livre-1 = ttWork.dec-livre-1 + ttwm-etiqueta.qtd-item.
    
            RUN bcp/bc9029f.p (INPUT TABLE ttWork,
                               INPUT TABLE tt-etiqueta-lida,
                               OUTPUT l-ok).

            IF l-ok = NO THEN DO:

                EMPTY TEMP-TABLE tt-etiqueta-lida.

                ASSIGN ttWork.cod-livre-1 = ""
                       ttWork.dec-livre-1 = 0.

                UNDO, RETURN ERROR.
            END.
    
            RETURN "OK":U.
        END.
    END.

    ELSE DO:

        DO TRANSACTION ON ENDKEY UNDO, RETURN ERROR:      
            FOR EACH tt-erro:
              DELETE tt-erro.
            END.
    
            RUN StartTask IN Hbcapiwms (INPUT ttwork.cod-usuario,
                                        INPUT ttwork.cod-coletor,
                                        INPUT ttwork.cod-equipamento,
                                        INPUT 13,
                                        INPUT ttwork.id-docto,
                                        INPUT ttwork.id-movto,
                                        INPUT ttwork.num-seq-item,
                                        OUTPUT TABLE tt-erro).
    
            IF RETURN-VALUE <> "OK" THEN DO:
               FOR EACH tt-erro:
                   RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
    
               END.
               ASSIGN VlogErro = YES.
               RETURN ERROR.
            END.
    
            ASSIGN vProcesso = YES
                   ttWork.horario-inicio = TIME.
    
            /* Pede o box */
    
            RUN GetAddressDescription IN Hbcapiwms (INPUT  ttWork.num-box,
                                                    INPUT  ttWork.cod-estabel,
                                                    INPUT  ttWork.cod-local,
                                                    OUTPUT ttWork.des-endereco).
    
            If  RETURN-VALUE = 'NOK':U Then Do:
                RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).
                UNDO, RETURN.
            End.
    
            ASSIGN ttWork.num-box-lido = 0.
    
            ASSIGN  ttwork.cod-item:SCREEN-VALUE IN FRAME {&Frame02Name}     = ttwork.cod-item
                    ttwork.num-serial:SCREEN-VALUE IN FRAME {&Frame02Name}   = string(ttwork.num-serial)
                    ttwork.des-endereco:SCREEN-VALUE IN FRAME {&Frame02Name} = ttwork.des-endereco.
    
           DO WHILE VlogErro = NO ON ENDKEY UNDO, RETURN ERROR:
              UPDATE ttWork.num-box-lido NO-LABELS WITH FRAME {&Frame02Name}.
    
              IF ttWork.num-box-lido <> ttWork.num-box THEN DO:
                 {bcp/bc9105.i "0" "Endere‡o inv lido "}
                 ASSIGN VlogErro = NO.
    
              END.
              ELSE VlogErro = YES.
    
           END.
           VlogErro = NO.
        END.
    
        ASSIGN {&TempTable}.num-box-lido   = ttWork.num-box-lido
               {&TempTable}.cod-item       = ttWork.cod-item
               {&TempTable}.num-serial     = ttWork.num-serial
               {&TempTable}.des-endereco   = ttWork.des-endereco
               {&TempTable}.cod-estabel    = ttWork.cod-estabel
               {&TempTable}.cod-local      = ttWork.cod-local
               {&TempTable}.num-box        = ttWork.num-box
               {&temptable}.id-docto       = ttWork.id-docto
               {&temptable}.id-movto       = ttWork.id-movto
               {&TempTable}.num-seq-item   = ttWork.num-seq-item
               {&TempTable}.horario-inicio = ttWork.horario-inicio.
    
        RUN GravaTransacao.

        
    END.

END PROCEDURE.                                                                 

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
/* Procedure GravaCamposFrame03:                                */
/*                                                              */
/*     ASSIGN vLogErro = NO.                                    */
/*                                                              */
/*     IF ttWork.num-box-lido <> ttWork.num-box THEN DO:        */
/*        RUN bcp/bc9115.p (0,"Endere‡o inv lido",8,20,3).      */
/*        ASSIGN vLogErro = YES.                                */
/*        RETURN ERROR.                                         */
/*     END.                                                     */
/*     ASSIGN {&TempTable}.num-box-lido = ttWork.num-box-lido.  */
/*                                                              */
/*     IF vLogErro = NO THEN DO:                                */
/*         RUN GravaTransacao.                                  */
/*     END.                                                     */
/*                                                              */
/* End Procedure.                                               */


/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaTransacao:

    ASSIGN vTransDetail = VTransaction   +
                          " Serial: "     +  STRING({&TempTable}.num-serial)     + 
                          " id-Docto: "   +  STRING({&temptable}.id-docto)       +
                          " id-Movto: "   +  STRING({&temptable}.id-movto)       +
                          " NumSeqItem: " +  STRING({&TempTable}.num-seq-item)   +
                          " Item: "       +  STRING(TRIM({&TempTable}.cod-item)) +
                          " idBox: "      +  STRING({&TempTable}.num-box).

    Run _RetornaUsuario (Output vNomeUsuario).

    Assign {&TempTable}.dat-atualizacao         = Today
           {&TempTable}.dat-transacao           = Today
           {&TempTable}.cod-usuario             = vNomeUsuario.

    Raw-transfer {&TempTable} To vConteudoRaw.

    FOR EACH tt-erro-after-GenerateDC:
        DELETE tt-erro-after-GenerateDC.
    END.
    
    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */

    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.

    IF AVAIL tt-erro-after-GenerateDC THEN DO:
        RUN bcp/bc9115.p (tt-erro-after-GenerateDC.cd-erro,tt-erro-after-GenerateDC.mensagem,8,20,3).
        HIDE ALL.
    END.
    ELSE DO:
        RUN bcp/bc9115.p ("0", "Armazenamento efetuado com sucesso.",8,20,3).
        HIDE ALL.
    END.

    // Integra‡Æo com o Protheus
    FOR EACH tt-prog-ponto:
        DELETE tt-prog-ponto.
    END.
    RUN esp/es0018p.p ( INPUT "wm-estab-api":U,
                        INPUT 1,
                        INPUT 0,
                        INPUT "":U,
                        OUTPUT TABLE tt-prog-ponto).
    IF CAN-FIND(FIRST tt-prog-ponto) THEN DO:
        FIND FIRST tt-prog-ponto
             WHERE ENTRY(2,tt-prog-ponto.conteudo,";") = ttWork.cod-estabel NO-ERROR.
        IF AVAIL tt-prog-ponto THEN DO:
            FIND FIRST wm-docto NO-LOCK
                 WHERE wm-docto.cod-estabel = ttWork.cod-estabel
                   AND wm-docto.cod-local   = ttWork.cod-local
                   AND wm-docto.id-docto    = ttWork.id-docto NO-ERROR.
            IF AVAIL wm-docto AND wm-docto.ind-sit-docto = 2 THEN DO:
                RUN esp/wmp/returnDoctoEntrada.p(INPUT ROWID(wm-docto),
                                                 OUTPUT l-erro,
                                                 OUTPUT TABLE rowErrors).
                IF CAN-FIND(FIRST rowErrors) THEN DO:
                    FOR EACH Rowerrors NO-LOCK:
                        RUN bcp/bc9115.p  (Rowerrors.ErrorNum, Rowerrors.ErrorDescription,8,20,3).
                    END.
                    RETURN ERROR.
                END.
            END.
        END.
    END.

END PROCEDURE.
