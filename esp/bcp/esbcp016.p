/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESBCP016 2.00.00.020 } /*** 010020 ***/
{include/i-license-manager.i ESBCP016 MBC,MCE,MRE,MWM}
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9020.p                                                                  **
**   Objetivo..: Templates DC Interface para transacao de Ressupr Flow Rack                **
********************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName ESBCP016
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-ressup-wms
{esp/bcp/esbcp016.i " "}
{esp/bcp/esbcp016.i1 "New"}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

Define Temp-table ttWork No-Undo like {&TempTable}.

Create ttWork.

Define Temp-table tt-mostra-locais NO-UNDO
    Field num-seq           As Integer
    Field des-local         As Character Format 'X(19)'
    Field rowid-box-movto   As Rowid
    FIELD cod-bloco        like wm-box.cod-bloco
    FIELD cod-rua          like wm-box.cod-rua
    FIELD cod-nivel        like wm-box.cod-nivel
    FIELD cod-coluna       like wm-box.cod-coluna
        Index ID num-seq.

Define Query  qry-wm-box-movto For tt-mostra-locais.

Define Browse brw-wm-box-movto Query qry-wm-box-movto No-lock
             Display 
              tt-mostra-locais.des-local
                    With No-box No-labels Size 20 By 4 No-scrollbar-vertical.

Define Variable vCodItemCorrente        As Character Format 'x(16)':U   Init ''  No-undo.
Define Variable vDesItemCorrente        As Character Format 'x(18)':U   Init ''  No-undo.
Define Variable vLogEmProcesso          As Logical                      Init No  No-undo.

Define NEW SHARED Variable vLogControla       As Logical                Init No  No-undo.
Define Variable vLogEmProcesso-aux As Logical                Init No  No-undo.
Define New Shared Variable vEsc               As Logical                Init No  No-undo.


Define Variable vLogUtilizaColetor      As Logical                      Init No  No-undo.
Define Variable vLogAprovaFatura        As Logical                      Init No  No-undo.
Define Variable vLogControlaLogin       As Logical                      Init No  No-undo.

Define Variable vCodSenha AS CHAR FORMAT 'x(12)':U No-undo.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE l-primeiro    AS LOGICAL INIT YES    NO-UNDO.
DEFINE VARIABLE c-desc-opcao  AS CHARACTER FORMAT "X(19)"  NO-UNDO.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

DEFINE TEMP-TABLE tt-opcao NO-UNDO
    FIELD cod-opcao AS INTEGER FORMAT "9"
    FIELD descricao AS CHAR FORMAT "x(17)".

RUN piOpcao.

Define Query qry-opcao For tt-opcao.
Define Browse brw-opcao Query qry-opcao No-lock
             Display 
              tt-opcao.descricao
                    With No-box No-labels Size 19 By 3 No-scrollbar-vertical.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Ressupr Flow Rack'                                At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             At Row 04 Col 01          ~
                             vCodSenha                                          At Row 04 Col 05 No-label ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Ressupr Flow Rack'        At Row 01 Col 01          ~
                             '--------------------':U   At Row 02 Col 01          ~
                             'Zona Ini:'                At Row 03 Col 01          ~
                             ttWork.cod-zona-ini        At Row 03 Col 12 No-Label ~
                             'Zona Fim:'                At Row 04 Col 01          ~
                             ttWork.cod-zona-fim        At Row 04 Col 12 No-Label ~
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&GLOBAL-DEFINE Frame03Name  Frame03
&GLOBAL-DEFINE Frame03Defs  'Ressupr Flow Rack'     AT ROW 1 COLUMN 01          ~
                            '---------------------' AT ROW 2 COLUMN 01          ~
                             brw-opcao              At Row 3 Col 01             ~
&GLOBAL-DEFINE Frame03Repeat NO

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Ressupr Flow Rack'                                At Row 01 Col 01          ~
                             c-desc-opcao                                       At Row 02 Col 01 No-label ~
                             brw-wm-box-movto                                   At Row 03 Col 01          ~
                             vCodItemCorrente                                   At Row 07 Col 01 No-label ~
                             vDesItemCorrente                                   At Row 08 Col 01 No-label ~
