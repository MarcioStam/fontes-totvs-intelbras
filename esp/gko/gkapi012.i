DEFINE TEMP-TABLE tt-material NO-UNDO
    FIELD desc-item                 LIKE ITEM.desc-item                 SERIALIZE-NAME "description"      
    FIELD it-codigo                 LIKE ITEM.it-codigo                 SERIALIZE-NAME "code"             
    FIELD itemType                  AS INTEGER                          SERIALIZE-NAME "itemType"         
    FIELD altura                    AS CHARACTER                        SERIALIZE-NAME "height"           
    FIELD largura                   AS CHARACTER                        SERIALIZE-NAME "width"            
    FIELD comprim                   AS CHARACTER                        SERIALIZE-NAME "depth"            
    FIELD cod-unid-negoc            LIKE it-nota-fisc.cod-unid-negoc    SERIALIZE-NAME "businessUnit"     
    FIELD fm-cod-com                LIKE item.fm-cod-com                SERIALIZE-NAME "comercialFamilly" 
    FIELD cod-ean                   LIKE item-mat.cod-ean               SERIALIZE-NAME "ean"              
    FIELD class-fiscal              LIKE item.class-fiscal              SERIALIZE-NAME "taxClassification".

DEFINE TEMP-TABLE tt-parceiro NO-UNDO SERIALIZE-NAME "parceiro"
    FIELD partnerType                       AS CHARACTER
    FIELD cod-emitente                      LIKE emitente.cod-emitente  SERIALIZE-NAME "customerCode"
    FIELD nome-emit                         LIKE emitente.nome-emit     SERIALIZE-NAME "corporateName"
    FIELD natureza                          AS CHARACTER                SERIALIZE-NAME "nature"
    FIELD taxaPayerICMS                     AS INTEGER                  SERIALIZE-NAME "taxaPayerICMS"
    FIELD taxpayerOptingICMS                AS INTEGER                  SERIALIZE-NAME "taxpayerOptingICMS"
    FIELD cgc                               LIKE emitente.cgc           SERIALIZE-NAME "documentNumber"
    FIELD companyType                       AS CHARACTER                SERIALIZE-NAME "companyType"
    FIELD ins-municipal                     LIKE emitente.ins-municipal SERIALIZE-NAME "municipalRegistration"
    FIELD ins-estadual                      LIKE emitente.ins-estadual  SERIALIZE-NAME "stateRegistration"
    FIELD appointmentRequesAutomatically    AS LOGICAL                  SERIALIZE-NAME "appointmentRequesAutomatically"
    FIELD schedulingType                    AS CHARACTER                SERIALIZE-NAME "schedulingType"
    FIELD birthDate                         AS CHARACTER                SERIALIZE-NAME "birthDate"
    FIELD formCommunicationId               AS CHARACTER                SERIALIZE-NAME "formCommunicationId"
    FIELD formCommunication                 AS CHARACTER                SERIALIZE-NAME "formCommunication"
    FIELD isCharge                          AS LOGICAL                  SERIALIZE-NAME "isCharge"
    FIELD noticeLateCharge                  AS LOGICAL                  SERIALIZE-NAME "noticeLateCharge"
    FIELD confirmationNotice                AS LOGICAL                  SERIALIZE-NAME "confirmationNotice"
    FIELD bairro                            LIKE emitente.bairro        SERIALIZE-NAME "deliveryDistrict"
    FIELD cep                               LIKE emitente.cep           SERIALIZE-NAME "deliveryCep"
    FIELD endereco                          LIKE emitente.endereco      SERIALIZE-NAME "deliveryStreet"
    FIELD cidade                            LIKE emitente.cidade        SERIALIZE-NAME "deliveryCity"
    FIELD estado                            LIKE emitente.estado        SERIALIZE-NAME "deliveryState".


