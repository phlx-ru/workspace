import { UserModule } from '@/store/modules/user'

export const checkPermission = (value: string[]): boolean => {
  if (value && value.length > 0) {
    return UserModule.roles.some(role => {
      return value.includes(role)
    })
  }

  console.error('need roles! Like v-permission="[\'admin\',\'editor\']"')
  return false
}