&global-define Frame04Repeat YES

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                                  ~
               ttWork.cod-usuario  WHEN ttWork.cod-usuario = ''~
               vCodSenha           WHEN ttWork.cod-usuario = ''~
               ttWork.cod-coletor ~
               ttWork.cod-equipamento 
&global-define Update02Fields ttWork.cod-zona-ini ttWork.cod-zona-fim
&global-define Update03Fields brw-opcao
&global-define Update04Fields brw-wm-box-movto

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
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
                            ON 'Return':U        OF brw-opcao In Frame {&Frame03Name}        ~
                            DO:                                                                     ~
                               Apply 'Go':U To This-procedure.                                      ~
                            END.                                                                    ~
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                               Apply 'Go':U To This-procedure.                                      ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                Find ttwm-box-movto                                                 ~
                                    Where ttWm-box-movto.r-rowid = tt-mostra-locais.rowid-box-movto ~
                                           No-error.                                                ~
                                If  Not Available ttwm-box-movto Then DO:                           ~
                                    ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame04 = ""      ~
                                           vDesItemCorrente:SCREEN-VALUE IN FRAME Frame04 = "".     ~
                                    Return No-apply.                                                ~
                                END.                                                                ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttwm-box-movto.cod-estabel, ~
                                                                    Input ttwm-box-movto.cod-local,   ~
                                                                    Input ttwm-box-movto.id-docto,    ~
                                                                    Input ttwm-box-movto.num-seq-item,~
                                                                    Output Table ttwm-docto-itens ).  ~
                                Find First ttwm-docto-itens.                                          ~
                                ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame04 = ttwm-docto-itens.cod-item. ~
                                RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).                                 ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item).                        ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                  ~
                                   RUN getCharField IN wgbosc044 (INPUT "des-item":U,                              ~
                                                                  OUTPUT vDesItemCorrente).                        ~
                                   ASSIGN vDesItemCorrente:SCREEN-VALUE IN FRAME Frame04 = vDesItemCorrente.       ~
                                END.                                                                               ~
                                ELSE                                                                               ~
                                   ASSIGN vDesItemCorrente:SCREEN-VALUE IN FRAME Frame04 = "".                     ~
                            END.                                                                                   ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                Return 'ESC'.           ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame04 ~
                            DO:                         ~
                                Return 'ESC'.           ~
                            END.                        

/************************************************************/
&global-define TriggersCloseProgram RUN piFinalizaObjetos.
    
&global-define ErrorDisplaySeconds 3

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
    IF v_cod_usuar_corren <> '' THEN DO: 
       ASSIGN vCodSenha:BLANK IN FRAME Frame01                 = NO.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
              ttWork.cod-usuario                               = v_cod_usuar_corren
              vCodSenha                                        = '****************':U 
              vCodSenha:SCREEN-VALUE IN FRAME frame01          = '****************':U. 
       IF v_cod-coletor_corren     <> '' AND 
           v_cod-equipamento_corren <> '' THEN DO:
            ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                   ttWork.cod-coletor     = v_cod-coletor_corren
                   ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                   ttWork.cod-equipamento = v_cod-equipamento_corren.
       END.
    END.
    ELSE DO:
       ASSIGN vCodSenha:BLANK IN FRAME Frame01                 = YES.
       ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
              ttWork.cod-usuario                               = '' 
              vCodSenha                                        = ''  
              vCodSenha:SCREEN-VALUE IN FRAME Frame01          = ''.
    END.
End Procedure.

Procedure InicializaCamposFrame02:
    IF v_cod_usuar_corren = '' THEN RETURN ERROR.

    IF l-primeiro THEN
        ASSIGN ttWork.cod-zona-ini = ""
               ttWork.cod-zona-fim = "ZZZZZ"
               l-primeiro          = NO.
End Procedure.

Procedure InicializaCamposFrame03:
    ASSIGN vLogErro    = NO
           vLogCancela = NO
           vLogSai     = NO
           vLogEmProcesso-aux = NO.

    Open Query qry-opcao For Each tt-opcao.

