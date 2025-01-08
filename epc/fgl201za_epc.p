/*****************************************************************************
** Programa..............: fgl201za_epc
** Versao................:  1.00.00.000
** Nome Externo..........: epc/fgl201za_epc.p
** Criado por............: Andrey M Oliveira
** Criado em.............: 07/12/2020
*****************************************************************************/
{esp/es0018.i}
/********************* Temporary Table Definition Begin *********************/

define temp-table tt_epc no-undo
    field cod_event        as character
    field cod_parameter    as character
    field val_parameter    as character
    index id is primary cod_parameter cod_event ascending.

/********************** Temporary Table Definition End **********************/

/************************ Parameter Definition Begin ************************/

def Input param p_ind_event
    as character
    format "X(10)"
    no-undo.
DEF INPUT-OUTPUT PARAM TABLE  
    FOR tt_epc.

/************************* Parameter Definition End *************************/

def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu†rio Corrente"
    column-label "Usu†rio Corrente"
    no-undo.

IF  p_ind_event = "validar" THEN DO:

    FIND tt_epc NO-LOCK
        WHERE tt_epc.cod_event     = p_ind_event
        AND   tt_epc.cod_parameter = "ParÉmetros" NO-ERROR.
    
    IF  NOT AVAIL tt_epc THEN 
        RETURN "OK".
    
    IF  entry(3, tt_epc.val_parameter, chr(10)) = "eliminar"
    OR  entry(3, tt_epc.val_parameter, chr(10)) = "Descontabilizar" THEN DO:
        
        FIND FIRST lote_ctbl USE-INDEX ltctbla_id
            WHERE lote_ctbl.cod_empresa   = v_cod_empres_usuar
            AND   lote_ctbl.num_lote_ctbl = int(entry(1, tt_epc.val_parameter, chr(10))) NO-LOCK NO-ERROR.
        
        IF  AVAIL lote_ctbl THEN DO:
            IF  lote_ctbl.cod_usuar_ult_atualiz <> v_cod_usuar_corren THEN DO:
                CREATE tt_epc.
                ASSIGN tt_epc.cod_event     = p_ind_event
                       tt_epc.cod_parameter = "Retorno"
                       tt_epc.val_parameter = "17006" + chr(10) + "Lote n∆o pode ser eliminado/descontabilizado !" + chr(10) 
                                            + "Lote gerado pelo usu†rio " + caps(lote_ctbl.cod_usuar_ult_atualiz) + " n∆o pode ser eliminado/descontabilizado por outro usu†rio !".
        
                RETURN "NOK".
            END.
            ELSE 
                RETURN "OK".
        END.
        ELSE
            RETURN "OK".
    END.
END.
