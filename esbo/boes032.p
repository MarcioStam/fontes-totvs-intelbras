&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOES032 2.00.00.000}                               
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */
 
/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName  BOES032
&GLOBAL-DEFINE DBOVersion  2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName  comp-familia-item
&GLOBAL-DEFINE TableLabel  Complemento Fam¡lia-item
&GLOBAL-DEFINE QueryName qr{&TableName} 
 
/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */
 
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */
 
/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{esbo/boes032.i RowObject}
 
 
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
 
 
/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
/* ************************* Defini‡Æo de vari veis *********************** */
define variable v-cod-familia as integer no-undo.
define variable v-cod-sub-familia as integer no-undo.
define variable v-cod-car-familia as integer no-undo.
define variable v-cod-comp-familia as integer no-undo.

def temp-table tt-comp-familia-ext no-undo
     field meses-validade like int-familia.meses-validade    
     field perc-nqa like familia.perc-nqa              
     field nivel like familia.nivel                 
     field contr-qualid like familia.contr-qualid          
     field criticidade like familia.criticidade           
     field deposito-pad like familia.deposito-pad          
     field loc-unica like familia.loc-unica             
     field tipo-requis like familia.tipo-requis           
     field ciclo-contag like familia.ciclo-contag          
     field fraciona like familia.fraciona              
     field un like familia.un                    
     field tempo-segur like familia.tempo-segur           
     field res-for-comp like familia.res-for-comp          
     field periodo-fixo like familia.periodo-fixo          
     field perc-perda like int-familia.perc-perda        
     field desc-ingles like int-familia.desc-ingles       
     field pad-nomenc like int-familia.pad-nomenc
     FIELD cod-unid-negoc LIKE familia-mat.cod-unid-negoc.        

def temp-table ttfamilia no-undo like familia
    field r-rowid as rowid.
    
def temp-table ttint-familia no-undo like int-familia
    field r-rowid as rowid.
        
def temp-table ttfam-uni-estab no-undo like fam-uni-estab
    field r-rowid as rowid.

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
   Type: DBOProgram Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 17.17
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard */
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
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.                                                                       

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "abreviatura":U THEN ASSIGN pFieldValue = RowObject.abreviatura.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFamilyInfo DBOProgram 
PROCEDURE getFamilyInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-familia-id as char no-undo.
    def output param table for tt-comp-familia-ext.
    
    for each tt-comp-familia-ext:
        delete tt-comp-familia-ext.
    end.
    
    for first familia no-lock
        where familia.fm-codigo = p-familia-id,
        first int-familia of familia no-lock,
        FIRST familia-mat OF familia NO-LOCK:

        create tt-comp-familia-ext.
        assign tt-comp-familia-ext.meses-validade = int-familia.meses-validade    
               tt-comp-familia-ext.perc-nqa = familia.perc-nqa              
               tt-comp-familia-ext.nivel = familia.nivel                 
               tt-comp-familia-ext.contr-qualid = familia.contr-qualid          
               tt-comp-familia-ext.criticidade = familia.criticidade           
               tt-comp-familia-ext.deposito-pad = familia.deposito-pad          
               tt-comp-familia-ext.loc-unica = familia.loc-unica             
               tt-comp-familia-ext.tipo-requis = familia.tipo-requis           
               tt-comp-familia-ext.ciclo-contag = familia.ciclo-contag          
               tt-comp-familia-ext.fraciona = familia.fraciona              
               tt-comp-familia-ext.un = familia.un                    
               tt-comp-familia-ext.tempo-segur = familia.tempo-segur           
               tt-comp-familia-ext.res-for-comp = familia.res-for-comp          
               tt-comp-familia-ext.periodo-fixo = familia.periodo-fixo          
               tt-comp-familia-ext.perc-perda = int-familia.perc-perda        
               tt-comp-familia-ext.desc-ingles = int-familia.desc-ingles       
               tt-comp-familia-ext.pad-nomenc = int-familia.pad-nomenc
               tt-comp-familia-ext.cod-unid-negoc = familia-mat.cod-unid-negoc.        
    end.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.                                                                         

    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-car-familia":U THEN ASSIGN pFieldValue = RowObject.cod-car-familia.
        WHEN "cod-comp-familia":U THEN ASSIGN pFieldValue = RowObject.cod-comp-familia.
        WHEN "cod-familia":U THEN ASSIGN pFieldValue = RowObject.cod-familia.
        WHEN "cod-sub-familia":U THEN ASSIGN pFieldValue = RowObject.cod-sub-familia.
        OTHERWISE RETURN "NOK":U.
    END CASE.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-car-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-comp-familia AS integer NO-UNDO.                                                                   

    FIND bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-familia = p-cod-familia              
        AND bf{&TableName}.cod-sub-familia = p-cod-sub-familia        
        AND bf{&TableName}.cod-car-familia = p-cod-car-familia        
        AND bf{&TableName}.cod-comp-familia = p-cod-comp-familia      
        NO-ERROR.
    IF NOT AVAILABLE bf{&TableName} THEN RETURN "NOK":U.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&TableName})).
    IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToFamilia-Item DBOProgram 
