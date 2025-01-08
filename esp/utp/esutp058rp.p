/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESUTP058RP 2.06.00.002}
/*------------------------------------------------------------------------
    File        : ESUTP058RP.P
    Purpose     : Exportaá∆o do Centro de Custo e do Aprovador do Centro
                  de Custo.
    Syntax      : <none>
    Description : <none>

    Author(s)   : Fabiano Sakae Ribeiro (Exponencial TI)
    Created     : Outubro de 2012
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Include Definitions ---                                              */

{esp/utp/esutp058.i} /* Definiá∆o das Temp-Tables */
{include/i-rpvar.i}
{utp/ut-glob.i}
{esp/es0018.i}

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE h-acomp       AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-estabelec   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cc-codigo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arquivo   LIKE tt-param.arquivo NO-UNDO.
DEFINE VARIABLE c-dir-origem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-dir-backup  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-arq-backup  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-destino AS CHARACTER   NO-UNDO
    FORMAT "x(15)"
    LABEL "Destino".

/* Stream Definitions ---                                               */

DEFINE STREAM str-rp.

DEFINE INPUT  PARAMETER raw-param AS RAW         NO-UNDO.
DEFINE INPUT  PARAMETER TABLE FOR tt-raw-digita.

/* ***************************  Main Block  *************************** */

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST param-global NO-LOCK NO-ERROR.

FIND FIRST empresa
    WHERE empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

ASSIGN c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ""
       c-titulo-relat = "Exportaá∆o de Centros de Custos"
       c-sistema      = "Espec°ficos Intelbras".

{include/i-rpc255.i &STREAM="str-rp"}
{include/i-rpout.i &STREAM="STREAM str-rp"}

VIEW STREAM str-rp FRAME f-cabec-255.
VIEW STREAM str-rp FRAME f-rodape-255.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp NO-ERROR.

RUN pi-inicializar IN h-acomp (INPUT "") NO-ERROR.
RUN pi-executar    IN THIS-PROCEDURE.
RUN pi-finalizar   IN h-acomp.

IF VALID-HANDLE(h-acomp) 
THEN
    DELETE PROCEDURE h-acomp.

ASSIGN h-acomp = ?.

{include/i-rpclo.i &STREAM="STREAM str-rp"}

RETURN "OK".

/* **********************  Internal Procedures  *********************** */

PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-dir AS CHARACTER   NO-UNDO.


    IF  tt-param.l-centro-custo = YES
    THEN DO:
        RUN pi-seta-titulo IN h-acomp (INPUT "Gerando arquivo Centro Custo...") NO-ERROR.
        RUN pi-acompanhar  IN h-acomp (INPUT "Gerando...") NO-ERROR.

        EMPTY TEMP-TABLE tt-integra-ccusto.

        FOR EACH  cc_uni_estab NO-LOCK
            WHERE cc_uni_estab.cod_ccusto >= tt-param.c-ccusto-ini
              AND cc_uni_estab.cod_ccusto <= tt-param.c-ccusto-fim
            BREAK BY cc_uni_estab.cod_ccusto
                  BY cc_uni_estab.cod_estab:

            RUN pi-acompanhar  IN h-acomp (INPUT "C.Custo.: " + cc_uni_estab.cod_ccusto) NO-ERROR.
        
            RUN esp/es0018p.p (INPUT "msg0178", /* Nome do programa  */
                               INPUT 1,         /* Ponto do programa */
                               INPUT 0,
                               INPUT "",
                               OUTPUT TABLE tt-prog-ponto) NO-ERROR.

            FIND FIRST tt-prog-ponto
                WHERE entry(1,tt-prog-ponto.conteudo,";") = cc_uni_estab.cod_estab NO-LOCK NO-ERROR.

            IF  AVAIL tt-prog-ponto THEN
                ASSIGN c-estabelec = entry(2,tt-prog-ponto.conteudo,";").
            ELSE
                NEXT.

            ASSIGN c-cc-codigo = CAPS(TRIM(cc_uni_estab.cod_unid_negoc)) + TRIM(cc_uni_estab.cod_ccusto).
        
            FOR FIRST emscad.ccusto NO-LOCK
                WHERE emscad.ccusto.cod_empresa      = i-ep-codigo-usuario
                  AND emscad.ccusto.cod_plano_ccusto = "padrao"
                  AND emscad.ccusto.cod_ccusto       = cc_uni_estab.cod_ccusto:
        
                IF NOT CAN-FIND(FIRST tt-integra-ccusto
                                WHERE tt-integra-ccusto.c-cod-ccusto = c-cc-codigo
                                  AND tt-integra-ccusto.c-cod-estab  = c-estabelec) 
                THEN DO:
                    CREATE tt-integra-ccusto.
                    ASSIGN tt-integra-ccusto.c-cod-estab  = c-estabelec
                           tt-integra-ccusto.c-cod-ccusto = c-cc-codigo
                           tt-integra-ccusto.c-nom-ccusto = TRIM(emscad.ccusto.des_tit_ctbl)
                           tt-integra-ccusto.c-ind-movto  = tt-param.c-ind-movto.

                    IF  cc_uni_estab.log_movta_desp_viagem = NO OR 
                        emscad.ccusto.dat_fim_valid          < TODAY 
                    THEN
                        ASSIGN tt-integra-ccusto.c-ind-movto = "E". /* Eliminaá∆o */
                END.
            END. /* FOR FIRST emscad.ccusto NO-LOCK */
        END. /* FOR EACH  cc_uni_estab NO-LOCK */

        IF CAN-FIND(FIRST tt-integra-ccusto)
        THEN DO:
            FOR EACH tt-integra-ccusto NO-LOCK:
                EMPTY TEMP-TABLE tt-tmp-integra-ccusto.
                CREATE tt-tmp-integra-ccusto.
                BUFFER-COPY tt-integra-ccusto TO tt-tmp-integra-ccusto.
                RUN esp/esb/out/msg0178.p (INPUT TABLE tt-tmp-integra-ccusto). /* Integrar com Barramento */
            END.
        END.
    END. /* IF  tt-param.l-centro-custo = YES */


