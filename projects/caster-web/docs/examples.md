# caster-web 範例區

## 元件範例（登入頁）
```jsx
import { useAuthStore } from '../../stores/useAuthStore'
import { useTranslation } from 'react-i18next'

const Login = () => {
  const { login } = useAuthStore()
  const { t } = useTranslation('login')

  return (
    <form onSubmit={e => { e.preventDefault(); login(form) }}>
      <h1>{t('title')}</h1>
      {/* ... */}
    </form>
  )
}
```

## Store 範例（Zustand）
```javascript
import { create } from 'zustand'
import { useLoadingStore } from '../useLoadingStore'
import { apiErrorToast } from '../../utils/apiErrorToast'

const { setLoadingState } = useLoadingStore.getState()

export const useAuthStore = create((set) => ({
  isLogin: false,
  user: null,
  login: async (data) => {
    setLoadingState(true)
    try {
      const res = await loginAPI(data)
      set({ isLogin: true, user: res?.data?.data?.user ?? null })
    } catch (err) {
      apiErrorToast('auth.login', err)
    } finally {
      setLoadingState(false)
    }
  },
}))
```

## 預設篩選條件範例
```javascript
const DEFAULT_FILTERS = {
  account: '',
  status: 'audit_deposit',
  order_type: 'all',
  ip: '',
  sn: '',
  start_at: '2022-01-01',
  end_at: dayjs().format('YYYY-MM-DD'),
  page: 1
}
```

## 分支命名範例
- 新增功能：`feat/user-login`
- 優化/調整：`ref/ui-improvements`
- 修復問題：`fix/login-validation`
- 語系調整：`lang/zh-TW`