DEFINE TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD cod-estabel                       LIKE estabelec.cod-estabel	                SERIALIZE-HIDDEN
    FIELD partnerType                       AS CHARACTER                                SERIALIZE-NAME "partnerType"
    FIELD customerCode                      AS CHARACTER      	                        SERIALIZE-NAME "customerCode"
    FIELD documentNumber                    LIKE emitente.cgc	                        SERIALIZE-NAME "documentNumber"
    FIELD nr-nota-fis                       LIKE nota-fiscal.nr-nota-fis                SERIALIZE-NAME "invoiceNumber"
    FIELD serie                             LIKE nota-fiscal.serie	                    SERIALIZE-NAME "serie"
    FIELD invoiceType                       AS CHARACTER                                SERIALIZE-NAME "invoiceType"   /* Entrada ou Sa¡da */
    FIELD nat-operacao                      LIKE nota-fiscal.nat-operacao	            SERIALIZE-NAME "operationType"
    FIELD issueDate                         LIKE nota-fiscal.dt-emis-nota	            SERIALIZE-NAME "issueDate"
    FIELD dt-emis-nota                      LIKE nota-fiscal.dt-emis-nota	            SERIALIZE-NAME "registrationDate"
    FIELD dt-saida                          LIKE nota-fiscal.dt-saida	                SERIALIZE-NAME "shipmentDate"
    FIELD senderType                        AS CHARACTER                                SERIALIZE-NAME "senderType"
    FIELD customerCodeSender                LIKE estabelec.cod-emitente	                SERIALIZE-NAME "customerCodeSender"
    FIELD documentNumberSender              LIKE emitente.cgc 	                        SERIALIZE-NAME "documentNumberSender"
    FIELD shippingType                      AS CHARACTER                                SERIALIZE-NAME "shippingType"
    FIELD consumerCodePaymentShipping       AS INTEGER                                  SERIALIZE-NAME "consumerCodePaymentShipping"
    FIELD documentNumberPaymentShipping     AS CHARACTER                                SERIALIZE-NAME "documentNumberPaymentShipping"
    FIELD nr-pedcli                         LIKE nota-fiscal.nr-pedcli	                SERIALIZE-NAME "linkedDocument"
    FIELD customerCodeShippingCompany       LIKE emitente.cod-emitente                  SERIALIZE-NAME "customerCodeShippingCompany"
    FIELD documentNumberShippingCompany     LIKE emitente.cgc       	                SERIALIZE-NAME "documentNumberShippingCompany"
    FIELD via-transp                        LIKE transporte.via-transp	                SERIALIZE-NAME "meansOfTransport"
    FIELD taxOperation                      LIKE nota-fiscal.nat-operacao	            SERIALIZE-NAME "taxOperation"
    FIELD quantityGrossWeight               AS DECIMAL                                  SERIALIZE-NAME "quantityGrossWeight"
    FIELD quantityCubedWeight               AS DECIMAL                                  SERIALIZE-NAME "quantityCubedWeight"
    FIELD quantityNetWeight                 AS DECIMAL                                  SERIALIZE-NAME "quantityNetWeight"
    FIELD kindOfPacking                     AS CHARACTER                                SERIALIZE-NAME "kindOfPacking"
    FIELD quantityVolume                    AS DECIMAL                                  SERIALIZE-NAME "quantityVolume"
    FIELD cod-chave-aces-nf-eletro          LIKE nota-fiscal.cod-chave-aces-nf-eletro   SERIALIZE-NAME "NFEAccessKey"
    FIELD documentIsPreparation             AS LOGICAL                                  SERIALIZE-NAME "documentIsPreparation"
    FIELD documentNeedsCompleted            AS LOGICAL                                  SERIALIZE-NAME "documentNeedsCompleted"
    FIELD shippingPaymentStatus             AS CHARACTER                                SERIALIZE-NAME "shippingPaymentStatus"
    FIELD observation1                      AS CHARACTER                                SERIALIZE-NAME "observation1"
    FIELD observation2                      AS CHARACTER                                SERIALIZE-NAME "observation2"
    FIELD observation3                      AS CHARACTER                                SERIALIZE-NAME "observation3"
    FIELD channelSales                      AS CHARACTER                                SERIALIZE-NAME "channelSales"
    FIELD attendant                         AS CHARACTER                                SERIALIZE-NAME "attendant"
    FIELD commercialApproverUser            AS DATE                                SERIALIZE-NAME "commercialApproverUser"
    FIELD commercialChangeDate              AS DATE                                     SERIALIZE-NAME "commercialChangeDate1"
    FIELD descriptionSalesChannel           AS CHARACTER                                SERIALIZE-NAME "descriptionSalesChannel"
    FIELD implementationDate                AS DATE                                     SERIALIZE-NAME "implementationDate"
    FIELD creditApprovalDate                AS DATE                                     SERIALIZE-NAME "creditApprovalDate"
    FIELD commercialChangeDate1             AS DATE                                     SERIALIZE-NAME "commercialChangeDate"
    FIELD orderDeliveryDate                 AS DATE                                     SERIALIZE-NAME "orderDeliveryDate"
    FIELD airTransportType                  AS CHARACTER                                SERIALIZE-NAME "airTransportType"
    FIELD vtexPartner                       AS CHARACTER                                SERIALIZE-NAME "vtexPartner"
    FIELD vtexOrder                         AS CHARACTER                                SERIALIZE-NAME "vtexOrder"
    FIELD customerOrderNumber               AS CHARACTER                                SERIALIZE-NAME "customerOrderNumber"
    FIELD bairro                            LIKE  nota-fiscal.bairro                    SERIALIZE-NAME "deliveryDistrict"
    FIELD cep                               LIKE  nota-fiscal.cep                       SERIALIZE-NAME "deliveryCep"
    FIELD endereco                          LIKE  nota-fiscal.endereco                  SERIALIZE-NAME "deliveryStreet"
    FIELD cidade                            LIKE  nota-fiscal.cidade                    SERIALIZE-NAME "deliveryCity"
    FIELD estado                            LIKE  nota-fiscal.estado                    SERIALIZE-NAME "deliveryState"
    FIELD redispatchPartnerType             AS CHARACTER                                SERIALIZE-NAME "redispatchPartnerType"  /* Quando tiver Fixo local de redespacho */
    FIELD redispatchCustomerCode            AS CHARACTER                                SERIALIZE-NAME "redispatchCustomerCode"
    FIELD redispatchDocumentNumber          LIKE emitente.cgc                           SERIALIZE-NAME "redispatchDocumentNumber"
    FIELD subsidiaryCarrierDocumentNumber   AS CHARACTER                                SERIALIZE-NAME "subsidiaryCarrierDocumentNumber"
    FIELD carrierCode                       AS INTEGER                                  SERIALIZE-NAME "carrierCode"
    FIELD equipmentCode                     AS CHARACTER                                SERIALIZE-NAME "equipmentCode"
    FIELD transportCode                     AS CHARACTER                                SERIALIZE-NAME "transportCode"
    FIELD contractCode                      AS CHARACTER                                SERIALIZE-NAME "contractCode"
    FIELD redispatchType                    AS CHARACTER                                SERIALIZE-NAME "redispatchType"
    FIELD differentiatedShipping            AS INTEGER                                  SERIALIZE-NAME "differentiatedShipping"
    FIELD position                          AS CHARACTER                                SERIALIZE-NAME "position"
    FIELD shippingStatus                    AS CHARACTER                                SERIALIZE-NAME "shippingStatus".