End Procedure.
/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:

    IF ttWork.cod-opcao = 1 THEN DO:
        If  vLogEmProcesso = Yes AND vLogEmProcesso-aux = NO
        AND AVAIL ttwm-box-movto Then Do:
            Run inicializaTarefaMovtoNOK In wgbosc096
                                     (Input ttwm-box-movto.id-docto,
                                      Input 04,
                                      Input ttWork.cod-usuario,
                                      Input ttWork.cod-equipamento,
                                      Input ttWork.cod-coletor,
                                      Input ttwm-box-movto.id-movto,
                                      Input ttwm-box-movto.num-seq-item).
            Run EmptyRowErrors In wgbosc074.
            Run getRowErrors   In wgbosc074 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Hide All.
                Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
                Hide All.
            End. /* Each RowErrors */

            If  Can-find( First rowErrors) Then Do:
                Assign vLogErro = Yes.
                View Frame Frame04.
                Return Error.
            End.

            Assign vLogEmProcesso = No.
        End.
    END.

    ASSIGN vLogErro    = NO
           vLogCancela = NO.

    RUN GetTasks.

    IF vLogErro = YES THEN RETURN ERROR.

    Empty Temp-table tt-mostra-locais.

    Assign vNumSeq = 0.

    wm-boxm:
    For Each ttwm-box-movto:

        /* Pegar Informacoes Box */
        Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto.cod-estabel,
                                              Input ttwm-box-movto.cod-local,
                                              Input ttwm-box-movto.id-box,
                                              Input ttwm-box-movto.id-box).

        Run openQueryStatic In wgbosc030 (Input 'Boxes':U).

        Run getBatchRecords IN wgbosc030 (Input  ?,
                                          Input  NO,
                                          Input  ?,
                                          Output vNumCont,
                                          Output Table ttwm-box).

        Find First ttwm-box No-error.

        If Not Avail ttwm-box Then Next wm-boxm.

        Assign vNumSeq = vNumSeq + 1.

        Create tt-mostra-locais.
        Assign tt-mostra-locais.num-seq           = vNumSeq
               tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                    ttwm-box.cod-rua              + '/':U +
                                                    ttwm-box.cod-nivel            + '/':U +
                                                    ttwm-box.cod-coluna           + '/':U +
                                                    If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
               tt-mostra-locais.rowid-box-movto   = ttwm-box-movto.r-rowid
               tt-mostra-locais.cod-bloco         = ttwm-box.cod-bloco
               tt-mostra-locais.cod-rua           = ttwm-box.cod-rua
               tt-mostra-locais.cod-nivel         = ttwm-box.cod-nivel
               tt-mostra-locais.cod-coluna        = ttwm-box.cod-coluna.

    End. /*For Each ttwm-box-movto:*/

    FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
    IF RECID(tt-mostra-locais) = ? THEN DO:
       CREATE tt-mostra-locais.
       ASSIGN tt-mostra-locais.num-seq   = 999
              tt-mostra-locais.des-local = 'Sem tarefas (WMS).'.
    END.

    DISP c-desc-opcao WITH FRAME Frame04.

    IF ttWork.cod-opcao = 1 THEN /* ordena por ordem crescente */
        Open Query qry-wm-box-movto For Each tt-mostra-locais 
            By tt-mostra-locais.cod-bloco
            By tt-mostra-locais.cod-rua
            By tt-mostra-locais.cod-coluna
            By tt-mostra-locais.cod-nivel.
    ELSE            /* ordena por ordem decrescente para operador fazer caminho inverso da separaá∆o */
        Open Query qry-wm-box-movto For Each tt-mostra-locais 
            By tt-mostra-locais.cod-bloco  DESC
            By tt-mostra-locais.cod-rua    DESC
            By tt-mostra-locais.cod-coluna DESC
            By tt-mostra-locais.cod-nivel  DESC.

    Apply 'value-changed':U To brw-wm-box-movto In Frame {&Frame04Name}.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    /* Validacoes Frame 01 Inicio --- */

    Assign vLogErro          = No
           vLogControlaLogin = NO.

    IF v2_cod_usuar_corren = ''  THEN DO:
       FOR each tt-erros:
           DELETE tt-erros.
       END.
       login:
       do on error  undo login, leave login
       on quit   undo login, leave login
       on stop   undo login, leave login
       on endkey undo login, leave login: 
           run btb/btapi910za.p (input ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame01, INPUT vCodSenha, output table tt-erros) NO-ERROR.        
       end. 
       IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
          {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado. (DC)"}
          Assign vLogErro           = Yes
                 v_cod_usuar_corren = ''.
          RETURN ERROR.
       END.
       ELSE DO:
          IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
             {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta. (DC)"} 
              Assign vLogErro           = Yes
                     v_cod_usuar_corren = ''.
              RETURN ERROR.
          END.
          ELSE DO:
              IF CAN-FIND (FIRST tt-erros) THEN DO:
                {bcp/bc9105.i "202" "Problemas na autenticaá∆o do usu†rio. (DC)"} 
                Assign vLogErro           = Yes
                       v_cod_usuar_corren = ''.
                RETURN ERROR.
              END.
          END.
       END.
       ASSIGN vLogControlaLogin = YES.
    END.

    Run scbo/bosc092.p Persistent Set wgbosc092 No-error.
    Run scbo/bosc096.p Persistent Set wgbosc096 No-error.
    Run scbo/bosc032.p Persistent Set wgbosc032 No-error.
    Run scbo/bosc074.p Persistent Set wgbosc074 No-error.
    Run scbo/bosc038.p Persistent Set wgbosc038 No-error.
    Run scbo/bosc030.p Persistent Set wgbosc030 No-error.
    /*Run scbo/bosc039.p Persistent Set wgbosc039 No-error.*/
    Run scbo/bosc044.p Persistent Set wgbosc044 No-error.
    /*Run scbo/bosc093.p Persistent Set wgbosc093 No-error.*/
    Run scbo/bosc079.p Persistent Set wgbosc079 No-error.
    
    IF NOT VALID-HANDLE(wgbosc135) THEN DO:
        Run scbo/bosc135.p Persistent Set wgbosc135 No-error.
    END.

    Run scbo/bosc098.p Persistent Set wgbosc098 No-error.

    {bcp/bc9017.i1 ttWork.cod-usuario}
    If  vLogOk = NO Then Do:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "101" "Usu†rio Inv†lido. (DC)"}
        Return Error.
    End.

    /* Valida se usuˇrio tem permissío para executar a tarefa. */
    RUN validaUsuarioTarefa In wgbosc135 (Input ttWork.cod-usuario,
                                          INPUT 04).
    If  Return-value <> 'OK' Then Do:
        Assign vLogErro = YES.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "100" "Usu†rio sem permiss∆o para executar Ressuprimento. (WMS)"}
        Return Error.
    END.

    /* Valida existància do usu†rio no WMS e retorna se ele tem ou n∆o permiss∆o para utilizar coletor e aprovar faturas. */
    RUN validaUsuario In wgbosc079 (Input  ttWork.cod-usuario,
                                    Output vLogUtilizaColetor,
                                    Output vLogAprovaFatura).
    If  Return-value <> 'OK' Then Do:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "101" "Usu†rio Inv†lido. (WMS)"}
        Return Error.
    End.

    IF  vLogUtilizaColetor = NO THEN DO:
        Assign vLogErro = Yes.
        IF vLogControlaLogin = YES THEN
           ASSIGN v_cod_usuar_corren  = ''
                  v2_cod_usuar_corren = ''.
        {bcp/bc9105.i "102" "Usu†rio sem permiss∆o para utilizar Coletor. (WMS)"}
        Return Error.
    END.

    /* valida se existe equipamento, se Ç do tipo coletor e se est† ativo */
    Run validaEquipColetor In wgbosc092  (Input  ttWork.cod-coletor,
                                          Output vCodTipoEquip,
                                          Output vLogAtivo,
                                          Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "102" "Coletor Invalido. (WMS)"}
        Return Error.
    End.

    If   vLogAtivo = No Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "103" "Coletor Inativo. (WMS)"}
        Return Error.
    End.

    /* valida se existe equipamento, se Ç do tipo transportador e se est† ativo */
    Run validaEquipTransportador In wgbosc092  (Input  ttWork.cod-equipamento,
                                                Output vCodTipoEquip,
                                                Output vLogAtivo,
                                                Output vLogProcesso).
    If  Return-value <> 'OK':U Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "104" "Equipto Invalido. (WMS)"}
        Return Error.
    End.

    If   vLogAtivo = No Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "105" "Equipto Inativo. (WMS)"}
        Return Error.
    End.

    /* Validacoes Frame 02 Fim    --- */
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

     Assign vLogIniciado = No.

     Assign ttWork.qtd-embal-lidas  = 0
            ttWork.des-seriais      = ''.

