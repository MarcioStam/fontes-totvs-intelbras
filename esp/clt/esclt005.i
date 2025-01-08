DEF TEMP-TABLE ttvolume-nf
    FIELD cod-estabel LIKE volume-nf.cod-estabel
    FIELD serie       LIKE volume-nf.serie
    FIELD nr-nota-fis LIKE volume-nf.nr-nota-fis
    FIELD tot-vol     LIKE volume-nf.nr-volume
    FIELD qtd-col     LIKE volume-nf.nr-volume
    INDEX ch-pri cod-estabel serie nr-nota-fis.
