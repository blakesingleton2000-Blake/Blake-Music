// PostHog Analytics Integration
// Add to app/layout.tsx or create providers file

'use client'

import { useEffect } from 'react'
import { usePathname } from 'next/navigation'
import posthog from 'posthog-js'

export function PostHogProvider({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()

  useEffect(() => {
    // Initialize PostHog
    if (typeof window !== 'undefined' && process.env.NEXT_PUBLIC_POSTHOG_KEY) {
      posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
        api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST || 'https://app.posthog.com',
        loaded: (posthog) => {
          if (process.env.NODE_ENV === 'development') {
            posthog.debug()
          }
        },
      })
    }
  }, [])

  useEffect(() => {
    // Track pageviews
    if (pathname && typeof window !== 'undefined') {
      posthog.capture('$pageview')
    }
  }, [pathname])

  return <>{children}</>
}

// Track key events
export function trackEvent(eventName: string, properties?: Record<string, any>) {
  if (typeof window !== 'undefined') {
    posthog.capture(eventName, properties)
  }
}

// Key events to track:
// - 'user_signed_up'
// - 'user_completed_onboarding'
// - 'music_generated' (with mode, duration)
// - 'track_played'
// - 'track_liked'
// - 'playlist_created'
// - 'oauth_connected' (with platform)
// - 'premium_upgraded'
// - 'generation_failed' (with error)