/*     IF  tt-param.l-colaboradores = YES                                                                                                                       */
/*     THEN DO:                                                                                                                                                 */
/*         RUN pi-seta-titulo IN h-acomp (INPUT "Localizando diret¢rio parametrizado...") NO-ERROR.                                                             */
/*                                                                                                                                                              */
/*         RUN pi-acompanhar IN h-acomp (INPUT "Localizando...") NO-ERROR.                                                                                      */
/*                                                                                                                                                              */
/*         ASSIGN c-dir-origem = ""                                                                                                                             */
/*                c-dir-backup = "".                                                                                                                            */
/*                                                                                                                                                              */
/*         FOR FIRST ponto-programa NO-LOCK                                                                                                                     */
/*             WHERE ponto-programa.nome-programa = "esutp058":U                                                                                                */
/*               AND ponto-programa.ponto         = 1,                                                                                                          */
/*             EACH conteudo-programa NO-LOCK                                                                                                                   */
/*             WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:                                                                              */
/*                                                                                                                                                              */
/*             IF conteudo-programa.conteudo                    <> "":U AND                                                                                     */
/*                NUM-ENTRIES(conteudo-programa.conteudo, ";":U) > 1    THEN DO:                                                                                */
/*                                                                                                                                                              */
/*                 /* Diret¢rio no sistema operacional WIN32 */                                                                                                 */
/*                 IF OPSYS = "WIN32":U THEN DO:                                                                                                                */
/*                     IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "SAIDAALATURWIN32":U THEN                                                               */
/*                         ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";":U).                                                                   */
/*                     IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "BACKUPALATURWIN32":U THEN                                                              */
/*                         ASSIGN c-dir-backup = ENTRY(2, conteudo-programa.conteudo, ";":U).                                                                   */
/*                 END.                                                                                                                                         */
/*                 /* Diret¢rio no sistema operacional UNIX */                                                                                                  */
/*                 ELSE DO:                                                                                                                                     */
/*                     IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "SAIDAALATURUNIX":U THEN                                                                */
/*                         ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";":U).                                                                   */
/*                     IF ENTRY(1, conteudo-programa.conteudo, ";":U) = "BACKUPALATURUNIX":U THEN                                                               */
/*                         ASSIGN c-dir-backup = ENTRY(2, conteudo-programa.conteudo, ";":U).                                                                   */
/*                 END.                                                                                                                                         */
/*             END.                                                                                                                                             */
/*         END.                                                                                                                                                 */
/*                                                                                                                                                              */
/*         IF  i-num-ped-exec-rpw <> 0                                                                                                                          */
/*         THEN DO:                                                                                                                                             */
/*             IF  c-dir-origem = ""  OR                                                                                                                        */
/*                 c-dir-backup = ""                                                                                                                            */
/*             THEN DO:                                                                                                                                         */
/*                 PUT STREAM str-rp UNFORMATTED "Diret¢rio UNIX n∆o encontrado no Conte£do do Ponto do Programa! (Nome Programa: esutp058, Ponto: 1)" SKIP.    */
/*                 RETURN "NOK".                                                                                                                                */
/*             END.                                                                                                                                             */
/*         END.                                                                                                                                                 */
/*         ELSE DO:                                                                                                                                             */
/*             IF  c-dir-origem = ""  OR                                                                                                                        */
/*                 c-dir-backup = ""                                                                                                                            */
/*             THEN DO:                                                                                                                                         */
/*                 PUT STREAM str-rp UNFORMATTED "Diret¢rio WINDOWS n∆o encontrado no Conte£do do Ponto do Programa! (Nome Programa: esutp058, Ponto: 1)" SKIP. */
/*                 RETURN "NOK".                                                                                                                                */
/*             END.                                                                                                                                             */
/*         END.                                                                                                                                                 */
/*                                                                                                                                                              */
/*         FILE-INFO:FILE-NAME = c-dir-origem.                                                                                                                  */
/*                                                                                                                                                              */
/*         IF FILE-INFO:FULL-PATHNAME           = "" OR                                                                                                         */
/*            FILE-INFO:FULL-PATHNAME           = ?  OR                                                                                                         */
/*            INDEX(FILE-INFO:FILE-TYPE, "D")   = 0                                                                                                             */
/*         THEN DO:                                                                                                                                             */
/*             PUT STREAM str-rp UNFORMATTED "Diret¢rio " + c-dir-origem + " inv†lido!" SKIP.                                                                   */
/*             RETURN "NOK".                                                                                                                                    */
/*         END.                                                                                                                                                 */
/*                                                                                                                                                              */
/*         FILE-INFO:FILE-NAME = c-dir-backup.                                                                                                                  */
/*                                                                                                                                                              */
/*         IF FILE-INFO:FULL-PATHNAME           = "" OR                                                                                                         */
/*            FILE-INFO:FULL-PATHNAME           = ?  OR                                                                                                         */
/*            INDEX(FILE-INFO:FILE-TYPE, "D")   = 0                                                                                                             */
/*         THEN DO:                                                                                                                                             */
/*             PUT STREAM str-rp UNFORMATTED "Diret¢rio " + c-dir-backup + " inv†lido!" SKIP.                                                                   */
/*             RETURN "NOK".                                                                                                                                    */
/*         END.                                                                                                                                                 */
/*                                                                                                                                                              */
/*                                                                                                                                                              */
/*         EMPTY TEMP-TABLE tt-arquivos-colab.                                                                                                                  */
/*         EMPTY TEMP-TABLE tt-integra-colab.                                                                                                                   */
/*                                                                                                                                                              */
/*         INPUT FROM OS-DIR(c-dir-origem) NO-ECHO.                                                                                                             */
/*         REPEAT:                                                                                                                                              */
/*             CREATE tt-arquivos-colab.                                                                                                                        */
/*             IMPORT tt-arquivos-colab.nom-arquivo                                                                                                             */
/*                    tt-arquivos-colab.nom-completo                                                                                                            */
/*                    tt-arquivos-colab.ind-tipo-arquivo.                                                                                                       */
/*                                                                                                                                                              */
/*             IF  INDEX(tt-arquivos-colab.nom-arquivo,".txt")  = 0   OR                                                                                        */
/*                       tt-arquivos-colab.ind-tipo-arquivo    <> "F" OR                                                                                        */
/*                       tt-arquivos-colab.nom-completo         = ""  OR                                                                                        */
/*                       tt-arquivos-colab.nom-completo         = " " OR                                                                                        */
/*                       tt-arquivos-colab.nom-completo         = ?                                                                                             */
/*             THEN                                                                                                                                             */
/*                 DELETE tt-arquivos-colab.                                                                                                                    */
/*         END.                                                                                                                                                 */
/*                                                                                                                                                              */
/*         IF CAN-FIND(FIRST tt-arquivos-colab)                                                                                                                 */
/*         THEN                                                                                                                                                 */
/*             RUN pi-importa-arq-colab.                                                                                                                        */
/*                                                                                                                                                              */
/*         IF CAN-FIND(FIRST tt-integra-colab)                                                                                                                  */
/*         THEN DO:                                                                                                                                             */
/*             FOR EACH tt-integra-colab NO-LOCK:                                                                                                               */
/*                 EMPTY TEMP-TABLE tt-tmp-integra-colab.                                                                                                       */
/*                 CREATE tt-tmp-integra-colab.                                                                                                                 */
/*                 BUFFER-COPY tt-integra-colab TO tt-tmp-integra-colab.                                                                                        */
/*                 RUN esp/esb/out/msg0178-colab.p (INPUT TABLE tt-tmp-integra-colab). /* Integrar com Barramento */                                            */
/*             END.                                                                                                                                             */
/*         END.                                                                                                                                                 */
/*                                                                                                                                                              */
/*         FOR EACH tt-arquivos-colab                                                                                                                           */
/*             BREAK BY tt-arquivos-colab.nom-arquivo:                                                                                                          */
/*                                                                                                                                                              */
/*             IF  SEARCH(tt-arquivos-colab.nom-completo) = ?                                                                                                   */
/*             THEN                                                                                                                                             */
/*                 NEXT.                                                                                                                                        */
/*                                                                                                                                                              */
/*             ASSIGN c-arq-backup = c-dir-backup + tt-arquivos-colab.nom-arquivo.                                                                              */
/*                                                                                                                                                              */
/*             OS-COPY   VALUE(tt-arquivos-colab.nom-completo) VALUE(c-arq-backup).                                                                             */
/*             OS-DELETE VALUE(tt-arquivos-colab.nom-completo).                                                                                                 */
/*         END.                                                                                                                                                 */
/*     END. /* IF  tt-param.l-colaboradores = YES */                                                                                                            */

    RETURN "OK".

