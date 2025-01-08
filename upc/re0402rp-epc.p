/***********************************************************************
**  Programa..: upc\re0402-epc.p
**  Autor.....: Osnir
**  Data......: 21/09/2007
**  Descricao.: 
**  Versão....: 
**              Desenvolvimento Programa
************************************************************************/

{include/i-epc200.i1}
{utp/ut-glob.i}

{esp/es0018.i}
def input param p-ind-event as char no-undo.
def input-output param table for tt-epc.

DEFINE TEMP-TABLE TT_File NO-UNDO 
    FIELD FILENAME   AS CHARACTER
    FIELD FullPath   AS CHARACTER
    FIELD FILE       AS CHARACTER
    FIELD lImportado AS LOGICAL.

DEFINE VARIABLE i-time   AS INTEGER     NO-UNDO.
DEFINE VARIABLE cCampo1  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo2  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo3  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo4  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo5  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCampo6  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-achou-usuario AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-arquivo-cancelamento AS CHARACTER   NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE      NO-UNDO.
DEFINE VARIABLE l-erro AS LOGICAL     NO-UNDO.

DEFINE VARIABLE r-rowid-docum-est AS ROWID       NO-UNDO.
DEFINE VARIABLE l-permissao AS LOGICAL     NO-UNDO.


case p-ind-event:
    WHEN "NAO-DESATUALIZA" THEN DO:
        for each tt-epc no-lock
            where tt-epc.cod-event = p-ind-event 
              AND tt-epc.cod-parameter = "ROWID-DOCUM-EST": 

            find docum-est 
                 where rowid(docum-est) = to-rowid(tt-epc.val-parameter) no-lock no-error.
            if   not avail docum-est then 
                 next.

            FIND FIRST nota-fiscal NO-LOCK
                 WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                   AND nota-fiscal.serie       = docum-est.serie-docto
                   AND nota-fiscal.nr-nota-fis = docum-est.nro-docto
                   AND nota-fiscal.cod-emitente = docum-est.cod-emitente
                   AND nota-fiscal.nat-operacao = docum-est.nat-operacao NO-ERROR.
            ASSIGN l-achou-usuario = NO.
            IF AVAIL nota-fiscal  THEN DO:

                for each ponto-programa
                     where ponto-programa.nome-programa = "ft2200"
                       AND ponto-programa.ponto         = 2,
                      EACH conteudo-programa NO-LOCK
                     WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

                    IF conteudo-programa.conteudo = v_cod_usuar_corren THEN DO:
                       ASSIGN l-achou-usuario = YES.
                    END.
                END.
                IF l-achou-usuario = NO THEN DO:
                    FIND FIRST natur-oper NO-LOCK
                        WHERE  natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-ERROR.

                   find first estabelec 
                         where estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK no-error.

                     IF AVAIL nota-fiscal        and
                        AVAIL natur-oper         and
                        natur-oper.imp-nota      AND
                        AVAIL estabelec          AND
                        estabelec.estado <> "MG" AND
                         (TODAY - docum-est.dt-atualiza > 1 OR
                         (TODAY - docum-est.dt-atualiza = 1 and
                          docum-est.hr-atual < string(TIME,"HH:MM:SS"))) THEN DO:
                        PUT "" SKIP.
                        PUT "ATENCAO - >>>>>>> Nota fiscal " nota-fiscal.nr-nota-fis " emitida a mais de 1 dia n’o pode ser cancelada. " nota-fiscal.dt-emis-nota " " nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-emitente  " " nota-fiscal.nat-operacao SKIP.
                        PUT "" SKIP.
                        RETURN 'NOK'.
                     END.
                END.

            END.

            ASSIGN l-permissao = NO.
            EMPTY TEMP-TABLE tt-prog-ponto.
    
            RUN esp/es0018p.p (INPUT "re0402":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            FOR EACH tt-prog-ponto:
               FIND FIRST usuar_grp_usuar NO-LOCK
                    WHERE usuar_grp_usuar.cod_grp_usuar = tt-prog-ponto.conteudo
                      AND usuar_grp_usuar.cod_usuar     = c-seg-usuario NO-ERROR.
               IF AVAIL usuar_grp_usuar THEN DO:
                  ASSIGN l-permissao = YES.
               END.
            END.
            IF l-permissao = NO THEN DO:
               IF (TODAY - docum-est.dt-trans) > 7 THEN DO:
                   PUT "" SKIP.
                   PUT "ATENCAO - >>>>>>> Nota fiscal de entrada " docum-est.nro-docto " atualizada a mais de 7 dias nao pode ser desatualizada. Favor entrar em contato com os usuarios do Fiscal Avan‡ado. ( Docto: " docum-est.nro-docto " Serie: " docum-est.serie-docto " Emitente: " STRING(docum-est.cod-emitente) " Natureza: " docum-est.nat-operacao  SKIP.
                   PUT "" SKIP.
                   RETURN 'NOK'.
               END.
            END.

        END.
    END.
    when "fim-atualizacao" then do:
        for each tt-epc no-lock
            where tt-epc.cod-event = p-ind-event : 

            find docum-est 
                 where rowid(docum-est) = to-rowid(tt-epc.val-parameter) no-lock no-error.
            if   not avail docum-est then 
                 next.
            FOR EACH item-doc-est OF docum-est NO-LOCK:

                 IF item-doc-est.nro-comp   <> "" AND
                    item-doc-est.serie-comp <> "" THEN DO:
                     FIND nota-fiscal
                          WHERE nota-fiscal.cod-estabel = docum-est.cod-estabel
                            AND nota-fiscal.serie       = item-doc-est.serie-comp
                            AND nota-fiscal.nr-nota-fis = item-doc-est.nro-comp
                         NO-LOCK NO-ERROR.

                     IF AVAIL nota-fiscal THEN DO:
                        FOR EACH comissao-fat
                            where comissao-fat.cod-estabel    = nota-fiscal.cod-estabel
                              AND comissao-fat.serie          = nota-fiscal.serie
                              AND comissao-fat.nr-nota-fis    = docum-est.nro-docto
                              AND comissao-fat.cod-emitente   = docum-est.cod-emitente
                              AND comissao-fat.id-tipo-inform = 2 EXCLUSIVE-LOCK:
                            DELETE comissao-fat.
                        END.
                     END.
                 END.
            end.  
            
            FIND FIRST int_solic_transf
                WHERE int_solic_transf.serie_transf    = docum-est.serie-docto
                AND   int_solic_transf.nr_nota_transf  = docum-est.nro-docto
                AND   int_solic_transf.emitente_transf = docum-est.cod-emitente
                AND   int_solic_transf.nat_oper_transf = docum-est.nat-operacao
                AND   int_solic_transf.ind_aprovac     = "Pendente" EXCLUSIVE-LOCK NO-ERROR.

            IF  AVAIL int_solic_transf THEN
                DELETE int_solic_transf.
        end.    
    end.

end case.



return "OK":U.



