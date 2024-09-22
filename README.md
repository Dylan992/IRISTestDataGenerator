# IRIS Test Data Generator

Used to generate test data

### Describe 

- 1. First, select the namespace
- 2. Select the table that needs to generate test data
- 3. Select the corresponding fields on the left and the rules on the right. After selecting, click the "Generate Data" button to generate test data

---

### Currently supports generating the following types of data


- Text
- Number
- Enum
- UUID
- regular expression 
- Multiple date and time formats
   - 1: '%Y%m%d%H%M%S',
   - 2: '%Y-%m-%d %H:%M:%S',
   - 3: '%d/%m/%Y %I:%M %p',
   - 4: '%B %d, %Y %H:%M'
   - 5: '%Y-%m-%d'
- Time
## How to use it

### Prerequisites
Make sure you have git and Docker desktop installed.
### Installation
#### 1.Clone/git pull the repo into any local directory
```
git clone https://github.com/Dylan992/IRISTestDataGenerator.git
```  
#### Open the terminal in this directory and run

```
docker-compose build
```
#### Run the IRIS container 

```
docker-compose up -d
```
