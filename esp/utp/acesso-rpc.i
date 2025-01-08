&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : utp/acesso-rpc.i
    Purpose     : Cont‚m as rotinas conecta-rpc e desconecta-rpc,
                  para permitir as conexÆo com o servidor RPC sob
                  demanda.

    Syntax      : run conecta-rpc (output h-rpc).
                  run desconecta-rpc (input h-rpc).
                  h-rpc ‚ uma var¡avel tipo handle usada para
                  referˆncia a conexÆo RPC

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* Defina o pr‚-processador TESTE na se‡Æo Definitions do programa que
   usar esta include, quando desejar usar o servidor de testes.
   Defina desta forma:
   
   &scoped-define TESTE 1
   
   NÆo esque‡a de apagar esta linha na se‡Æo Definitions de seu programa
   ANTES de compil -lo para libera‡Æo na produ‡Æo
   
   
Defina o preprocessador servidor-producao no definitions do programa que usar a include
para poder selecionar qual dos servidores deve ser utilizado.
                                        
&SCOPED-DEFINE SERVIDOR-PRODUCAO rpc21pr   
   
   
*/   


DEFINE VARIABLE c-serv-rpc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ambiente AS CHARACTER   NO-UNDO.
DEFINE VARIABLE param-rpc  AS CHARACTER   NO-UNDO.

RUN esp/es0018p.p (INPUT  "ambiente":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-ambiente = tt-prog-ponto.conteudo.
END.

EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT  "RPC":U,
                   INPUT  1,
                   INPUT  0,
                   INPUT  "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:
    ASSIGN c-serv-rpc = tt-prog-ponto.conteudo.
END.

CASE c-ambiente:
    WHEN "homologacao" THEN
        FIND FIRST servid_rpc NO-LOCK
        WHERE servid_rpc.cod_servid_rpc = ENTRY(1,c-serv-rpc,";"). 

    WHEN "producao" THEN
        FIND FIRST servid_rpc NO-LOCK
        WHERE servid_rpc.cod_servid_rpc = ENTRY(2,c-serv-rpc,";").

    WHEN "desenvolvimento" THEN
        FIND FIRST servid_rpc NO-LOCK
        WHERE servid_rpc.cod_servid_rpc = ENTRY(3,c-serv-rpc,";").

END CASE.


ASSIGN param-rpc = servid_rpc.des_carg_rpc.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE conecta-rpc Include 
PROCEDURE conecta-rpc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-rpc AS HANDLE NO-UNDO.
    DEF VAR l-ok AS LOGICAL NO-UNDO.

    CREATE SERVER p-rpc.
    DO ON ERROR undo, LEAVE:
        ASSIGN l-ok = p-rpc:CONNECT(param-rpc) NO-ERROR.
    END.
    IF NOT l-ok THEN DO:
        DELETE OBJECT p-rpc.
        p-rpc = ?.
        RETURN "NOK".
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE desconecta-rpc Include 
PROCEDURE desconecta-rpc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-rpc AS HANDLE NO-UNDO.

    IF VALID-HANDLE(p-rpc) THEN DO:
        p-rpc:DISCONNECT().
        DELETE OBJECT p-rpc.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

