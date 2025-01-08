define temp-table tt-param no-undo
   field usuario     as character
   field senha       as character
   field dt-inicial  as date
   field dt-final    as date.

DEF TEMP-TABLE ttRazaoConsolidado NO-UNDO
    FIELD CD_MasterExt         AS CHAR
    FIELD CD_UnidNegExt        AS INT
    FIELD CD_Co                AS CHAR
    FIELD CD_Classif           AS INT
    FIELD CD_Cc                AS CHAR
    FIELD CD_Prj               AS CHAR
    FIELD NM_Ano               AS INT
    FIELD NM_Mes               AS INT    
    FIELD NM_ValorRealizado    AS DEC
    FIELD TX_MoedaExt          AS CHAR
    FIELD TX_Co                AS CHAR
    FIELD TX_Cc                AS CHAR
    FIELD TX_Prj               AS CHAR
    INDEX idx_razao AS PRIMARY UNIQUE 
            cd_masterext 
            cd_co 
            cd_cc 
            cd_prj 
            nm_ano 
            nm_mes.

