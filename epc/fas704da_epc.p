/*****************************************************************************
** Programa..............: fas704da_epc.p
** Descricao.............: EPC do programa isl_bem_pat_calculo
** Criado em.............: 15/09/2009
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF BUFFER b_movto_cta_corren FOR movto_cta_corren.
DEF BUFFER b_cta_corren_orig  FOR cta_corren.
DEF BUFFER b_cta_corren_dest  FOR cta_corren.

DEF VAR h_fas704da_epc_1 AS WIDGET-HANDLE NO-UNDO.
DEF VAR h_object         AS WIDGET-HANDLE NO-UNDO.
DEF VAR v_cod_cta_dest   AS CHAR          NO-UNDO.

{esinc\es0000.i}

DEF NEW GLOBAL SHARED VAR h_ind_dwb_fas704da    AS WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cenar_fas704da      AS WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_desc_cenar_fas704da AS WIDGET-HANDLE  NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_zoo_cenar_fas704da  AS WIDGET-HANDLE  NO-UNDO.

DEF TEMP-TABLE tt-prog-ponto NO-UNDO
    FIELD nome-programa    LIKE ponto-programa.nome-programa
    FIELD ponto            LIKE ponto-programa.ponto
    FIELD sequencia        LIKE conteudo-programa.sequencia 
    FIELD conteudo         LIKE conteudo-programa.conteudo
    INDEX seq-campo nome-programa ponto sequencia.


IF  p_ind_event = "INITIALIZE" THEN DO:
    RUN epc/fas704da_epc_01.p PERSISTENT SET h_fas704da_epc_1(INPUT p_ind_event,
                                                              INPUT p_ind_object,
                                                              INPUT p_wgh_object,
                                                              INPUT p_wgh_frame,
                                                              INPUT p_cod_table,
                                                              INPUT p_rec_table).

    ASSIGN h_object           = p_wgh_frame:FIRST-CHILD
           h_object           = h_object:FIRST-CHILD 
           h_ind_dwb_fas704da = ?.

    DO WHILE VALID-HANDLE(h_object):
        IF  h_object:TYPE <> "field_group" THEN DO:
            IF  h_object:NAME = "ind_dwb_set_type" THEN 
                ASSIGN h_ind_dwb_fas704da = h_object.
        
            ASSIGN h_object = h_object:NEXT-SIBLING.
        END.
        ELSE 
            ASSIGN h_object = h_object:FIRST-CHILD.
       
        IF  VALID-HANDLE(h_ind_dwb_fas704da) THEN 
            LEAVE.
    END.

    IF  VALID-HANDLE(h_ind_dwb_fas704da) THEN
        ON "VALUE-CHANGED" OF h_ind_dwb_fas704da PERSISTENT RUN pi_trata_cenario IN h_fas704da_epc_1 .

END.

IF p_ind_event = 'DISPLAY' THEN DO:

    /* Usu rios com permissao pra informar o cen rio */
    RUN esp\es0018p.p (INPUT "cenar_ctbl",
                       INPUT 1,
                       INPUT 0,
                       INPUT "",
                       OUTPUT TABLE tt-prog-ponto) NO-ERROR.

    FIND tt-prog-ponto WHERE 
         tt-prog-ponto.conteudo = v_cod_usuar_corren NO-ERROR.

    IF  NOT AVAIL tt-prog-ponto THEN DO:
    
         /* Localizar o cen rio */
         ASSIGN h_object = p_wgh_frame:FIRST-CHILD
                h_object = h_object:FIRST-CHILD 
                h_cenar_fas704da  = ?.

         DO WHILE VALID-HANDLE(h_object):
            IF h_object:TYPE <> "field_group" THEN DO:
                 IF  h_object:NAME = "cod_cenar_ctbl" THEN 
                     ASSIGN h_cenar_fas704da = h_object.
                 
                 ASSIGN h_object = h_object:NEXT-SIBLING.
             END.
             ELSE 
                 ASSIGN h_object = h_object:FIRST-CHILD.
             
             IF  VALID-HANDLE(h_cenar_fas704da) THEN 
                 LEAVE.
         END.
         ASSIGN h_cenar_fas704da:SCREEN-VALUE = "".
         ASSIGN h_cenar_fas704da:SENSITIVE = NO.
    
         /* Localizar a descri‡Æo do cen rio */
         ASSIGN h_object               = p_wgh_frame:FIRST-CHILD
                h_object               = h_object:FIRST-CHILD 
                h_desc_cenar_fas704da  = ?.
         
         DO WHILE VALID-HANDLE(h_object):
            IF h_object:TYPE <> "field_group" THEN DO:
                 IF  h_object:NAME = "des_cenar_ctbl" THEN 
                     ASSIGN h_desc_cenar_fas704da = h_object.
                 
                 ASSIGN h_object = h_object:NEXT-SIBLING.
             END.
             ELSE 
                 ASSIGN h_object = h_object:FIRST-CHILD.
             
             IF  VALID-HANDLE(h_desc_cenar_fas704da) THEN 
                 LEAVE.
         END.
         ASSIGN h_desc_cenar_fas704da:SCREEN-VALUE = "".
    
         /* Localizar o zoom do cen rio */
         ASSIGN h_object              = p_wgh_frame:FIRST-CHILD
                h_object              = h_object:FIRST-CHILD 
                h_zoo_cenar_fas704da  = ?.

         DO WHILE VALID-HANDLE(h_object):
            IF h_object:TYPE <> "field_group" THEN DO:
                 IF  h_object:NAME = "bt_zoo_54621" THEN 
                     ASSIGN h_zoo_cenar_fas704da = h_object.
                 
                 ASSIGN h_object = h_object:NEXT-SIBLING.
             END.
             ELSE 
                 ASSIGN h_object = h_object:FIRST-CHILD.

             IF  VALID-HANDLE(h_zoo_cenar_fas704da) THEN 
                 LEAVE.
         END.
         ASSIGN h_zoo_cenar_fas704da:SENSITIVE = NO.
    END.

END.
RETURN "OK".
