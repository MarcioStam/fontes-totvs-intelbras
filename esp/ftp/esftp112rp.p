/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Programa.: esp/ftp/esftp112rp.p
**  Objetivo.: Combina‡Æo dos programas FT0910 e ESFTP069.
**  Cria‡Æo..: 02/06/2010
**
*******************************************************************************/
{include/i-prgvrs.i ESFTP112 2.04.00.000}
{utp/ut-glob.i}
{esp/ftp/esftp112.i} /* Defini‡Æo das temp-tables tt-param e tt-raw-digita */
    def temp-table tt-raw-digita NO-UNDO
        field raw-digita   as raw.

define temp-table tt-ft2100 NO-UNDO
    field destino           as integer  
    field arquivo           as char
    field usuario           as char
    field data-exec         as date
    field hora-exec         as integer
    field tipo-atual        as integer   /* 1 - Atualiza, 2 - Desatualiza */
    field c-desc-tipo-atual as char format "x(15)"
    field da-emissao-ini    as date format "99/99/9999"
    field da-emissao-fim    as date format "99/99/9999"
    field da-saida          as date format "99/99/9999"
    field da-vencto-ipi     as date format "99/99/9999"
    field da-vencto-icms    as date format "99/99/9999"
    field da-vencto-iss     as date format "99/99/9999"
    field c-estabel-ini     as char
    field c-estabel-fim     as char
    field c-serie-ini       as char
    field c-serie-fim       as char
    field c-nr-nota-ini     as char
    field c-nr-nota-fim     as char
    field i-embarque-ini    as DEC
    field i-embarque-fim    as DEC
    field c-preparador      as char
    field l-disp-men        as log
    field l-b2b             as log
    FIELD log-1             AS LOG.

DEFINE VARIABLE c-linha  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont   AS INTEGER     NO-UNDO.
def var h-acomp          as handle no-undo.
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF tt-param.c-arquivo-import <> "" THEN DO:
    run utp/ut-acomp.p persistent set h-acomp.  
    RUN pi-inicializar in h-acomp (input "Imprimindo...").
    INPUT FROM VALUE(tt-param.c-arquivo-import) NO-ECHO.
    REPEAT:
        IMPORT c-linha.
        ASSIGN i-cont = i-cont + 1.
        RUN pi-acompanhar IN h-acomp (INPUT "Importando linha " + STRING(i-cont)).

        FIND nota-fiscal
            WHERE nota-fiscal.cod-estabel = string(ENTRY(1, c-linha, ";"))
              AND nota-fiscal.serie       = string(ENTRY(2, c-linha, ";"))
              AND nota-fiscal.nr-nota-fis = string(int(ENTRY(3, c-linha, ";")),"9999999")
            NO-LOCK NO-ERROR.
        IF AVAIL nota-fiscal THEN DO:
           create   tt-ft2100.
           assign   tt-ft2100.destino           = 2
                    tt-ft2100.arquivo           = tt-param.arquivo
                    tt-ft2100.usuario           = c-seg-usuario
                    tt-ft2100.data-exec         = today
                    tt-ft2100.hora-exec         = time
                    tt-ft2100.tipo-atual        = tt-param.tipo-atual
                    tt-ft2100.c-desc-tipo-atual = IF tt-param.tipo-atual = 1 THEN "Atualiza" ELSE "Desatualiza"
                    tt-ft2100.da-emissao-ini    = nota-fiscal.dt-emis-nota
                    tt-ft2100.da-emissao-fim    = nota-fiscal.dt-emis-nota
                    tt-ft2100.da-saida          = ?
                    tt-ft2100.da-vencto-ipi     = today
                    tt-ft2100.da-vencto-icms    = today
                    tt-ft2100.da-vencto-iss     = today
                    tt-ft2100.c-estabel-ini     = nota-fiscal.cod-estabel
                    tt-ft2100.c-estabel-fim     = nota-fiscal.cod-estabel
                    tt-ft2100.c-serie-ini       = nota-fiscal.serie
                    tt-ft2100.c-serie-fim       = nota-fiscal.serie
                    tt-ft2100.c-nr-nota-ini     = nota-fiscal.nr-nota-fis
                    tt-ft2100.c-nr-nota-fim     = nota-fiscal.nr-nota-fis
                    tt-ft2100.i-embarque-ini    = nota-fiscal.cdd-embarq
                    tt-ft2100.i-embarque-fim    = nota-fiscal.cdd-embarq
                    tt-ft2100.c-preparador      = ""
                    tt-ft2100.l-disp-men        = no
                    tt-ft2100.l-b2b             = no
                    tt-ft2100.log-1             = NO.
                                                                                
            RUN chama_ft2100.
        END.
    END.
    INPUT CLOSE.
    RUN pi-finalizar in h-acomp.
