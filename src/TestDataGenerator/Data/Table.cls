/// 
Class TestDataGenerator.Data.Table
{

/// d ##class(TestDataGenerator.Data.Table).Run()
ClassMethod Run()
{
	Set abc= ..GetTable()
	#; Set abc= ..GetFieldName("TestDataGenerator_DB","User")
	zw abc
#;	w abc.%ToJSON()
}

/// Get table name
ClassMethod GetTable(namespace)
{
	set:$L(namespace)'=0 $NAMESPACE =namespace
	new $NAMESPACE
	Set template =##class(TestDataGenerator.Util.Result).%New()
	Set data=[],obj={}
	Set name="",schame="",total=0
	&sql(DECLARE C1 CURSOR FOR
		 SELECT  TABLE_SCHEMA, TABLE_NAME 
		 INTO :schame,:name
		 FROM INFORMATION_SCHEMA.TABLES 
		 WHERE TABLE_TYPE='BASE TABLE' )

	 &sql(OPEN C1)
	      QUIT:(SQLCODE'=0)
	 &sql(FETCH C1)
		
	 While (SQLCODE = 0) {
		 Set result ={}
		 Set result.id=%ROWID
		 Set result.num=%ROWCOUNT
		 Set result.name=name
		 Set result.schame=schame
		 Set result.tableName=schame_"."_name
		 Set total =%ROWCOUNT
		 d data.%Push(result)
	    &sql(FETCH C1)
	 }
 	&sql(CLOSE C1)
	Set obj.data=data
	Set obj.total=total
 	return template.OK(obj,)
}

/// get filed name
ClassMethod GetFieldName(tableSchame, tableName, namespace)
{
	set:$L(namespace)'=0 $NAMESPACE =namespace
	new $NAMESPACE
	Set template =##class(TestDataGenerator.Util.Result).%New()
	Set data=[],obj={}
	Set cName="",type="",schame="",total=0
	&sql(DECLARE C1 CURSOR FOR
		SELECT COLUMN_NAME,DATA_TYPE,DESCRIPTION 
		    INTO :cName,:type,:description 
			FROM INFORMATION_SCHEMA.COLUMNS 
			where TABLE_SCHEMA=:tableSchame AND TABLE_NAME=:tableName
	)
	 &sql(OPEN C1)
	      QUIT:(SQLCODE'=0)
	 &sql(FETCH C1)	
	 While (SQLCODE = 0) {
		 Set result ={}
		 Set result.columnName=cName
		 Set result.type=type
		 Set result.description=description
		 Set total =%ROWCOUNT
		 d data.%Push(result)
	    &sql(FETCH C1)
	 }
	&sql(CLOSE C1)	
	Set obj.data=data
	Set obj.total=total

	return template.OK(obj,)
}

ClassMethod GetNameSpace()
{
	Set template =##class(TestDataGenerator.Util.Result).%New()
	Set namespaces = ##class(%SYS.Namespace).ListAll(.a)
	set data=[]
  	Set ns=""
	For {
		Set ns=$o(a(ns)) If ns=""  Quit
		Set obj ={}
		Set obj.namespace =ns
        d data.%Push(obj)
	}
	return template.OK(data,)
}

}

