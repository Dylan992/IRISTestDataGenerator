/// 
Class TestDataGenerator.Interface.Table Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

ClassMethod GetStatus(ser As %String) As %Status
{
     Quit $$$OK
}

ClassMethod Table(Method As %String) As %Status
{
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content="",message=""
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
		if Method = "GetTable"{
			Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Data.Table).GetTable(json.namespace)
		}
		elseif Method ="GetFieldName"{
			Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Data.Table).GetFieldName(json.tableSchame,json.tableName,json.namespace)
		}
		elseif Method ="GetNameSpace"{
			Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Data.Table).GetNameSpace()
		}
		ELSE{

			Set template =##class(TestDataGenerator.Util.Result).%New()
			Set message=template.ERROR("Method does not exist!")
		}
		
	   	
	}Catch(e){
		Set template =##class(TestDataGenerator.Util.Result).%New()
		Set message=template.ERROR(e.DisplayString())
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

ClassMethod Mock(Method As %String) As %Status
{
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content="",message=""
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
		if Method = "add"{
			Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Data.ADD).add(json.namespace,json.schame,json.table,json.count,json.rule)
		}
		ELSE{
			
			Set template =##class(TestDataGenerator.Util.Result).%New()
			Set message=template.ERROR("Method does not exist!")
		}
		
	   	
	}Catch(e){
		Set template =##class(TestDataGenerator.Util.Result).%New()
		Set message=template.ERROR(e.DisplayString())
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
 <Route Url="/*" Method="OPTIONS" Call="Status"/>
  <Route Url="/Table/:Method" Method="POST" Call="Table"/>
  <Route Url="/Mock/:Method" Method="POST" Call="Mock"/>
</Routes>
}

}