PROCEDURE linkToFamilia-Item :
/*---------------------------------------------------------------
  Purpose:     Recebe handle do DBO Item e execute m‚todo getKey
  Parameters:  recebe handle de um DBO
  Notes:       
----------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getKey IN pHandle (OUTPUT v-cod-familia).
   
   RETURN "OK":U.
   
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
DEFINE INPUT PARAMETER iAbertura AS INTEGER NO-UNDO.

    CASE iAbertura:
        WHEN 1 THEN
            RUN openQueryStatic ("Main":U).
        WHEN 2 THEN           
            RUN openQueryStatic ("Compl":U).                          
    END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCompl DBOProgram 
PROCEDURE openQueryCompl :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-familia = v-cod-familia                
        AND {&TableName}.cod-sub-familia = v-cod-sub-familia          
        AND {&TableName}.cod-car-familia = v-cod-car-familia          
        AND {&TableName}.cod-comp-familia = v-cod-comp-familia        
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFamilia DBOProgram 
PROCEDURE openQueryFamilia :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-familia = v-cod-familia                
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCompl DBOProgram 
PROCEDURE setConstraintCompl :
DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-sub-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-car-familia AS integer NO-UNDO.                                                                    
    DEFINE INPUT PARAMETER p-cod-comp-familia AS integer NO-UNDO.                                                                   

    ASSIGN 
    v-cod-familia = p-cod-familia                                     
    v-cod-sub-familia = p-cod-sub-familia                             
    v-cod-car-familia = p-cod-car-familia                             
    v-cod-comp-familia = p-cod-comp-familia                           
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFamilia DBOProgram 
PROCEDURE setConstraintFamilia :
DEFINE INPUT PARAMETER p-cod-familia AS integer NO-UNDO.                                                                        
    DEFINE INPUT PARAMETER p-cod-sub-familia AS integer NO-UNDO.                                                                    

    ASSIGN 
    v-cod-familia = p-cod-familia                                     
    .
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFamilyInfo DBOProgram 
PROCEDURE setFamilyInfo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pi-cod-estabel as char no-undo.
    def input param p-familia-id as char no-undo.
    def input param table for tt-comp-familia-ext.
    
    empty temp-table ttfamilia.
    empty temp-table ttint-familia.
    empty temp-table ttfam-uni-estab.
    
    for each familia no-lock
        where familia.fm-codigo = p-familia-id:
        
        create ttfamilia.
        buffer-copy familia to ttfamilia.
        ttfamilia.r-rowid = rowid(familia).
    end.    
    
    for each int-familia no-lock
        where int-familia.fm-codigo = p-familia-id:
        
        create ttint-familia.
        buffer-copy int-familia to ttint-familia.
        ttint-familia.r-rowid = rowid(int-familia).
    end.    

    find first ttfamilia no-error.
    if not avail ttfamilia then create ttfamilia.
    find first ttfamilia no-error.
    find first ttint-familia no-error.
    if not avail ttint-familia then create ttint-familia.
    find first ttfam-uni-estab no-error.
    if not avail ttfam-uni-estab then create ttfam-uni-estab.
    
    for first tt-comp-familia-ext:
        assign ttfamilia.fm-codigo          = p-familia-id
               ttint-familia.fm-codigo      = ttfamilia.fm-codigo
               ttfamilia.perc-nqa           = tt-comp-familia-ext.perc-nqa        
               ttfamilia.nivel              = tt-comp-familia-ext.nivel        
               ttfamilia.contr-qualid       = tt-comp-familia-ext.contr-qualid        
               ttfamilia.criticidade        = tt-comp-familia-ext.criticidade        
               ttfamilia.deposito-pad       = tt-comp-familia-ext.deposito-pad        
               ttfamilia.loc-unica          = tt-comp-familia-ext.loc-unica        
               ttfamilia.tipo-requis        = tt-comp-familia-ext.tipo-requis        
               ttfamilia.ciclo-contag       = tt-comp-familia-ext.ciclo-contag        
               ttfamilia.fraciona           = tt-comp-familia-ext.fraciona        
               ttfamilia.un                 = tt-comp-familia-ext.un        
               ttfamilia.tempo-segur        = tt-comp-familia-ext.tempo-segur        
               ttfamilia.res-for-comp       = tt-comp-familia-ext.res-for-comp        
               ttfamilia.periodo-fixo       = tt-comp-familia-ext.periodo-fixo
               ttint-familia.meses-validade = tt-comp-familia-ext.meses-validade
               ttint-familia.perc-perda     = tt-comp-familia-ext.perc-perda  
               ttint-familia.desc-ingles    = tt-comp-familia-ext.desc-ingles  
               ttint-familia.pad-nomenc     = tt-comp-familia-ext.pad-nomenc
               ttfam-uni-estab.fm-codigo    = ttfamilia.fm-codigo.
               
    end.                                           

    do while true:
        find first familia 
            where familia.fm-codigo = ttfamilia.fm-codigo
            exclusive-lock no-wait no-error.
        if avail familia and not locked(familia) then leave.
        if not avail familia then do:
            create familia.
            leave.
        end.    
        pause 1.
    end.
    disable triggers for load of familia.
    buffer-copy ttfamilia to familia.
    /* if ttfamilia.r-rowid = ? THEN */ /*  Agora vai atualizar a descri‡Æo - Emerson */
        for first familia-item no-lock
            where familia-item.cod-familia = int(substring(p-familia-id, 1, 3)),
            first sub-familia-item no-lock
            where sub-familia-item.cod-familia = familia-item.cod-familia
            and   sub-familia-item.cod-sub-familia = int(substring(p-familia-id, 4, 2)),
            first car-familia-item of sub-familia-item no-lock
            where car-familia-item.cod-car-familia = int(substring(p-familia-id, 6, 2)),
            first comp-familia-item of car-familia-item no-lock
            where comp-familia-item.cod-comp-familia = int(substring(p-familia-id, 8, 1)):
            
            familia.descricao = /* trim(familia-item.descricao) +  " " + */
                                trim(sub-familia-item.descricao) + " " +
                                trim(car-familia-item.descricao) + " " +
                                trim(comp-familia-item.descricao).
        end.
        
    release familia.

    do while true:
        find first int-familia 
            where int-familia.fm-codigo = ttint-familia.fm-codigo
            exclusive-lock no-wait no-error.
        if avail int-familia and not locked(int-familia) then leave.
        if not avail int-familia then do:
            create int-familia.
            leave.
        end.    
        pause 1.
    end.
    disable triggers for load of int-familia.
    buffer-copy ttint-familia to int-familia.
    release int-familia.


    do while true:
        find first familia-mat 
            where familia-mat.fm-codigo = ttfamilia.fm-codigo
            exclusive-lock no-wait no-error.
        if avail familia-mat and not locked(familia-mat) then leave.
        if not avail familia-mat then do:
            create familia-mat.
            leave.
        end.    
        pause 1.
    end.
    disable triggers for load of familia-mat.
    assign familia-mat.fm-codigo      = ttfamilia.fm-codigo
           familia-mat.cod-unid-negoc = tt-comp-familia-ext.cod-unid-negoc.
    release familia-mat.

    do while true:
        find first fam-uni-estab 
            where fam-uni-estab.fm-codigo = ttfamilia.fm-codigo
            and   fam-uni-estab.cod-estabel = pi-cod-estabel
            exclusive-lock no-wait no-error.
        if avail fam-uni-estab and not locked(fam-uni-estab) then leave.
        if not avail fam-uni-estab then do:
            create fam-uni-estab.
            leave.
        end.    
        pause 1.
    end.
    disable triggers for load of fam-uni-estab.
    assign fam-uni-estab.fm-codigo    = ttfamilia.fm-codigo
           fam-uni-estab.cod-estabel  = pi-cod-estabel       
           fam-uni-estab.contr-qualid = ttfamilia.contr-qualid
           fam-uni-estab.criticidade  = ttfamilia.criticidade
           fam-uni-estab.deposito-pad = ttfamilia.deposito-pad
           fam-uni-estab.loc-unica    = ttfamilia.loc-unica
           fam-uni-estab.tipo-requis  = ttfamilia.tipo-requis                
           fam-uni-estab.ciclo-contag = ttfamilia.ciclo-contag
           fam-uni-estab.tempo-segur  = ttfamilia.tempo-segur
           fam-uni-estab.res-for-comp = ttfamilia.res-for-comp
           fam-uni-estab.periodo-fixo = ttfamilia.periodo-fixo
           fam-uni-estab.cod-unid-negoc = tt-comp-familia-ext.cod-unid-negoc.
    release fam-uni-estab.
    
    do while true:
        find first fam-mat-estab 
            where fam-mat-estab.fm-codigo = ttfamilia.fm-codigo
            and   fam-mat-estab.cod-estabel = pi-cod-estabel
            exclusive-lock no-wait no-error.
        if avail fam-mat-estab and not locked(fam-mat-estab) then leave.
        if not avail fam-mat-estab then do:
            create fam-mat-estab.
            leave.
        end.    
        pause 1.
    end.
    disable triggers for load of fam-mat-estab.
    assign fam-mat-estab.fm-codigo    = ttfamilia.fm-codigo
           fam-mat-estab.cod-estabel  = pi-cod-estabel       
           fam-mat-estab.contr-qualid = ttfamilia.contr-qualid
           fam-mat-estab.criticidade  = ttfamilia.criticidade
           fam-mat-estab.loc-unica    = ttfamilia.loc-unica
           fam-mat-estab.ciclo-contag = ttfamilia.ciclo-contag
           fam-mat-estab.tempo-segur  = ttfamilia.tempo-segur
           fam-mat-estab.res-for-comp = ttfamilia.res-for-comp
           fam-mat-estab.periodo-fixo = ttfamilia.periodo-fixo.
    release fam-mat-estab.
    
    do while true:
        find first fam-man-estab 
            where fam-man-estab.fm-codigo = ttfamilia.fm-codigo
            and   fam-man-estab.cod-estabel = pi-cod-estabel
            exclusive-lock no-wait no-error.
        if avail fam-man-estab and not locked(fam-man-estab) then leave.
        if not avail fam-man-estab then do:
            create fam-man-estab.
            leave.
        end.    
        pause 1.
    end.
    disable triggers for load of fam-man-estab.
    assign fam-man-estab.fm-codigo    = ttfamilia.fm-codigo
           fam-man-estab.cod-estabel  = pi-cod-estabel       
           fam-man-estab.contr-qualid = ttfamilia.contr-qualid
           fam-man-estab.deposito-pad = ttfamilia.deposito-pad
           fam-man-estab.tipo-requis  = ttfamilia.tipo-requis
           fam-man-estab.tempo-segur  = ttfamilia.tempo-segur
           fam-man-estab.res-for-comp = ttfamilia.res-for-comp
           fam-man-estab.periodo-fixo = ttfamilia.periodo-fixo.
    release fam-man-estab.
    
    if not can-find(first folh-fm-it no-lock
        where folh-fm-it.fm-codigo = ttfamilia.fm-codigo
        and   folh-fm-it.cd-folha  = "1") then do:
        
        disable triggers for load of folh-fm-it.
        create folh-fm-it. 
        assign folh-fm-it.fm-codigo = ttfamilia.fm-codigo 
               folh-fm-it.cd-folha  = "1".
        
    end.    

    return "OK".
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    def var c-familia-id as char no-undo.

    CASE pType:
         WHEN "Create" THEN DO:
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia
                 AND bf{&TableName}.cod-comp-familia = RowObject.cod-comp-familia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="1"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             
             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia
                 AND bf{&TableName}.abreviatura = RowObject.abreviatura) THEN DO:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe complemento de fam¡lia com esta abreviatura",
                                        INPUT "Existe complemento de fam¡lia com esta abreviatura",
                                        INPUT "").                    
             END.
             if not can-find(first sub-familia-item no-lock
                where sub-familia-item.cod-familia     = RowObject.cod-familia
                and   sub-familia-item.cod-sub-familia = RowObject.cod-sub-familia) then do:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Subfam¡lia'"
                 }
                
             end.   
             if not can-find(first car-familia-item no-lock
                where car-familia-item.cod-familia     = RowObject.cod-familia
                and   car-familia-item.cod-sub-familia = RowObject.cod-sub-familia
                AND   car-familia-item.cod-car-familia = RowObject.cod-car-familia) then do:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'Caracter¡sticas da Subfam¡lia'"
                 }
                
             end.   


         END.
         WHEN "Update" THEN DO:

             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia
                 AND bf{&TableName}.cod-comp-familia = RowObject.cod-comp-familia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.

             IF CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia
                 AND bf{&TableName}.abreviatura = RowObject.abreviatura
                 and rowid(bf{&TableName}) ne RowObject.r-rowid) THEN DO:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe complemento de fam¡lia com esta abreviatura",
                                        INPUT "Existe complemento de fam¡lia com esta abreviatura",
                                        INPUT "").                    
             END.

         END.
         WHEN "Delete" THEN DO:
             IF NOT CAN-FIND(FIRST bf{&TableName} NO-LOCK
                 WHERE bf{&TableName}.cod-familia = RowObject.cod-familia
                 AND bf{&TableName}.cod-sub-familia = RowObject.cod-sub-familia
                 AND bf{&TableName}.cod-car-familia = RowObject.cod-car-familia
                 AND bf{&TableName}.cod-comp-familia = RowObject.cod-comp-familia) THEN DO:
                 {method/svc/errors/inserr.i
                     &ErrorNumber="2"
                     &ErrorType="EMS"
                     &ErrorSubType="ERROR"
                     &ErrorParameters="'{&TableLabel}'"
                 }
             END.
             
             c-familia-id = string(RowObject.cod-familia,"999") +
                            string(RowObject.cod-sub-familia,"99") +
                            string(RowObject.cod-car-familia,"99") +
                            string(RowObject.cod-comp-familia,"9").
             
             if can-find(first familia no-lock
                where familia.fm-codigo begins c-familia-id) then do:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe Fam¡lia Material EMS para esta fam¡lia",
                                        INPUT "ExclusÆo, somente atrav‚s do programa CD0202",
                                        INPUT "").                    
                
             end. 
             /*
             if can-find(first item no-lock
                where item.fm-codigo = c-familia-id) then do:
                 RUN _insertErrorManual(INPUT 0,
                                        INPUT "EMS",
                                        INPUT "ERROR",
                                        INPUT "Existe item nesta fam¡lia",
                                        INPUT "Existe item nesta fam¡lia",
                                        INPUT "").                    
                
             end.   
             */
         END.
    END CASE.

    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

