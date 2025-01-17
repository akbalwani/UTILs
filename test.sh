
#!/bin/sh
filename=Private_accounts_psotest.txt
#sturl="https://stback.dev.brighthouse.na.axway.cloud:444"
#sturl="https://stback-1.ppr.brighthouse.na.axway.cloud:444"
sturl="https://stback-2.prd.brighthouse.na.axway.cloud:444"
curl -s -k -X GET "$sturl/api/v2.0/accounts/?idp_id=ST_IDP&fields=name,homeFolderAccessLevel&limit=250" -H "accept: application/json" -H "Authorization: Basic YWtiYWx3YW5pOkF4d2F5cHNvQDEyMzQ=" | jq .result | jq '.[]| select(.homeFolderAccessLevel != "PUBLIC") | .name' | tr -d '"' >Private_accounts.txt

echo "Private accounts dumped in file Private_accounts.txt"


make_public(){
 for i in $(cat $filename)
 do echo "name $i"
	curl -k -X 'PATCH' \
		  "$sturl/api/v2.0/accounts/$i?idp_id=ST_IDP&ownershipChangeMode=recursive" \
		    -H 'Content-Type: application/json' \
		    -H 'Authorization: Basic YWtiYWx3YW5pOkF4d2F5cHNvQDEyMzQ=' \
		      -d '[
	  {
		      "op": "replace",
		          "path": "/homeFolderAccessLevel",
			      "value": "PUBLIC"
			        }
				]'
done;
}


#make_public()
