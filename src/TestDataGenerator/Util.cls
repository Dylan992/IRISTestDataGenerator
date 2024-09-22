/// 
Class TestDataGenerator.Util
{

/// d ##class(TestDataGenerator.Util).Run()
ClassMethod Run() As %Status
{	
	 zn "%sys"
	 Set props("Database")="USER",sc=##Class(Config.MapPackages).Create("%ALL","TestDataGenerator",.props)
	 Set property("AutheEnabled")=64,property("IsNameSpaceDefault")=0,property("MatchRoles")="%All:%All,:%All",property("GroupById")="%ISCMgtPortal",property("NameSpace")="USER",property("DeepSeeEnabled")=1,property("DispatchClass")="TestDataGenerator.Rest.Api"
	 Set tSC=##Class(Security.Applications).Create("/API",.property)
}

}

