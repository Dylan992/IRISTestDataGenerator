/// 
Class TestDataGenerator.Generator.Currency
{

/// d ##class(TestDataGenerator.Generator.Currency).Run()
ClassMethod Run()
{
	zw "START"
	#; set msg =..Enum("apple,banana,cherry")
	#; set msg =..UUID()
#;	set msg =..Number(-10,100,3,3)
	set msg =..DayTime("2024-01-01 00:00:00","2024-01-05 00:00:00",1)
#;	set msg =..Time("08:00:00","10:00:00")
	#; set msg =..RandomText(300,300)
	 zw msg
}

ClassMethod Faker() [ Language = python ]
{
	from faker import Faker
	fake = Faker([ 'zh_CN', 'en_US'])
#	fake.name()
#	fake.address()
	msg =fake.name()
#	msg=fake.Generator.format('name')
	return msg
}

/// Randomly return one of the enumerated types
ClassMethod Enum(string) [ Language = python ]
{
from faker import Faker
from faker.providers import DynamicProvider

medical_professions_provider = DynamicProvider(
     provider_name="medical_profession",
     elements=[item.strip().lower() for item in string.split(',')],
)

fake = Faker()

# then add new provider to faker instance
fake.add_provider(medical_professions_provider)

return fake.medical_profession()
}

/// Generate random numbers
ClassMethod Number(start, end, type, decimal = "") [ Language = python ]
{

from faker import Faker
import random

fake = Faker()
    
if type == 1:
	#Generate integers within the range
    return fake.random_int(min=start, max=end)
else:
	#Generate decimals within the range and dynamically preserve accuracy
	num =round(random.uniform(start, end), decimal)
	format_str = f"{{:.{decimal}f}}"
	# Format floating-point numbers to a specified precision
	return format_str.format(num)
}

/// Generate random date and time within a given time range.
/// Parameters:
/// start (str): Start date in the format of 'YYYY-MM-DD HH: MM: SS'
/// end   (str): End date in the format of 'YYYY-MM-DD HH: MM: SS'
/// type : 
///     1: '%Y%m%d%H%M%S',
///     2: '%Y-%m-%d %H:%M:%S',
///     3: '%d/%m/%Y %I:%M %p',
///     4: '%B %d, %Y %H:%M'
///     5: '%Y-%m-%d'
ClassMethod DayTime(start, end, type = 1) [ Language = python ]
{
from faker import Faker
from datetime import datetime

def get_date_format(type):
    # Define a dictionary mapping type to date format
    switcher = {
        1: '%Y%m%d%H%M%S',
        2: '%Y-%m-%d %H:%M:%S',
        3: '%d/%m/%Y %I:%M %p',
        4: '%B %d, %Y %H:%M',
        5: '%Y-%m-%d'
    }
    return switcher.get(type, '%Y-%m-%d %H:%M:%S')	
	
def generate_random_datetime(start_date, end_date,type):
    # Create Faker instanceCreate Faker instance
    fake = Faker()

    date_format =  get_date_format(type)
    
    # Convert string date to timestamp object
    start_dt = datetime.strptime(start_date, '%Y-%m-%d %H:%M:%S')
    end_dt   = datetime.strptime(end_date, '%Y-%m-%d %H:%M:%S')

    # Generate a random date and time within a given range
    random_datetime = fake.date_time_between(start_date=start_dt, end_date=end_dt)
    
    # Return formatted date and time string
    daytime =random_datetime.strftime(date_format)
    return daytime

random_datetime = generate_random_datetime(start, end,type)

return random_datetime
}

/// Generate random time within a given time range.
/// Parameters:
/// start (str): Start date in the format of 'HH: MM: SS'
/// end   (str): End date in the format of 'HH: MM: SS'
ClassMethod Time(start, end) [ Language = python ]
{
from faker import Faker
from datetime import datetime, time, timedelta
import random

fake = Faker()

def random_time_within_range(start_time, end_time):
	#Generate a random date
    random_date = fake.date_time_this_century()
    
	#Convert start and end times to timestamp objects
    start_datetime = datetime.combine(random_date, start_time)
    end_datetime = datetime.combine(random_date, end_time)
    
	#Calculate the total number of seconds within the time range
    delta = end_datetime - start_datetime
    total_seconds = delta.total_seconds()
    
	#Generate random seconds
    random_seconds = random.randint(0, int(total_seconds))
    
	#Create random time
    random_datetime = start_datetime + timedelta(seconds=random_seconds)
    return random_datetime.time()

start_time = datetime.strptime(start, "%H:%M:%S").time()
end_time = datetime.strptime(end, "%H:%M:%S").time()

random_time = random_time_within_range(start_time, end_time)
return str(random_time)
}

ClassMethod Regex(regexString) [ Language = python ]
{
	from xeger import Xeger

	# Create Xeger instance
	xeger = Xeger()

	# Define regular expressions
	regex = regexString  

	# Generate random data that conforms to regular expressions
	generated_data = xeger.xeger(regex)

	return generated_data
}

ClassMethod UUID() [ Language = python ]
{
from xeger import Xeger

# Creat Xeger 
xeger = Xeger()

# Define regular expressions
regex = r'([0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12})'  


# Generate random data that conforms to regular expressions
generated_data = xeger.xeger(regex)
return generated_data
#; print(f"Generated Data: {generated_data}")
}

ClassMethod UUID1(abc) [ Language = python ]
{
from xeger import Xeger

# Creat Xeger 
xeger = Xeger()

# Define regular expressions
regex = r'([0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12})'  


# Generate random data that conforms to regular expressions
generated_data = xeger.xeger(regex)
return generated_data
#; print(f"Generated Data: {generated_data}")
}

ClassMethod RandomText(min, max) [ Language = python ]
{
	from faker import Faker
	import random

	faker = Faker()
	text = faker.text(max_nb_chars=max)
	    
	while len(text) < min:
	     text += ' ' + faker.sentence()
	    
	return text[:max]
}

}