End Procedure.

Procedure GravaCamposFrame03:
    Assign vLogErro = No.

    ASSIGN ttWork.cod-opcao = tt-opcao.cod-opcao
           c-desc-opcao     = tt-opcao.descricao.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:
    /* Validacoes Frame 03 Inicio --- */

    Assign vLogErro = No.

    If Not Avail ttwm-box-movto Then Do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "301" "Movto Invalido. (WMS)"}
       Return Error.
    End.

    Run getInfoDoctoItens IN wgbosc096 (Input ttwm-box-movto.cod-estabel, 
                                        Input ttwm-box-movto.cod-local,   
                                        Input ttwm-box-movto.id-docto,    
                                        Input ttwm-box-movto.num-seq-item, 
                                        Output Table ttwm-docto-itens). 
    Find First ttwm-docto-itens NO-ERROR.  

    If  vLogEmProcesso = No Then Do:
        Run inicializaTarefaMovtoOK In wgbosc096
                                     (Input ttwm-box-movto.id-docto,
                                      Input 04,     
                                      Input ttWork.cod-usuario,              
                                      Input ttWork.cod-equipamento,          
                                      Input ttWork.cod-coletor,              
                                      Input ttwm-box-movto.id-movto,         
                                      Input ttwm-box-movto.num-seq-item).

        IF  Return-value <> 'OK':U Then Do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "302" "Movto Expirou. (WMS)"}
            Return Error.
        End.

        Assign vLogEmProcesso = Yes.
    End.
    ASSIGN ttwork.num-tempo-inicio = TIME
           ttwork.des-seriais = "".
    Hide All.
    IF ttWork.cod-opcao = 1 THEN DO:
        RUN esp/bcp/esbcp016f.p (INPUT ROWID(ttwm-box-movto),
                                 INPUT-OUTPUT TABLE ttWork).
    END.
    ELSE DO:
        ASSIGN ttWork.des-endereco-entrada = tt-mostra-locais.des-local.
        RUN esp/bcp/esbcp016m.p (INPUT ROWID(ttwm-box-movto),
                                 INPUT-OUTPUT TABLE ttWork).
    END.

    FIND FIRST ttWork NO-ERROR.
    Hide All.

