import { RouteConfig } from 'vue-router'
import Layout from '@/layout/index.vue'

const marshroutesRoutes: RouteConfig = {
  path: '/marshroutes',
  component: Layout,
  redirect: '/marshroutes/active',
  name: 'Marshroutes',
  meta: {
    title: 'marshroutes',
    icon: 'nested'
  },
  children: [
    {
      path: 'active',
      component: () => import(/* webpackChunkName: "menu1" */ '@/views/marshroutes/active/index.vue'),
      name: 'Active Marshroutes',
      meta: { title: 'marshroutesActive' }
    },
    {
      path: 'all',
      component: () => import(/* webpackChunkName: "menu2" */ '@/views/marshroutes/all/index.vue'),
      name: 'All Marshroutes',
      meta: { title: 'marshroutesAll' }
    },
    {
      path: 'drivers',
      component: () => import(/* webpackChunkName: "menu2" */ '@/views/marshroutes/drivers/index.vue'),
      name: 'Drivers',
      meta: { title: 'marshroutesDrivers' }
    }
  ]
}

export default marshroutesRoutes
