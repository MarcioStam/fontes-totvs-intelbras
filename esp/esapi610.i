assign jCatalogo = new JsonObject().
jCatalogo:add("productId",item.it-codigo).
jCatalogo:add("completeName",trim(replace(int-item.desc-completa + " / " + ITEM.desc-inter,'"',''))).
jCatalogo:add("unitMeasure",item.un).
jCatalogo:add("materialGroupID",item.fm-codigo).
jCatalogo:add("shortName",trim(replace(item.desc-item,'"',''))).

jArrayCatalogo:add(jCatalogo).

