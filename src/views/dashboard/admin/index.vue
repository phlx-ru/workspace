<template>
  <div class="dashboard-editor-container">
    <div class="panel">
      <el-row>
        <el-col :xs="24" :sm="24" :lg="12">
          <line-chart :chart-data="lineChartData" />
        </el-col>

        <el-col :xs="24" :sm="24" :lg="12">
          <div class="chart-wrapper">
            <bar-chart />
          </div>
        </el-col>
      </el-row>

      <el-row>
        <el-col :xs="24" :sm="24" :lg="12">
          <div class="chart-wrapper">
            <pie-chart />
          </div>
        </el-col>

        <el-col :xs="24" :sm="24" :lg="12">
          <div class="chart-wrapper">
            <radar-chart />
          </div>
        </el-col>
      </el-row>
    </div>

    <el-row :gutter="8">
      <el-col :xs="24" :sm="24" :md="24" :lg="12" :xl="12" style="padding-right:8px;margin-bottom:30px;">
        <transaction-table />
      </el-col>

      <el-col :xs="24" :sm="24" :md="12" :lg="6" :xl="6" style="margin-bottom:30px;">
        <todo-list />
      </el-col>

      <el-col :xs="24" :sm="12" :md="12" :lg="6" :xl="6" style="margin-bottom:30px;">
        <box-card />
      </el-col>
    </el-row>
  </div>
</template>

<script lang="ts">
import 'echarts/theme/helianthus' // Theme used in BarChart, LineChart, PieChart and RadarChart
import { Component, Vue } from 'vue-property-decorator'
import GithubCorner from '@/components/GithubCorner/index.vue'
import BarChart from './components/BarChart.vue'
import BoxCard from './components/BoxCard.vue'
import LineChart, { ILineChartData } from './components/LineChart.vue'
import PieChart from './components/PieChart.vue'
import RadarChart from './components/RadarChart.vue'
import TodoList from './components/TodoList/index.vue'
import TransactionTable from './components/TransactionTable.vue'

const lineChartData: { [type: string]: ILineChartData } = {
  newVisitis: {
    expectedData: [100, 120, 161, 134, 105, 160, 165],
    actualData: [120, 82, 91, 154, 162, 140, 145]
  },
  messages: {
    expectedData: [200, 192, 120, 144, 160, 130, 140],
    actualData: [180, 160, 151, 106, 145, 150, 130]
  },
  purchases: {
    expectedData: [80, 100, 121, 104, 105, 90, 100],
    actualData: [120, 90, 100, 138, 142, 130, 130]
  },
  shoppings: {
    expectedData: [130, 140, 141, 142, 145, 150, 160],
    actualData: [120, 82, 91, 154, 162, 140, 130]
  }
}

@Component({
  name: 'DashboardAdmin',
  components: {
    GithubCorner,
    BarChart,
    BoxCard,
    LineChart,
    PieChart,
    RadarChart,
    TodoList,
    TransactionTable
  }
})
export default class extends Vue {
  private lineChartData = lineChartData.newVisitis

  private handleSetLineChartData(type: string) {
    this.lineChartData = lineChartData[type]
  }
}
</script>

<style lang="scss" scoped>
.dashboard-editor-container {
  padding: 32px;
  background-color: rgb(240, 242, 245);
  position: relative;

  .panel {
    background: #fff;
    padding: 16px 16px 0;
    margin-bottom: 32px;
  }

  .chart-wrapper {
    background: #fff;
    padding: 16px 16px 0;
    margin-bottom: 32px;
  }
}

@media (max-width:1024px) {
  .chart-wrapper {
    padding: 8px;
  }
}
</style>
