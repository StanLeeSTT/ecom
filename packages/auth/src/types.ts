// Placeholder for auth types
// Will be implemented in Phase 1

export interface User {
  id: string
  email: string
  createdAt: Date
  updatedAt: Date
}

export interface AuthPayload {
  token: string
  refreshToken: string
  user: User
}

export interface SignUpInput {
  email: string
  password: string
  name: string
}

export interface SignInInput {
  email: string
  password: string
}
