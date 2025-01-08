/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
define buffer empresa for mgcad.empresa.
{include/i-prgvrs.i ESBC9029 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9029 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: ESbc9029.p                                                                  **
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

/* Definicao da temp-table de integracao ---                */

&global-define TEMPTABLE tt-storage-serial-wms
{bcp/bc9029.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-etiqueta-lida NO-UNDO
    FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
    FIELD qtd-item    LIKE wm-etiqueta.qtd-item.

DEFINE TEMP-TABLE tt-docto-itens-emb-manual NO-UNDO
    FIELD cod-embalagem         LIKE wm-box-saldo.cod-embalagem
    FIELD qtd-item-emb          LIKE wm-box-saldo.qtd-item
    FIELD qti-embalagem         LIKE wm-box-movto.qti-embalagem
    FIELD qtd-volume            LIKE wm-item-embalagem.qtd-volume
    FIELD qtd-peso              LIKE wm-item-embalagem.qtd-peso
    FIELD id-box                LIKE wm-box.id-box
    FIELD cod-bloco             LIKE wm-box.cod-bloco
    FIELD cod-rua               LIKE wm-box.cod-rua
    FIELD cod-nivel             LIKE wm-box.cod-nivel
    FIELD cod-coluna            LIKE wm-box.cod-coluna.

Define Temp-table ttWork NO-UNDO like {&TempTable}.
Create ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/


/* ************************** Definitions ******************************** */
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE vNomeUsuario        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE vLogControlaLogin   AS LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE vProcesso           AS LOGICAL INITIAL NO           NO-UNDO.
DEFINE VARIABLE l-menu-padrao       AS LOGICAL INITIAL YES          NO-UNDO.
DEFINE VARIABLE vOpcao              AS INTEGER                      NO-UNDO.
DEFINE VARIABLE idEtiquetaArm       LIKE wm-etiqueta.id-etiqueta    NO-UNDO.
DEFINE VARIABLE l-etiqueta-1  AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-primeiro AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-sucesso AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE Hbosc038   AS HANDLE.
DEFINE VARIABLE Hbosc109   AS HANDLE.
DEFINE VARIABLE Hbcapiwms  AS HANDLE.
DEFINE VARIABLE Hbcapi9029 AS HANDLE.
DEFINE VARIABLE Hbosc074   AS HANDLE.
DEFINE VARIABLE h-bosc035sto AS HANDLE.


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
&global-define Frame02Defs   'Armaz. Serial WMS   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Serial:'                                          AT ROW 03 COL 01          ~
                              ttWork.num-serial                                 AT ROW 04 COL 01 NO-LABEL ~
                             'Item:'                                            AT ROW 05 COL 01          ~
                              ttWork.cod-item                                   AT ROW 06 COL 01 NO-LABEL ~
                              ttWork.des-endereco                               At Row 07 Col 01 NO-LABEL ~
                              'Box: '                                           At Row 08 Col 01          ~
                              ttWork.num-box-lido                               At Row 08 Col 05 No-label ~
&global-define Frame02Repeat YES

/* Definicao da Frame03 ---                             */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Armaz. Serial WMS   '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Box diferente do '                                AT ROW 03 COL 01          ~
                             'sugerido. Deseja '                                AT ROW 04 COL 01          ~
                             'confirmar?'                                       At Row 05 Col 01          ~
                             '1 - Sim / 2 - NÆo'                                At Row 06 Col 01          ~
                             "Op‡Æo:"                                           AT ROW 08 COL 01          ~
                             vOpcao                                             At Row 08 Col 07 No-label ~
&global-define Frame03Repeat NO



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
/* &global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. */

&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
/* &global-define TriggerAfterFrame03  Run GravaCamposFrame03. */


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
           ttWork.dec-livre-1   = 0.

    DISPLAY ttWork.num-serial  
            ttWork.cod-item    
            ttWork.des-endereco
            ttWork.num-box-lido WITH FRAME frame02.
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

    DEFINE VARIABLE de-serial-lido LIKE in-agrup-etiqueta.id-etiqueta-pai NO-UNDO.

    ASSIGN vLogErro = NO
           l-primeiro = YES.
        
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
    EMPTY TEMP-TABLE ttwm-etiqueta.

    /*RUN getInfoEtiqueta IN Hbosc074 (INPUT ttwork.num-serial,
                                     OUTPUT TABLE ttwm-etiqueta).
    MESSAGE "B"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    IF RETURN-VALUE <> "OK":U THEN DO:

        MESSAGE "erro 074"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        Run getrowErrors In Hbosc074 (output Table RowErrors).
        FOR EACH Rowerrors NO-LOCK:
            RUN bcp/bc9115.p  (Rowerrors.ErrorNum, Rowerrors.ErrorDescription,8,20,3).
        END.
        RETURN ERROR.
    END.

    FIND FIRST ttwm-etiqueta NO-ERROR.*/

    IF CAN-FIND(FIRST in-agrup-etiqueta
                WHERE in-agrup-etiqueta.id-etiqueta-pai  = ttwork.num-serial) THEN DO:

        FIND FIRST in-agrup-etiqueta NO-LOCK
             WHERE in-agrup-etiqueta.id-etiqueta-pai  = ttwork.num-serial NO-ERROR.  
        
        IF  NOT AVAIL in-agrup-etiqueta THEN DO:
            {bcp/bc9105.i "202" "Etiqueta Pai CKD nÆo foi encontrada."}
            ASSIGN vLogErro = YES.
            RETURN ERROR.
        END.

        ASSIGN de-serial-lido = ttwork.num-serial
               l-etiqueta-1   = YES
               l-sucesso = NO.

        DO TRANSACTION ON ENDKEY UNDO, RETURN ERROR:
            FOR EACH in-agrup-etiqueta NO-LOCK
               WHERE in-agrup-etiqueta.id-etiqueta-pai  = de-serial-lido:

                LOG-MANAGER:WRITE-MESSAGE("bc9029-1 in-agrup-etiqueta.id-etiqueta-filho=" + STRING(in-agrup-etiqueta.id-etiqueta-filho)) NO-ERROR.
        
                ASSIGN ttwork.num-serial = in-agrup-etiqueta.id-etiqueta-filho.
    
                RUN pi-executa-grava-frame2.
                IF RETURN-VALUE = "NOK" THEN
                    RETURN ERROR.
            END.
        END.

        IF l-sucesso THEN DO:
            RUN bcp/bc9115.p ("0", "Armazenamento efetuado com sucesso.",8,20,3).
            HIDE ALL.
        END.
    END.
    ELSE DO:
        ASSIGN l-sucesso = NO.
        DO TRANSACTION ON ENDKEY UNDO, RETURN ERROR:      
            RUN pi-executa-grava-frame2.
            IF RETURN-VALUE = "NOK" THEN
                RETURN ERROR.
        END.

        IF l-sucesso THEN DO:
            RUN bcp/bc9115.p ("0", "Armazenamento efetuado com sucesso.",8,20,3).
            HIDE ALL.
        END.
    END.
    
End Procedure.

PROCEDURE pi-executa-grava-frame2:

    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE rowerrors.
    EMPTY TEMP-TABLE tt-etiqueta-lida.

    IF NOT VALID-HANDLE(Hbosc074) THEN DO:
       Run scbo/bosc074.p Persistent Set Hbosc074       No-error.
       Run openQueryStatic In Hbosc074 (Input "Main":U) No-error.
    END.

    RUN getInfoEtiqueta IN Hbosc074 (INPUT ttwork.num-serial,
                                     OUTPUT TABLE ttwm-etiqueta).

    IF RETURN-VALUE <> "OK":U THEN DO:

        Run getrowErrors In Hbosc074 (output Table RowErrors).
        FOR EACH Rowerrors NO-LOCK:
            RUN bcp/bc9115.p  (Rowerrors.ErrorNum, Rowerrors.ErrorDescription,8,20,3).
        END.
        RETURN "NOK".
    END.

    FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE("bc9029-2 ttwm-etiqueta.log-reporta=" + STRING(ttwm-etiqueta.log-reporta)) NO-ERROR.

    IF ttwm-etiqueta.log-reporta = NO THEN DO:
        ASSIGN VlogErro = YES.
        {bcp/bc9105.i "201" "Etiqueta nao reportada "}
        RETURN "NOK".
    END.

    IF VALID-HANDLE(Hbosc074) THEN
        DELETE OBJECT Hbosc074.

    EMPTY TEMP-TABLE tt-erro.
     /*  */
    RUN GetSerialStorageTask IN Hbcapi9029 (INPUT-OUTPUT TABLE ttWork,
                                            OUTPUT TABLE tt-erro).

    IF RETURN-VALUE <> 'OK':U THEN DO:
LOG-MANAGER:WRITE-MESSAGE("bc9029-3 RETURN-VALUE=" + STRING(RETURN-VALUE)) NO-ERROR.
       FOR EACH tt-erro
           WHERE tt-erro.cd-erro <> 3
             AND tt-erro.cd-erro <> 8:
           RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).

       END.
       ASSIGN VlogErro = YES.
       RETURN "NOK".
    END.

    FIND FIRST ttwork NO-ERROR.

LOG-MANAGER:WRITE-MESSAGE("bc9029-2 ttwork.num-serial=" + STRING(ttwork.num-serial)) NO-ERROR.

    FOR FIRST wm-box-movto NO-LOCK
        WHERE wm-box-movto.cod-estabel      = ttWork.cod-estabel
          AND wm-box-movto.cod-local        = ttWork.cod-local
          AND wm-box-movto.id-movto         = ttWork.id-movto
          AND wm-box-movto.ind-tipo-movto   = 1 /*entrada*/:
    END.

    IF NOT AVAIL wm-box-movto THEN DO:
        {bcp/bc9105.i "202" "Movimento da etiqueta nÆo foi encontrado."}
        ASSIGN vLogErro = YES.
        RETURN "NOK".
    END.

    IF wm-box-movto.qti-embalagem > 1 THEN DO:
        
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
           RETURN "NOK".
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

            RETURN "NOK".
        END.

        RETURN "OK":U.
        
    END.

    ELSE DO:

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
           RETURN "NOK".
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
            RETURN "NOK".
        End.
        

        ASSIGN  ttwork.cod-item:SCREEN-VALUE IN FRAME {&Frame02Name}     = ttwork.cod-item
                ttwork.num-serial:SCREEN-VALUE IN FRAME {&Frame02Name}   = string(ttwork.num-serial)
                ttwork.des-endereco:SCREEN-VALUE IN FRAME {&Frame02Name} = ttwork.des-endereco.

        IF l-primeiro THEN DO:
           ASSIGN ttWork.num-box-lido = 0.
           DO WHILE VlogErro = NO ON ENDKEY UNDO, RETURN "NOK":
              UPDATE ttWork.num-box-lido NO-LABELS WITH FRAME {&Frame02Name}.
    
              FIND FIRST wm-box NO-LOCK
                   WHERE wm-box.cod-estabel = ttWork.cod-estabel
                     AND wm-box.cod-local   = ttWork.cod-local  
                     AND wm-box.id-box      = ttWork.num-box-lido NO-ERROR.
              IF NOT AVAIL wm-box THEN DO:

                  {bcp/bc9105.i "0" "Box informado nÆo existe."}
                  ASSIGN VlogErro = NO.
              END.
              ELSE DO:
                  IF wm-box.log-bloq-armaz THEN DO:
    
                      {bcp/bc9105.i "0" "Box informado est  bloqueado."}
                      ASSIGN VlogErro = NO.
                  END.
                  ELSE DO:
                      IF ttWork.num-box-lido <> ttWork.num-box THEN DO:
        
                         DO ON ENDKEY UNDO, RETURN "NOK":
                            UPDATE vOpcao WITH FRAME {&Frame03Name}.

                            IF vOpcao <> 1 AND vOpcao <> 2 THEN DO:
        
                                {bcp/bc9105.i "0" "Op‡Æo inv lida."}
                                 ASSIGN VlogErro = NO.
                            END.
        
                            IF vOpcao = 1 THEN DO:  /*Sim - Trocar o Box sugerido*/

                                if not avail ttWork then leave.

                                RUN piArmazenaOutroEndereco.
                                IF RETURN-VALUE = "OK" THEN DO:
                                   ASSIGN vLogErro = YES.
                                END.
                            END. 
                            ELSE
                               ASSIGN VlogErro = NO.
                         END.
            
                      END.
                      ELSE VlogErro = YES.
                  END.
              END. /*else do*/
           END.
           VlogErro = NO.
        END.
        ELSE DO:
            RUN piArmazenaOutroEndereco.
        END.
        

        ASSIGN l-primeiro = NO.

        FIND FIRST ttWork NO-ERROR.
    
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
        /*RUN bcp/bc9115.p ("0", "Armazenamento efetuado com sucesso.",8,20,3).
        HIDE ALL.*/
        ASSIGN l-sucesso = YES.
    END.

    RETURN "OK":u.

End Procedure.

PROCEDURE piArmazenaOutroEndereco:
    DEFINE VARIABLE inumseq AS INTEGER NO-UNDO.

    /* desfazer sugestÆo de armazenamento */
    FIND FIRST wm-movto-etiqueta NO-LOCK
         WHERE wm-movto-etiqueta.id-etiqueta = ttwm-etiqueta.id-etiqueta NO-ERROR.
    IF AVAIL wm-movto-etiqueta THEN DO:

        FIND FIRST wm-box-movto NO-LOCK
             WHERE wm-box-movto.cod-estabel = wm-movto-etiqueta.cod-estabel
               AND wm-box-movto.cod-local   = wm-movto-etiqueta.cod-local
               AND wm-box-movto.id-movto    = wm-movto-etiqueta.id-movto NO-ERROR.
        IF AVAIL wm-box-movto THEN DO:
            /* gravar numero da sequancia da wm-docto-itens para localizar a mesma no doAlocationManual*/
            ASSIGN inumseq = wm-box-movto.num-seq-item.
               
            RUN wmp/wm9032a.p (INPUT ROWID(wm-box-movto)
                              ,INPUT NO
                              ,OUTPUT TABLE RowErrors).

            IF RETURN-VALUE <> "OK" THEN DO:
               {bcp/bc9105.i "15" "Movimento nÆo foi desfeito. Favor ler outro endere‡o."}
               RETURN "NOK":U.
            END.
        END.
    END.
    IF NOT CAN-FIND(FIRST wm-movto-etiqueta NO-LOCK
                    WHERE wm-movto-etiqueta.id-etiqueta = ttwm-etiqueta.id-etiqueta) THEN DO:
            
          FIND FIRST wm-docto NO-LOCK
               WHERE wm-docto.id-carga = ttwm-etiqueta.id-carga NO-ERROR.
          IF NOT AVAIL wm-docto THEN DO:
               {bcp/bc9105.i "15" "Etiqueta nÆo relacionada a documento de entrada"}
               RETURN "NOK":U.
          END.
            
          FIND FIRST wm-docto-itens NO-LOCK
               WHERE wm-docto-itens.cod-estabel   = wm-docto.cod-estabel
                 AND wm-docto-itens.cod-local     = wm-docto.cod-local
                 AND wm-docto-itens.id-docto      = wm-docto.id-docto
                 AND wm-docto-itens.cod-item      = ttwm-etiqueta.cod-item
                 AND wm-docto-itens.cod-refer     = ttwm-etiqueta.cod-refer
                 AND wm-docto-itens.cod-lote      = ttwm-etiqueta.cod-lote
                 AND wm-docto-itens.num-seq-item  = inumseq
                 AND wm-docto-itens.ind-sit-movto = 1 NO-ERROR.
          IF AVAIL wm-docto-itens THEN DO:
                
               FIND FIRST wm-item-embalagem-local NO-LOCK
                    WHERE wm-item-embalagem-local.cod-estabel   = wm-docto.cod-estabel
                      AND wm-item-embalagem-local.cod-local     = wm-docto.cod-local
                      AND wm-item-embalagem-local.cod-item      = ttwm-etiqueta.cod-item
                      AND wm-item-embalagem-local.cod-embalagem = ttwm-etiqueta.cod-embalagem NO-ERROR.
               IF AVAIL wm-item-embalagem-local THEN DO:
                   EMPTY TEMP-TABLE tt-docto-itens-emb-manual.
                   
                   CREATE tt-docto-itens-emb-manual.
                   ASSIGN tt-docto-itens-emb-manual.cod-embalagem = wm-item-embalagem-local.cod-embalagem
                          tt-docto-itens-emb-manual.qtd-volume    = wm-item-embalagem-local.qtd-volume
                          tt-docto-itens-emb-manual.qtd-peso      = wm-item-embalagem-local.qtd-peso
                          tt-docto-itens-emb-manual.qtd-item      = ttWm-etiqueta.qtd-item
                          tt-docto-itens-emb-manual.qti-embalagem = 1
                          tt-docto-itens-emb-manual.id-box        = ttwork.num-box-lido.

                   
                   RUN scbo/bosc035sto.p PERSISTENT SET h-bosc035sto.
                   RUN openQueryStatic IN h-bosc035sto (INPUT "Main":U) NO-ERROR.
                    
                   RUN doAlocationManual IN h-bosc035sto (INPUT TABLE tt-docto-itens-emb-manual
                                                         ,INPUT ROWID(wm-docto-itens)
                                                         ,OUTPUT TABLE RowErrors).
                   FIND FIRST RowErrors NO-ERROR.
                   IF AVAIL RowErrors THEN DO:
                      RUN bcp/bc9115.p  (Rowerrors.ErrorNum, Rowerrors.ErrorDescription,8,20,3).
                      RUN destroy IN h-bosc035sto.
                      RETURN "NOK":U.
                   END.
               END.
               ELSE DO:
                   {bcp/bc9105.i "15" "Nao encontrado sequencia do item no documento com a quantidade da etiqueta."}
                   RETURN "NOK":U.
               END.
          END.

         /* Gera tarefa de aramzenamento na bosc096 GetTarefaArmazEtiqueta */
          RUN GetSerialStorageTask IN Hbcapi9029 (INPUT-OUTPUT TABLE ttWork
                                                 ,OUTPUT TABLE tt-erro).

          FIND FIRST ttwork NO-ERROR.
            
          IF RETURN-VALUE <> 'OK':U THEN DO:
              FOR EACH tt-erro
                 WHERE tt-erro.cd-erro <> 3
                   AND tt-erro.cd-erro <> 8:

                  RUN bcp/bc9115.p (tt-erro.cd-erro,tt-erro.mensagem,8,20,3).        
              END.
              RETURN "NOK":U.
          END.
    END.
   

    RETURN "OK":U.
END PROCEDURE.