END PROCEDURE.


PROCEDURE pi-importa-arq-colab:

    DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.

    FOR EACH tt-arquivos-colab
        BREAK BY tt-arquivos-colab.nom-arquivo:

        IF  tt-arquivos-colab.nom-completo = ""  OR
            tt-arquivos-colab.nom-completo = " " OR
            tt-arquivos-colab.nom-completo = ?
        THEN
            DELETE tt-arquivos-colab.

        IF  SEARCH(tt-arquivos-colab.nom-completo) = ?
        THEN
            NEXT.

        INPUT FROM VALUE(tt-arquivos-colab.nom-completo).

        REPEAT:
            IMPORT UNFORMATTED c-linha.

            IF  NUM-ENTRIES(c-linha,";") >= 20
            THEN DO:
                CREATE tt-integra-colab.
                ASSIGN tt-integra-colab.NomeEmpresa          =     ENTRY(01,c-linha,";")
                       tt-integra-colab.NomeEmpresaCCusto    =     ENTRY(02,c-linha,";")
                       tt-integra-colab.Matricula            =     ENTRY(03,c-linha,";")
                       tt-integra-colab.NomeCompleto         =     ENTRY(04,c-linha,";")
                       tt-integra-colab.Cargo                =     ENTRY(05,c-linha,";")
                       tt-integra-colab.Departamento         =     ENTRY(06,c-linha,";")
                       tt-integra-colab.CCusto               =     ENTRY(07,c-linha,";")
                       tt-integra-colab.E-mail               =     ENTRY(08,c-linha,";")
                       tt-integra-colab.E-mailAlternativo    =     ENTRY(09,c-linha,";")
                       tt-integra-colab.DataNascimento       = INT(ENTRY(10,c-linha,";"))
                       tt-integra-colab.Sexo                 = INT(ENTRY(11,c-linha,";"))
                       tt-integra-colab.LoginAlatur          =     ENTRY(12,c-linha,";")
                       tt-integra-colab.Telefone             =     ENTRY(13,c-linha,";")
                       tt-integra-colab.Endereco             =     ENTRY(14,c-linha,";")
                       tt-integra-colab.Cidade               =     ENTRY(15,c-linha,";")
                       tt-integra-colab.Estado               =     ENTRY(16,c-linha,";")
                       tt-integra-colab.CEP                  =     ENTRY(17,c-linha,";")
                       tt-integra-colab.CPF                  =     ENTRY(18,c-linha,";")
                       tt-integra-colab.RG                   =     ENTRY(19,c-linha,";")
                       tt-integra-colab.Tercerizado          = INT(ENTRY(20,c-linha,";")).
            END.
        END.
        INPUT CLOSE.
    END.
END PROCEDURE.