DEFINE TEMP-TABLE tt-item-nota-fiscal NO-UNDO SERIALIZE-NAME "Itens"
    FIELD cod-estabel                       LIKE estabelec.cod-estabel	                SERIALIZE-HIDDEN
    FIELD cod-emitente                      LIKE estabelec.cod-emitente	                SERIALIZE-HIDDEN
    FIELD nr-nota-fis                       LIKE nota-fiscal.nr-nota-fis                SERIALIZE-HIDDEN
    FIELD serie                             LIKE nota-fiscal.serie                      SERIALIZE-HIDDEN
    FIELD it-codigo                         LIKE it-nota-fisc.it-codigo                 SERIALIZE-NAME "code"
    FIELD nr-seq-fat                        LIKE  it-nota-fisc.nr-seq-fat               SERIALIZE-NAME "invoiceItemNumber"
    FIELD DNEItemValue                      AS CHARACTER                                SERIALIZE-NAME "DNEItemValue"            /* round(item-doc-est.preco-total[1],2) */
    FIELD quantity                          AS CHARACTER                                SERIALIZE-NAME "quantity"                 /* round(it-nota-fisc.qt-faturada[1],2) */
    FIELD unit                              AS CHARACTER                                SERIALIZE-NAME "unit"
    FIELD peso-liq-fat                      AS CHARACTER                                SERIALIZE-NAME "quantityNetWeight"
    FIELD quantityCubedWeight               AS DECIMAL                                  SERIALIZE-NAME "quantityCubedWeight"
    FIELD peso-bruto                        AS CHARACTER                                SERIALIZE-NAME "quantityGrossWeight"
    FIELD cubageValue                       AS CHARACTER                                SERIALIZE-NAME "cubageValue"
    FIELD quantityVolume                    AS INTEGER                                  SERIALIZE-NAME "quantityVolume"
    FIELD costCenterCode                    AS CHARACTER                                SERIALIZE-NAME "costCenterCode"
    FIELD accountingAccount                 AS CHARACTER                                SERIALIZE-NAME "accountingAccount"
    FIELD shippingCanceled                  AS LOGICAL                                  SERIALIZE-NAME "shippingCanceled"
    FIELD ICMSCreditStatus                  AS LOGICAL                                  SERIALIZE-NAME "ICMSCreditStatus"
    FIELD taxStatus1                        AS LOGICAL                                  SERIALIZE-NAME "taxStatus1"
    FIELD taxStatus2                        AS LOGICAL                                  SERIALIZE-NAME "taxStatus2"
    FIELD taxStatus3                        AS LOGICAL                                  SERIALIZE-NAME "taxStatus3".
    










        
        
        
        
	    
        
        
        
