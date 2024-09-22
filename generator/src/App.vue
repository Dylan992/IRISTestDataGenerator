<template>
  <div id="app">
    <div class="container">
      <div class="left-panel">
        <div>
          <el-form ref="form" label-width="200px">
            <el-form-item label="Please select namespace">
              <el-select
                v-model="selectedName"
                placeholder="Please select namespace"
                @change="getTable"
              >
                <el-option
                  v-for="(namespace, index) in namespaces"
                  :key="index"
                  :label="namespace.namespace"
                  :value="namespace.namespace"
                >
                </el-option>
              </el-select>
            </el-form-item>
          </el-form>
          <!-- search -->
          <el-input
            style="padding: 10px"
            v-model="searchQuery"
            placeholder="Search Table"
            clearable
            @input="filterTreeData"
          >
          </el-input>
        </div>
        <el-tree
          class="tree-wrapper"
          :data="filteredTreeData"
          :props="defaultProps"
          :load="loadNode"
          lazy
          show-checkbox
          @check-change="handleCheckChange"
          @node-click="echo"
          node-key="id"
        ></el-tree>
      </div>

      <div class="right-panel">
        <!-- Select Type -->
        <div>
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="Select type">
              <el-select
                v-model="selectedType"
                placeholder="Please select type"
                @change="generateContent"
              >
                <el-option label="text" value="text"></el-option>
                <el-option label="digit" value="number"></el-option>
                <el-option label="regular expression" value="regex"></el-option>
                <el-option label="uuid" value="uuid"></el-option>
                <el-option label="enumeration" value="enum"></el-option>
                <el-option label="date" value="date"></el-option>
                <el-option label="time" value="time"></el-option>
              </el-select>
            </el-form-item>
          </el-form>
        </div>

        <!-- Text Type Options -->
        <div v-if="selectedType === 'text'">
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="character in range">
              <el-input-number
                v-model="minChars"
                :min="1"
                placeholder="Minimum Character Count"
                @change="generateContent"
              ></el-input-number>
              --
              <el-input-number
                v-model="maxChars"
                :min="1"
                @change="generateContent"
                placeholder="Maximum number of characters"
              ></el-input-number>
            </el-form-item>
          </el-form>
        </div>

        <div v-if="selectedType === 'number'">
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="Numeric Range">
              <el-input-number
                @change="generateContent"
                v-model="minNumber"
                placeholder="minimum value"
              ></el-input-number>
              --
              <el-input-number
                @change="generateContent"
                v-model="maxNumber"
                placeholder="Maximum value"
              ></el-input-number>
            </el-form-item>

            <!-- Checkbox Option for Including Decimal -->
            <el-form-item>
              <el-checkbox
                v-model="includeDecimal"
                @change="handleDecimalChange"
                >Contains decimals</el-checkbox
              >

              <!-- Only show this when "includeDecimal" is true -->
              <el-input-number
                style="margin-left: 20px"
                v-model="decimalPlaces"
                :min="0"
                :max="10"
                @change="generateContent"
                v-if="includeDecimal"
                placeholder="Decimal places"
              ></el-input-number>
            </el-form-item>
          </el-form>
        </div>

        <!-- Regex Type Options -->
        <div v-if="selectedType === 'regex'">
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="regular expression">
              <el-input
                v-model="regexPattern"
                @change="generateContent"
                placeholder="Enter regular expression"
              ></el-input>
            </el-form-item>
          </el-form>
        </div>

        <!-- UUID Type -->
        <div v-if="selectedType === 'uuid'"></div>

        <!-- Enum Type Options -->
        <div v-if="selectedType === 'enum'">
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="Enumeration values">
              <el-input
                v-model="enumValues"
                @change="generateContent"
                placeholder="Input enumeration values"
              ></el-input>
            </el-form-item>
          </el-form>
        </div>

        <!-- Date Type Options -->
        <div v-if="selectedType === 'date'">
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="Date Range">
              <el-date-picker
                v-model="minDate"
                @change="generateContent"
                type="date"
                placeholder="Min Date"
              ></el-date-picker>
              --
              <el-date-picker
                v-model="maxDate"
                type="date"
                @change="generateContent"
                placeholder="Maximum date"
              ></el-date-picker>
            </el-form-item>

            <!-- Type Selection -->
            <el-form-item label="Type Selection">
              <el-select
                v-model="dateType"
                placeholder="Please select type"
                @change="generateContent"
              >
                <el-option label="%Y%m%d%H%M%S" :value="1"></el-option>
                <el-option label="%Y-%m-%d %H:%M:%S" :value="2"></el-option>
                <el-option label="%d/%m/%Y %I:%M %p" :value="3"></el-option>
                <el-option label="%B %d, %Y %H:%M" :value="4"></el-option>
                <el-option label="%Y-%m-%d" :value="5"></el-option>
              </el-select>
            </el-form-item>
          </el-form>
        </div>

        <div v-if="selectedType === 'time'">
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="Time frame">
              <el-time-picker
                is-range
                v-model="time"
                range-separator="to"
                start-placeholder="time-on"
                end-placeholder="End Time"
                placeholder="Select a time range"
                @change="changeTime"
              >
              </el-time-picker>
            </el-form-item>
          </el-form>
        </div>

        <!-- Content Preview -->
        <div>
          <el-form ref="form" label-width="150px" label-position="left">
            <el-form-item label="Preview">
              <el-input
                type="textarea"
                :value="contentPreview"
                readonly
              ></el-input>
            </el-form-item>
          </el-form>
        </div>
        <div style="position: relative; width: 100%; margin-top: 10%">
          <el-form
            style="position: absolute"
            ref="form"
            label-width="150px"
            label-position="left"
          >
            <el-form-item label="Generate Count">
              <el-input-number
                v-model="count"
                :min="1"
                label="Generate Count"
                size="small"
              ></el-input-number>
            </el-form-item>
          </el-form>

          <el-row style="display: flex; justify-content: center">
            <el-button type="primary" round @click="submit">
              Generate Data
            </el-button>
          </el-row>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      namespaces: [],
      namespace: "USER",
      selectedName: "USER",
      searchQuery: "",
      key: "",
      selectedType: "text",
      selectedNode: null,
      minChars: 10,
      maxChars: 50,
      minNumber: 0,
      maxNumber: 100,
      regexPattern: "[a-z]{5}",
      enumValues: "apple,banana,cherry",
      minDate: "2023-01-01",
      maxDate: "2023-12-31",
      contentPreview: "",
      includeDecimal: false,
      UUID: "",
      type: 1,
      decimalPlaces: 0,
      nullPercentage: 0,
      defaultPercentage: 0,
      time: [new Date(2016, 9, 10, 8, 40), new Date(2016, 9, 10, 9, 40)],
      startTime: "08:40:00",
      endTime: "09:40:00",
      dateType: 1,
      treeData: [],
      filteredTreeData: [],
      selectedRows: [],
      tableSchame: "",
      rules: [],
      count: 10,
      tableName: "",
      defaultProps: {
        children: "children",
        label: "tableName",
        hasChildren: (node) => {
          // Only allow first-level nodes to have children
          return node.level === 1 && node.hasChildren === true;
        },
      },
    };
  },
  methods: {
    loadNode(node, resolve) {
      if (node.level === 0) {
        // If it's a root node, resolve tree data
        resolve(this.treeData);
      } else if (node.level === 1) {
        // Only load children for first-level nodes
        const tableSchame = node.data.schame;
        const tableName = node.data.name;
        this.tableSchame = node.data.schame;
        this.tableName = node.data.name;

        // API call to get child nodes (i.e., field data)
        axios
          .post("/API/Data/Table/GetFieldName", {
            tableSchame: tableSchame,
            tableName: tableName,
          })
          .then((res) => {
            if (res.data.code === "200") {
              // Map the returned data to tree node format
              const children = res.data.data.data.map((field, index) => {
                return {
                  id: node.data.id + "-" + (index + 1), // Generate unique ID for child nodes
                  tableName: field.columnName, // Column name to display
                  description: field.description, // Optional: description as a tooltip or hint
                  hasChildren: false, // Second-level nodes (fields) cannot be expanded further
                };
              });
              resolve(children); // Load child nodes
            } else {
              console.error("Failed to load field names:", res.data.message);
            }
          })
          .catch((error) => {
            console.error("API Error:", error);
          });
      } else {
        // For second-level nodes or beyond, resolve with an empty array to prevent expansion
        resolve([]);
      }
    },

    handleCheckChange(node) {
      this.key = node.tableName;
      console.log(this.key);

      const rule = {
        key: this.key,
        method: "",
        parm: [],
      };
      console.log(this.selectedType + "1");

      if (this.selectedType === "text") {
        rule.method = "RandomText";
        rule.parm = [this.minChars, this.maxChars];
      } else if (this.selectedType === "number") {
        rule.method = "Number";
        rule.parm = [
          this.minNumber,
          this.maxNumber,
          this.type,
          this.decimalPlaces,
        ];
      } else if (this.selectedType === "enum") {
        rule.method = "Enum";
        rule.parm = [this.enumValues];
      } else if (this.selectedType === "regex") {
        rule.method = "Regex";
        rule.parm = [this.regexPattern];
      } else if (this.selectedType === "uuid") {
        rule.method = "UUID1";
        rule.parm = [this.UUID];
      } else if (this.selectedType === "date") {
        const minDate = new Date(this.minDate);
        const maxDate = new Date(this.maxDate);
        rule.method = "DayTime";
        rule.parm = [
          this.formatDate(minDate),
          this.formatDate(maxDate),
          this.dateType,
        ];
      } else if (this.selectedType === "time") {
        rule.method = "Time";
        rule.parm = [this.startTime, this.endTime];
      }

      const existingRuleIndex = this.rules.findIndex((r) => r.key === rule.key);

      if (existingRuleIndex > -1) {
        this.rules[existingRuleIndex] = rule;
      } else {
        this.rules.push(rule);
      }

      console.log("Current Rules:", this.rules);

      this.selectedType = "text";
      this.minChars = "10";
      this.maxChars = "50";
      this.minNumber = "0";
      this.maxNumber = "100";
      this.regexPattern = "[a-z]{5}";
      this.enumValues = "apple,banana,cherry";
      this.minDate = "2023-01-01";
      this.maxDate = "2023-12-31";
    },
    getRuleByKey(key) {
      const rule = this.rules.find((r) => r.key === key);
      if (rule) {
        console.log(rule);

        this.selectedType = rule.method;
        this.key = rule.key;

        switch (rule.method) {
          case "RandomText":
            [this.minChars, this.maxChars] = rule.parm;
            this.selectedType = "text";
            this.generateContent();
            break;
          case "Number":
            [this.minNumber, this.maxNumber, this.type, this.decimalPlaces] =
              rule.parm;
            this.selectedType = "number";
            this.generateContent();

            break;
          case "Enum":
            this.enumValues = rule.parm[0];
            this.selectedType = "enum";
            this.generateContent();
            break;
          case "Regex":
            this.regexPattern = rule.parm[0];
            this.selectedType = "regex";
            this.generateContent();
            break;
          case "UUID1":
            this.UUID = rule.parm[0];
            this.selectedType = "uuid";
            this.generateContent();
            break;
          case "DayTime":
            // 需要分解参数
            [this.minDate, this.maxDate, this.dateType] = rule.parm;
            this.selectedType = "date";
            this.generateContent();
            break;
          case "Time":
            [this.startTime, this.endTime] = rule.parm;
            this.selectedType = "time";
            this.generateContent();
            break;
        }
      }
    },
    filterTreeData() {
      if (this.searchQuery.trim() === "") {
        this.filteredTreeData = this.treeData;
      } else {
        this.filteredTreeData = this.treeData.filter((node) =>
          node.tableName.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      }
    },
    generateContent() {
      console.log(this.selectedType);

      switch (this.selectedType) {
        case "text":
          this.generateText();
          break;
        case "number":
          this.generateNumber();
          break;
        case "regex":
          this.generateRegex();
          break;
        case "uuid":
          this.generateUUID();
          break;
        case "enum":
          this.generateEnum();
          break;
        case "date":
          this.generateDate();
          break;
        case "time":
          this.generateTime();
          break;
      }
    },
    generateText() {
      const start = this.minChars;
      const end = this.maxChars;

      axios
        .post("/API/Generator/Methods/RandomText", { start, end })
        .then((res) => {
          if (res.status === 200) {
            this.contentPreview = res.data;
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    handleDecimalChange() {
      if (this.includeDecimal) {
        this.type = 0; // Set type to 1 when decimals are included
      } else {
        this.type = 1; // Reset to 0 if decimals are not included
      }
      this.generateContent(); // Regenerate content when decimal option changes
    },
    generateNumber() {
      const start = this.minNumber;
      const end = this.maxNumber;
      const type = this.type; // Use the updated type value
      const decimal = this.decimalPlaces;

      // Include decimal places if the option is selected
      axios
        .post("/API/Generator/Methods/Number", {
          start,
          end,
          type,
          decimal,
        })
        .then((res) => {
          if (res.status === 200) {
            this.contentPreview = res.data;
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    generateRegex() {
      const regexPattern = this.regexPattern;
      console.log(regexPattern);

      axios
        .post("/API/Generator/Methods/Regex", { pattern: regexPattern })
        .then((res) => {
          console.log(res);

          if (res.status === 200) {
            this.contentPreview = res.data.pattern;
          } else {
            console.error("Failed to generate content:", res.data.message);
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    clear() {
      this.contentPreview = "";
    },
    echo(node) {
      this.getRuleByKey(node.tableName);
    },
    generateUUID() {
      axios
        .post("/API/Generator/Methods/UUID")
        .then((res) => {
          if (res.status === 200) {
            this.contentPreview = res.data;
            this.UUID = res.data;
          } else {
            console.error("Failed to generate content:", res.data.message);
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    generateEnum() {
      const enumValues = this.enumValues;
      axios
        .post("/API/Generator/Methods/Enum", { enum: enumValues })
        .then((res) => {
          console.log(res);

          if (res.status === 200) {
            this.contentPreview = res.data;
          } else {
            console.error("Failed to generate content:", res.data.message);
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    generateDate() {
      console.log(this.minDate);
      const minDate = new Date(this.minDate);
      const maxDate = new Date(this.maxDate);
      const end = this.formatDate(maxDate);
      const start = this.formatDate(minDate);
      const type = this.dateType;
      axios
        .post("/API/Generator/Methods/DayTime", { start, end, type })
        .then((res) => {
          if (res.status === 200) {
            this.contentPreview = res.data;
          } else {
            console.error("Failed to generate content:", res.data.message);
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    changeTime(e) {
      const a = e[0];
      const b = e[1];
      const date = new Date(a);
      this.startTime = date.toTimeString().split(" ")[0];
      const date1 = new Date(b);
      this.endTime = date1.toTimeString().split(" ")[0];
      this.generateContent();
    },
    generateTime() {
      console.log(this.startTime);
      const start = this.startTime;
      const end = this.endTime;
      axios
        .post("/API/Generator/Methods/Time", { start, end })
        .then((res) => {
          console.log(res);

          if (res.status === 200) {
            this.contentPreview = res.data;
          } else {
            console.error("Failed to generate content:", res.data.message);
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
    formatDate(date) {
      const options = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
        timeZone: "Asia/Shanghai",
      };
      const formattedDate = new Intl.DateTimeFormat("zh-CN", options).format(
        date
      );
      return formattedDate.replace(/\//g, "-").replace(",", "");
    },
    getTable(e) {
      const namespace = e;
      this.namespace = e;
      axios.post("/API/Data/Table/GetTable", { namespace }).then((res) => {
        this.treeData = res.data.data.data;
        this.filteredTreeData = this.treeData;
        this.searchQuery = "";
      });
    },
    submit() {
      const namespace = this.namespace;
      const tableSchame = this.tableSchame;
      const tableName = this.tableName;
      const count = this.count;

      if (this.rules.length > 1) {
        const secondRule = this.rules[1];
        this.rules[0].key = secondRule.key;
        this.rules.splice(1, 1);
      }

      const requestData = {
        namespace: namespace,
        rule: this.rules,
        schame: tableSchame,
        table: tableName,
        count: count,
      };

      console.log(requestData);

      axios
        .post("/API/Data/Mock/add", requestData)
        .then((res) => {
          console.log(res);

          if (res.data.code === 200) {
            this.$message({
              message: res.data.msg,
              type: "success",
              duration: 1000,
            });
            this.$router.go(0);
            this.generateContent();
          } else {
            this.$message({
              message: "Please submit complete information",
              type: "warning",
              duration: 1000,
            });
          
          }
        })
        .catch((error) => {
          console.error("API Error:", error);
        });
    },
  },
  mounted() {
    axios.post("/API/Data/Table/GetNameSpace").then((res) => {
      this.namespaces = res.data.data;
    });
    const namespace = this.namespace;
    axios.post("/API/Data/Table/GetTable", { namespace }).then((res) => {
      this.treeData = res.data.data.data;
      this.filteredTreeData = this.treeData;
    });
    this.generateContent();
  },
};
</script>

<style>
.container {
  display: flex;
  flex-direction: row;
  height: 100vh;
}

.left-panel {
  width: 30%;
  padding: 20px;
  border-right: 1px solid #ccc;
  display: flex;
  flex-direction: column;
}
.tree-wrapper {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
}
.right-panel {
  width: 70%;
  padding: 20px;
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
}
</style>
