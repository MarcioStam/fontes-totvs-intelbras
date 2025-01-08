def temp-table tt_unid_negoc{1} no-undo
    field cod_unid_negoc as character format "x(3)"  label "Unid Neg¢cio" column-label "Un Neg"
    field des_unid_negoc as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo"
    field cdn_unid_negoc as Integer   format ">>9"   initial 0 label "N£mero Unidade Negoc" column-label "Numero UN"
    index ch-codigo is primary unique
        cod_unid_negoc.

