IF p-modelo = 634 THEN DO:

    PUT UNFORMATTED "^FO120,60,1^A0B,40,50^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
    PUT UNFORMATTED "^FO170,60^BY5^BCN,124,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    PUT UNFORMATTED "^FO1190,60,1^A0B,60,50^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */        
   
    PUT UNFORMATTED "^FO80,270^A0N,52,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
    PUT UNFORMATTED "^FO80,330^A0N,52,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
    PUT UNFORMATTED "^LRY^FO80,250^GB1090,0,140^FS^LRN" SKIP.  /* Quadro preto */
   
    IF item-ean.imei THEN DO:
       PUT UNFORMATTED "^FO120,420^BY5^BCN,84,N,N,N,N^FD" int-etiqueta-5g.cod-imei "^FS" SKIP.
       PUT UNFORMATTED "^FO05,520^ADN,54,25^FB978^FB1260,1,0,C^FDIMEI:" int-etiqueta-5g.cod-imei "^FS" SKIP.
    END.
   
    PUT UNFORMATTED "^FO90,580^BY6^BCN,84,N,N,N,N^FD" int-etiqueta-5g.n-serie  "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    PUT UNFORMATTED "^FO05,680^ADN,54,25^FB978^FB1260,1,0,C^FDNS:" int-etiqueta-5g.n-serie  "^FS" SKIP.
    PUT UNFORMATTED "^FO1060,680^A0N,76,76^FB100,1,0,R^FD" int-etiqueta-5g.celula-nome "^FS" SKIP. /* Sigla */
   
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
    IF AVAIL ITEM THEN DO:
        FIND FIRST int-portaria-movto NO-LOCK
             WHERE int-portaria-movto.it-codigo = item.it-codigo
               AND int-portaria-movto.dt-fim = ?
               AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
        IF AVAIL int-portaria-movto THEN
            PUT UNFORMATTED "^FO130,750^A0N,60,30^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
    END.       
   
    ASSIGN c-senha-wifi = replace(int-etiqueta-5g.senha-wifi,'_','_5f')  /* Underline - chr(95) */
           c-senha-wifi = replace(c-senha-wifi,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-senha-adm = replace(int-etiqueta-5g.senha-adm,'_','_5f')  /* Underline - chr(95) */
           c-senha-adm = replace(c-senha-adm,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-nome-wifi-aux = replace(int-etiqueta-5g.wifi-ssid,'_','_5f').  /* Underline - chr(95) */            
   
    PUT UNFORMATTED
         "~~DGlocal-anatel.GRF,02560,020,,:::::::W0JFC,V0LF80,U01FKFE0,T01FMFC,T07FNF,S01FOF,S07FOFC0,R01FPFE0,R03FQF0,R0SF8,Q01FRFC,Q07FRFE,Q0TFE,P01FFC03FOF,P07FC0H0PF80,P0FE0I01FNFC0,O03F80J07FMFE0,O0F0L01FMFE0,N01E0M0OF0,N0380M07FMF0,N060N03FMF8,N040N03FMF8,X01FMF8,Y0NFC,:Y07FLFC,Y07FLFE,::Y07FMF,Y03FMF,N01FHF80K03FMF,N07FHFE0K03FMF,N0KF80J03FMF,M03FJFE0J03FMF,M07FKFK03FMF,M0MF80I03FMF,L01FLFC0I03FMF,L03FLFE0I03FMF,L07FMFJ07FMF,L0OF80H07FMF,K01FNF80H07FMF,K01FNFC0H07FMF,K01FNFE0H07FMF,K03FNFE0H07FMF,K07FNFE0H0OF,K07FOFI0OF,K0QFH01FNF,:K0QF803FNF,::K0QF803FMFE,K0QF807FMFE,:K0QF80FNFE,K0QFH0OFE,K0QF01FNFC,K07FOF03FNFC,:K07FNFE07FNF8,K03FNFE07FNF8,K03FNFE0FOF8,K01FNFC3FOF8,L0OF83FOF0,L0OF07FOF0,L03FMF0FOFE0,L03FLFE0FOFE0,M0MF80FOFE0,M0MF01FOFC0,M07FJFE03FOFC0,M01FJF807FOFC0,N07FIFH0QF80,N03FHFC01FPF80,O03FC003FPF,,::L01F01F0FC0F87FLF8,L03F83F0F80F87FFDFFDF8,L07F83F8F81F807C1F01F8,L07F83F8F83FC0FC3F01F0,L0HF83F8F03FC0FC3F01F0,K01FF87FCF07FC0FC3F01F0,K01FF87FEF0FBC0F83FF1E0,K03EFC7FHF1FBC0F83FF1E0,K07EFC7FFE1F3C1F87FF1E0,K0FCFCFDFE3F3E1F07C03C0,K0IFCF9FE3FFE1F07C03C0,J01FHFCF8FE7FFE3F0FC03C0,J01FHFDF8FC7FFE3E0F807C0,J03F07DF0FCF83E3E0F807C0,J03E07DF07DF83E3E0F80780,J07E07DF079F83E7E0FFEFFE,J07C0FDF03BF03E7E0FFEFFE,,::::::::::::::::::::::::" SKIP.

    PUT UNFORMATTED "^FO2345,360^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
    
    PUT UNFORMATTED "^FO2250,470^A0N,30,30^FD" item-ean.homolog "^FS" SKIP.

    /* Modelo */
    PUT UNFORMATTED "^FO1470,60^A0N,62,62^FB870,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
    PUT UNFORMATTED "^LRY^FO1240,20^GB1250,100,100^FS^LRN" SKIP.  /* Quadro preto */

    /* Informaá‰es Item */
    PUT UNFORMATTED "^FO1340,135^A0N,34,34^FD" item-ean.char-2 "^FS" SKIP.

    /* Data */
    PUT UNFORMATTED "^FO1650,135^A0N,34,34^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.

    PUT UNFORMATTED "^FO1340,175^A0N,34,34^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.

    PUT UNFORMATTED "^FO1340,215^A0N,34,34^FB760,1,0,L^FD" 'MAC:' int-etiqueta-5g.mac "^FS" SKIP.
    PUT UNFORMATTED "^FO1340,245^BY2.5^BCN,74,N,N,N,N^FD" int-etiqueta-5g.mac "^FS" SKIP.  /* Codigo de Barras EAN 128 */

    PUT UNFORMATTED "^FO1340,335^A0N,34,34^FB760,1,0,L^FD" 'NS:' int-etiqueta-5g.n-serie "^FS" SKIP.
    PUT UNFORMATTED "^FO1340,365^BY2.5^BCN,74,N,N,N,N^FD" int-etiqueta-5g.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

    IF item-ean.imei THEN DO:
       PUT UNFORMATTED "^FO1340,455^A0N,34,34^FB760,1,0,L^FD" 'IMEI:' int-etiqueta-5g.cod-imei "^FS" SKIP.
       PUT UNFORMATTED "^FO1340,485^BY2.5^BCN,74,N,N,N,N^FD" int-etiqueta-5g.cod-imei "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    END.        

    ASSIGN c-monta-qr-code = 'WIFI:T:WPA;S:' + c-nome-wifi-aux + ';P:' + c-senha-wifi + ';USER:admin;PASS:' + c-senha-adm + ';;'.         

    /* QR CODE */
    PUT UNFORMATTED "^FO2260,135^BQR,2,5^FH^FDQA," c-monta-qr-code  "^FS" SKIP.       

    PUT UNFORMATTED "^FH^FO1855,135^A0N,34,34^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP.
    PUT UNFORMATTED "^FO1855,175^A0N,34,34^FB760,1,0,L^FD" /*'Suporte:'*/ item-ean.fone "^FS" SKIP.
    PUT UNFORMATTED "^FO1855,215^A0N,34,34^FB760,1,0,L^FD" 'Modelo: ' CAPS(item-ean.nome-abrev) "^FS" SKIP.
    PUT UNFORMATTED "^FO1855,255^A0N,34,34^FB760,1,0,L^FD" item-ean.info-tec  "^FS" SKIP.

    PUT UNFORMATTED "^FO1865,300^A0N,45,34^FB760,1,0,L^FDWIFI: " /*c-nome-wifi*/   "^FS" SKIP.
    PUT UNFORMATTED "^FO1945,300^A0N,45,45^FB800,1,0,L^FD"  int-etiqueta-5g.wifi-ssid  "^FS" SKIP.

    PUT UNFORMATTED "^FO1910,360^A0N,34,34^FB760,1,0,L^FDSenha: " /*c-senha-wifi*/ "^FS" SKIP. 
    PUT UNFORMATTED "^FO2020,360^A0N,40,50^FH^FD"  int-etiqueta-5g.senha-wifi  "^FS" SKIP.

    PUT UNFORMATTED "^FO1910,410^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[6] "^FS" SKIP. 
    PUT UNFORMATTED "^FO1980,460^A0N,34,34^FB760,1,0,L^FD" item-ean.texto[7] "^FS" SKIP. //Usuario
    PUT UNFORMATTED "^FO1980,510^A0N,34,34^FB760,1,0,L^FD" 'Senha: ' /*c-senha-adm*/ "^FS" SKIP. 
    PUT UNFORMATTED "^FO2080,510^A0N,40,50^FH^FD"  int-etiqueta-5g.senha-adm  "^FS" SKIP.


    PUT UNFORMATTED "^FO1260,670^ABN,40,20^FB650,1,0,C^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP. 
    PUT UNFORMATTED "^FO1260,735^ABN,40,20^FB650,1,0,C^FD" 'NS:' int-etiqueta-5g.n-serie "^FS" SKIP.

    PUT UNFORMATTED "^FO1880,670^ABN,40,20^FB650,1,0,C^FD"  CAPS(item-ean.nome-abrev)  "^FS" SKIP. 
    PUT UNFORMATTED "^FO1880,735^ABN,40,20^FB650,1,0,C^FD" 'NS:' int-etiqueta-5g.n-serie "^FS" SKIP.
END.


IF p-modelo = 662 THEN DO:

   PUT UNFORMATTED "^FO120,90,1^A0B,40,50^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
   PUT UNFORMATTED "^FO170,90^BY5^BCN,124,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
   PUT UNFORMATTED "^FO1190,90,1^A0B,60,50^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */        

   PUT UNFORMATTED "^FO80,300^A0N,52,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
   PUT UNFORMATTED "^FO80,360^A0N,52,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
   PUT UNFORMATTED "^LRY^FO80,280^GB1090,0,140^FS^LRN" SKIP.  /* Quadro preto */

   IF item-ean.imei THEN DO:
      PUT UNFORMATTED "^FO120,450^BY5^BCN,84,N,N,N,N^FD" int-etiqueta-5g.cod-imei "^FS" SKIP.
      PUT UNFORMATTED "^FO05,550^ADN,54,25^FB978^FB1260,1,0,C^FDIMEI:" int-etiqueta-5g.cod-imei "^FS" SKIP.
   END.

   PUT UNFORMATTED "^FO90,610^BY6^BCN,84,N,N,N,N^FD" int-etiqueta-5g.n-serie  "^FS" SKIP.  /* Codigo de Barras EAN 128 */
   PUT UNFORMATTED "^FO05,710^ADN,54,25^FB978^FB1260,1,0,C^FDNS:" int-etiqueta-5g.n-serie  "^FS" SKIP.
   PUT UNFORMATTED "^FO1060,710^A0N,76,76^FB100,1,0,R^FD" int-etiqueta-5g.celula-nome "^FS" SKIP. /* Sigla */
   
   /*
   FIND FIRST ITEM NO-LOCK
        WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
   IF AVAIL ITEM THEN DO:
       FIND FIRST int-portaria-movto NO-LOCK
            WHERE int-portaria-movto.it-codigo = item.it-codigo
              AND int-portaria-movto.dt-fim = ?
              AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
       IF AVAIL int-portaria-movto THEN
           PUT UNFORMATTED "^FO130,780^A0N,60,30^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
   END.*/       

   ASSIGN c-senha-wifi = replace(int-etiqueta-5g.senha-wifi,'_','_5f')  /* Underline - chr(95) */
          c-senha-wifi = replace(c-senha-wifi,'^','_5e'). /* Chapeu - chr(94) */

   ASSIGN c-senha-adm = replace(int-etiqueta-5g.senha-adm,'_','_5f')  /* Underline - chr(95) */
          c-senha-adm = replace(c-senha-adm,'^','_5e'). /* Chapeu - chr(94) */

   ASSIGN c-nome-wifi-aux = replace(int-etiqueta-5g.wifi-ssid,'_','_5f').  /* Underline - chr(95) */ 

   ASSIGN c-monta-qr-code = 'WIFI:T:WPA;S:' + c-nome-wifi-aux + ';P:' + c-senha-wifi + ';USER:admin;PASS:' + c-senha-adm + ';;'.         

   

   PUT UNFORMATTED "^FT1393,150^A0N,42,40^FH\^FD" CAPS(item-ean.linha[1])    "^FS" SKIP. 
   PUT UNFORMATTED "^FT1393,202^A0N,42,40^FH\^FDNS:" int-etiqueta-5g.n-serie "^FS" SKIP.

   PUT UNFORMATTED "^FT2025,150^A0N,42,40^FH\^FD" CAPS(item-ean.linha[1])    "^FS" SKIP.
   PUT UNFORMATTED "^FT2025,202^A0N,42,40^FH\^FDNS:" int-etiqueta-5g.n-serie "^FS" SKIP.

   PUT UNFORMATTED "^FT1393,407^A0N,42,40^FH\^FD" CAPS(item-ean.linha[1])    "^FS" SKIP.
   PUT UNFORMATTED "^FT1393,459^A0N,42,40^FH\^FDNS:" int-etiqueta-5g.n-serie "^FS" SKIP.

   PUT UNFORMATTED "^FT2025,407^A0N,42,40^FH\^FD" CAPS(item-ean.linha[1])    "^FS" SKIP.
   PUT UNFORMATTED "^FT2025,459^A0N,42,40^FH\^FDNS:" int-etiqueta-5g.n-serie "^FS" SKIP.



   PUT UNFORMATTED "^FT30,962^A0N,75,74^FB750,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP. 
   PUT UNFORMATTED "^FT140,1025^A0N,42,40^FH\^FD" item-ean.char-2 "^FS" SKIP. 
   PUT UNFORMATTED "^FT140,1077^A0N,42,40^FH\^FDCNPJ:" c-cgc "^FS" SKIP. 
   PUT UNFORMATTED "^FT140,1124^A0N,42,40^FH\^FD" item-ean.fone "^FS" SKIP.

   PUT UNFORMATTED "^FO90,1135^BY4^BCN,84,N,N,N,N^FD" int-etiqueta-5g.n-serie "^FS" SKIP.
   PUT UNFORMATTED "^FO05,1230^ADN,54,20^FB800,1,0,C^FDNS:" int-etiqueta-5g.n-serie  "^FS" SKIP.

   PUT UNFORMATTED "^FO880,1135^BY4^BCN,84,N,N,N,N^FD" int-etiqueta-5g.mac "^FS" SKIP.
   PUT UNFORMATTED "^FO795,1230^ADN,54,20^FB800,1,0,C^FDMAC:" int-etiqueta-5g.mac "^FS" SKIP.

   IF item-ean.imei THEN DO:
      PUT UNFORMATTED "^FO1680,1135^BY4^BCN,84,N,N,N,N^FD" int-etiqueta-5g.cod-imei "^FS" SKIP.
      PUT UNFORMATTED "^FO1600,1230^ADN,54,20^FB800,1,0,C^FDIMEI:" int-etiqueta-5g.cod-imei "^FS" SKIP.
   END.


   PUT UNFORMATTED "^FT800,920^A0N,42,40^FH\^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP. 

   PUT UNFORMATTED "^FH^FT800,1015^A0N,42,40^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP. 
   PUT UNFORMATTED "^FT800,964^A0N,42,40^FH\^FDModelo:" CAPS(item-ean.nome-abrev) "^FS" SKIP. 
   PUT UNFORMATTED "^FT800,1120^A0N,42,40^FH\^FD" item-ean.info-tec "^FS" SKIP. 
   PUT UNFORMATTED "^FT800,1068^A0N,42,40^FH\^FD" item-ean.texto[6] "^FS" SKIP. 
   PUT UNFORMATTED "^FT1614,941^A0N,42,40^FH\^FDWIFI:" int-etiqueta-5g.wifi-ssid "^FS" SKIP. 
   PUT UNFORMATTED "^FT1614,993^A0N,42,40^FH\^FDSenha:" int-etiqueta-5g.senha-wifi "^FS" SKIP. 
   PUT UNFORMATTED "^FT1614,1041^A0N,42,40^FH\^FD"item-ean.texto[7] "^FS" SKIP. 
   PUT UNFORMATTED "^FT1614,1091^A0N,42,40^FH\^FDSenha:" int-etiqueta-5g.senha-adm  "^FS" SKIP. 

   /*
   PUT UNFORMATTED
     "~~DGlocal-anatel.GRF,02560,020,,:::::::W0JFC,V0LF80,U01FKFE0,T01FMFC,T07FNF,S01FOF,S07FOFC0,R01FPFE0,R03FQF0,R0SF8,Q01FRFC,Q07FRFE,Q0TFE,P01FFC03FOF,P07FC0H0PF80,P0FE0I01FNFC0,O03F80J07FMFE0,O0F0L01FMFE0,N01E0M0OF0,N0380M07FMF0,N060N03FMF8,N040N03FMF8,X01FMF8,Y0NFC,:Y07FLFC,Y07FLFE,::Y07FMF,Y03FMF,N01FHF80K03FMF,N07FHFE0K03FMF,N0KF80J03FMF,M03FJFE0J03FMF,M07FKFK03FMF,M0MF80I03FMF,L01FLFC0I03FMF,L03FLFE0I03FMF,L07FMFJ07FMF,L0OF80H07FMF,K01FNF80H07FMF,K01FNFC0H07FMF,K01FNFE0H07FMF,K03FNFE0H07FMF,K07FNFE0H0OF,K07FOFI0OF,K0QFH01FNF,:K0QF803FNF,::K0QF803FMFE,K0QF807FMFE,:K0QF80FNFE,K0QFH0OFE,K0QF01FNFC,K07FOF03FNFC,:K07FNFE07FNF8,K03FNFE07FNF8,K03FNFE0FOF8,K01FNFC3FOF8,L0OF83FOF0,L0OF07FOF0,L03FMF0FOFE0,L03FLFE0FOFE0,M0MF80FOFE0,M0MF01FOFC0,M07FJFE03FOFC0,M01FJF807FOFC0,N07FIFH0QF80,N03FHFC01FPF80,O03FC003FPF,,::L01F01F0FC0F87FLF8,L03F83F0F80F87FFDFFDF8,L07F83F8F81F807C1F01F8,L07F83F8F83FC0FC3F01F0,L0HF83F8F03FC0FC3F01F0,K01FF87FCF07FC0FC3F01F0,K01FF87FEF0FBC0F83FF1E0,K03EFC7FHF1FBC0F83FF1E0,K07EFC7FFE1F3C1F87FF1E0,K0FCFCFDFE3F3E1F07C03C0,K0IFCF9FE3FFE1F07C03C0,J01FHFCF8FE7FFE3F0FC03C0,J01FHFDF8FC7FFE3E0F807C0,J03F07DF0FCF83E3E0F807C0,J03E07DF07DF83E3E0F80780,J07E07DF079F83E7E0FFEFFE,J07C0FDF03BF03E7E0FFEFFE,,::::::::::::::::::::::::" SKIP.

   PUT UNFORMATTED "^FO2160,940^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.*/

   PUT UNFORMATTED
     "^FO2100,860^GFA,07168,07168,00032,:Z64:eJztmL+L41YQx5+kMwIJjLdycYWWrYIC/gfcqFhIm+JMSv8ZV0rk/hGxaYwMqo3UKFXaDeRI69K4crHhGvmUeb/0RnrvyQcHKYIHW0g7fPb7Zt7M6O0Scre73e1u/53NNptkyh8XRW73PvzSgf1s9bs1tZ3Vz/DuasVLbpnFv+y4vVr8+7qeWsBM4LYFBGdpRreTSt6ygLq33OT2e7x7M/lXZVGIBJgCcNLr5mE7EUCV9WuoTPJMVPyCRPcH7OryBGS6f8OuD9M7IBeQW/18ARerf84SYOd5DbRWv8f0D1b/7AZPJiqAmsMTYOf5BmRWf2rbAGGryRaQfGP1r9kC7Pz2Bh+z+I9Wf3RjA8MbBXCLNxaAs/k8yQcq46GpALaq5yJTARRqy/kUOA3cS1TzJj5EIZv0t6jpTTzb84Lfz/UJMKi5SJ8AvObFnhv0xeRpbPpi8OX4Afs5InIe6Q3AS05ohvoEEoOzRfxXLXyZAPGghy80Dfpi6vISWGv6PZ+gxSC/K8c+42Mtfvna4RWg8+Fg7Ov6/eC/mPm5mPq86Est/gjzMhiT/k4lo7rB4/zHMv4TSgbybyXfKh7X31rq0wLwdP0U8z6uBW4rGT9dv4trwcAvb+iHuBYNfKTr9/HToAOVCo2/mvn+tV+RUS8Y9NOJ+Ev1gPrfwfpy+/H8G+jX0/omHscvt/9o4X0Dj/Pv4Vb4Rh7vv+wFGy/SPziAYP1wSv9N1XJjiv+k7jPkl5p00amBx/0nby18P4owj/tf3mIezZ/hKBTmKVF5Ozh/+ErUN/Fo/gWqEpQh0cjE9/NXpWJ4AE17SN4ZXn+s52UpFCa+Va0w5H/U0j98/UZa+oe8K99/LqoEfQNe1U4Mjx+uzHlo1hfLHk3icQJ24zfBKIALmsQjXp4/+k4Y8ezQm6BOaIZ+VvZEnn0N538Q/gsVgsa7rOLcfhKNebL5QNgfn8KSsf//a+8S9qE3756fn+GbwLOyGLouZ9edWxQFfHN47s1JGxJdCL22tHvh+xoNpn9OwpysofgO0P0VlEIeYr47Mj4hW8k3Ax5GfXwiRQZX9+n8FJyfSHBU7hnUWtQ6tHdbsmwXUbsgmPdAf30g0PDQ9N4BVkEI1veBTynvwJnDh18BQxjzAdT6qiQlHX3E3ZE5bQPER5TvGN9RnrIRmv7h/kDWFeh7FdcHfo35L2+c968d/RuY8pBMlf6XE1T/r2finuiXxR4jPv27Bf73K4mAX144j/TrTweYOp8qEK5o8O+Bhc1Q/E/Ap3/QhafEv2j6JcRcrl52ZJWXNPAV8CvFO50PyYvoIv7sKBzBKQDxXgUxV+FvkISszmghwDYgfb9l/Bfgm5QVQtdi3j1BzOcABt45izMIPj4XtBilLdsl8MuO7mCaUf6fDw7ioegOTuXBwKuEPqwftX/UfWwdKLy3WfexS6Ij005V+DDxoOTdMqfnvkzEX2K+u3ogfqG120QN5R309lnv9zQDUPP1vs4gcKqN3n7p5w1kgKQX/7pJm63GQ6hnyEB8DOACGaCNQNTbz0lfnSvjWQ/CUzfkQY7qr/P3tAelPto+4nyFqtseU8Y3Y77kFTDPIe5VBhtfvsARuPgB8R3ddUAF310d9f7yQKqCkg8h+UK/pmNAvn9g6VBBF+ILPqHsDP0D6pF+HvkNf3p8ZF9hC/gsFuJGPvGf3O1ud/sO+xfv+VsJ:C65A" SKIP.

   
   PUT UNFORMATTED "^FT2056,1100^A0N,42,40^FH\^FD" item-ean.homolog  "^FS" SKIP.

   /* QR CODE */
   PUT UNFORMATTED "^FO1370,900^BQR,2,5^FH^FDQA," c-monta-qr-code  "^FS" SKIP.       

   PUT UNFORMATTED "^LRY^FO9,875^GB769,0,103^FS^LRN" SKIP. 

END.


IF p-modelo = 628 THEN DO:

    PUT UNFORMATTED "^FO120,60,1^A0B,40,50^FD" STRING(TODAY, "99/99/99") "^FS" SKIP. /* Imprime Data Vertical */
    PUT UNFORMATTED "^FO170,60^BY5^BCN,124,Y,N^FD" string(item-mat.cod-ean, "9(13)") "^FS" SKIP.  /* Codigo de Barras EAN 13 */
    PUT UNFORMATTED "^FO1190,60,1^A0B,60,50^FD" item-ean.it-codigo "^FS" SKIP. /* Sigla */        
   
    PUT UNFORMATTED "^FO80,270^A0N,52,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP.
    PUT UNFORMATTED "^FO80,330^A0N,52,78^FB1090,1,0,C^FD" CAPS(item-ean.linha[2]) "^FS" SKIP.
    PUT UNFORMATTED "^LRY^FO80,250^GB1090,0,140^FS^LRN" SKIP.  /* Quadro preto */
   
    IF item-ean.imei THEN DO:
       PUT UNFORMATTED "^FO120,420^BY5^BCN,124,N,N,N,N^FD" int-etiqueta-5g.cod-imei "^FS" SKIP.
       PUT UNFORMATTED "^FO05,560^ADN,54,25^FB978^FB1260,1,0,C^FDIMEI:" int-etiqueta-5g.cod-imei "^FS" SKIP.
    END.
   
    PUT UNFORMATTED "^FO90,630^BY6^BCN,124,N,N,N,N^FD" int-etiqueta-5g.n-serie  "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    PUT UNFORMATTED "^FO05,770^ADN,54,25^FB978^FB1260,1,0,C^FDNS:" int-etiqueta-5g.n-serie  "^FS" SKIP.
    PUT UNFORMATTED "^FO1060,770^A0N,76,76^FB100,1,0,R^FD" int-etiqueta-5g.celula-nome "^FS" SKIP. /* Sigla */
   
    FIND FIRST ITEM NO-LOCK
         WHERE ITEM.it-codigo = item-ean.it-codigo NO-ERROR.
    IF AVAIL ITEM THEN DO:
        FIND FIRST int-portaria-movto NO-LOCK
             WHERE int-portaria-movto.it-codigo = item.it-codigo
               AND int-portaria-movto.dt-fim = ?
               AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
        IF AVAIL int-portaria-movto THEN
            PUT UNFORMATTED "^FO130,860^A0N,60,30^FDESTE PRODUTO ê BENEFICIADO PELA LEGISLAÄ«O DE INFORMµTICA^FS" SKIP.
    END.       
   
    ASSIGN c-senha-wifi = replace(int-etiqueta-5g.senha-wifi,'_','_5f')  /* Underline - chr(95) */
           c-senha-wifi = replace(c-senha-wifi,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-senha-adm = replace(int-etiqueta-5g.senha-adm,'_','_5f')  /* Underline - chr(95) */
           c-senha-adm = replace(c-senha-adm,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-nome-wifi-aux = replace(int-etiqueta-5g.wifi-ssid,'_','_5f').  /* Underline - chr(95) */

    PUT UNFORMATTED
         "~~DGlocal-anatel.GRF,02560,020,,:::::::W0JFC,V0LF80,U01FKFE0,T01FMFC,T07FNF,S01FOF,S07FOFC0,R01FPFE0,R03FQF0,R0SF8,Q01FRFC,Q07FRFE,Q0TFE,P01FFC03FOF,P07FC0H0PF80,P0FE0I01FNFC0,O03F80J07FMFE0,O0F0L01FMFE0,N01E0M0OF0,N0380M07FMF0,N060N03FMF8,N040N03FMF8,X01FMF8,Y0NFC,:Y07FLFC,Y07FLFE,::Y07FMF,Y03FMF,N01FHF80K03FMF,N07FHFE0K03FMF,N0KF80J03FMF,M03FJFE0J03FMF,M07FKFK03FMF,M0MF80I03FMF,L01FLFC0I03FMF,L03FLFE0I03FMF,L07FMFJ07FMF,L0OF80H07FMF,K01FNF80H07FMF,K01FNFC0H07FMF,K01FNFE0H07FMF,K03FNFE0H07FMF,K07FNFE0H0OF,K07FOFI0OF,K0QFH01FNF,:K0QF803FNF,::K0QF803FMFE,K0QF807FMFE,:K0QF80FNFE,K0QFH0OFE,K0QF01FNFC,K07FOF03FNFC,:K07FNFE07FNF8,K03FNFE07FNF8,K03FNFE0FOF8,K01FNFC3FOF8,L0OF83FOF0,L0OF07FOF0,L03FMF0FOFE0,L03FLFE0FOFE0,M0MF80FOFE0,M0MF01FOFC0,M07FJFE03FOFC0,M01FJF807FOFC0,N07FIFH0QF80,N03FHFC01FPF80,O03FC003FPF,,::L01F01F0FC0F87FLF8,L03F83F0F80F87FFDFFDF8,L07F83F8F81F807C1F01F8,L07F83F8F83FC0FC3F01F0,L0HF83F8F03FC0FC3F01F0,K01FF87FCF07FC0FC3F01F0,K01FF87FEF0FBC0F83FF1E0,K03EFC7FHF1FBC0F83FF1E0,K07EFC7FFE1F3C1F87FF1E0,K0FCFCFDFE3F3E1F07C03C0,K0IFCF9FE3FFE1F07C03C0,J01FHFCF8FE7FFE3F0FC03C0,J01FHFDF8FC7FFE3E0F807C0,J03F07DF0FCF83E3E0F807C0,J03E07DF07DF83E3E0F80780,J07E07DF079F83E7E0FFEFFE,J07C0FDF03BF03E7E0FFEFFE,,::::::::::::::::::::::::" SKIP. 

    PUT UNFORMATTED "^FO2270,685^XGlocal-anatel.GRF^FS" /* Impressao da Imagem ANATEL */ SKIP.
    
    PUT UNFORMATTED "^FO2160,800^A0N,35,35^FD" item-ean.homolog "^FS" SKIP.
     
    /*ETIQUETA 2 */

    /* Modelo */
    PUT UNFORMATTED "^FO1470,90^A0N,62,62^FB870,1,0,C^FD" CAPS(item-ean.nome-abrev) "^FS" SKIP.    /* Imprime modelo */
    PUT UNFORMATTED "^LRY^FO1240,50^GB1250,100,100^FS^LRN" SKIP.  /* Quadro preto */

    /* Informaá‰es Item */
    PUT UNFORMATTED "^FO1310,170^A0N,50,40^FD" item-ean.char-2 "^FS" SKIP.

    /* Data */
    PUT UNFORMATTED "^FO2230,620^A0N,50,40^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.

    PUT UNFORMATTED "^FO1310,230^A0N,50,40^FB760,1,0,L^FDCNPJ: " c-cgc "^FS" SKIP.

    PUT UNFORMATTED "^FO1310,290^A0N,40,40^FB760,1,0,L^FD" 'MAC:' int-etiqueta-5g.mac "^FS" SKIP.
    PUT UNFORMATTED "^FO1310,330^BY2.5^BCN,90,N,N,N,N^FD" int-etiqueta-5g.mac "^FS" SKIP.  /* Codigo de Barras EAN 128 */

    PUT UNFORMATTED "^FO1310,435^A0N,40,40^FB760,1,0,L^FD" 'NS:' int-etiqueta-5g.n-serie "^FS" SKIP.
    PUT UNFORMATTED "^FO1310,470^BY2.5^BCN,90,N,N,N,N^FD" int-etiqueta-5g.n-serie "^FS" SKIP.  /* Codigo de Barras EAN 128 */

    IF item-ean.imei THEN DO:
       PUT UNFORMATTED "^FO1310,580^A0N,40,40^FB760,1,0,L^FD" 'IMEI:' int-etiqueta-5g.cod-imei "^FS" SKIP.
       PUT UNFORMATTED "^FO1310,615^BY2.5^BCN,90,N,N,N,N^FD" int-etiqueta-5g.cod-imei "^FS" SKIP.  /* Codigo de Barras EAN 128 */
    END.        

    PUT UNFORMATTED "^FO1310,720^A0N,50,40^FB760,1,0,L^FD" 'Modelo: ' CAPS(item-ean.nome-abrev) "^FS" SKIP. 

    PUT UNFORMATTED "^FO1310,770^A0N,50,40^FB760,1,0,L^FD" item-ean.texto[7] "^FS" SKIP.  // USUARIO ADMIN

    PUT UNFORMATTED "^FO1310,830^A0N,50,40^FB760,1,0,L^FD" 'Senha: ' /*c-senha-adm*/ "^FS" SKIP. 
    PUT UNFORMATTED "^FO1430,830^A0N,67,69^FH^FD"  int-etiqueta-5g.senha-adm  "^FS" SKIP.



    ASSIGN c-monta-qr-code = 'WIFI:T:WPA;S:' + c-nome-wifi-aux + ';P:' + c-senha-wifi + ';USER:admin;PASS:' + c-senha-adm + ';;'.         

    /* QR CODE */
    PUT UNFORMATTED "^FO1940,610^BQR,2,5^FH^FDQA," c-monta-qr-code  "^FS" SKIP.       

    PUT UNFORMATTED "^FH^FO1940,170^A0N,50,40^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP.
    PUT UNFORMATTED "^FO1940,250^A0N,50,40^FB760,1,0,L^FD" /*'Suporte:'*/ item-ean.fone "^FS" SKIP.
   
    PUT UNFORMATTED "^FO1940,320^A0N,50,40^FB760,1,0,L^FD" item-ean.info-tec  "^FS" SKIP.
    
    PUT UNFORMATTED "^FO1940,400^A0N,50,40^FB760,1,0,L^FD" item-ean.texto[6] "^FS" SKIP.  // IP Gerencia

    PUT UNFORMATTED "^FO1935,470^A0N,50,40^FB760,1,0,L^FDWIFI: " /*c-nome-wifi*/   "^FS" SKIP.
    PUT UNFORMATTED "^FO2035,470^A0N,50,50^FB800,1,0,L^FD"  int-etiqueta-5g.wifi-ssid  "^FS" SKIP.

    PUT UNFORMATTED "^FO1940,540^A0N,50,40^FB760,1,0,L^FDSenha: " /*c-senha-wifi*/ "^FS" SKIP. 
    PUT UNFORMATTED "^FO2055,540^A0N,50,50^FH^FD"  int-etiqueta-5g.senha-wifi  "^FS" SKIP.

END.



IF p-modelo = 663 THEN DO:

    ASSIGN c-senha-wifi = replace(int-etiqueta-5g.senha-wifi,'_','_5f')  /* Underline - chr(95) */
           c-senha-wifi = replace(c-senha-wifi,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-senha-adm = replace(int-etiqueta-5g.senha-adm,'_','_5f')  /* Underline - chr(95) */
           c-senha-adm = replace(c-senha-adm,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-nome-wifi-aux = replace(int-etiqueta-5g.wifi-ssid,'_','_5f').  /* Underline - chr(95) */            

    
    PUT UNFORMATTED "^FT100,165^A0N,50,53^FD" item-ean.char-2 "^FS" SKIP.
    PUT UNFORMATTED "^FT1000,170^A0N,58,61^FD" STRING(TODAY,"99/99/9999") "^FS" SKIP.
    PUT UNFORMATTED "^FH^FT1343,170^A0N,50,53^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP.
     
    PUT UNFORMATTED "^BY6,3,82^FT800,270^BCN,,N,N^FD" int-etiqueta-5g.n-serie "^FS" SKIP.
    PUT UNFORMATTED "^FT1046,320^ABN,39,26^FDNS:" int-etiqueta-5g.n-serie "^FS" SKIP.
    
    PUT UNFORMATTED "^BY6,3,76^FT800,410^BCN,,N,N^FD" int-etiqueta-5g.mac "^FS" SKIP.
    PUT UNFORMATTED "^FT1046,465^ABN,39,26^FDMAC:" int-etiqueta-5g.mac "^FS" SKIP.    
    
    PUT UNFORMATTED "^BY6,3,86^FT800,560^BCN,,N,N^FD" mac-address.motiv-re "^FS" SKIP. // GPON
    PUT UNFORMATTED "^FT1046,615^ABN,39,26^FDGPONSN:" mac-address.motiv-re "^FS" SKIP.

    PUT UNFORMATTED "^FT100,555^A0N,50,53^FDWIFI:" "^FS" SKIP.
    PUT UNFORMATTED "^FT224,555^A0N,50,53^FD" int-etiqueta-5g.wifi-ssid "^FS" SKIP.

    PUT UNFORMATTED "^FT100,620^A0N,50,53^FDSenha:" "^FS" SKIP.
    PUT UNFORMATTED "^FT262,620^A0N,50,53^FD" int-etiqueta-5g.senha-wifi "^FS" SKIP.
    
    PUT UNFORMATTED "^FT100,210^A0N,50,53^FDCNPJ:" c-cgc "^FS" SKIP.
    PUT UNFORMATTED "^FT100,260^A0N,50,53^FD" item-ean.fone  "^FS" SKIP.
    PUT UNFORMATTED "^FH^FT100,320^A0N,50,53^FDTens_C6o: " CAPS(item-ean.info-tec[1]) "^FS" SKIP.
    PUT UNFORMATTED "^FT100,367^A0N,50,53^FDCorrente: " CAPS(item-ean.info-tec[2]) "^FS" SKIP.

    PUT UNFORMATTED "^FT100,430^A0N,50,53^FDWIFI 5G:" "^FS" SKIP.
    PUT UNFORMATTED "^FT294,430^A0N,50,53^FD" int-etiqueta-5g.wifi-ssid "_5G" "^FS" SKIP.

    PUT UNFORMATTED "^FT100,495^A0N,50,53^FDSenha 5G:" "^FS" SKIP.
    PUT UNFORMATTED "^FT340,495^A0N,50,53^FD" int-etiqueta-5g.senha-wifi "^FS" SKIP.


    PUT UNFORMATTED "^FH^FT100,682^A0N,50,53^FDIP Ger_88ncia: " item-ean.texto[6] "^FS" SKIP.  // IP Gerencia

    PUT UNFORMATTED "^FH^FT100,736^A0N,50,53^FDUsu_A0rio: " item-ean.texto[7] "^FS" SKIP. // Usuario ADMIN
    PUT UNFORMATTED "^FT100,792^A0N,50,53^FDSenha:" int-etiqueta-5g.senha-adm "^FS" SKIP.

END.




IF p-modelo = 664 THEN DO:

    ASSIGN c-senha-wifi = replace(int-etiqueta-5g.senha-wifi,'_','_5f')  /* Underline - chr(95) */
           c-senha-wifi = replace(c-senha-wifi,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-senha-adm = replace(int-etiqueta-5g.senha-adm,'_','_5f')  /* Underline - chr(95) */
           c-senha-adm = replace(c-senha-adm,'^','_5e'). /* Chapeu - chr(94) */
   
    ASSIGN c-nome-wifi-aux = replace(int-etiqueta-5g.wifi-ssid,'_','_5f').  /* Underline - chr(95) */       

    PUT UNFORMATTED "^FT80,220^A0N,58,57^FD" item-ean.char-2 "^FS" SKIP. 
    PUT UNFORMATTED "^FT1200,210^A0N,67,67^FD" STRING(TODAY,"99/99/9999") "^FS" "^FS" SKIP. 
    PUT UNFORMATTED "^FH^FT1715,210^A0N,58,57^FD" REPLACE(item-ean.origem,'È','_e9') "^FS" SKIP. 

    PUT UNFORMATTED "^BY8,3,113^FT900,350^BCN,,N,N^FD" int-etiqueta-5g.n-serie "^FS" SKIP. 
    PUT UNFORMATTED "^FT1280,415^ABN,54,34^FDNS:" int-etiqueta-5g.n-serie "^FS" SKIP. 

    PUT UNFORMATTED "^BY8,3,83^FT900,510^BCN,,N,N^FD" int-etiqueta-5g.mac "^FS" SKIP. 
    PUT UNFORMATTED "^FT1280,580^ABN,54,34^FDMAC:" int-etiqueta-5g.mac "^FS" SKIP. 

    PUT UNFORMATTED "^BY8,3,98^FT900,700^BCN,,N,N^FD" mac-address.motiv-re "^FS" SKIP. //GPON 
    PUT UNFORMATTED "^FT1280,765^ABN,54,34^FDGPONSN:" mac-address.motiv-re "^FS" SKIP.
     
    PUT UNFORMATTED "^FT80,730^A0N,58,57^FDWIFI:" "^FS" SKIP. 
    PUT UNFORMATTED "^FT209,730^A0N,58,57^FD" int-etiqueta-5g.wifi-ssid "^FS" SKIP.

    PUT UNFORMATTED "^FT80,800^A0N,58,57^FDSenha:" "^FS" SKIP. 
    PUT UNFORMATTED "^FT247,800^A0N,58,57^FD" int-etiqueta-5g.senha-wifi "^FS" SKIP. 

    PUT UNFORMATTED "^FT80,291^A0N,58,57^FDCNPJ:" c-cgc "^FS" SKIP. 
    PUT UNFORMATTED "^FT80,364^A0N,58,57^FD" item-ean.fone "^FS" SKIP. 
    PUT UNFORMATTED "^FH^FT80,442^A0N,58,57^FDTens_C6o: " CAPS(item-ean.info-tec[1]) "^FS" SKIP. 
    PUT UNFORMATTED "^FT80,504^A0N,58,57^FDCorrente: " CAPS(item-ean.info-tec[2]) "^FS" SKIP. 

    PUT UNFORMATTED "^FT80,590^A0N,58,57^FDWIFI 5G:" "^FS" SKIP. 
    PUT UNFORMATTED "^FT328,590^A0N,58,57^FD" int-etiqueta-5g.wifi-ssid "_5G" "^FS" SKIP. 

    PUT UNFORMATTED "^FT80,660^A0N,58,57^FDSenha 5G:" "^FS" SKIP. 
    PUT UNFORMATTED "^FT328,660^A0N,58,57^FD" int-etiqueta-5g.senha-wifi "^FS" SKIP. 

    PUT UNFORMATTED "^FH^FT80,895^A0N,58,57^FDIP Ger_88ncia: " item-ean.texto[6] "^FS" SKIP.  // IP Gerencia

    PUT UNFORMATTED "^FH^FT80,957^A0N,58,57^FDUsu_A0rio: " item-ean.texto[7] "^FS" SKIP.  // Usuario ADMIN
    PUT UNFORMATTED "^FT80,1023^A0N,58,57^FDSenha: " int-etiqueta-5g.senha-adm "^FS" SKIP. 

END.


IF p-modelo = 665 THEN DO:

   PUT UNFORMATTED "^BY7,2,159^FT262,800^BEB,,Y,N" SKIP. 
   PUT UNFORMATTED "^FD" STRING(item-mat.cod-ean, "9(13)") "^FS" SKIP. 
   
   PUT UNFORMATTED "^BY4,3,160^FT795,860^BCB,,N,N^FD"  int-etiqueta-5g.n-serie   "^FS" SKIP. 
   PUT UNFORMATTED "^FT840,780^ABB,38,28^FB600,1,0,L^FDNS:" int-etiqueta-5g.n-serie   "^FS" SKIP. 

   PUT UNFORMATTED "^BY5,3,160^FT1020,920^BCB,,N,N^FD" int-etiqueta-5g.mac   "^FS"    SKIP. 
   PUT UNFORMATTED "^FT1070,780^ABB,38,28^FB600,1,0,L^FDMAC:" int-etiqueta-5g.mac   "^FS" SKIP.

   PUT UNFORMATTED "^BY5,3,160^FT1260,920^BCB,,N,N^FD" mac-address.motiv-re  "^FS"        SKIP. 
   PUT UNFORMATTED "^FT1305,780^ABB,38,28^FB800,1,0,L^FDGPONSN:" mac-address.motiv-re  "^FS"  SKIP. //GPON

   PUT UNFORMATTED "^FT469,1000^A0B,67,66^FB1090,1,0,C^FD" CAPS(item-ean.linha[1]) "^FS" SKIP. 
   PUT UNFORMATTED "^FH^FT564,1000^A0B,67,66^FB1090,1,0,C^FD" replace(CAPS(item-ean.linha[2]),'‡','_E0' ) "^FS" SKIP. 

   PUT UNFORMATTED "^FT320,67^A0I,67,66^FD" item-ean.it-codigo "^FS" SKIP. 
   PUT UNFORMATTED "^FT1386,150^A0B,58,61^FD" int-etiqueta-5g.celula-nome "^FS" SKIP. 
   
   PUT UNFORMATTED "^FT327,875^A0I,67,66^FD" STRING(TODAY,"99/99/99") "^FS" SKIP. 
   PUT UNFORMATTED "^LRY^FO393,50^GB0,887,202^FS^LRN" SKIP. 
   PUT UNFORMATTED "^PQ1,0,1,Y" SKIP. 
   PUT UNFORMATTED "^XZ" SKIP.      

END.





