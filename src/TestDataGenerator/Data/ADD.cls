Class TestDataGenerator.Data.ADD
{

/// d ##class(TestDataGenerator.Data.ADD).Run()
ClassMethod Run()
{

	s namespace="%sys"
	Set rule=[{"key":"name","method":"Enum","parm":["abc,wed,qwd,sdqawd"]},{"key":"addr","method":"RandomText","parm":[100,200]}]
	Set abc= ..add(namespace,"TestDataGenerator_DB","UserTest",20,rule)
	zw abc
#;	w abc.%ToJSON()
}

ClassMethod add(namespace, schame, table, count, rule)
{
	Set template =##class(TestDataGenerator.Util.Result).%New()
	Try{
		Set this=$namespace
		Set tableName =schame_"."_table
		// 
		Set parms =0
		Set num = rule.%Size()
		Set colum="",value=""
		Set iter= rule.%GetIterator()	
		while iter.%GetNext(.columnKey , .columnObj )	
		{
			// Retrieve fields and mapping information
			Set key(columnKey)=columnObj.key
			Set method(columnKey)=columnObj.method
			set parms(columnKey)=columnObj.parm
		}
		for j=1:1:count{
			Set columns="",values="", i=0
			kill parm
			for{
				Set i =i+1
				if i>num quit
				set methodi=method(i-1)
				set parmsi=parms(i-1)
				Set parmIter= parmsi.%GetIterator()	
				while parmIter.%GetNext(.parmKey , .parmValue ){
					Set parm=parmKey+1
					Set parm(parmKey+1)=parmValue				
				}

				Set:$L(columns)'=0 columns =columns_","_key(i-1)
				Set:$L(columns)=0 columns =key(i-1)
				s parm(i)=$CLASSMETHOD("TestDataGenerator.Generator.Currency",methodi,parm...)
				S parm=i
				Set:$L(values)'=0 values =values_","_"?"
				Set:$L(values)=0 values ="?"

			}
			if $namespace'=namespace{
				
				new $namespace
				Set $namespace= namespace
			}
			set sql="Insert into "_tableName_"( "_columns_" ) values ( "_values_" )"
			Set tStatement = ##class(%SQL.Statement).%New()
		    Set qStatus = tStatement.%Prepare(sql)
		    Set tResult = tStatement.%Execute(parm...)

			Set SQLCODE =tResult.%SQLCODE
			Set Message =tResult.%Message
			if SQLCODE '=0{
				return template.Result(SQLCODE,{},0,Message)
			}
		
		}
		
		new $namespace
		Set $namespace= this
		
		
	}Catch e{
		Set msg=e.DisplayString()
		return template.Result(500,{},0,msg)
	}
	
		return template.Result(200,{},1,"Data generation successful")
}

}

