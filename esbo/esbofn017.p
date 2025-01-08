&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOFN017
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName usuar_mestre
&GLOBAL-DEFINE TableName2 colab-salario-var
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName  qr{&TableName} 
&GLOBAL-DEFINE QueryName2 qr{&TableName2}

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{esbo/esbofn017.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/
DEFINE QUERY {&QueryName2}  FOR {&TableName} SCROLLING.
DEFINE QUERY {&QueryName} FOR {&TableName}, {&TableName2} SCROLLING.


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.
DEFINE BUFFER bf{&TableName2} FOR {&TableName2}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 11.27
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod_dialet":U THEN ASSIGN pFieldValue = RowObject.cod_dialet.
        WHEN "cod_e_mail_celular":U THEN ASSIGN pFieldValue = RowObject.cod_e_mail_celular.
        WHEN "cod_e_mail_local":U THEN ASSIGN pFieldValue = RowObject.cod_e_mail_local.
        WHEN "cod_idiom_orig":U THEN ASSIGN pFieldValue = RowObject.cod_idiom_orig.
        WHEN "cod_livre_1":U THEN ASSIGN pFieldValue = RowObject.cod_livre_1.
        WHEN "cod_livre_2":U THEN ASSIGN pFieldValue = RowObject.cod_livre_2.
        WHEN "cod_senha":U THEN ASSIGN pFieldValue = RowObject.cod_senha.
        WHEN "cod_senha_framework":U THEN ASSIGN pFieldValue = RowObject.cod_senha_framework.
        WHEN "cod_servid_exec":U THEN ASSIGN pFieldValue = RowObject.cod_servid_exec.
        WHEN "cod_usuario":U THEN ASSIGN pFieldValue = RowObject.cod_usuario.
        WHEN "des_checksum":U THEN ASSIGN pFieldValue = RowObject.des_checksum.
        WHEN "des_cod_perf_usuar":U THEN ASSIGN pFieldValue = RowObject.des_cod_perf_usuar.
        WHEN "hra_ult_erro_tentat_aces":U THEN ASSIGN pFieldValue = RowObject.hra_ult_erro_tentat_aces.
        WHEN "ind_tip_aces_usuar":U THEN ASSIGN pFieldValue = RowObject.ind_tip_aces_usuar.
        WHEN "ind_tip_usuar":U THEN ASSIGN pFieldValue = RowObject.ind_tip_usuar.
        WHEN "nom_dir_spool":U THEN ASSIGN pFieldValue = RowObject.nom_dir_spool.
        WHEN "nom_subdir_spool":U THEN ASSIGN pFieldValue = RowObject.nom_subdir_spool.
        WHEN "nom_subdir_spool_rpw":U THEN ASSIGN pFieldValue = RowObject.nom_subdir_spool_rpw.
        WHEN "nom_usuario":U THEN ASSIGN pFieldValue = RowObject.nom_usuario.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat_fim_valid":U THEN ASSIGN pFieldValue = RowObject.dat_fim_valid.
        WHEN "dat_inic_valid":U THEN ASSIGN pFieldValue = RowObject.dat_inic_valid.
        WHEN "dat_livre_1":U THEN ASSIGN pFieldValue = RowObject.dat_livre_1.
        WHEN "dat_livre_2":U THEN ASSIGN pFieldValue = RowObject.dat_livre_2.
        WHEN "dat_ult_erro_tentat_aces":U THEN ASSIGN pFieldValue = RowObject.dat_ult_erro_tentat_aces.
        WHEN "dat_valid_senha":U THEN ASSIGN pFieldValue = RowObject.dat_valid_senha.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qtd_erro_tentat_aces":U THEN ASSIGN pFieldValue = RowObject.qtd_erro_tentat_aces.
        WHEN "val_livre_1":U THEN ASSIGN pFieldValue = RowObject.val_livre_1.
        WHEN "val_livre_2":U THEN ASSIGN pFieldValue = RowObject.val_livre_2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "idi_dtsul":U THEN ASSIGN pFieldValue = RowObject.idi_dtsul.
        WHEN "idi_dtsul_instan":U THEN ASSIGN pFieldValue = RowObject.idi_dtsul_instan.
        WHEN "idi_tip_login":U THEN ASSIGN pFieldValue = RowObject.idi_tip_login.
        WHEN "num_dias_valid_senha":U THEN ASSIGN pFieldValue = RowObject.num_dias_valid_senha.
        WHEN "num_dia_cont_modul_dtsul":U THEN ASSIGN pFieldValue = RowObject.num_dia_cont_modul_dtsul.
        WHEN "num_livre_1":U THEN ASSIGN pFieldValue = RowObject.num_livre_1.
        WHEN "num_livre_2":U THEN ASSIGN pFieldValue = RowObject.num_livre_2.
        WHEN "num_perf_usuar":U THEN ASSIGN pFieldValue = RowObject.num_perf_usuar.
        WHEN "num_pessoa":U THEN ASSIGN pFieldValue = RowObject.num_pessoa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice srmstr_id
  Parameters:  
               retorna valor do campo cod_usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod_usuario LIKE usuar_mestre.cod_usuario NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod_usuario = RowObject.cod_usuario.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log_ativ_multi_idiom":U THEN ASSIGN pFieldValue = RowObject.log_ativ_multi_idiom.
        WHEN "log_full_determ":U THEN ASSIGN pFieldValue = RowObject.log_full_determ.
        WHEN "log_livre_1":U THEN ASSIGN pFieldValue = RowObject.log_livre_1.
        WHEN "log_livre_2":U THEN ASSIGN pFieldValue = RowObject.log_livre_2.
        WHEN "log_mostra_framework":U THEN ASSIGN pFieldValue = RowObject.log_mostra_framework.
        WHEN "log_segur_uhr_atlzdo":U THEN ASSIGN pFieldValue = RowObject.log_segur_uhr_atlzdo.
        WHEN "log_servid_exec_obrig":U THEN ASSIGN pFieldValue = RowObject.log_servid_exec_obrig.
        WHEN "log_solic_impres":U THEN ASSIGN pFieldValue = RowObject.log_solic_impres.
        WHEN "log_trace":U THEN ASSIGN pFieldValue = RowObject.log_trace.
        WHEN "log_usuar_atlzdo_ged":U THEN ASSIGN pFieldValue = RowObject.log_usuar_atlzdo_ged.
        WHEN "log_usuar_wap":U THEN ASSIGN pFieldValue = RowObject.log_usuar_wap.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice srmstr_id
  Parameters:  
               recebe valor do campo cod_usuario
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod_usuario LIKE usuar_mestre.cod_usuario NO-UNDO.

    FIND FIRST bfusuar_mestre WHERE 
        bfusuar_mestre.cod_usuario = pcod_usuario NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfusuar_mestre THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfusuar_mestre)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName2} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySalVariavel DBOProgram 
PROCEDURE openQuerySalVariavel :
/*------------------------------------------------------------------------------
  Purpose:     Buscar somente usu†rios com sal†rio vari†vel cadastrados
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK,
                            FIRST colab-salario-var NO-LOCK
                            WHERE colab-salario-var.cod-colab = usuar_mestre.cod_usuario INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

