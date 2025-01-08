/*****************************************************************************
** Programa..............: fas705ca_epc_01.p
** Descricao.............: EPC do programa isl_bem_pat_ctbz para tratar
** Criado em.............: 24/08/2018
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF VAR h_object       AS WIDGET-HANDLE  NO-UNDO.
DEF VAR v_cod_cta_dest AS CHAR           NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_ind_dwb_set_type AS WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cenar            AS WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_zoo_225773       AS WIDGET-HANDLE  NO-UNDO.

{esinc\es0000.i}

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


PROCEDURE pi_trata_cenario:
    IF  VALID-HANDLE(h_ind_dwb_set_type) THEN DO:
        /* Usu rios com permissao pra informar o cen rio */
        RUN esp\es0018p.p (INPUT "cenar_ctbl",
                           INPUT 1,
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto) NO-ERROR.

        FIND tt-prog-ponto WHERE 
             tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.

        IF  NOT AVAIL tt-prog-ponto THEN DO:

            IF  VALID-HANDLE(h_cenar) THEN
                ASSIGN h_cenar:SENSITIVE    = NO
                       h_cenar:SCREEN-VALUE = "".

            IF  VALID-HANDLE(h_zoo_225773) THEN
                ASSIGN h_zoo_225773:SENSITIVE      = NO.
        END.
    END.
END PROCEDURE.
