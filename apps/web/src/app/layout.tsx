import React from 'react'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'LEGIMI Commerce - Dashboard',
  description: 'AI-native commerce operating system',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
