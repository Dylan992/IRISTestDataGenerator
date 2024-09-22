Class TestDataGenerator.Interface.Generator Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

ClassMethod GetStatus(ser As %String) As %Status
{
     Quit $$$OK
}

ClassMethod Generator(Method As %String) As %Status
{
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{

		Set content="",message=""
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
		if Method = "Enum"{
            Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Generator.Currency).Enum(json.enum)
		}
		elseif Method ="Number"{
			Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Generator.Currency).Number(json.start+0,json.end+0,json.type+0,json.decimal+0)
		}
        elseif Method ="RandomText"{
			Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Generator.Currency).RandomText(json.start+0,json.end+0)
		}
       
        elseif Method ="Regex"{
			Set message = ##class(TestDataGenerator.Generator.Currency).Regex(content)
		}
        elseif Method ="UUID"{
			Set message = ##class(TestDataGenerator.Generator.Currency).UUID()
		}
        elseif Method ="DayTime"{
            Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Generator.Currency).DayTime(json.start,json.end,json.type)
		}elseif Method ="Time"{
            Set json ={}.%FromJSON(content)
			Set message = ##class(TestDataGenerator.Generator.Currency).Time(json.start,json.end)
		}
        
        ELSE{
			zw Method
			Set template =##class(TestDataGenerator.Util.Result).%New()
			Set message=template.ERROR("Method does not exist!")
		}
		
	   	
	}Catch(e){
        zw "ERROR"
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
 <Route Url="/Methods/:Method" Method="POST" Call="Generator"/>
</Routes>
}

}

