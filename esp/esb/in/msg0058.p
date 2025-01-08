
/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**/
/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i msg0058 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: MSG0058
**  Objetivo: <comment>
**  Autor...:     
**  Data....: 11.02.2014 11:25
*******************************************************************************/

CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

DEFINE TEMP-TABLE tt-cont-emit LIKE cont-emit.
DEFINE TEMP-TABLE tt-repres    LIKE repres.
DEFINE TEMP-TABLE tt-atendente LIKE atendente.
DEFINE VARIABLE l-log AS LOGICAL     NO-UNDO.

{esp/esb/in/msg0058.i}

DEFINE BUFFER b-int-cont-emit FOR int-cont-emit.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE DATASET mensagem FOR cabecalho, conteudo, EnderecoPrincipal, msg0058
   DATA-RELATION FOR conteudo, msg0058 RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0058, EnderecoPrincipal RELATION-FIELDS (idm, idm) NESTED.

ASSIGN l-log = NO.
IF l-log  THEN
    IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 1").

DATASET mensagem:READ-XML('longchar', iXML, 'empty', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, msg0058r, resultado
   DATA-RELATION FOR conteudor, msg0058r RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR msg0058r, resultado RELATION-FIELDS (idm, idm) NESTED.

FIND msg0058.

IF l-log  THEN
   IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 2").

CREATE cabecalhor.
FIND cabecalho.
BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.
ASSIGN cabecalhor.CodigoMensagem = 'MSG0058R1'.

CREATE conteudor.
CREATE resultado.
CREATE msg0058r. 

IF l-log  THEN
   IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 3").

FIND FIRST int-emitente NO-LOCK
     WHERE int-emitente.cod-guid = msg0058.Canal NO-ERROR.

IF l-log  THEN
   IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 1 " + STRING(AVAIL int-emitente)   ).

IF msg0058.ContatoNFE <> 993520000 THEN DO: /*ContatoNFE = SIM*/

    IF l-log  THEN
       IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 1a " + string(msg0058.ContatoNFE) + " " + STRING(msg0058.Email)  ).

   FOR EACH cont-emit EXCLUSIVE-LOCK
                WHERE cont-emit.cod-emitente = int-emitente.cod-emitente
                  AND cont-emit.e-mail      = STRING(msg0058.Email):
       FIND FIRST int-cont-emit exclusive-LOCK
            WHERE int-cont-emit.cod-emitente = int-emitente.cod-emitente
              AND int-cont-emit.sequencia    = cont-emit.sequencia NO-ERROR.
       IF l-log  THEN
          IF OPSYS = "UNIX" THEN log-manager:write-message("eliminado " + string(msg0058.ContatoNFE) + " " + STRING(msg0058.Email)  ).
       DELETE int-cont-emit.
       DELETE cont-emit.
   END.
END.

IF msg0058.ContatoNFE = 993520000 THEN DO: /*ContatoNFE = SIM*/


    IF NOT AVAIL int-emitente 
    OR msg0058.Canal = "" 
    OR msg0058.Canal = ? THEN
        RUN pi-erro (INPUT "NÆo encontrado c¢digo do cliente CRM no ERP").

    IF NOT CAN-FIND (FIRST tt-erro) THEN DO:
       FIND FIRST int-cont-emit exclusive-LOCK
             WHERE int-cont-emit.cod-emitente = int-emitente.cod-emitente
               AND int-cont-emit.vl-guid      = msg0058.CodigoContato  NO-ERROR.
       IF NOT AVAIL int-cont-emit THEN
            FIND FIRST cont-emit EXCLUSIVE-LOCK
                WHERE cont-emit.cod-emitente = int-emitente.cod-emitente
                  AND cont-emit.e-mail      = STRING(msg0058.Email)  NO-ERROR.
       ELSE DO:
           FIND FIRST cont-emit EXCLUSIVE-LOCK
               WHERE cont-emit.cod-emitente = int-emitente.cod-emitente
                 AND cont-emit.sequencia    = int-cont-emit.sequencia  NO-ERROR.
       END.

        IF AVAIL cont-emit THEN DO:
           FIND FIRST int-cont-emit exclusive-LOCK
                WHERE int-cont-emit.cod-emitente = int-emitente.cod-emitente
                  AND int-cont-emit.sequencia    = cont-emit.sequencia NO-ERROR.
           IF NOT AVAIL INT-cont-emit THEN DO:
               FIND LAST b-int-cont-emit NO-LOCK
                   WHERE b-int-cont-emit.cod-emitente = int-emitente.cod-emitente NO-ERROR.

               CREATE int-cont-emit.
               ASSIGN int-cont-emit.cod-emitente = int-emitente.cod-emitente
                      int-cont-emit.sequencia    = cont-emit.sequencia
                      int-cont-emit.vl-guid      = msg0058.CodigoContato.

           END.

        END.
        ELSE DO:
            FIND LAST b-int-cont-emit NO-LOCK
                WHERE b-int-cont-emit.cod-emitente = int-emitente.cod-emitente NO-ERROR.
    
            CREATE int-cont-emit.
            ASSIGN int-cont-emit.cod-emitente = int-emitente.cod-emitente
                   int-cont-emit.sequencia    = IF AVAIL b-int-cont-emit THEN b-int-cont-emit.sequencia + 10 ELSE 10
                   int-cont-emit.vl-guid      = msg0058.CodigoContato.
    
            CREATE cont-emit.
            ASSIGN cont-emit.cod-emitente = int-emitente.cod-emitente
                   cont-emit.sequencia    = int-cont-emit.sequencia.  


        END.
        ASSIGN int-cont-emit.vl-guid  = msg0058.CodigoContato
               cont-emit.nome         = "NFE"
               cont-emit.e-mail       = STRING(msg0058.Email)
               cont-emit.ramal        = msg0058.Ramal
               cont-emit.ramal-fax    = msg0058.RamalFax
               cont-emit.telefax      = string(msg0058.Fax,'X(15)')
               cont-emit.telefone     = string(msg0058.Telefone,'X(15)')
               cont-emit.int-1        = 2 /*Contato NFE*/. 

        IF msg0058.Area = 993520000 THEN
             ASSIGN cont-emit.area = "Administrativa".
        ELSE IF msg0058.Area = 993520001 THEN
             ASSIGN cont-emit.area = "Assistˆncia T‚cnica".
        ELSE IF msg0058.Area = 993520002 THEN 
            ASSIGN cont-emit.area = "Comercial".
        ELSE IF msg0058.Area = 993520003 THEN 
            ASSIGN cont-emit.area = "Com‚rcio Exterior".
        ELSE IF msg0058.Area = 993520004 THEN 
            ASSIGN cont-emit.area = "Compras".
        ELSE IF msg0058.Area = 993520005 THEN 
            ASSIGN cont-emit.area = "Controladoria".
        ELSE IF msg0058.Area = 993520006 THEN 
            ASSIGN cont-emit.area = "Financeira".
        ELSE IF msg0058.Area = 993520007 THEN 
            ASSIGN cont-emit.area = "Inform tica".
        ELSE IF msg0058.Area = 993520010 THEN 
            ASSIGN cont-emit.area = "Log¡stica".
        ELSE IF msg0058.Area = 993520011 THEN 
            ASSIGN cont-emit.area = "Marketing" .
        ELSE IF msg0058.Area = 993520012 THEN 
            ASSIGN cont-emit.area = "P&D".
        ELSE IF msg0058.Area = 993520008 THEN 
            ASSIGN cont-emit.area = "Produ‡Æo".
        ELSE IF msg0058.Area = 993520009 THEN 
            ASSIGN cont-emit.area = "Qualidade".
        ELSE IF msg0058.Area = 993520013 THEN 
            ASSIGN cont-emit.area = "Recebimento".
        ELSE IF msg0058.Area = 993520015 THEN 
            ASSIGN cont-emit.area = "Relacionamento ao Cliente".
        ELSE 
            ASSIGN cont-emit.area = "A Classificar".

        IF l-log  THEN
           IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 5").

        IF msg0058.Cargo = 993520000 THEN 
            ASSIGN cont-emit.cargo = "Administrador".
        ELSE IF msg0058.Cargo = 993520001 THEN 
            ASSIGN cont-emit.cargo = "Analista".
        ELSE IF msg0058.Cargo = 993520002 THEN 
            ASSIGN cont-emit.cargo = "Assistente".
        ELSE IF msg0058.Cargo = 993520003 THEN 
            ASSIGN cont-emit.cargo = "Atendente".
        ELSE IF msg0058.Cargo = 993520004 THEN 
            ASSIGN cont-emit.cargo = "Auxiliar de Produ‡Æo".
        ELSE IF msg0058.Cargo = 993520005 THEN 
            ASSIGN cont-emit.cargo = "Comprador".
        ELSE IF msg0058.Cargo = 993520006 THEN 
            ASSIGN cont-emit.cargo = "Consultor".
        ELSE IF msg0058.Cargo = 993520007 THEN 
            ASSIGN cont-emit.cargo = "Contador".
        ELSE IF msg0058.Cargo = 993520008 THEN 
            ASSIGN cont-emit.cargo = "Coordenador".
        ELSE IF msg0058.Cargo = 993520009 THEN 
            ASSIGN cont-emit.cargo = "Diretor".
        ELSE IF msg0058.Cargo = 993520010 THEN 
            ASSIGN cont-emit.cargo = "Engenheiro".
        ELSE IF msg0058.Cargo = 993520011 THEN 
            ASSIGN cont-emit.cargo = "Gerente".
        ELSE IF msg0058.Cargo = 993520012 THEN 
            ASSIGN cont-emit.cargo = "Presidente".
        ELSE IF msg0058.Cargo = 993520013 THEN 
            ASSIGN cont-emit.cargo = "Pr‚ Venda".
        ELSE IF msg0058.Cargo = 993520014 THEN 
            ASSIGN cont-emit.cargo = "Promotor".
        ELSE IF msg0058.Cargo = 993520015 THEN 
            ASSIGN cont-emit.cargo = "Propriet rio / S¢cio".
        ELSE IF msg0058.Cargo = 993520016 THEN 
            ASSIGN cont-emit.cargo = "Representante".
        ELSE IF msg0058.Cargo = 993520017 THEN 
            ASSIGN cont-emit.cargo = "Secret ria".
        ELSE IF msg0058.Cargo = 993520018 THEN 
            ASSIGN cont-emit.cargo = "Supervisor".
        ELSE IF msg0058.Cargo = 993520019 THEN 
            ASSIGN cont-emit.cargo = "T‚cnico".
        ELSE IF msg0058.Cargo = 993520020 THEN 
            ASSIGN cont-emit.cargo = "Vendedor".
        ELSE IF msg0058.Cargo = 993520021 THEN 
            ASSIGN cont-emit.cargo = "Vice Presidente".
        ELSE 
            ASSIGN cont-emit.cargo = "A Classificar".
        
        IF l-log  THEN
           IF OPSYS = "UNIX" THEN log-manager:write-message("msg0058 6").
    END.
END.

IF  CAN-FIND (FIRST tt-erro) THEN DO:
    ASSIGN resultado.sucesso    = NO
           resultado.CodigoErro = 17006.
    ASSIGN resultado.Mensagem = "".
    FOR EACH tt-erro:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + ";".
    END.
END.
ELSE DO:
    ASSIGN msg0058r.CodigoContato     = msg0058.CodigoContato
           msg0058r.Proprietario      = msg0058.Proprietario
           msg0058r.TipoProprietario  = msg0058.TipoProprietario.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

RETURN.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

END PROCEDURE.
