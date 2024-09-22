Class TestDataGenerator.Util.Result Extends %RegisteredObject
{

Method OK(data As %RegisteredObject, msg As %String = "") As %String
{

	Set jsonObject = ##class(%DynamicObject).%New()
	Set jsonObject.code="200"
	Set jsonObject.data=data
	Set jsonObject=jsonObject.%Set("success",1,"boolean")
	Set jsonObject.msg="Operation successful !"
	Set:$L(msg)'=0 jsonObject.msg=msg
	Quit jsonObject.%ToJSON()
}

Method ERROR(msg As %String = "") As %String
{
	Set jsonObject = ##class(%DynamicObject).%New()
	Set jsonObject.code="500"
	Set jsonObject=jsonObject.%Set("success",0,"boolean")
	Set jsonObject.msg="No data available at the moment !"
	Set:$L(msg)'=0 jsonObject.msg=msg
	Quit jsonObject.%ToJSON()
}

///   success: 1 --> true    0 --> false
Method Result(code As %String, data As %RegisteredObject, success As %String, msg As %String = "") As %String
{
	Set jsonObject = ##class(%DynamicObject).%New()
	Set jsonObject.code=code
	Set:data.%Size()'=0 jsonObject.data=data
	Set jsonObject=jsonObject.%Set("success",success,"boolean")
	Set jsonObject.msg="Operation successful !"
	Set:$L(msg)'=0 jsonObject.msg=msg
	Quit jsonObject.%ToJSON()
}

}

