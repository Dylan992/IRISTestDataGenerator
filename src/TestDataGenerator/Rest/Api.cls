/// 
Class TestDataGenerator.Rest.Api Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

Parameter CONTENTTYPE = "application/json";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

ClassMethod HandleDefaultCorsRequest(pUrl As %String) As %Status [ Private ]
{
    Do %response.SetHeader("Access-Control-Allow-Origin","*")
    Do %response.SetHeader("Access-Control-Allow-Credentials","true")
    Do %response.SetHeader("Access-Control-Allow-Methods","GET, PUT, POST, DELETE, PATCH, OPTIONS")
    Do %response.SetHeader("Access-Control-Allow-Headers","Access-Control-*, Content-Type, Authorization, Accept, Accept-Language, X-Requested-With, Origin")
    
    Quit $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Map Prefix="/Data" Forward="TestDataGenerator.Interface.Table"/>
  <Map Prefix="/Generator" Forward="TestDataGenerator.Interface.Generator"/>
</Routes>
}

}

