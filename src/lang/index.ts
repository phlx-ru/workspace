import Vue from 'vue'
import VueI18n from 'vue-i18n'

import { getLanguage } from '@/utils/cookies'

// element-ui built-in lang
import elementEnLocale from 'element-ui/lib/locale/lang/en'
import elementRuLocale from 'element-ui/lib/locale/lang/ru-RU'

// User defined lang
import enLocale from './en'
import ruLocale from './ru'

Vue.use(VueI18n)

const messages = {
  en: {
    ...enLocale,
    ...elementEnLocale
  },
  ru: {
    ...ruLocale,
    ...elementRuLocale
  }
}

export const getLocale = () => {
  const cookieLanguage = getLanguage()
  if (cookieLanguage) {
    document.documentElement.lang = cookieLanguage
    return cookieLanguage
  }

  const language = navigator.language.toLowerCase()
  const locales = Object.keys(messages)
  for (const locale of locales) {
    if (language.indexOf(locale) > -1) {
      document.documentElement.lang = locale
      return locale
    }
  }

  // Default language is russian
  return 'ru'
}

const i18n = new VueI18n({
  locale: getLocale(),
  messages
})

export default i18n