End Procedure.

PROCEDURE GetTasks:
    DEFINE BUFFER bf-box-movto FOR wm-box-movto.

    Empty Temp-table ttWm-box-movto.
    ASSIGN vLogErro = NO.

    RUN getMovtosTarefasAbertasRessup In wgbosc096 (Input  vCodTipoEquip,
                                                    Input  04,
                                                    Input  "",           
                                                    Input  ttWork.cod-equipamento,
                                                    Output Table ttWm-box-movto).

    Run getMovtosTarefasAbertasRessup In wgbosc096 (Input  vCodTipoEquip,
                                                    Input  04,
                                                    Input  ttWork.cod-usuario,
                                                    Input  ttWork.cod-equipamento,
                                                    Output Table ttWm-box-movto APPEND).

    IF ttWork.cod-opcao = 1 THEN DO:
        /* exibir tarefas de ressuprimento com armazenamento na zona informada */
        FOR EACH ttWm-box-movto,
            FIRST wm-box-movto NO-LOCK
            WHERE wm-box-movto.cod-estabel    = ttWm-box-movto.cod-estabel
              AND wm-box-movto.cod-local      = ttWm-box-movto.cod-local
              AND wm-box-movto.id-movto       = ttWm-box-movto.id-movto
              AND wm-box-movto.ind-tipo-movto = 1,
            FIRST wm-box NO-LOCK
                WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                  AND wm-box.cod-local   = wm-box-movto.cod-local
                  AND wm-box.id-box      = wm-box-movto.id-box:

             FOR FIRST zona-separa-box USE-INDEX znsepbox-02 NO-LOCK
                 WHERE zona-separa-box.cod-estabel = wm-box.cod-estabel
                   AND zona-separa-box.cod-local   = wm-box.cod-local
                   AND zona-separa-box.id-box      = wm-box.id-box
                   AND zona-separa-box.cod-zona   >= ttWork.cod-zona-ini
                   AND zona-separa-box.cod-zona   <= ttWork.cod-zona-fim:
             END.
    
             IF NOT AVAIL zona-separa-box THEN
                 DELETE ttwm-box-movto.

             FOR FIRST bf-box-movto NO-LOCK
                 WHERE bf-box-movto.cod-estabel    = wm-box-movto.cod-estabel
                   AND bf-box-movto.cod-local      = wm-box-movto.cod-local
                   AND bf-box-movto.id-movto       = wm-box-movto.id-movto
                   AND bf-box-movto.ind-tipo-movto = 2:
             END.
      
             IF bf-box-movto.dec-2 <> 0
             AND can-find(FIRST wm-etiqueta no-lock
                          WHERE wm-etiqueta.id-etiqueta = bf-box-movto.dec-2) THEN
                 DELETE ttwm-box-movto. /* movimento j† coletou e gerou saldo para ressup */
        END.
    END.
    ELSE DO: /* armazenamento */
        FOR EACH ttWm-box-movto,
            FIRST wm-box-movto NO-LOCK
            WHERE wm-box-movto.cod-estabel    = ttWm-box-movto.cod-estabel
              AND wm-box-movto.cod-local      = ttWm-box-movto.cod-local
              AND wm-box-movto.id-movto       = ttWm-box-movto.id-movto
              AND wm-box-movto.ind-tipo-movto = 1,
            FIRST wm-box NO-LOCK
                WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                  AND wm-box.cod-local   = wm-box-movto.cod-local
                  AND wm-box.id-box      = wm-box-movto.id-box:
    
             FOR FIRST zona-separa-box USE-INDEX znsepbox-02 NO-LOCK
                 WHERE zona-separa-box.cod-estabel = wm-box.cod-estabel
                   AND zona-separa-box.cod-local   = wm-box.cod-local
                   AND zona-separa-box.id-box      = wm-box.id-box
                   AND zona-separa-box.cod-zona   >= ttWork.cod-zona-ini
                   AND zona-separa-box.cod-zona   <= ttWork.cod-zona-fim:
             END.
    
             IF NOT AVAIL zona-separa-box THEN DO:
                 DELETE ttwm-box-movto.
                 NEXT.
             END.
    
             IF ttwm-box-movto.dec-2 <> 0
             AND can-find(FIRST wm-etiqueta no-lock
                          WHERE wm-etiqueta.id-etiqueta = ttWm-box-movto.dec-2) THEN DO:  /* troca movto de saida por entrada */
                 BUFFER-COPY wm-box-movto TO ttwm-box-movto
                     ASSIGN ttwm-box-movto.r-rowid = ROWID(wm-box-movto).
             END.
             ELSE
                 DELETE ttwm-box-movto. /* ignora se nao separou ainda */
        END.

    END.
    RETURN 'OK':U.
END PROCEDURE.

PROCEDURE piFinalizaObjetos:

    IF VALID-HANDLE(wgbosc030) THEN
        RUN destroy IN wgbosc030.

    IF VALID-HANDLE(wgbosc032) THEN
        RUN destroy IN wgbosc032.

    IF VALID-HANDLE(wgbosc038) THEN
        RUN destroy IN wgbosc038.

    IF VALID-HANDLE(wgbosc039) THEN
        RUN destroy IN wgbosc039.

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

    IF VALID-HANDLE(wgbosc098) THEN
        RUN destroy IN wgbosc098.

    RETURN "OK".
END PROCEDURE.

PROCEDURE piOpcao:

    EMPTY TEMP-TABLE tt-opcao.
    CREATE tt-opcao.
    ASSIGN tt-opcao.cod-opcao = 1
           tt-opcao.descricao = "SEPARACAO".

    CREATE tt-opcao.
    ASSIGN tt-opcao.cod-opcao = 2
           tt-opcao.descricao = "ARMAZENAMENTO".

    RETURN "OK".
END PROCEDURE.
