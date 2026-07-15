// Central place for the destinations the marketing site links out to.
// The Kanban Live app lives on its own subdomain (single-domain tenancy).
export const APP_URL = 'https://app.kanbanlive.com';
export const LOGIN_URL = `${APP_URL}/users/sign_in`;
export const SIGNUP_URL = `${APP_URL}/users/sign_up`;
// Nav "Start free trial" routes to Pricing (per the design), where the plan
// CTAs then hand off to app sign-up.
export const TRIAL_URL = '/pricing/';
export const CONTACT_EMAIL = 'hello@kanbanlive.com';
