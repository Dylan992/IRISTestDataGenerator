/// 
Class TestDataGenerator.DB.UserTest Extends %Persistent
{

/// name
Property name As %String(MAXLEN = 256000);

Property email As %String(MAXLEN = 256000);

Property addr As %String(MAXLEN = 256000);

Property telphone As %String(MAXLEN = 256000);

Property corporateName As %String(MAXLEN = 256000);

Property notes As %String(MAXLEN = 256000);

Storage Default
{
<Data name="UserTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>email</Value>
</Value>
<Value name="4">
<Value>addr</Value>
</Value>
<Value name="5">
<Value>telphone</Value>
</Value>
<Value name="6">
<Value>corporateName</Value>
</Value>
<Value name="7">
<Value>notes</Value>
</Value>
</Data>
<DataLocation>^TestDataGenerator.DB.UserTestD</DataLocation>
<DefaultData>UserTestDefaultData</DefaultData>
<ExtentSize>2</ExtentSize>
<IdLocation>^TestDataGenerator.DB.UserTestD</IdLocation>
<IndexLocation>^TestDataGenerator.DB.UserTestI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="addr">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.999999:1</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="corporateName">
<AverageFieldSize>3.5</AverageFieldSize>
<OutlierSelectivity>.999999:12</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="email">
<AverageFieldSize>5</AverageFieldSize>
<OutlierSelectivity>.999999:"2w1"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="name">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.999999:1</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="notes">
<AverageFieldSize>3.5</AverageFieldSize>
<OutlierSelectivity>.999999:12</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="telphone">
<AverageFieldSize>5</AverageFieldSize>
<OutlierSelectivity>.999999:"2w1"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^TestDataGenerator.DB.UserTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