END.
ELSE DO:
/*             MESSAGE tt-param.usuario                      SKIP                                                                             */
/*                 tt-param.destino                      SKIP                                                                                 */
/*                 tt-param.tipo-atual                   SKIP                                                                                 */
/*                 tt-param.c-desc-tipo-atua                  SKIP                                                                            */
/*                 tt-param.da-emissao-ini                              SKIP                                                                  */
/*                 tt-param.da-emissao-fim                                   SKIP                                                             */
/*                 tt-param.da-saida                                              SKIP                                                        */
/*                 tt-param.da-vencto-icms                                             SKIP                                                   */
/*                 tt-param.da-vencto-ipi                                                   SKIP                                              */
/*                 tt-param.da-vencto-iss                                                        SKIP                                         */
/*                 tt-param.c-estabel-ini                                                             SKIP                                    */
/*                 tt-param.c-estabel-fim                                                                  SKIP                               */
/*                 tt-param.c-serie-ini                                                                         SKIP                          */
/*                 tt-param.c-serie-fim                                                                              SKIP                     */
/*                 tt-param.c-nr-nota-ini                                                                                 SKIP                */
/*                 tt-param.c-nr-nota-fim                                                                                      SKIP           */
/*                 tt-param.de-embarque-ini                                                                                         SKIP      */
/*                 tt-param.de-embarque-fim                                                                                              SKIP */
/*                 tt-param.c-preparador     SKIP                                                                                             */
/*                 tt-param.c-arquivo-import      SKIP                                                                                        */
/*                 tt-param.l-disp-men                 SKIP                                                                                   */
/*                                                                                                                                            */
/*                                                                                                                                            */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                                                             */
       create   tt-ft2100.
       assign   tt-ft2100.destino           = 2
                tt-ft2100.arquivo           = tt-param.arquivo
                tt-ft2100.usuario           = c-seg-usuario
                tt-ft2100.data-exec         = today
                tt-ft2100.hora-exec         = time
                tt-ft2100.tipo-atual        = tt-param.tipo-atual
                tt-ft2100.c-desc-tipo-atual = IF tt-param.tipo-atual = 1 THEN "Atualiza" ELSE "Desatualiza"
                tt-ft2100.da-emissao-ini    = tt-param.da-emissao-ini
                tt-ft2100.da-emissao-fim    = tt-param.da-emissao-fim
                tt-ft2100.da-saida          = tt-param.da-saida
                tt-ft2100.da-vencto-ipi     = tt-param.da-vencto-ipi   
                tt-ft2100.da-vencto-icms    = tt-param.da-vencto-icms  
                tt-ft2100.da-vencto-iss     = tt-param.da-vencto-iss   
                tt-ft2100.c-estabel-ini     = tt-param.c-estabel-ini   
                tt-ft2100.c-estabel-fim     = tt-param.c-estabel-fim   
                tt-ft2100.c-serie-ini       = tt-param.c-serie-ini     
                tt-ft2100.c-serie-fim       = tt-param.c-serie-fim     
                tt-ft2100.c-nr-nota-ini     = tt-param.c-nr-nota-ini   
                tt-ft2100.c-nr-nota-fim     = tt-param.c-nr-nota-fim   
                tt-ft2100.i-embarque-ini    = tt-param.de-embarque-ini  
                tt-ft2100.i-embarque-fim    = tt-param.de-embarque-fim  
                tt-ft2100.c-preparador      = tt-param.c-preparador    
                tt-ft2100.l-disp-men        = tt-param.l-disp-men      
                tt-ft2100.l-b2b             = tt-param.l-b2b           
                tt-ft2100.log-1             = tt-param.log-1.           
        RUN chama_ft2100.

END.


PROCEDURE chama_ft2100.
/*     MESSAGE  tt-ft2100.destino              SKIP                                              */
/*              tt-ft2100.arquivo              SKIP                                              */
/*              tt-ft2100.usuario               SKIP                                             */
/*              tt-ft2100.data-exec              SKIP                                            */
/*              tt-ft2100.hora-exec                SKIP                                          */
/*              tt-ft2100.tipo-atual                     SKIP                                    */
/*              tt-ft2100.c-desc-tipo-atual                    SKIP                              */
/*              tt-ft2100.da-emissao-ini                             SKIP                        */
/*              tt-ft2100.da-emissao-fim                                   SKIP                  */
/*              tt-ft2100.da-saida                                                               */
/*              tt-ft2100.da-vencto-ipi              SKIP                                        */
/*              tt-ft2100.da-vencto-icms                   SKIP                                  */
/*              tt-ft2100.da-vencto-iss                          SKIP                            */
/*              tt-ft2100.c-estabel-ini                                SKIP                      */
/*              tt-ft2100.c-estabel-fim                                      SKIP                */
/*              tt-ft2100.c-serie-ini                                              SKIP          */
/*              tt-ft2100.c-serie-fim                   SKIP                                     */
/*              tt-ft2100.c-nr-nota-ini                       SKIP                               */
/*              tt-ft2100.c-nr-nota-fim                             SKIP                         */
/*              tt-ft2100.i-embarque-ini                                  SKIP                   */
/*              tt-ft2100.i-embarque-fim                                        SKIP             */
/*              tt-ft2100.c-preparador                                                SKIP       */
/*              tt-ft2100.l-disp-men                                                        SKIP */
/*              tt-ft2100.l-b2b              SKIP                                                */
/*              tt-ft2100.log-1                    SKIP                                          */
/*                                                                                               */
/*                                                                                               */
/*                                                                                               */
/*                                                                                               */
/*                                                                                               */
/*         VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */

        raw-transfer tt-ft2100 to raw-param.
        run ftp/ft2100rp.p (input raw-param,
                            input table tt-raw-digita).
        {include/i-rpexc.i}
END PROCEDURE.

RETURN "OK":U.





