/*****************************************************************************
** Programa..............: fas701cada_epc.p
** Descricao.............: EPC do programa add_bem_pat e mod_bem_pat
** Criado em.............: 28/01/2016
*****************************************************************************/

DEF INPUT PARAM p_ind_event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_ind_object AS CHAR          NO-UNDO.
DEF INPUT PARAM p_wgh_object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p_wgh_frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p_cod_table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p_rec_table  AS RECID         NO-UNDO.

DEF NEW GLOBAL SHARED VAR h_cod_portad    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR h_cod_cart      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR text_cod_portad AS WIDGET-HANDLE NO-UNDO.

/*
MESSAGE "p_ind_event "  p_ind_event  skip
        "p_ind_object " p_ind_object skip
        "p_wgh_object " p_wgh_object skip
        "p_wgh_frame "  p_wgh_frame  skip
        "p_cod_table "  p_cod_table 
        VIEW-AS ALERT-BOX.
*/

IF  p_ind_event = "initialize" then do:
    
    IF  NOT VALID-HANDLE(text_cod_portad) THEN DO:
        CREATE TEXT text_cod_portad
        ASSIGN FRAME        = p_wgh_frame
               FORMAT       = "x(5)"
               WIDTH        = 5
               SCREEN-VALUE = "Port:"
               ROW          = 2.40
               COL          = 28
               VISIBLE      = YES
               FONT         = 1.
    END.

    IF  NOT VALID-HANDLE(h_cod_portad) THEN DO:
        CREATE FILL-IN h_cod_portad
        ASSIGN NAME              = "cod_portad"
               FRAME             = p_wgh_frame
               SIDE-LABEL-HANDLE = text_cod_portad:HANDLE
               ROW               = 2.29
               COLUMN            = 31.5
               HEIGHT            = 0.88
               WIDTH             = 6
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "x(5)"
               TOOLTIP           = "Portador de Renegocia‡Æo"
               HELP              = "Portador de Renegocia‡Æo"
               VISIBLE           = YES
               SENSITIVE         = YES.
    END.

    IF  NOT VALID-HANDLE(h_cod_cart) THEN DO:
        CREATE FILL-IN h_cod_cart
        ASSIGN NAME              = "cod_cart"
               FRAME             = p_wgh_frame
               SIDE-LABEL-HANDLE = text_cod_portad:HANDLE
               ROW               = 2.29
               COLUMN            = 38
               HEIGHT            = 0.88
               WIDTH             = 4
               DATA-TYPE         = "CHARACTER"
               FORMAT            = "x(5)"
               TOOLTIP           = "Carteira de Renegocia‡Æo"
               HELP              = "Carteira de Renegocia‡Æo"
               VISIBLE           = YES
               SENSITIVE         = YES.
    END.

    ASSIGN h_cod_portad:SCREEN-VALUE = "9919"
           h_cod_cart:SCREEN-VALUE   = "90".
END.

IF  p_ind_event = "each_titulo" then do:

    IF  VALID-HANDLE(h_cod_portad)
    AND h_cod_portad:SCREEN-VALUE <> "" THEN DO:

        FIND FIRST tit_acr
            WHERE RECID(tit_acr) = p_rec_table NO-LOCK NO-ERROR.

        IF  AVAIL tit_acr THEN DO:
    
            IF  tit_acr.cod_portador  <> h_cod_portad:SCREEN-VALUE
            OR  tit_acr.cod_cart_bcia <> h_cod_cart:SCREEN-VALUE THEN
                RETURN "NOK".
        END.
    END.
END.

RETURN "OK".
